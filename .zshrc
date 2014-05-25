## Basic
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt correct
setopt multios
setopt no_beep
setopt nonomatch
setopt notify
setopt print_eight_bit

## Color
autoload -U colors; colors
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

## Complement
if [ -e /usr/share/zsh/site-functions ]; then
  fpath=(/usr/share/zsh/site-functions $fpath)
fi

autoload -U compinit; compinit
setopt list_packed
setopt mark_dirs
setopt equals
setopt magic_equal_subst
setopt brace_ccl
setopt extended_glob
setopt globdots
setopt numeric_glob_sort
setopt complete_aliases
setopt complete_in_word
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:processes' command 'ps x -o pid,s,args' # complement process ids  
zstyle ':completion:*' menu select=2                  # highlight completion menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'   # ignorecase
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # set colors
zstyle ':completion:*' use-cache true                 # use cache

## History
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt extended_history
setopt hist_expire_dups_first
function history-all { history -E 1 }

## Prompt
# http://qiita.com/hash/items/325cffc755fc1ff91928
setopt prompt_subst

autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null
function git-current-branch {
  local name st color gitdir action
  if [[ "$PWD" =~ '/¥.git(/.*)?$' ]]; then
    return
  fi

  name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
  if [[ -z $name ]]; then
    return
  fi

  gitdir=`git rev-parse --git-dir 2> /dev/null`
  action=`VCS_INFO_git_getaction "$gitdir"` && action="($action)"
  st=`git status 2> /dev/null`

  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    color='%{\e[38;5;117m%}'
  elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
    color='%{\e[38;5;220m%}'
  elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
    color='%B%{\e[38;5;197m%}'
  else
    color='%{\e[38;5;197m%}'
  fi

  echo "${color}[${name}${action}]%{\e[0m%}%b"
}

PROMPT=$'
[${?}] %{\e[38;5;197m%}[${SHELL}] %{\e[38;5;220m%}[${USER}@${HOST%%.*}] %{\e[38;5;076m%}[%~]%{\e[0m%} `git-current-branch` 
%(!.#.$) '
RPROMPT='%D{%b %d, %Y %H:%M:%S}'

## Title user@hostname ($SHELL)
case "${TERM}" in
  kterm*|xterm*|)
    precmd() {
      echo -ne "\033]0;${USER}@${HOST%%.*} (${SHELL})\007"
    }
    ;;
esac

## syntax highlighting
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh ]; then
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
fi

## keybind
bindkey -v
bindkey '^P'    history-beginning-search-backward
bindkey '^N'    history-beginning-search-forward
bindkey '^[[Z'  reverse-menu-complete
bindkey "^[OH"  beginning-of-line
bindkey "^[OF"  end-of-line
bindkey "^[[3~" delete-char

## Aliases
alias cp='nocorrect cp -i -v'
alias mv='nocorrect mv -i -v'
alias ls='ls --color=auto -F'
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -Al'
alias du='du -h'
alias mkdir='nocorrect mkdir'
alias vi='vim'
alias sl="ruby ~/.local/bin/sl/sl.rb"

alias -s rb='ruby'
alias -s {png,jpg,jpeg,gif,bmp,PNG,JPG,BMP}=viewnior
