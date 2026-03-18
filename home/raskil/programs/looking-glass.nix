{ pkgs, lib, ... }:
let
  lookingGlassConfig = pkgs.writeText "looking-glass-client.ini" ''
    [app]
    shmFile=/dev/kvmfr0
    renderer=egl
    framePollInterval=500
    cursorPollInterval=500

    [win]
    autoResize=yes
    keepAspect=yes
    fpsMin=120
    jitRender=yes
    noScreensaver=yes

    [input]
    captureOnFocus=yes
    rawMouse=yes
    mouseSmoothing=no

    [spice]
    enable=yes
    host=127.0.0.1
    port=5900
    input=yes
    clipboard=yes
    audio=yes

    [egl]
    multisample=no
    vsync=no
  '';
in
{
  xdg.configFile."looking-glass/client.ini".source = lookingGlassConfig;

  home.packages = [
    (pkgs.writeShellApplication {
      name = "lg-launch";
      runtimeInputs = [
        pkgs.bashInteractive
        pkgs.coreutils
        pkgs.gnused
        pkgs.libvirt
        pkgs.looking-glass-client
      ];
      text = ''
        #!/usr/bin/env bash
        set -euo pipefail

        vm_name="win10"
        libvirt_uri="''${LIBVIRT_URI:-qemu:///system}"
        if [[ $# -gt 0 && "''${1:0:1}" != "-" ]]; then
          vm_name="$1"
          shift
        fi

        virsh_cmd() {
          virsh --connect "$libvirt_uri" "$@"
        }

        if ! virsh_cmd dominfo "$vm_name" >/dev/null 2>&1; then
          echo "error: VM '$vm_name' was not found in libvirt" >&2
          exit 1
        fi

        state="$(virsh_cmd domstate "$vm_name" | tr -d '\r')"
        if [[ "$state" != "running" ]]; then
          echo "Starting VM '$vm_name'..."
          virsh_cmd start "$vm_name" >/dev/null
        fi

        host=""
        port=""
        uri=""

        for _ in $(seq 1 30); do
          uri="$(virsh_cmd domdisplay "$vm_name" 2>/dev/null || true)"
          if [[ "$uri" =~ ^spice://([^:]+):([0-9]+)$ ]]; then
            host="''${BASH_REMATCH[1]}"
            port="''${BASH_REMATCH[2]}"
            break
          fi
          sleep 1
        done

        if [[ -z "$host" || -z "$port" ]]; then
          echo "error: unable to resolve SPICE endpoint for '$vm_name' (last value: ''${uri:-empty})" >&2
          exit 1
        fi

        exec ${pkgs.looking-glass-client}/bin/looking-glass-client -c "$host" -p "$port" "$@"
      '';
    })
    (lib.hiPrio (pkgs.writeShellApplication {
      name = "looking-glass-client";
      runtimeInputs = [
        pkgs.bashInteractive
      ];
      text = ''
        #!/usr/bin/env bash
        set -euo pipefail
        exec lg-launch "$@"
      '';
    }))
  ];
}
