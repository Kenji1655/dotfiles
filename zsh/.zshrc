# Zsh configuration - Gruvbox workstation
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export EDITOR=nvim
export VISUAL=nvim
export TERMINAL=alacritty
export BROWSER=firefox
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export TMUX_CONF="$HOME/.config/tmux/tmux.conf"
export PATH="$HOME/.local/bin:$PATH"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git z sudo extract docker docker-compose command-not-found tmux)

if [[ -d "$ZSH" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# Load packaged plugins when Oh My Zsh plugins are not present.
[[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

HISTFILE="$HOME/.cache/zsh/history"
HISTSIZE=50000
SAVEHIST=50000
setopt AUTO_CD CORRECT SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
bindkey -e
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#665c54"

alias ll='eza -lah --icons'
alias la='eza -la --icons'
alias ls='eza --icons'
alias tree='eza --tree --icons'
alias cat='bat'
alias vim='nvim'
alias mkdir='mkdir -pv'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias gs='git status --short --branch'
alias gc='git commit'
alias gca='git commit --amend'
alias gp='git push'
alias gpl='git pull --rebase'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gco='git checkout'
alias update='sudo pacman -Syu'
alias cleanup='orphans=$(pacman -Qtdq 2>/dev/null); [[ -n "$orphans" ]] && sudo pacman -Rns $orphans || echo "No orphan packages"'
alias pkgcache='sudo paccache -rk2 && sudo paccache -ruk0'
alias mirrors='sudo reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist'
alias ip='ip -c'
alias df='df -h'
alias du='du -h'
alias ff='fastfetch'
alias health='system-health'

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
