# colors {{{
autoload -Uz colors; colors
if (( $+commands[dircolors] )); then
  eval "$(dircolors -b)"
else
  export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:'
fi
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

# completion
setopt list_packed
setopt magic_equal_subst

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

# prompt
setopt prompt_subst

# load add-zsh-hook function
autoload -Uz add-zsh-hook
# }}}

# exports {{{
# remove duplicate
typeset -Ua cdpath fpath manpath path

export KCODE=u
export REPORTTIME=5
export EDITOR='vim'
export PAGER='less'

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

(( $+commands[ruby] )) && path=(`ruby -e 'print Gem.user_dir'`/bin(N-/) $path)
# }}}

# prompt {{{
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

PROMPT=$'
%{$fg_bold[yellow]%}%n@%m %{$fg_bold[green]%}%~%{$reset_color%} %{$fg_bold[blue]%}`update_vcs_info`%{$reset_color%}
%(?,,%{$fg_bold[red]%}%? )%{$reset_color%}❯ '
RPROMPT='%D{%H:%M:%S}'
# }}}

# completion {{{
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
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file    ~/.cache/zsh/recent-dirs
zstyle ':chpwd:*' recent-dirs-max     1000
zstyle ':chpwd:*' recent-dirs-pushd   true
# }}}

# aliases {{{
alias cp='nocorrect cp -i -v'
alias du='du -h'
alias gdb='gdb -q'
alias grep='grep --binary-files=without-match --color=auto'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv -i -v'
alias tree='tree --dirsfirst'
alias tweet='t update'
alias vi='vim'

case $OSTYPE in
darwin*)
  alias ls='ls -G';;
linux*)
  alias ls='ls --color=auto -F --group-directories-first';;
esac
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -Al'

alias -s jar='java -jar'
alias -s rb='ruby'
alias -s {bmp,gif,jpg,JPG,png,svg}=viewnior
alias -s {html,htm,xhtml}=chromium

alias -g N='> /dev/null 2>&1'
# }}}

# bindkeys {{{
bindkey -v

bindkey '^N'    history-beginning-search-forward
bindkey '^P'    history-beginning-search-backward

bindkey "^A"    beginning-of-line
bindkey "^E"    end-of-line

bindkey '^?'    backward-delete-char
bindkey '^[[Z'  reverse-menu-complete

bindkey "^K"    kill-whole-line
bindkey "^[[3~" delete-char
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
  autoload -Uz chpwd_recent_filehandler
  chpwd_recent_filehandler && for line in $reply; do
  if [[ -d "$line" ]]; then
    echo "$line"
  fi
done
}
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

# fzf {{{
function fzf-recent-dirs() {
  local selected_dir="$(recent-dirs | fzf)"
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${(q)selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}

zle -N fzf-recent-dirs
bindkey '^r'  fzf-recent-dirs

function fzf-select-history() {
  local tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
  BUFFER=$(history -n 1 | \
    eval $tac | \
    fzf --query "$LBUFFER")
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
[ -f $ZSH_SYNTAX_HIGHLIGHTING_PATH ] && source $ZSH_SYNTAX_HIGHLIGHTING_PATH
# }}}

# vim:set foldmethod=marker:
