# ========== NixOS stuff ==========
def switch [] {
  ^$"($env.NIXOS_CONFIG_PATH)/scripts/switch.nu"
}
alias update = sudo nix flake update --flake $"($env.NIXOS_CONFIG_PATH)/."

# ========== Modules ==========
use std/dirs

# ========== Config ==========
$env.config = {
  show_banner: false
  buffer_editor: 'hx'
  keybindings: [
    {
      name: accept-autosuggestion
      modifier: alt
      keycode: char_a
      mode: emacs
      event: { send: HistoryHintComplete }
    }
  ]
}

# ========== Aliases ==========

# Git
alias gst = git status
alias gl = git log
alias glg = git log --graph --oneline --all
alias gp = git pull
alias gpr = git pull --rebase
alias gco = git checkout
alias ga = git add
alias gc = git commit
alias gb = git branch
alias gd = git diff
alias gds = git diff --staged
alias gstash = git stash
alias gclean = git clean -fd

# Dirs
alias d = dirs
alias da = dirs add
alias ddr = dirs drop
alias dg = dirs goto
alias dn = dirs next
alias dp = dirs prev

# Other
alias e = explore
alias h = help