#!/usr/bin/env nu
def try_or_exit [cmd: closure, msg: string] {
    try {
        do $cmd
    } catch { |err|
        print $msg
        print $"Details: ($err.msg)"
        exit 1
    }
}

try_or_exit { nixos-rebuild build --flake $"($env.NIXOS_CONFIG_PATH)#" } "Error building NixOS generation"
try_or_exit { nvd diff /run/current-system result } "Error comparing NixOS generations"
try_or_exit { do -i { sudo nixos-rebuild switch --flake $"($env.NIXOS_CONFIG_PATH)#" } } "Error switching to new NixOS generation"
try_or_exit { rm result } "Error removing result symlink"