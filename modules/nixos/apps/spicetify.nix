{
  inputs,
  pkgs,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  imports = [
    inputs.spicetify-nix.nixosModules.spicetify
  ];

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplayMod
      betterGenres
      beautifulLyrics
      powerBar
      shuffle
    ];
    theme = spicePkgs.themes.comfy;
    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus
    ];
  };
}
