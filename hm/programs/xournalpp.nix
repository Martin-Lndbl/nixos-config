{ pkgs, config, ... }:
let
  # Trilium integration. "Open externally" on a PDF note or a .xopp note both
  # end up in xopp-open, which finds the note by content hash (Trilium's
  # blobId; titles aren't unique) and edits tmp/<xoppNoteId>.xopp, uploading
  # every save via ETAPI. A PDF without a .xopp child gets one created, with
  # the PDF as background at tmp/trilium-bg/<pdfNoteId>.pdf. Working copies
  # sit next to Trilium's own exports so relative background paths resolve
  # the same either way.
  etapiLib = ''
    api="http://localhost:''${TRILIUM_PORT:-37840}/etapi"
    token_file="${config.xdg.configHome}/sops-nix/secrets/trilium_etapi"
    tmp_dir="''${TRILIUM_DATA_DIR:-$HOME/.local/share/trilium-data}/tmp"

    etapi() {
      local token="''${TRILIUM_ETAPI_TOKEN:-}"
      if [[ -z $token ]]; then
        [[ -r $token_file ]] || { echo "no ETAPI token at $token_file" >&2; return 1; }
        token=$(<"$token_file")
      fi
      curl -fsS --max-time 30 -H "Authorization: $token" "$@"
    }

    # Same id Trilium derives from the content.
    blob_id() {
      openssl dgst -sha512 -binary "$1" | base64 -w0 | tr '+/' 'XY' | cut -c1-20
    }

    stamp_of() {
      cat "$1.stamp" 2>/dev/null || true
    }

    # fetch_bg <noteId|attachmentId> <dest>: refresh dest when the blob changed;
    # keep a cached copy if Trilium is unreachable.
    fetch_bg() {
      local id=$1 dest=$2 kind=notes meta stamp
      if ! meta=$(etapi "$api/notes/$id" 2>/dev/null); then
        if meta=$(etapi "$api/attachments/$id" 2>/dev/null); then
          kind=attachments
        elif [[ -f $dest ]]; then
          return 0
        else
          echo "cannot fetch $id from Trilium" >&2
          return 1
        fi
      fi
      stamp=$(jq -r '.blobId // .utcDateModified' <<<"$meta")
      if [[ -f $dest && $(stamp_of "$dest") == "$stamp" ]]; then
        return 0
      fi
      mkdir -p "$(dirname "$dest")"
      etapi -o "$dest.part" "$api/$kind/$id/content" || return 1
      mv "$dest.part" "$dest"
      printf '%s' "$stamp" >"$dest.stamp"
    }
  '';

  runtimeInputs = with pkgs; [
    curl
    jq
    gzip
    gnugrep
    gnused
    coreutils
  ];

  xopp-open = pkgs.writeShellApplication {
    name = "xopp-open";
    runtimeInputs =
      runtimeInputs
      ++ (with pkgs; [
        xournalpp
        openssl
        gawk
        poppler-utils
        inotify-tools
        libnotify
      ]);
    text = etapiLib + ''
      notify() {
        echo "$1" >&2
        notify-send -a xopp-open Xournal++ "$1" 2>/dev/null || true
      }

      # search_blob <query> <blobId>: noteId of the matching note with that content
      search_blob() {
        etapi -G --data-urlencode "search=$1" --data-urlencode includeArchivedNotes=true "$api/notes" \
          | jq -r --arg b "$2" '[.results[] | select(.blobId == $b)][0].noteId // empty'
      }

      # Download every trilium-bg/<id>.pdf the xopp references, relative to it.
      fetch_bgs() {
        local dir ref id dest
        dir=$(dirname "$(realpath "$1")")
        while IFS= read -r ref; do
          id=$(sed -E 's#.*trilium-bg/([A-Za-z0-9_]+)\.pdf$#\1#' <<<"$ref")
          case $ref in
            /*) dest=$ref ;;
            *) dest=$dir/$ref ;;
          esac
          fetch_bg "$id" "$dest" || true
        done < <(zcat -f "$1" 2>/dev/null \
          | grep -oE 'filename="[^"]*trilium-bg/[A-Za-z0-9_]+\.pdf"' \
          | sed -E 's/^filename="(.*)"$/\1/' | sort -u)
      }

      # new_xopp <pdf> <background ref> <out>: one page per PDF page
      new_xopp() {
        pdfinfo -f 1 -l 1000000 "$1" | awk -v ref="$2" '
          /^Page +[0-9]+ size:/ { w[$2] = $4; h[$2] = $6; if ($2 > n) n = $2 }
          /^Page +[0-9]+ rot:/ { r[$2] = $4 }
          END {
            print "<?xml version=\"1.0\" standalone=\"no\"?>"
            print "<xournal creator=\"xopp-open\" fileversion=\"4\">"
            print "<title>Xournal++ document - see https://xournalpp.github.io/</title>"
            for (i = 1; i <= n; i++) {
              pw = w[i]; ph = h[i]
              if (r[i] % 180 == 90) { t = pw; pw = ph; ph = t }
              printf "<page width=\"%s\" height=\"%s\">\n", pw, ph
              if (i == 1) printf "<background type=\"pdf\" domain=\"absolute\" filename=\"%s\" pageno=\"1\"/>\n", ref
              else printf "<background type=\"pdf\" pageno=\"%d\"/>\n", i
              print "<layer/>"
              print "</page>"
            }
            print "</xournal>"
          }' | gzip >"$3"
        [[ -s $3 ]]
      }

      upload() {
        etapi -X PUT -H 'Content-Type: application/octet-stream' \
          --data-binary @"$2" "$api/notes/$1/content" || return 1
        blob_id "$2" >"$2.stamp"
      }

      sync_up() {
        if [[ -f $2 && $(blob_id "$2") != "$(stamp_of "$2")" ]]; then
          upload "$1" "$2" || notify "uploading $(basename "$2") to Trilium failed"
        fi
      }

      # PDF export -> id of its .xopp child note, created on first open.
      pdf_to_xopp() {
        local pdf_id meta child title xopp_id f
        pdf_id=$(search_blob "note.mime = 'application/pdf'" "$(blob_id "$1")") || return 1
        [[ -n $pdf_id ]] || return 1
        meta=$(etapi "$api/notes/$pdf_id") || return 1
        for child in $(jq -r '.childNoteIds[]' <<<"$meta"); do
          if etapi "$api/notes/$child" | jq -e '.title | endswith(".xopp")' >/dev/null; then
            echo "$child"
            return 0
          fi
        done

        fetch_bg "$pdf_id" "$tmp_dir/trilium-bg/$pdf_id.pdf" || return 1
        title=$(jq -r '(.title | sub("\\.pdf$"; ""; "i")) + ".xopp"' <<<"$meta")
        xopp_id=$(jq -n --arg p "$pdf_id" --arg t "$title" \
          '{parentNoteId: $p, title: $t, type: "file", mime: "application/x-xopp", content: ""}' \
          | etapi -X POST -H 'Content-Type: application/json' --data-binary @- "$api/create-note" \
          | jq -r '.note.noteId // empty') || return 1
        [[ -n $xopp_id ]] || return 1
        f=$tmp_dir/$xopp_id.xopp
        new_xopp "$tmp_dir/trilium-bg/$pdf_id.pdf" "trilium-bg/$pdf_id.pdf" "$f" || return 1
        upload "$xopp_id" "$f" || return 1
        echo "$xopp_id"
      }

      # Bring tmp/<id>.xopp up to date with the note; never drop unsynced edits.
      checkout() {
        local id=$1 f=$tmp_dir/$1.xopp remote
        remote=$(etapi "$api/notes/$id" | jq -r '.blobId') || return 1
        if [[ -f $f && -f $f.stamp && $(blob_id "$f") != "$(stamp_of "$f")" ]]; then
          if [[ $remote == "$(stamp_of "$f")" ]]; then
            upload "$id" "$f"
            return
          fi
          cp "$f" "$f.conflict-$(date +%Y%m%d-%H%M%S)"
          notify "$(basename "$f") changed both locally and in Trilium; kept local copy as .conflict"
        fi
        if [[ ! -f $f || $(blob_id "$f") != "$remote" ]]; then
          etapi -o "$f.part" "$api/notes/$id/content" || return 1
          mv "$f.part" "$f"
        fi
        printf '%s' "$remote" >"$f.stamp"
      }

      edit() {
        local id=$1 f=$2 pid
        xournalpp "$f" &
        pid=$!
        while kill -0 "$pid" 2>/dev/null; do
          inotifywait -qq -t 10 -e close_write -e moved_to "$(dirname "$f")" || true
          sync_up "$id" "$f"
        done
        sync_up "$id" "$f"
      }

      [[ $# -ge 1 && -f $1 ]] || exec xournalpp "$@"
      file=$(realpath "$1")
      case ''${file,,} in
        *.pdf) kind=pdf ;;
        *) kind=xopp ;;
      esac

      # Only Trilium's own exports (tmp-<pid>-<rand>-<title>) are notes.
      if [[ $file == "$(realpath -m "$tmp_dir")"/tmp-* ]]; then
        id=""
        if [[ $kind == pdf ]]; then
          id=$(pdf_to_xopp "$file") || id=""
        else
          id=$(search_blob "note.title *= '.xopp'" "$(blob_id "$file")") || id=""
        fi
        if [[ -n $id ]] && checkout "$id"; then
          fetch_bgs "$tmp_dir/$id.xopp"
          edit "$id" "$tmp_dir/$id.xopp"
          exit 0
        fi
        notify "Couldn't resolve the Trilium note, opening $(basename "$file") directly"
      fi

      if [[ $kind == pdf ]]; then
        exec ${config.programs.firefox.finalPackage}/bin/firefox "$file"
      fi
      fetch_bgs "$file"
      exec xournalpp "$file"
    '';
  };

  trilium-bg = pkgs.writeShellApplication {
    name = "trilium-bg";
    runtimeInputs = runtimeInputs ++ [ pkgs.wl-clipboard ];
    text = etapiLib + ''
      if [[ $# -ne 1 ]]; then
        echo "usage: trilium-bg <noteId|attachmentId|title>" >&2
        echo "fetches the PDF into Trilium's tmp/trilium-bg and prints/copies its path" >&2
        exit 1
      fi
      q=$1

      if [[ $q =~ ^[A-Za-z0-9_]+$ ]] \
        && { etapi "$api/notes/$q" >/dev/null 2>&1 || etapi "$api/attachments/$q" >/dev/null 2>&1; }; then
        id=$q
      else
        title=''${q//\'/}
        search="note.mime = 'application/pdf' AND note.title *=* '$title'"
        res=$(etapi -G --data-urlencode "search=$search" "$api/notes")
        case $(jq '.results | length' <<<"$res") in
          0)
            echo "no PDF note matching '$q'" >&2
            exit 1
            ;;
          1) id=$(jq -r '.results[0].noteId' <<<"$res") ;;
          *)
            echo "several PDF notes match '$q':" >&2
            jq -r '.results[] | "  \(.noteId)  \(.title)"' <<<"$res" >&2
            exit 1
            ;;
        esac
      fi

      dest="$tmp_dir/trilium-bg/$id.pdf"
      fetch_bg "$id" "$dest"
      echo "$dest"
      [[ -n ''${WAYLAND_DISPLAY:-} ]] && wl-copy -n "$dest"
    '';
  };
in
{
  home.packages = with pkgs; [
    xournalpp
    xopp-open
    trilium-bg
  ];

  # Default handler for .xopp and PDFs (see mime.nix); PDFs not exported by
  # Trilium go straight on to firefox.
  xdg.desktopEntries.xopp-open = {
    name = "Xournal++ (Trilium)";
    exec = "xopp-open %f";
    icon = "com.github.xournalpp.xournalpp";
    terminal = false;
    noDisplay = true;
    mimeType = [
      "application/x-xopp"
      "application/x-xojpp"
      "application/pdf"
    ];
  };


  # xournalpp rewrites this whenever a tool or window setting changes, so the
  # rendered file is only ever the starting point; see modules/hm.
  xdg.mutableConfigFiles = [ "xournalpp/settings.xml" ];

  xdg.configFile."xournalpp/settings.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!--The Xournal++ settings file. Do not edit this file! Most settings are available in the Settings dialog, the others are commented in this file, but handle with care!-->
    <settings>
      <property name="pressureSensitivity" value="true"/>
      <property name="minimumPressure" value="0.05"/>
      <property name="pressureMultiplier" value="1.29"/>
      <property name="zoomGesturesEnabled" value="true"/>
      <property name="selectedToolbar" value="Right hand Note Taking"/>
      <property name="lastSavePath" value="/home/mrtn/documents/tum-WS25/aca"/>
      <property name="lastOpenPath" value="/home/mrtn/documents/tum-WS25/aca"/>
      <property name="lastImagePath" value=""/>
      <property name="edgePanSpeed" value="20"/>
      <property name="edgePanMaxMult" value="5"/>
      <property name="zoomStep" value="10"/>
      <property name="zoomStepScroll" value="2"/>
      <property name="displayDpi" value="72"/>
      <property name="mainWndWidth" value="1898"/>
      <property name="mainWndHeight" value="1009"/>
      <property name="maximized" value="true"/>
      <property name="showToolbar" value="true"/>
      <property name="showSidebar" value="true"/>
      <property name="sidebarWidth" value="149"/>
      <property name="sidebarNumberingStyle" value="1"/>
      <property name="sidebarOnRight" value="false"/>
      <property name="scrollbarOnLeft" value="false"/>
      <property name="menubarVisible" value="false"/>
      <property name="filepathShownInTitlebar" value="false"/>
      <property name="pageNumberShownInTitlebar" value="false"/>
      <property name="numColumns" value="1"/>
      <property name="numRows" value="1"/>
      <property name="viewFixedRows" value="false"/>
      <property name="showPairedPages" value="false"/>
      <property name="layoutVertical" value="true"/>
      <property name="layoutRightToLeft" value="false"/>
      <property name="layoutBottomToTop" value="false"/>
      <property name="numPairsOffset" value="1"/>
      <!--The icon theme, allowed values are "disabled", "onDrawOfLastPage", and "onScrollOfLastPage"-->
      <property name="emptyLastPageAppend" value="disabled"/>
      <property name="presentationMode" value="false"/>
      <!--Which GUI elements are shown in default view mode, separated by a colon (,)-->
      <property name="defaultViewModeAttributes" value="showMenubar,showToolbar,showSidebar"/>
      <!--Which GUI elements are shown in fullscreen view mode, separated by a colon (,)-->
      <property name="fullscreenViewModeAttributes" value="goFullscren,showToolbar,showSidebar"/>
      <!--Which GUI elements are shown in presentation view mode, separated by a colon (,)-->
      <property name="presentationViewModeAttributes" value="goFullscren,showToolbar"/>
      <!--The cursor icon used with a stylus, allowed values are "none", "dot", "big", "arrow"-->
      <property name="stylusCursorType" value="dot"/>
      <!--The eraser cursor visibility used with a stylus, allowed values are "never", "always", "hover", "touch"-->
      <property name="eraserVisibility" value="always"/>
      <!--The icon theme, allowed values are "iconsColor", "iconsLucide"-->
      <property name="iconTheme" value="iconsLucide"/>
      <!--Dark/light mode, allowed values are "useSystem", "forceLight", "forceDark"-->
      <property name="themeVariant" value="useSystem"/>
      <property name="highlightPosition" value="false"/>
      <property name="cursorHighlightColor" value="2164260608"/>
      <property name="cursorHighlightBorderColor" value="2147483903"/>
      <property name="cursorHighlightRadius" value="30"/>
      <property name="cursorHighlightBorderWidth" value="0"/>
      <property name="useStockIcons" value="false"/>
      <property name="disableScrollbarFadeout" value="false"/>
      <property name="disableAudio" value="false"/>
      <!--Hides scroolbars in the main window, allowed values: "none", "horizontal", "vertical", "both"-->
      <property name="scrollbarHideType" value="none"/>
      <property name="autoloadMostRecent" value="false"/>
      <property name="autoloadPdfXoj" value="true"/>
      <property name="defaultSaveName" value="%F-Note-%H-%M"/>
      <property name="defaultPdfExportName" value="%{name}_annotated"/>
      <property name="autosaveEnabled" value="true"/>
      <property name="autosaveTimeout" value="3"/>
      <property name="addHorizontalSpace" value="false"/>
      <property name="addHorizontalSpaceAmountRight" value="150"/>
      <property name="addHorizontalSpaceAmountLeft" value="150"/>
      <property name="addVerticalSpace" value="false"/>
      <property name="addVerticalSpaceAmountAbove" value="150"/>
      <property name="addVerticalSpaceAmountBelow" value="150"/>
      <property name="unlimitedScrolling" value="false"/>
      <property name="drawDirModsEnabled" value="false"/>
      <property name="drawDirModsRadius" value="50"/>
      <property name="snapRotation" value="true"/>
      <property name="snapRotationTolerance" value="0.3"/>
      <property name="snapGrid" value="false"/>
      <property name="snapGridTolerance" value="0.5"/>
      <property name="snapGridSize" value="14.17"/>
      <property name="strokeRecognizerMinSize" value="40"/>
      <property name="touchDrawing" value="false"/>
      <property name="gtkTouchInertialScrolling" value="true"/>
      <property name="pressureGuessing" value="false"/>
      <property name="recolor.enabled" value="false"/>
      <property name="recolor.sidebar" value="false"/>
      <property name="recolor.dark" value="4281349190"/>
      <property name="recolor.light" value="4291219701"/>
      <property name="selectionBorderColor" value="4292795866"/>
      <property name="backgroundColor" value="4287137928"/>
      <property name="selectionMarkerColor" value="4285702095"/>
      <property name="activeSelectionColor" value="4286381056"/>
      <property name="touchZoomStartThreshold" value="0"/>
      <property name="pageRerenderThreshold" value="5"/>
      <!--The count of rendered PDF pages which will be cached.-->
      <property name="pdfPageCacheSize" value="10"/>
      <property name="preloadPagesBefore" value="3"/>
      <property name="preloadPagesAfter" value="5"/>
      <property name="eagerPageCleanup" value="true"/>
      <!--Config for new pages-->
      <property name="pageTemplate" value="xoj/template&#10;copyLastPageSize=false&#10;copyLastPageSettings=true&#10;size=595.275591x841.889764&#10;backgroundType=graph&#10;backgroundColor=#ffffff&#10;"/>
      <property name="sizeUnit" value="cm"/>
      <property name="audioFolder" value=""/>
      <property name="audioInputDevice" value="-1"/>
      <property name="audioOutputDevice" value="-1"/>
      <property name="audioSampleRate" value="44100"/>
      <property name="audioGain" value="1"/>
      <property name="defaultSeekTime" value="5"/>
      <property name="pluginEnabled" value=""/>
      <property name="pluginDisabled" value=""/>
      <property name="strokeFilterIgnoreTime" value="150"/>
      <property name="strokeFilterIgnoreLength" value="1"/>
      <property name="strokeFilterSuccessiveTime" value="500"/>
      <property name="strokeFilterEnabled" value="false"/>
      <property name="doActionOnStrokeFiltered" value="false"/>
      <property name="trySelectOnStrokeFiltered" value="false"/>
      <property name="snapRecognizedShapesEnabled" value="false"/>
      <property name="restoreLineWidthEnabled" value="false"/>
      <property name="numIgnoredStylusEvents" value="0"/>
      <property name="inputSystemTPCButton" value="false"/>
      <property name="inputSystemDrawOutsideWindow" value="true"/>
      <property name="preferredLocale" value=""/>
      <property name="useSpacesForTab" value="false"/>
      <property name="numberOfSpacesForTab" value="4"/>
      <property name="laserPointerFadeOutTime" value="500"/>
      <property name="stabilizerAveragingMethod" value="0"/>
      <property name="stabilizerPreprocessor" value="0"/>
      <property name="stabilizerBuffersize" value="20"/>
      <property name="stabilizerSigma" value="0.5"/>
      <property name="stabilizerDeadzoneRadius" value="1.3"/>
      <property name="stabilizerDrag" value="0.4"/>
      <property name="stabilizerMass" value="5"/>
      <property name="stabilizerCuspDetection" value="true"/>
      <property name="stabilizerFinalizeStroke" value="true"/>
      <property name="colorPalette" value="${pkgs.xournalpp}/share/xournalpp/palettes/xournal.gpl"/>
      <property name="latexSettings.autoCheckDependencies" value="true"/>
      <property name="latexSettings.defaultText" value="x^2"/>
      <property name="latexSettings.globalTemplatePath" value="${pkgs.xournalpp}/share/xournalpp/resources/default_template.tex"/>
      <property name="latexSettings.genCmd" value="pdflatex -halt-on-error -interaction=nonstopmode '{}'"/>
      <property name="latexSettings.sourceViewThemeId" value="classic"/>
      <property name="latexSettings.editorFont" value="Monospace 12"/>
      <property name="latexSettings.useCustomEditorFont" value="false"/>
      <property name="latexSettings.editorWordWrap" value="true"/>
      <property name="latexSettings.sourceViewAutoIndent" value="true"/>
      <property name="latexSettings.sourceViewSyntaxHighlight" value="true"/>
      <property name="latexSettings.sourceViewShowLineNumbers" value="false"/>
      <property name="latexSettings.useExternalEditor" value="false"/>
      <property name="latexSettings.externalEditorAutoConfirm" value="false"/>
      <property name="latexSettings.externalEditorCmd" value=""/>
      <property name="latexSettings.temporaryFileExt" value="tex"/>
      <property name="font" font="Sans" size="12"/>
      <data name="buttonConfig">
        <data name="default">
          <attribute name="color" type="hex" value="ff000000"/>
          <attribute name="drawingType" type="string" value="default"/>
          <attribute name="size" type="string" value="thin"/>
          <attribute name="strokeType" type="string" value="none"/>
          <attribute name="tool" type="string" value="pen"/>
        </data>
        <data name="eraser">
          <attribute name="eraserMode" type="string" value="deleteStroke"/>
          <attribute name="size" type="string" value="thin"/>
          <attribute name="tool" type="string" value="eraser"/>
        </data>
        <data name="left">
          <attribute name="tool" type="string" value="none"/>
        </data>
        <data name="middle">
          <attribute name="tool" type="string" value="hand"/>
        </data>
        <data name="right">
          <attribute name="tool" type="string" value="none"/>
        </data>
        <data name="stylus">
          <attribute name="tool" type="string" value="selectRegion"/>
        </data>
        <data name="stylus2">
          <attribute name="tool" type="string" value="none"/>
        </data>
        <data name="touch">
          <attribute name="device" type="string" value=""/>
          <attribute name="disableDrawing" type="boolean" value="false"/>
          <attribute name="tool" type="string" value="none"/>
        </data>
      </data>
      <data name="deviceClasses">
        <data name="Wacom HID 524E Pen">
          <attribute name="deviceClass" type="int" value="2"/>
          <attribute name="deviceSource" type="int" value="1"/>
        </data>
        <data name="Wacom HID 524E Pen (Eraser)">
          <attribute name="deviceClass" type="int" value="3"/>
          <attribute name="deviceSource" type="int" value="2"/>
        </data>
        <data name="Wayland Finger Scrolling">
          <attribute name="deviceClass" type="int" value="1"/>
          <attribute name="deviceSource" type="int" value="6"/>
        </data>
        <data name="Wayland Pointer">
          <attribute name="deviceClass" type="int" value="1"/>
          <attribute name="deviceSource" type="int" value="0"/>
        </data>
        <data name="Wayland Touch">
          <attribute name="deviceClass" type="int" value="4"/>
          <attribute name="deviceSource" type="int" value="5"/>
        </data>
        <data name="Wayland Wheel Scrolling">
          <attribute name="deviceClass" type="int" value="1"/>
          <attribute name="deviceSource" type="int" value="0"/>
        </data>
        <data name="xwayland-pointer:1">
          <attribute name="deviceClass" type="int" value="1"/>
          <attribute name="deviceSource" type="int" value="0"/>
        </data>
        <data name="xwayland-relative-pointer:1">
          <attribute name="deviceClass" type="int" value="1"/>
          <attribute name="deviceSource" type="int" value="0"/>
        </data>
        <data name="xwayland-tablet eraser:1">
          <attribute name="deviceClass" type="int" value="3"/>
          <attribute name="deviceSource" type="int" value="2"/>
        </data>
        <data name="xwayland-tablet stylus:1">
          <attribute name="deviceClass" type="int" value="2"/>
          <attribute name="deviceSource" type="int" value="1"/>
        </data>
        <data name="xwayland-touch:1">
          <attribute name="deviceClass" type="int" value="4"/>
          <attribute name="deviceSource" type="int" value="5"/>
        </data>
      </data>
      <data name="lastUsedPageBgColor">
        <attribute name="color00" type="hex" value="ff2e2e2e"/>
        <attribute name="color01" type="hex" value="ff120e0e"/>
        <attribute name="color02" type="hex" value="ffffffff"/>
        <attribute name="color03" type="hex" value="ffffffff"/>
        <attribute name="color04" type="hex" value="ffffffff"/>
        <attribute name="color05" type="hex" value="ffffffff"/>
        <attribute name="color06" type="hex" value="ffffffff"/>
        <attribute name="color07" type="hex" value="ffffffff"/>
        <attribute name="color08" type="hex" value="ffffffff"/>
        <attribute name="count" type="int" value="9"/>
      </data>
      <data name="tools">
        <attribute name="current" type="string" value="highlighter"/>
        <data name="drawArrow">
          <attribute name="drawingType" type="string" value="default"/>
        </data>
        <data name="drawCoordinateSystem">
          <attribute name="drawingType" type="string" value="default"/>
        </data>
        <data name="drawDoubleArrow">
          <attribute name="drawingType" type="string" value="default"/>
        </data>
        <data name="drawEllipse">
          <attribute name="drawingType" type="string" value="default"/>
        </data>
        <data name="drawRect">
          <attribute name="drawingType" type="string" value="default"/>
        </data>
        <data name="drawSpline">
          <attribute name="drawingType" type="string" value="default"/>
        </data>
        <data name="eraser">
          <attribute name="drawingType" type="string" value="default"/>
          <attribute name="size" type="string" value="MEDIUM"/>
          <attribute name="type" type="string" value="deleteStroke"/>
        </data>
        <data name="hand">
          <attribute name="drawingType" type="string" value="default"/>
        </data>
        <data name="highlighter">
          <attribute name="color" type="hex" value="808080"/>
          <attribute name="drawingType" type="string" value="rectangle"/>
          <attribute name="fill" type="int" value="0"/>
          <attribute name="fillAlpha" type="int" value="128"/>
          <attribute name="size" type="string" value="BIG"/>
        </data>
        <data name="image">
          <attribute name="drawingType" type="string" value="default"/>
        </data>
        <data name="laserPointerHighlighter">
          <attribute name="color" type="hex" value="ffffff00"/>
          <attribute name="drawingType" type="string" value="default"/>
          <attribute name="size" type="string" value="BIG"/>
        </data>
        <data name="laserPointerPen">
          <attribute name="color" type="hex" value="ffffff00"/>
          <attribute name="drawingType" type="string" value="default"/>
          <attribute name="size" type="string" value="MEDIUM"/>
        </data>
        <data name="pen">
          <attribute name="color" type="hex" value="000000"/>
          <attribute name="drawingType" type="string" value="default"/>
          <attribute name="fill" type="int" value="0"/>
          <attribute name="fillAlpha" type="int" value="128"/>
          <attribute name="size" type="string" value="THIN"/>
          <attribute name="style" type="string" value="plain"/>
        </data>
        <data name="playObject">
          <attribute name="drawingType" type="string" value="default"/>
        </data>
        <data name="selectMultiLayerRect">
          <attribute name="drawingType" type="string" value="default"/>
        </data>
        <data name="selectMultiLayerRegion">
          <attribute name="drawingType" type="string" value="default"/>
        </data>
        <data name="selectObject">
          <attribute name="drawingType" type="string" value="default"/>
        </data>
        <data name="selectPdfTextLinear">
          <attribute name="color" type="hex" value="ff000000"/>
          <attribute name="drawingType" type="string" value="default"/>
        </data>
        <data name="selectPdfTextRect">
          <attribute name="color" type="hex" value="ff000000"/>
          <attribute name="drawingType" type="string" value="default"/>
        </data>
        <data name="selectRect">
          <attribute name="drawingType" type="string" value="default"/>
        </data>
        <data name="selectRegion">
          <attribute name="drawingType" type="string" value="default"/>
        </data>
        <data name="showFloatingToolbox">
          <attribute name="drawingType" type="string" value="default"/>
        </data>
        <data name="text">
          <attribute name="color" type="hex" value="ff000000"/>
          <attribute name="drawingType" type="string" value="default"/>
        </data>
        <data name="verticalSpace">
          <attribute name="drawingType" type="string" value="default"/>
        </data>
      </data>
      <data name="touch">
        <attribute name="cmdDisable" type="string" value=""/>
        <attribute name="cmdEnable" type="string" value=""/>
        <attribute name="disableTouch" type="boolean" value="true"/>
        <attribute name="method" type="string" value="auto"/>
        <attribute name="timeout" type="int" value="500"/>
      </data>
    </settings>
  '';
}
