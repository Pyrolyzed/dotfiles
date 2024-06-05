# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Plugins
autoload -U compinit; compinit
source ~/.local/share/zsh-plugins/fzf-tab/fzf-tab.plugin.zsh
source ~/.local/share/zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source ~/.local/share/zsh-plugins/zsh-completions/zsh-completions.plugin.zsh
source ~/.local/share/zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

# Shell integrations
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

# Setup Vi keybindings
bindkey -v

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls -a --color $realpath'

# Aliases
alias remove-orphans="sudo pacman -Qdtq | sudo pacman -Rns -"
alias cd="z"
alias ls="ls --color"
alias vim="nvim"
alias c="clear"
alias neofetch="fastfetch"
alias cat="bat"
alias install="sudo pacman -Sy"
alias upgrade="sudo pacman -Syu"
alias mkdir="mkdir -p"
alias ll="ls -l --color"

# Setup Powerlevel10k
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
