### Variables
export EDITOR="vim"
export KCODE=u
export LANG=en_US.UTF-8
export REPORTTIME=5

path=(
  ~/.local/bin(N-/)
  ~/.gem/ruby/2.1.0/bin(N-/)
  ~/.cabal/bin(N-/)
  ~/.go/bin(N-/)
  $path
)

# remove duplicate path
typeset -Ua path cdpath fpath manpath

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# golang
export GOPATH=~/.go

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
bindkey '^r' peco-select-history

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

### cdr
[ ! -e "${XDG_CACHE_HOME:-$HOME/.cache}/shell" ] && mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/shell"

autoload -U chpwd_recent_dirs cdr add-zsh-hook; add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':completion:*:*:cdr:*:*' menu selection
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 64
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-pushd true
zstyle ':chpwd:*' recent-dirs-file "${XDG_CACHE_HOME:-$HOME/.cache}/shell/chpwd-recent-dirs"

function open_cdr {
  if [[ -z "$BUFFER" ]]; then
    BUFFER="cdr "
    CURSOR=$#BUFFER
    zle expand-or-complete
  else 
    BUFFER=$BUFFER";"
    CURSOR=$#BUFFER
  fi
}
zle -N open_cdr
bindkey ";" open_cdr

### Color
autoload -U colors; colors
export LS_COLORS='no=00;38;5;252:rs=0:di=01;38;5;111:ln=01;38;5;113:mh=00:pi=48;5;241;38;5;192;01:so=48;5;241;38;5;192;01:do=48;5;241;38;5;192;01:bd=48;5;241;38;5;177;01:cd=48;5;241;38;5;177;01:or=48;5;236;38;5;196:su=48;5;209;38;5;235:sg=48;5;192;38;5;235:ca=30;41:tw=48;5;113;38;5;235:ow=48;5;113;38;5;111:st=48;5;111;38;5;235:ex=01;38;5;209:*#=00;38;5;246:*~=00;38;5;246:*.o=00;38;5;246:*.swp=00;38;5;246:'

# syntax highlighting
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh ]; then
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
fi

### Prompt
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
%(?,,%{$fg_bold[red]%}%?%{$reset_color%} )❯ '
RPROMPT='%D{%H:%M:%S}'

### Title
case "${TERM}" in
  kterm*|xterm*|)
    precmd() {
      echo -ne "\033]0;${USER}@${HOST%%.*} (${SHELL})\007"
    }
    ;;
esac

### Aliases
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
alias grep='grep --color -I'
alias vi='vim'
alias sl='ruby ~/.local/bin/sl/sl.rb'
alias gl='cd $(ghq list -p | peco)'
alias webrick="ruby -rwebrick -e 'WEBrick::HTTPServer.new({:DocumentRoot => \"./\", :Port => 3000}).start'"

alias -s rb='ruby'
alias -s {html,htm,xhtml}=chromium
alias -s {png,jpg,jpeg,gif,bmp,PNG,JPG,BMP}=viewnior
