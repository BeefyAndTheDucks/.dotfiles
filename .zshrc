# ─────────────────────────────────────────────
# HISTORY
# ─────────────────────────────────────────────

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000


# ─────────────────────────────────────────────
# OPTIONS
# ────────────────────────────────────────────

setopt appendhistory sharehistory
setopt extendedglob
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
setopt autocd


# ─────────────────────────────────────────────
# COMPLETION
# ─────────────────────────────────────────────

if [[ ":$FPATH:" != *":$HOME/completions:"* ]]; then export FPATH="$HOME/completions:$FPATH"; fi


fpath=($fpath $HOME/.local/share/zsh/generated_man_completions)


# Set up stuff
zmodload zsh/complist
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"

# Other options
# default completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' menu no

# fzf tab
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'

zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"



# Cache autoloading for the speeds
autoload -Uz compinit

if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.m-1) ]]; then
  compinit -C
else
  compinit
fi



# ─────────────────────────────────────────────
# ENVIRONMENT
# ─────────────────────────────────────────────

export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR="nvim"

export LUAROCKS_CONFIG="$HOME/.luarocks/config.lua"

# What counts as ending a word is stored in my string of text here
WORDCHARS='*?_[]~=&;!#$%^(){}'

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH


# ─────────────────────────────────────────────
# ALIASES AND FUNCTIONS
# ─────────────────────────────────────────────

alias wprop="qdbus org.kde.KWin /KWin queryWindowInfo"
alias update="sudo dnf upgrade -y && flatpak update -y"
alias del="trash-put"

alias h='history 1 | fzf --tac --reverse --header "Search History" | sed "s/^[ ]*[0-9]*[ ]*//" | wl-copy'
alias clear="printf '\e[3J' && clear"

alias install="sudo dnf install"

alias start-playit="sudo systemctl start playit"
alias stat-playit="sudo systemctl status playit"
alias stop-playit="sudo systemctl stop playit"

alias fix-perms="sudo restorecon -v"

# fish like completions for zsh cuz cool
zsh_update_completions() {
    local start_time=$SECONDS
    local step_start step_elapsed

    rm -f ~/.zcompdump

    step_start=$SECONDS
    print "[1/3] Parsing man pages with fish..."
    fish -c 'fish_update_completions'
    step_elapsed=$(( SECONDS - step_start ))
    print " done in ${step_elapsed}s"

    step_start=$SECONDS
    print "\n[2/3] Converting to Zsh completions..."
    zsh-manpage-completion-generator -src ~/.cache/fish/generated_completions
    step_elapsed=$(( SECONDS - step_start ))
    print " done in ${step_elapsed}s"

    step_start=$SECONDS
    print "\n[3/3] Reloading completion system..."

    compinit
    step_elapsed=$(( SECONDS - step_start ))
    print " done in ${step_elapsed}s"

    print "\n All done - $(( SECONDS - start_time ))s total"
}

# ─────────────────────────────────────────────
# TOOLS
# ─────────────────────────────────────────────

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

source <(fzf --zsh)

eval "$(zoxide init zsh --cmd cd)"

[[ -t 0 && $(tty) != /dev/tty[0-9]* ]] && eval "$(starship init zsh)"

# ─────────────────────────────────────────────
# PLUGINS
# ─────────────────────────────────────────────

export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

source ~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/plugins/zsh-autopair/autopair.zsh


source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ─────────────────────────────────────────────
# KEYBINDS
# ─────────────────────────────────────────────

bindkey '^H' backward-kill-word

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

bindkey '^J' self-insert-unmeta
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

# ─────────────────────────────────────────────
# MISC
# ─────────────────────────────────────────────

# nobody likes the beep
unsetopt beep

