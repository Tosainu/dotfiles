# -------------------------------------
# exports
# -------------------------------------

# term
if [ "$TERM" = "xterm" ]; then
  if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
  else
    export TERM='xterm-color'
  fi
fi

export KCODE=u
export REPORTTIME=5
export EDITOR='vim'
export PAGER='less'
export VISUAL='vim'

path=(
  ~/.local/bin(N-/)
  ~/.cabal/bin(N-/)
  ~/.go/bin(N-/)
  `ruby -e 'print Gem.user_dir'`/bin(N-/)
  $path
)

fpath=(
  /usr/share/zsh/site-functions(N-/)
  ~/.go/src/github.com/motemen/ghq/zsh(N-/)
  $fpath
)

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# golang
export GOPATH=~/.go

# remove duplicate path
typeset -Ua path cdpath fpath manpath

# -------------------------------------
# zsh options
# -------------------------------------

# Basic
setopt correct
setopt extended_glob
setopt globdots
setopt ignore_eof
setopt mark_dirs
setopt no_beep
setopt noautoremoveslash
setopt print_eight_bit

# Directory
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups

# History
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt inc_append_history

# Title
case $TERM in
  xterm*)
    precmd() {
      echo -ne "\033]0;${USER}@${HOST%%.*} (${SHELL})\007"
    }
    ;;
esac

# -------------------------------------
# colors
# -------------------------------------

autoload -U colors; colors
export LS_COLORS='no=00;38;5;252:rs=0:di=01;38;5;111:ln=01;38;5;113:mh=00:pi=48;5;241;38;5;192;01:so=48;5;241;38;5;192;01:do=48;5;241;38;5;192;01:bd=48;5;241;38;5;177;01:cd=48;5;241;38;5;177;01:or=48;5;236;38;5;196:su=48;5;209;38;5;235:sg=48;5;192;38;5;235:ca=30;41:tw=48;5;113;38;5;235:ow=48;5;113;38;5;111:st=48;5;111;38;5;235:ex=01;38;5;209:*#=00;38;5;246:*~=00;38;5;246:*.o=00;38;5;246:*.swp=00;38;5;246:'

# -------------------------------------
# completion
# -------------------------------------

autoload -U compinit; compinit
setopt list_packed
setopt magic_equal_subst

zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' '+m:{a-z}={A-Z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' use-cache true
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:processes-names' command  'ps c -u ${USER} -o command | uniq'

# -------------------------------------
# cdr
# -------------------------------------

[ ! -e "${XDG_CACHE_HOME:-$HOME/.cache}/shell" ] && mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/shell"

autoload -U chpwd_recent_dirs cdr add-zsh-hook; add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':completion:*:*:cdr:*:*' menu selection
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 32
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-pushd true
zstyle ':chpwd:*' recent-dirs-file "${XDG_CACHE_HOME:-$HOME/.cache}/shell/chpwd-recent-dirs"

# -------------------------------------
# prompt
# -------------------------------------

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{red}'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}'
zstyle ':vcs_info:*' formats '%u%c%b'
zstyle ':vcs_info:*' actionformats '%u%c%b|%a'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

function +vi-git-untracked() {
  if command git status --porcelain 2> /dev/null \
    | awk '{print $1}' \
    | command grep -F '??' > /dev/null 2>&1 ; then
    hook_com[unstaged]+='%F{yellow}'
  fi
}

function update_vcs_info() {
  psvar=()
  vcs_info
  [[ -n $vcs_info_msg_0_ ]] && echo $vcs_info_msg_0_
}

setopt prompt_subst
PROMPT=$'
%{$fg_bold[yellow]%}%n@%m %{$fg_bold[green]%}%~%{$reset_color%} %{$fg_bold[blue]%}`update_vcs_info`%{$reset_color%}
%(?,,%{$fg_bold[red]%}%? )%{$reset_color%}❯ '
RPROMPT='%D{%H:%M:%S}'

# -------------------------------------
# functins
# -------------------------------------

# move to git root
function gr() {
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    cd `git rev-parse --show-toplevel`
  fi
}

# peco select history
function peco-select-history() {
  local tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
  BUFFER=$(history -n 1 | \
    eval $tac | \
    peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history

function open_cdr {
  if [[ -z "$BUFFER" ]]; then
    BUFFER="cdr "
    CURSOR=$#BUFFER
    zle expand-or-complete
  else 
    zle expand-or-complete
  fi
}
zle -N open_cdr

# -------------------------------------
# key bindings
# -------------------------------------

bindkey -v

bindkey '^P'  history-beginning-search-backward
bindkey '^N'  history-beginning-search-forward
bindkey '^?'  backward-delete-char
bindkey '^h'  backward-delete-char
bindkey '^[[Z'  reverse-menu-complete

bindkey '^r'  peco-select-history
bindkey '^I'  open_cdr

autoload -U select-word-style; select-word-style bash
bindkey '^w' backward-kill-word

# -------------------------------------
# aliases
# -------------------------------------

case $OSTYPE in
darwin*)
  alias ls='ls -G'
  ;;
linux*)
  alias ls='ls --color=auto -F --group-directories-first'
  ;;
esac
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -Al'
alias cp='nocorrect cp -i -v'
alias mv='nocorrect mv -i -v'
alias du='du -h'
alias mkdir='nocorrect mkdir'
alias grep='grep --binary-files=without-match --color=auto'
alias vi='vim'
alias sl='ruby ~/.ghq/github.com/pocke/sl_tweet/sl.rb'
alias gl='cd $(ghq list -p | peco)'

alias -g N='> /dev/null 2>&1'

alias -s rb='ruby'
alias -s {html,htm,xhtml}=chromium
alias -s {png,jpg,jpeg,gif,bmp,PNG,JPG,BMP}=viewnior

# -------------------------------------
# plugins
# -------------------------------------

# syntax highlighting
if [ -f ~/.ghq/github.com/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh ]; then
  source ~/.ghq/github.com/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
fi
