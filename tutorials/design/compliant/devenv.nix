{ pkgs, lib, config, ... }:
# The bench for the flower's electronics and its Haskell inference loop.
#
# What is here natively (aarch64-darwin): GHC and cabal for the categorifier-c work, esptool and the serial tools for the
# ESP32 flashing farm, and the Python the diagrams and simulations use.
#
# What is NOT: KiCad. nixpkgs marks it broken on aarch64-darwin (meta.available = false, meta.broken = true), and this
# machine has no Linux builder configured, so `nix build nixpkgs#kicad` cannot succeed here whatever the flake says. The
# `kicad-cli` script below runs the upstream KiCad container instead, which gives the headless CLI (DRC, netlist, plots,
# STEP export) that a scripted board needs; the GUI wants the official macOS package.
let
  ghc = pkgs.haskell.compiler.ghc98;
in {
  name = "flower-embedded";

  packages = with pkgs; [
    # --- Haskell, for the inference loop compiled through categorifier-c
    ghc
    cabal-install
    haskellPackages.haskell-language-server
    pkg-config
    zlib

    # --- ESP32: flashing, monitoring, the farm
    esptool
    picocom
    minicom
    usbutils

    # --- the numbers and the drawings
    (python3.withPackages (ps: with ps; [ numpy scipy matplotlib pyserial ]))

    # --- housekeeping
    jq
    git
  ];

  env = {
    # esptool talks to whatever the hub enumerates; the farm script fills these in per port
    ESPTOOL_BAUD = "921600";
    KICAD_IMAGE = "kicad/kicad:9.0";
  };

  scripts.kicad-cli.exec = ''
    # KiCad's headless CLI through the upstream container: nixpkgs' kicad does not build on aarch64-darwin.
    # Mounts the current directory at /work so paths in the arguments are the ones you typed.
    if ! docker info >/dev/null 2>&1; then
      echo "no container runtime is running: start one first (colima start, or Docker Desktop)" >&2
      exit 1
    fi
    exec docker run --rm -v "$PWD:/work" -w /work "$KICAD_IMAGE" kicad-cli "$@"
  '';

  scripts.ports.exec = ''
    # every USB serial device the farm can see right now
    ls /dev/cu.usbserial-* /dev/cu.usbmodem* /dev/cu.SLAB_USBtoUART* 2>/dev/null || echo "(no USB serial ports)"
  '';

  scripts.flash-farm.exec = ''
    # flash one image to every board on the bus, in parallel, and report per port
    img="''${1:?usage: flash-farm <firmware.bin> [offset]}"; off="''${2:-0x10000}"
    mapfile -t ports < <(ls /dev/cu.usbserial-* /dev/cu.usbmodem* /dev/cu.SLAB_USBtoUART* 2>/dev/null)
    if [ ''${#ports[@]} -eq 0 ]; then echo "no boards on the bus" >&2; exit 1; fi
    echo "flashing $img at $off to ''${#ports[@]} boards"
    pids=(); for p in "''${ports[@]}"; do
      ( esptool --chip esp32 --port "$p" --baud "$ESPTOOL_BAUD" write_flash "$off" "$img" \
          >"/tmp/flash-$(basename "$p").log" 2>&1 && echo "  ok   $p" || echo "  FAIL $p (see /tmp/flash-$(basename "$p").log)" ) &
      pids+=($!)
    done
    wait "''${pids[@]}"
  '';

  enterShell = ''
    echo "flower-embedded: ghc $(ghc --numeric-version), cabal $(cabal --numeric-version), esptool $(esptool version 2>/dev/null | head -1)"
    echo "  ports        - list the boards on the bus"
    echo "  flash-farm   - flash one image to all of them"
    echo "  kicad-cli    - KiCad's CLI in a container (nixpkgs' kicad is broken on aarch64-darwin)"
  '';
}
