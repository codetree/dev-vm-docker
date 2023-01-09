
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="zhann"

# define Python Environment Manager
export PYENV_ROOT=$HOME/.pyenv


#Path
export PATH=$HOME/.local/bin:$HOME/.bin:$HOME/.rbenv/bin:$PATH
export PATH=$PATH:$HOME/.ebcli-virtual-env/executables
export PATH=$PYENV_ROOT/bin:$PATH


# Env Vars
export EDITOR=vim
export CLICOLOR=1
export LESS="-irNF"
unset LESS_IS_MORE
export PAGER="less"

# History Options
export HISTSIZE=1200
export SAVEHIST=1000
export HISTFILE="$HOME/.zhistory_$(tmux display -p '#S_#I' 2>/dev/null)"
setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY # add timestamps to history
setopt HIST_REDUCE_BLANKS

bindkey -e
bindkey '^r' history-incremental-search-backward

# plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# rbenv setup
eval "$(rbenv init - zsh)"

# nvm setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# define aliases
alias ls='ls -G'
alias ll='ls -al'
alias python=python3
alias tmux_ct='tmux new-session -c ~/repos/codetree "tmux source-file ~/.tmux_ct"'
alias curl-json='curl -H "Accept: application/json; version=1"'
alias load-env='export $(cat .env | xargs)'