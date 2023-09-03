# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH
export PATH=$PATH:~/.composer/vendor/bin
export PATH="$PATH:$HOME/flutter/bin"
export TERM=xterm-256color

source ~/initProject.sh
source "$HOME/www/opensource/dotfiles/zsh/functions.sh"

export VISUAL='vim'
export EDITOR=$VISUAL

function msg_init { echo  "\033[1;33m==> $1 \033[0m"; }
function msg_ok { echo  "\033[1;32m==> $1 ✔\033[0m"; }
function msg_error { echo "\033[1;31m✖ $1 ✖\033[0m"; }

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Alias
alias sirius-app="cd ~/www/work/cloudfox/sirius-mobile"
alias clear-ios-simulator="xcrun simctl erase all"
alias check-rede="clear && ping www.uol.com.br"
alias a="php artisan"
alias wip="git add .;git commit -m 'wip' > /dev/null"

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Path to your oh-my-zsh installation.
export ZSH="/Users/$(whoami)/.oh-my-zsh"
export PATH="$PATH:/usr/local/bin"

# if [ "$TMUX" = "" ]; then tmux; fi

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="spaceship"

plugins=(
  git
  zsh-autosuggestions
  yarn-completion
  spaceship-vi-mode
  zsh-wakatime
  tmux
  z
)

source $ZSH/oh-my-zsh.sh

# User configurations

# Emulators
alias nexus5="emulator @Nexus_5"
alias nexus5Play="emulator @Nexus_5_Play"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
alias branch="git symbolic-ref --short HEAD|pbcopy"

# Clean Desktop
alias cleandesk="rm ~/Desktop/Screen*.mov && rm ~/Desktop/Screen*.png && rm ~/Desktop/Simulator*.png"

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

alias ll="exa -lah --git --grid --icons"
alias l="exa -la --git --icons"

# Edit .zshrc
alias zedit="vim ~/.dotfiles/.zshrc"

# Edit .vimrc
alias vedit="vim ~/.dotfiles/.vimrc"

alias vim='nvim'
alias vi='vim'
alias pn='pnpm'

# :better-vim edit
alias bvedit="cd ~/.config/better-vim && vim && 1"

# My $PATH configs
export PATH=./node_modules/.bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/bin:$PATH

# Expo Accounts
# alias expersonal="expo logout && expo login -u 'username' -p 'password'"


eval "$(rbenv init -)"

pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  package       # Package version
  node          # Node.js section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  exec_time     # Execution time
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "

export PATH="/usr/local/sbin:$PATH"


### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light zdharma/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-completions
zinit light buonomo/yarn-completion

function app() {
  case $1 in
    "--aab")
      msg_init "Generating .aab file"
      cd android && ./gradlew bundleRelease && cd ..
      msg_ok ".aab file generated successfully"
      ;;
    "--apk")
      msg_init "Generating .apk file"
      cd android && ./gradlew assembleRelease && cd ..
      msg_ok ".apk file generated successfully"    
      ;;
    "--clean")
      msg_init "Cleaning build folder on Android"
      cd android && ./gradlew clean && cd ../
      msg_ok "Successfully clean build folder"
      ;;
    *)
      msg_error "Informe o comando"
      ;;
  esac
}

function valet_link() {
  project=$1
  full_directory=$(pwd)

  if [[ -z "$project" ]]; then
    project=$(basename "$PWD")
  fi

  eval "ln -s $full_directory ~/www/valet/$project"
  valet secure $project
  open "https://$project.dev"
}

function mdd() {
  mkdir $1 && cd $1
}

function push () {
  git push origin $(git_current_branch) $@
}

function pull () {
  git pull origin $(git_current_branch) $@
}

function delete-branches () {
   for i in $(git branch | grep -v -E -w '(main|develop)$'); do
    git branch -D "$i"
  done
}


export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

export PATH="/opt/homebrew/opt/ruby@3.1/bin:$PATH"
export PATH="/opt/homebrew/lib/ruby/gems/3.1.0/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# place this after nvm initialization!
autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc


# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"


# Turso
export PATH="/Users/ribeiroevandro/.turso:$PATH"

# bun completions
[ -s "/Users/ribeiroevandro/.bun/_bun" ] && source "/Users/ribeiroevandro/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
