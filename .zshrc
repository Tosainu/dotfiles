# exports {{{
# remove duplicate
typeset -Ua cdpath fpath manpath path

export REPORTTIME=5
export EDITOR='vim'
export FUZZY_FINDER='fzy'
export PAGER='less'
export WORDCHARS="${WORDCHARS:s@/@}"
if [ -f $HOME/.config/less ]; then
  export LESSKEY=~/.config/less
fi

fpath=(
  /usr/share/zsh/site-functions(N-/)
  $fpath
)

path=(
  ~/.local/bin(N-/)
  ~/.cargo/bin(N-/)
  /usr/local/bin(N-/)
  $path
)

if (( $+commands[ruby] )); then
  path=($(ruby -e 'print Gem.user_dir')/bin(N-/) $path)
fi

# rust
if (( $+commands[rustc] )); then
  export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
fi

# colors
if (( $+commands[dircolors] )); then
  eval "$(dircolors -b)"
else
  export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:'
fi
# }}}

# autoloading functions {{{
autoload -Uz colors; colors
autoload -Uz compinit; compinit -d ~/.cache/zsh/compdump
autoload -Uz add-zsh-hook
autoload -Uz cdr
autoload -Uz chpwd_recent_dirs
autoload -Uz chpwd_recent_filehandler
autoload -Uz smart-insert-last-word
autoload -Uz vcs_info
# }}}

# basic settings {{{
# create ~/.cache/zsh directory
[ ! -d ~/.cache/zsh ] && mkdir -p ~/.cache/zsh

setopt correct
setopt extended_glob
setopt globdots
setopt ignore_eof
setopt mark_dirs
setopt no_beep
setopt noautoremoveslash
setopt print_eight_bit

# directory
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups

# History
HISTFILE=~/.cache/zsh/history
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt inc_append_history
# }}}

# prompt {{{
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' max-exports    1
zstyle ':vcs_info:*' formats        '%F{blue}%m%u%c%b%f'
zstyle ':vcs_info:*' actionformats  '%F{blue}%m%u%c%b|%a%f'
zstyle ':vcs_info:*' stagedstr      '%f%F{red}'
zstyle ':vcs_info:*' unstagedstr    '%f%F{yellow}'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

function +vi-git-untracked() {
  local reporoot=$(git rev-parse --show-toplevel)
  if [[ -n $(git ls-files --others --exclude-standard "$reporoot") ]]; then
    hook_com[misc]+='%f%F{yellow}'
  fi
}

add-zsh-hook precmd vcs_info

PROMPT=$'
%B%F{yellow}%n@%m%f %F{green}%~%f ${vcs_info_msg_0_}
%(?,,%F{red}%?%f )\ue0b1%b '
# }}}

# completion {{{
setopt list_packed
setopt magic_equal_subst

zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list
zstyle ':completion:*:*:*:*:*' menu select=2

# caching
zstyle ':completion::complete:*' cache-path ~/.cache/zsh/compcache
zstyle ':completion::complete:*' use-cache on

# case-insensitive match
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# directories
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' recent-dirs-insert both
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories

# kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single
# }}}

# cdr {{{
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file    ~/.cache/zsh/recent-dirs
zstyle ':chpwd:*' recent-dirs-max     1000
zstyle ':chpwd:*' recent-dirs-pushd   true
# }}}

# aliases {{{
alias cp='cp -i -v'
alias gdb='gdb -q'
alias grep='grep --binary-files=without-match --color=auto'
alias mv='mv -i -v'
alias sudo='sudo '
alias tree='tree --dirsfirst'
alias tweet='t update'
alias vi='vim'
alias www='ruby -run -ehttpd --'

case $OSTYPE in
darwin*)
  alias ls='ls -G';;
linux*)
  alias ls='ls --color=auto -F --group-directories-first';;
esac
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -Al'

if (( $+commands[stack] )); then
  alias ghc='stack ghc --'
  alias ghci='stack ghci --'
  alias runhaskell='stack runhaskell --'
fi

alias -s jar='java -jar'

open=${commands[open]:-${commands[xdg-open]}}
if [[ ! -z $open ]]; then
  alias open="$open"

  # images
  alias -s {bmp,gif,jpg,JPG,png,svg}='open'
  # documents
  alias -s {html,htm,pdf}='open'
  # medias
  alias -s {MOV,avi,m4v,mkv,mp3,mp4,mpg}='open'
fi

alias -g L="| $PAGER"
alias -g N='> /dev/null 2>&1'
alias -g X='| xargs'
# }}}

# bindkeys {{{
bindkey -e

bindkey '^N'    history-beginning-search-forward
bindkey '^P'    history-beginning-search-backward

bindkey "^A"    beginning-of-line
bindkey "^E"    end-of-line

bindkey "^?"    backward-delete-char
bindkey "^K"    kill-whole-line
bindkey "^[[3~" delete-char
bindkey '^W'    backward-kill-word

bindkey '^[[Z'  reverse-menu-complete

zle -N insert-last-word smart-insert-last-word
bindkey '^]' insert-last-word
# }}}

# term {{{
# Title
case $TERM in
  xterm*)
    function update_title() {
      echo -ne "\033]0;${USER}@${HOST%%.*} (${SHELL})\007"
    }
    add-zsh-hook precmd update_title
    ;;
esac

# https://github.com/thestinger/termite#id2
if [[ $TERM == xterm-termite && -a "/etc/profile.d/vte.sh" ]]; then
  . /etc/profile.d/vte.sh
fi

# disable XON/XOFF flow control
stty -ixon -ixoff 2> /dev/null
# }}}

# functions {{{
# move to git root
function gr() {
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    cd $(git rev-parse --show-toplevel)
  fi
}

function recent-dirs() {
  local line
  chpwd_recent_filehandler && for line in $reply; do
  if [[ -d "$line" ]]; then
    echo "$line"
  fi
done
}

function fuzzy-recent-dirs() {
  local selected_dir=$(recent-dirs | $FUZZY_FINDER --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${(q)selected_dir}"
    zle accept-line
  fi
}

zle -N fuzzy-recent-dirs
bindkey '^r'  fuzzy-recent-dirs

function fuzzy-select-history() {
  BUFFER=$(history -n 1 | ${commands[tac]:-"tail -r"} | $FUZZY_FINDER --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}

zle -N fuzzy-select-history
bindkey '^h'  fuzzy-select-history

function gl() {
  local selected_dir="$(ghq list -p | $FUZZY_FINDER)"
  if [ -n "$selected_dir" ]; then
    cd ${(q)selected_dir}
  fi
}
# }}}

# plugins {{{
ZSH_SYNTAX_HIGHLIGHTING_PATH=/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
if [ -f $ZSH_SYNTAX_HIGHLIGHTING_PATH ]; then
  source $ZSH_SYNTAX_HIGHLIGHTING_PATH
fi
# }}}

if [ -f $HOME/.zshrc.local ]; then
  source $HOME/.zshrc.local
fi

# vim:set foldmethod=marker:
