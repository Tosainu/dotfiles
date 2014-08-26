### Variables
export EDITOR="vim"
export KCODE=u
export LANG=en_US.UTF-8
export REPORTTIME=5

path=(
  ~/.local/bin(N-/)
  ~/.gem/ruby/2.1.0/bin(N-/)
  ~/.cabal/bin(N-/)
  $path
)

# remove duplicate path
typeset -Ua path cdpath fpath manpath

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

### Keybind
bindkey -v
bindkey '^[[Z'  reverse-menu-complete
bindkey "^[OH"  beginning-of-line
bindkey "^[OF"  end-of-line
bindkey "^[[3~" delete-char

### Basic
setopt correct
setopt extended_glob
setopt globdots
setopt ignore_eof
setopt mark_dirs
setopt no_beep
setopt noautoremoveslash
setopt print_eight_bit

### Directory
setopt auto_cd
setopt auto_pushd
setopt cdable_vars
setopt pushd_ignore_dups

# move to git root
function gr() {
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    cd `git rev-parse --show-toplevel`
  fi
}

### History
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt inc_append_history
bindkey '^P'    history-beginning-search-backward
bindkey '^N'    history-beginning-search-forward

# show all histories
function history-all { history -E 1 }

### Complement
autoload -U compinit; compinit
setopt list_packed
setopt magic_equal_subst
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list
# complement process ids
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
# highlight completion menu
zstyle ':completion:*' menu select=2
# ignorecase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# set colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# use cache
zstyle ':completion:*' use-cache true

### Color
autoload -U colors; colors
export LS_COLORS='no=00;38;5;252:rs=0:di=01;38;5;111:ln=01;38;5;113:mh=00:pi=48;5;241;38;5;192;01:so=48;5;241;38;5;192;01:do=48;5;241;38;5;192;01:bd=48;5;241;38;5;177;01:cd=48;5;241;38;5;177;01:or=48;5;236;38;5;196:su=48;5;209;38;5;235:sg=48;5;192;38;5;235:ca=30;41:tw=48;5;113;38;5;235:ow=48;5;113;38;5;111:st=48;5;111;38;5;235:ex=01;38;5;209:*#=00;38;5;246:*~=00;38;5;246:*.o=00;38;5;246:*.swp=00;38;5;246:'

# syntax highlighting
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh ]; then
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
fi

### Prompt
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

### Title
case "${TERM}" in
  kterm*|xterm*|)
    precmd() {
      echo -ne "\033]0;${USER}@${HOST%%.*} (${SHELL})\007"
    }
    ;;
esac

### Aliases
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
alias -s {html,htm,xhtml}=chromium
alias -s {png,jpg,jpeg,gif,bmp,PNG,JPG,BMP}=viewnior

hash -d c=~/codes/
hash -d t=/tmp/
hash -d a=/var/abs/
