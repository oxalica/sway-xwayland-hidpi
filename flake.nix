{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    xorg-xwayland-hidpi-xprop = {
      url = "git+https://aur.archlinux.org/xorg-xwayland-hidpi-xprop.git?ref=HEAD";
      flake = false;
    };
    wlroots-hidpi-xprop-git = {
      url = "git+https://aur.archlinux.org/wlroots-hidpi-xprop-git.git?ref=HEAD";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: let
    inherit (nixpkgs) lib;
    eachSystem = lib.genAttrs lib.systems.flakeExposed;
  in {
    packages = eachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      sources = pkgs.callPackage ./_sources/generated.nix { };
    in rec {
      xwayland-hidpi-xprop = pkgs.xwayland.overrideAttrs (old: {
        pname = "xwayland-hidpi-xprop";
        patches = old.patches or [ ] ++ [
          "${inputs.xorg-xwayland-hidpi-xprop}/hidpi.patch"
        ];
      });

      wlroots-hidpi-xprop = pkgs.callPackage ./wlroots-hidpi-xprop-git.nix {
        inherit (sources.wlroots-git) version src;
        xwayland = xwayland-hidpi-xprop;
        patches = map (f: "${inputs.wlroots-hidpi-xprop-git}/${f}") [
          "0001-xwayland-support-HiDPI-scale.patch"
          "0002-Fix-configure_notify-event.patch"
          "0003-Fix-size-hints-under-Xwayland-scaling.patch"
        ];
      };

      sway-unwrapped-xwayland-hidpi = (pkgs.sway-unwrapped.override {
        wlroots = wlroots-hidpi-xprop;
      }).overrideAttrs (old: {
        pname = "sway-unwrapped-xwayland-hidpi-git";
        inherit (sources.sway-git) version src;
        patches = lib.filter (p: p.name or null != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch") old.patches;
      });

      sway-xwayland-hidpi = pkgs.sway.override {
        sway-unwrapped = sway-unwrapped-xwayland-hidpi;
      };
    });
  };
}
