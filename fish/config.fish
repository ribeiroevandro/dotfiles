set -gx DOTFILES_HOME "$HOME/workspace/dotfiles"

source $DOTFILES_HOME/common/alias
source $DOTFILES_HOME/fish/functions/git.fish

if status is-interactive
# Commands to run in interactive sessions can go here
end
# load_nvm > /dev/stderr

# set SPACEFISH_PROMPT_ADD_NEWLINE false
set fish_greeting ""    

starship init fish | source

fzf --fish | source
zoxide init fish | source

export FZF_CTRL_T_OPTS="
  --height 100%
  --walker-skip .git,node_modules,target,.DS_Store
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"