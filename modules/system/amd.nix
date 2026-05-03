{
  flake.modules.nixos.amd =
    { pkgs, ... }:
    {
      boot.initrd.kernelModules = [
        "amdgpu"
      ];
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      # vulkaninfo
      environment.systemPackages = with pkgs; [
        vulkan-tools
      ];

    };
}
