#!/bin/zsh

push() {
  echo "push"
  # git push origin $(git_current_branch) $@
}

pull() {
  git pull origin $(git_current_branch) $@
}

incoming() {
  branch=$(git rev-parse --abbrev-ref HEAD)
  if git rev-parse --abbrev-ref "$branch@{upstream}" &>/dev/null; then
    git fetch --quiet
    git log --pretty=format:'%C(yellow)%h %C(white)- %C(red)%an %C(white)- %C(cyan)%d%Creset %s %C(white)- %ar%Creset' .."$branch@{upstream}"
  else
    echo "Nenhum upstream configurado para o branch '$branch'"
  fi
}

outgoing() {
  branch=$(git rev-parse --abbrev-ref HEAD)
  if git rev-parse --abbrev-ref "$branch@{upstream}" &>/dev/null; then
    git fetch --quiet
    git log --pretty=format:'%C(yellow)%h %C(white)- %C(red)%an %C(white)- %C(cyan)%d%Creset %s %C(white)- %ar%Creset' "$branch@{upstream}"..
  else
    echo "Nenhum upstream configurado para o branch '$branch'"
  fi
}


delete-branches() {
  git worktree prune
  # Lista branches usados em worktrees
  used_branches=$(git worktree list --porcelain | grep '^branch ' | awk '{print $2}')
  for branch in $(git branch | grep -v -E -w '(main|develop)$' | sed 's/^[* ]*//'); do
    if echo "$used_branches" | grep -qw "$branch"; then
      echo "Skipping branch '$branch' because it is used by a worktree."
    else
      git branch -D "$branch"
    fi
  done
}