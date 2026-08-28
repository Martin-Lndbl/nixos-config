"""Pick a border accent colour out of a wallpaper.

Printed as a bare rrggbb hex string. See border-colour.nix for why this
exists rather than caelestia's own scheme colours.
"""

import colorsys
import sys

from PIL import Image

# The classic scheme's primary, for wallpapers with no colour to find.
FALLBACK = "6a9fb5"

# Borders are thin, so the wallpaper's own lightness and saturation are
# discarded and the hue is re-rendered at values that stay legible against
# the classic scheme's dark surfaces.
BORDER_LIGHTNESS = 0.68
BORDER_MIN_SATURATION = 0.40


def accent(path: str) -> str:
    img = Image.open(path).convert("RGB")
    img.thumbnail((256, 256))
    quantised = img.quantize(colors=16, method=Image.Quantize.MEDIANCUT)
    palette = quantised.getpalette()
    counts = quantised.getcolors()
    total = sum(count for count, _ in counts)

    colours = []
    for count, index in counts:
        r, g, b = palette[index * 3:index * 3 + 3]
        hue, light, sat = colorsys.rgb_to_hls(r / 255, g / 255, b / 255)
        colours.append((count / total, hue, light, sat))

    # Near-black and blown-out regions carry no usable hue, and a grey border
    # would be indistinguishable from the inactive one. Among what is left,
    # weigh how much of the image a colour covers against how colourful it is,
    # so a large muted region cannot outright beat a small vivid one.
    usable = [c for c in colours if 0.20 <= c[2] <= 0.85 and c[3] >= 0.15]
    if usable:
        _, hue, _, sat = max(usable, key=lambda c: c[0] * c[3])
    else:
        # Dark or near-monochrome wallpapers have nothing that clears the bar
        # above but usually still hold a faint hue, and amplifying it beats
        # dropping to a constant.
        tinted = [c for c in colours if c[3] >= 0.05]
        if not tinted:
            return FALLBACK
        _, hue, _, sat = max(tinted, key=lambda c: c[3])

    r, g, b = colorsys.hls_to_rgb(
        hue, BORDER_LIGHTNESS, max(sat, BORDER_MIN_SATURATION)
    )
    return f"{round(r * 255):02x}{round(g * 255):02x}{round(b * 255):02x}"


if __name__ == "__main__":
    print(accent(sys.argv[1]))
