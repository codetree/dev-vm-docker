autoload -U compinit
autoload colors
compinit
colors

# disable scroll lock feature (Ctrl-s)
stty -ixon -ixoff

#Path
export PATH=$HOME/.bin:$PATH

# VAGRANT path
export VAGRANT=/vagrant

# Env Vars
export EDITOR=vim
export CLICOLOR=1

# Options
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt PROMPT_SUBST
setopt COMPLETE_IN_WORD
setopt AUTO_CD
export MAILCHECK=1
export MAILPATH="/var/mail/$USER"

# History Options
export HISTSIZE=1200
export SAVEHIST=1000
export HISTFILE="$HOME/.zhistory_$(tmux display -p '#S_#I' 2>/dev/null)"
setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY # add timestamps to history
setopt HIST_REDUCE_BLANKS

# Completion
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # case insensitive completion
zstyle ':completion:*:default' menu 'select=0' # menu-style

function refresh_ssh() {
  if [[ -n $TMUX ]]; then
    NEW_SSH_AUTH_SOCK=`tmux showenv | grep SSH_AUTH_SOCK | cut -d = -f 2`
    if [[ -n $NEW_SSH_AUTH_SOCK ]] && [[ -S $NEW_SSH_AUTH_SOCK ]]; then
      echo 'refreshing SSH_AUTH_SOCK'
      SSH_AUTH_SOCK=$NEW_SSH_AUTH_SOCK
    fi
  fi
}

cwd() {
  echo "%{$fg[magenta]%}%~%{$reset_color%}"
}

vc_prompt_info() {
  echo "%{$fg[cyan]%}[$(vcprompt -f %b%m%u)]%{$reset_color%}"
}

export PROMPT="
\$(cwd) \$(vc_prompt_info)
%{$fg[blue]%}%%%{$reset_color%} "

bindkey -e
bindkey '^r' history-incremental-search-backward

# golang setup
export GOPATH=$HOME/dev/go
export PATH=$GOPATH/bin:$PATH

# rbenv setup
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


if [ -e "$VAGRANT/my-env.sh" ]; then
  source "$VAGRANT/my-env.sh"
fi

# set up custom shortcuts
export PATH=$PATH:/vagrant/bin

# load Node Version Manager (nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[[ -r $NVM_DIR/bash_completion ]] && \. $NVM_DIR/bash_completion
