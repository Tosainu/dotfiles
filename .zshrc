# colors {{{
autoload -Uz colors; colors
if (( $+commands[dircolors] )); then
  eval "$(dircolors -b)"
else
  export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:'
fi
# }}}

# basic settings {{{
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
HISTFILE=~/.zsh_history
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
autoload -Uz compinit; compinit

zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' '+m:{a-z}={A-Z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' use-cache true
zstyle ':completion:*' recent-dirs-insert both
zstyle ':completion:*:*:cdr:*:*' menu selection
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:processes-names' command  'ps c -u ${USER} -o command | uniq'
# }}}

# cdr {{{
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file    "$HOME/.config/zsh/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-max     1000
zstyle ':chpwd:*' recent-dirs-pushd   true

[ ! -d $HOME/.config/zsh ] && mkdir -p $HOME/.config/zsh
# }}}

# aliases {{{
alias cp='nocorrect cp -i -v'
alias du='du -h'
alias gdb='gdb -q'
alias gl='cd $(ghq list -p | fzf)'
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
function fzf-cdr() {
  local selected_dir=$(cdr -l | awk '{ print $2 }' | fzf)
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}

zle -N fzf-cdr
bindkey '^r'  fzf-cdr

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
# }}}

# plugins {{{
ZSH_SYNTAX_HIGHLIGHTING_PATH=~/.ghq/github.com/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
if [ -f $ZSH_SYNTAX_HIGHLIGHTING_PATH ]; then
  source $ZSH_SYNTAX_HIGHLIGHTING_PATH
fi
# }}}

# vim:set foldmethod=marker:
