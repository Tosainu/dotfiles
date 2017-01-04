# exports {{{
# remove duplicate
typeset -Ua cdpath fpath manpath path

export REPORTTIME=5
export EDITOR='vim'
export PAGER='less'
export WORDCHARS="${WORDCHARS:s@/@}"

fpath=(
  /usr/share/zsh/site-functions(N-/)
  $fpath
)

path=(
  /usr/local/bin(N-/)
  ~/.local/bin(N-/)
  ~/.cabal/bin(N-/)
  $path
)

if (( $+commands[ruby] )); then
  path=(`ruby -e 'print Gem.user_dir'`/bin(N-/) $path)
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

PROMPT=$'
%{$fg_bold[yellow]%}%n@%m %{$fg_bold[green]%}%~%{$reset_color%} %{$fg_bold[blue]%}`update_vcs_info`%{$reset_color%}
%(?,,%{$fg_bold[red]%}%? )%{$reset_color%}❯ '

# http://zshwiki.org/home/examples/zlewidgets#vi_keys_-_show_mode
function zle-line-init zle-keymap-select {
  RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/}"
  RPS2=$RPS1
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
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
alias cp='nocorrect cp -i -v'
alias gdb='gdb -q'
alias grep='grep --binary-files=without-match --color=auto'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv -i -v'
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

alias -s hs='runhaskell'
alias -s jar='java -jar'
alias -s rb='ruby'

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
bindkey -v

bindkey -M viins '^N'    history-beginning-search-forward
bindkey -M viins '^P'    history-beginning-search-backward

bindkey -M viins "^A"    beginning-of-line
bindkey -M viins "^E"    end-of-line

bindkey -M viins "^?"    backward-delete-char
bindkey -M viins "^K"    kill-whole-line
bindkey -M viins "^[[3~" delete-char
bindkey -M viins '^W'    backward-kill-word

bindkey -M viins '^[[Z'  reverse-menu-complete

zle -N insert-last-word smart-insert-last-word
bindkey -M viins '^]' insert-last-word
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

if [[ $TERM == xterm-termite ]]; then
  . /etc/profile.d/vte.sh
  __vte_osc7
fi
# }}}

# functions {{{
# move to git root
function gr() {
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    cd `git rev-parse --show-toplevel`
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

function fzf-recent-dirs() {
  local selected_dir=$(recent-dirs | fzf --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${(q)selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}

zle -N fzf-recent-dirs
bindkey '^r'  fzf-recent-dirs

function fzf-select-history() {
  BUFFER=$(history -n 1 | fzf --tac --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}

zle -N fzf-select-history
bindkey '^h'  fzf-select-history

function gl() {
  local selected_dir="$(ghq list -p | fzf)"
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
