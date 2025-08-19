# -----------------------------
# Keybindings
# -----------------------------
bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# Increase nesting limit so Starship + vi-mode can both wrap zle widgets
typeset -g FUNCNEST=5000

# FZF, zoxide, and Starship inits
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# -----------------------------
# Zinit Setup
# -----------------------------
export ZINIT_HOME="${HOME}/.zinit/bin"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# -----------------------------
# Zinit Plugins (order matters)
# -----------------------------
# Load completions first
zinit light zsh-users/zsh-completions
autoload -Uz compinit
compinit

# Completion enhancers AFTER compinit
zinit light Aloxaf/fzf-tab

# Other plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# OMZ snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::command-not-found

# Replay previous working directory
zinit cdreplay -q

# -----------------------------
# fzf-tab Styles
# -----------------------------
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color ${(Q)realpath}'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color ${(Q)realpath}'

eval "$(starship init zsh)"

# -----------------------------
# History Settings
# -----------------------------
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

# -----------------------------
# Aliases
# -----------------------------
# Debian: bat is batcat
if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
  alias bat=batcat
  alias cat='batcat'
else
  alias cat='bat'
fi

alias ls='eza --icons --group-directories-first -h'

