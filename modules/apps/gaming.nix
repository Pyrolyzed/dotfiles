{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };

      environment.systemPackages = with pkgs; [
        steam-devices-udev-rules
        gamescope
        gamemode
        mangohud
        steam-run
        lutris
        bottles
        heroic
      ];

      programs.gamemode.enable = true;

    };
}
