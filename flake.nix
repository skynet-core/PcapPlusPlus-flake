{
  description = "PcapPlusPlus Flake";
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2511.906709";
    flake-utils.url = "github:numtide/flake-utils";
    PcapPlusPlus = {
      url = "github:seladb/PcapPlusPlus?ref=a49a79e0b67b402ad75ffa96c1795def36df75c8";
      flake = false;
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      PcapPlusPlus,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        commonNativePackages = with pkgs; [
          cmake
          ninja
          git
        ];
        buildInputs = with pkgs; [
          libpcap
          zstd
        ];
      in
      rec {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "PcapPlusPlus";
          version = "v25.05";
          inherit buildInputs;
          src = PcapPlusPlus;
          nativeBuildInputs = commonNativePackages ++ [ ];
          NIX_CFLAGS_COMPILE = "-O2 -pipe";
          cmakeFlags = [
            "-DPCAPPP_BUILD_PCAPPP=ON"
            "-DPCAPPP_BUILD_EXAMPLES=OFF"
            "-DPCAPPP_BUILD_TUTORIALS=OFF"
            "-DPCAPPP_INSTALL=ON"
            "-DBUILD_SHARED_LIBS=ON"
            "-DLIGHT_PCAPNG_ZSTD=ON"
            "-DCMAKE_INSTALL_INCLUDEDIR=include"
          ];
          outputs = [
            "out"
            "dev"
          ];
          __structuredAttrs = true;
        };
        packages.PcapPlusPlus = packages.default;
        packages.PcapPlusPlus-dev = packages.default.dev;
      }
    );
}
