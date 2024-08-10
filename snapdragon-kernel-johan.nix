{
  buildPackages,
  fetchFromGitHub,
  buildLinux,
  fetchpatch,
  kernel_src,
  ...
}@args:

let
  modDirVersion = "6.11.0-rc1";
in
buildLinux (
  args
  // {
    version = "${modDirVersion}";
    inherit modDirVersion;

    src = kernel_src;

    defconfig = "johan_defconfig";

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
