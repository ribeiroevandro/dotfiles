#!/bin/zsh

push() {
  git push origin $(git_current_branch) $@
}

pull() {
  git pull origin $(git_current_branch) $@
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