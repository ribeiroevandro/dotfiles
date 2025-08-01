if test -f "$HOME/.eas_credentials"
    source "$HOME/.eas_credentials"
end

source ~/.local/share/gh/extensions/gh-fish/gh-copilot-alias.fish

set -U fish_user_paths ~/.composer/vendor/bin $fish_user_paths


set -gx PATH $PATH $HOME/.maestro/bin
set -gx DOTFILES_HOME "$HOME/workspace/dotfiles"

set -gx ANDROID_HOME $HOME/Android/Sdk
set -gx PATH $PATH:$ANDROID_HOME/emulator
set -gx PATH $PATH:$ANDROID_HOME/tools
set -gx PATH $PATH:$ANDROID_HOME/tools/bin
set -gx PATH $PATH:$ANDROID_HOME/platform-tools

set -U fish_user_paths ~/Android/Sdk/platform-tools $fish_user_paths
set -U fish_user_paths $ANDROID_HOME/tools $fish_user_paths
set -U fish_user_paths $ANDROID_HOME/tools/bin $fish_user_paths
set -U fish_user_paths $ANDROID_HOME/platform-tools $fish_user_paths

set MAESTRO_CLI_ANALYSIS_NOTIFICATION_DISABLED true

source $DOTFILES_HOME/common/alias
source $DOTFILES_HOME/common/expo.fish
source $DOTFILES_HOME/fish/functions/git.fish


# load_nvm > /dev/stderr
# if status is-interactive
# Commands to run in interactive sessions can go here
# end

set SPACEFISH_PROMPT_ADD_NEWLINE false

set fish_greeting ""    

starship init fish | source

fzf --fish | source
zoxide init fish | source

export FZF_CTRL_T_OPTS="
  --height 100%
  --walker-skip .git,node_modules,target,.DS_Store
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

