# NixOS stuff
def switch [] {
  ^$"($env.NIXOS_CONFIG_PATH)/scripts/switch.nu"
}
alias update = sudo nix flake update --flake $"($env.NIXOS_CONFIG_PATH)/."

$env.config.show_banner = false
$env.config.buffer_editor = 'hx'

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
