{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
  cfg = config.custom.apps.gaming;
in
{
  options.custom.apps.gaming = {
    enable = mkEnableOption "Enable gaming" // {
      default = true;
    };
    minecraft.enable = mkEnableOption "Enable Minecraft";
    lutris.enable = mkEnableOption "Enable Lutris";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mangohud
      protonup-qt
      (mkIf cfg.lutris.enable lutris)
      (mkIf cfg.minecraft.enable prismlauncher)
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
