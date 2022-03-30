# exports {{{
# remove duplicate
typeset -U cdpath CDPATH fpath FPATH manpath MANPATH path PATH

export REPORTTIME=5
export EDITOR='vim'
export FUZZY_FINDER='fzy'
export FUZZY_FINDER_OPTS=(-p $(tput bold)$'fzy \ue0b1 '$(tput sgr0))
export PAGER='less'
export WORDCHARS="${WORDCHARS:s@/@}"
export LESSHISTFILE='/dev/null'

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

# colors
if (( $+commands[dircolors] )); then
  eval "$(dircolors -b)"
else
  export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:'
fi
# }}}

# basic settings {{{
# create ~/.cache/zsh directory
if [[ ! -d ~/.cache/zsh ]]; then
  mkdir -p ~/.cache/zsh
fi

autoload -Uz add-zsh-hook

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

# https://github.com/mollifier/config/blob/master/dot.zshrc
function _history_ignore() {
  local line=${1%%$'\n'}
  local cmd=${line%% *}

  [[ ${cmd} != t && ${cmd} != cd ]]
}
add-zsh-hook zshaddhistory _history_ignore
# }}}

# prompt {{{
setopt prompt_subst

autoload -Uz colors; colors
autoload -Uz vcs_info

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

autoload -Uz compinit; compinit -d ~/.cache/zsh/compdump

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
autoload -Uz cdr chpwd_recent_dirs

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
alias vi='vim'
alias www='python3 -m http.server'

case $OSTYPE in
darwin*)
  alias ls='ls -G';;
linux*)
  alias ls='ls --color=auto -F --group-directories-first';;
esac
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -Al'

if ! (( $+commands[tac] )); then
  alias tac='tail -r'
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

# <Del>
bindkey '^[[3~' delete-char

# <S-Tab>
bindkey '^[[Z'  reverse-menu-complete

autoload -Uz smart-insert-last-word
zle -N insert-last-word smart-insert-last-word
bindkey '^]' insert-last-word
# }}}

# term {{{
# Title
case $TERM in
  xterm*)
    function update_title() {
      echo -ne "\\033]0;${USER}@${HOST%%.*} (${SHELL})\\007"
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
  local -Ua reply
  autoload -Uz chpwd_recent_filehandler && chpwd_recent_filehandler
  integer nr=$#reply
  reply=(${^reply}(N/))
  reply=(${reply%/})
  (( $nr == $#reply )) || chpwd_recent_filehandler $reply
  printf "%s\n" "${reply[@]}"
}

function list-git-repos() {
  local repo_dir=(
    ~/work(N-/)
    ~/.vim/pack(N-/)
  )
  if (( $+commands[fd] )); then
    fd --type d --hidden --prune --glob '**/.git' "${repo_dir[@]}"
  else
    find  "${repo_dir[@]}" -type d -name '.git'
  fi | sed 's!/.git$!!'
}

function man() {
  LESS_TERMCAP_mb=$'\E[01;92m'  \
  LESS_TERMCAP_md=$'\E[01;92m'  \
  LESS_TERMCAP_me=$'\E[0m'      \
  LESS_TERMCAP_so=$'\E[7m'      \
  LESS_TERMCAP_se=$'\E[0m'      \
  LESS_TERMCAP_us=$'\E[4;96m'   \
  LESS_TERMCAP_ue=$'\E[0m'      \
  command man $@
}

if (( $+commands[$FUZZY_FINDER] )); then
  function fuzzy-finder() {
    command $FUZZY_FINDER $FUZZY_FINDER_OPTS $@
  }

  function fuzzy-recent-dirs() {
    local selected_dir=$(recent-dirs | fuzzy-finder --query="$LBUFFER")
    zle reset-prompt
    if [[ -n "$selected_dir" ]]; then
      BUFFER="cd ${(q)selected_dir}"
      zle accept-line
    fi
  }

  zle -N fuzzy-recent-dirs
  bindkey '^\[h'  fuzzy-recent-dirs

  function fuzzy-git-dirs() {
    local selected_dir=$(list-git-repos 2> /dev/null | fuzzy-finder --query="$LBUFFER")
    zle reset-prompt
    if [[ -n "$selected_dir" ]]; then
      BUFFER="cd ${(q)selected_dir}"
      zle accept-line
    fi
  }

  zle -N fuzzy-git-dirs
  bindkey '^\[g'  fuzzy-git-dirs

  function fuzzy-select-history() {
    local selected=$(history -n 1 | tac | fuzzy-finder --query="$LBUFFER")
    if [[ -n "$selected" ]]; then
      BUFFER="$selected"
      CURSOR=$#BUFFER
    fi
    zle reset-prompt
  }
  zle -N fuzzy-select-history
  bindkey '^\[r'  fuzzy-select-history
fi
# }}}

# plugins {{{
plugins=(
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh(N-.)
  ~/work/github.com/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh(N-.)
  ~/.zshrc.local(N-.)
)
for plugin in $plugins; do
  source "$plugin"
done
# }}}

# vim:set foldmethod=marker:
