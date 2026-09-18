# Helpers for services.pipewire.wireplumber.extraConfig."monitor.alsa.rules".
# Not a module: import it into a machine's `let` and call the functions.
{
  # Drop an entire card, profiles and all. Needed when no single node name is
  # stable, e.g. HDMI outputs whose name follows the active profile.
  hideCard = name: {
    matches = [ { "device.name" = name; } ];
    actions.update-props."device.disabled" = true;
  };

  # Drop one node while leaving the rest of its card alone.
  hideNode = name: {
    matches = [ { "node.name" = name; } ];
    actions.update-props."node.disabled" = true;
  };

  # Give a node a human-readable label in every volume UI.
  renameNode = name: label: {
    matches = [ { "node.name" = name; } ];
    actions.update-props = {
      "node.description" = label;
      "node.nick" = label;
    };
  };
}
