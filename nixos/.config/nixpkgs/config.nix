{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; rec {
    myEnv = pkgs.buildEnv {
      name = "custom";
      paths = [
        ffmpeg
        coreutils
        tldr
        pulsemixer
        spectrwm
      ];
      pathsToLink = [ "/share" "/bin" ];
    };
    unsEnv = pkgs.buildEnv {
      name = "unst";
      paths = [
        alacritty
      ];
    };
  };
}
