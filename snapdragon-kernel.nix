{
  buildPackages,
  fetchFromGitHub,
  buildLinux,
  fetchpatch,
  edk2_kernel_src,
  ...
}@args:

let
  modDirVersion = "6.10.0-rc3-next-20240613";
in
buildLinux (
  args
  // {
    version = "${modDirVersion}";
    inherit modDirVersion;

    src = edk2_kernel_src;

    defconfig = "x1e80100_defconfig";

    kernelPatches =
      [
        # { patch = ./linux-rock5-patch.patch; }
      ]
      ++ (with buildPackages.kernelPatches; [
        bridge_stp_helper
        request_key_helper
      ]);
  }
  // (args.argsOverride or { })
)
