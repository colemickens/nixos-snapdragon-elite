{
  buildPackages,
  fetchFromGitHub,
  buildLinux,
  fetchpatch,
  kernel_src,
  ...
}@args:

let
  # modDirVersion = "6.10.0-rc3-next-20240613";
  modDirVersion = "6.10.0-next-20240725";
in
buildLinux (
  args
  // {
    version = "${modDirVersion}";
    inherit modDirVersion;

    src = kernel_src;

    # defconfig = "x1e80100_defconfig";
    defconfig = "x1e_defconfig";

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
