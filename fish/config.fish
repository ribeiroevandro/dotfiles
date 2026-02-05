if test -f "$HOME/.eas_credentials"
    source "$HOME/.eas_credentials"
end

set -x PATH "/Users/EvandroBaia/Library/Application Support/Herd/bin/" $PATH
set -x HERD_PHP_84_INI_SCAN_DIR "/Users/EvandroBaia/Library/Application Support/Herd/config/php/84/"
set -x GPG_TTY (tty)
set -x PINENTRY_USER_DATA "USE_CURSES=1"
set -x PATH /usr/local/lib/ruby/gems/3.4.0/bin $PATH

source ~/.local/share/gh/extensions/gh-fish/gh-copilot-alias.fish

# set -g MOV2MP4_SOURCE_DIR ~/Desktop

# set -U fish_user_paths ~/.composer/vendor/bin $fish_user_paths

set -gx ANDROID_HOME $HOME/Android/Sdk
set -gx PATH $PATH:$ANDROID_HOME/emulator
set -gx PATH $PATH:$ANDROID_HOME/tools
set -gx PATH $PATH:$ANDROID_HOME/tools/bin
set -gx PATH $PATH:$ANDROID_HOME/platform-tools


# set -U fish_user_paths ~/Android/Sdk/platform-tools $fish_user_paths
# set -U fish_user_paths $ANDROID_HOME/tools $fish_user_paths
# set -U fish_user_paths $ANDROID_HOME/tools/bin $fish_user_paths
# set -U fish_user_paths $ANDROID_HOME/platform-tools $fish_user_paths

# set -gx PATH $PATH $HOME/.maestro/bin
set MAESTRO_CLI_ANALYSIS_NOTIFICATION_DISABLED true

set -gx DOTFILES_HOME "$HOME/workspace/dotfiles"
source $DOTFILES_HOME/common/alias
source $DOTFILES_HOME/common/expo.fish
source $DOTFILES_HOME/fish/functions/git.fish

load_nvm >/dev/stderr
# if status is-interactive
# Commands to run in interactive sessions can go here
# end

set SPACEFISH_PROMPT_ADD_NEWLINE false

set fish_greeting ""

starship init fish | source

fzf --fish | source
zoxide init fish | source

export FZF_CTRL_T_OPTS="
  --style full
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_CTRL_R_OPTS="
  --style full
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# export FZF_CTRL_T_OPTS="
# --height 100%
# --walker-skip .git,node_modules,target,.DS_Store
# --preview 'bat -n --color=always {}'
# --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
# source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# bun
# set --export BUN_INSTALL "$HOME/.bun"
# set --export PATH $BUN_INSTALL/bin $PATH
# pnpm
set -gx PNPM_HOME /Users/EvandroBaia/Library/pnpm
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Added by Windsurf
fish_add_path /Users/EvandroBaia/.codeium/windsurf/bin

fish_add_path $HOME/.local/bin

# Added by Antigravity
fish_add_path /Users/EvandroBaia/.antigravity/antigravity/bin
