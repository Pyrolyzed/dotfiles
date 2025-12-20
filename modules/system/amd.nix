{
  flake.modules.nixos.amd = {
    boot.initrd.kernelModules = [
      "amdgpu"
    ];
  };
}
