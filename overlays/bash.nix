self: super: {
  bash = super.bash.overrideAttrs
    (oldAttrs: {
      configureFlags = oldAttrs.configureFlags
        ++ [ "--without-bash-malloc" ];
    });
}
