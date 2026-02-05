# Function: git_current_branch
# Description: Returns the name of the current git branch
function git_current_branch --description "Get the name of the current git branch"
    git rev-parse --abbrev-ref HEAD
end

# Function: push
# Description: Pushes the current branch to origin
function push --description "Push the current branch to origin"
    git push origin (git_current_branch) $argv
end

# Function: pull
# Description: Pulls the current branch from origin
function pull --description "Pull the current branch from origin"
    git pull origin (git_current_branch) $argv
end

# Function: incoming
# Description: Show commits available on the remote that have not yet been pulled into the current branch
function incoming --description "Show remote commits not yet in the local branch"
    set branch (git_current_branch)

    # Suppress both stdout and stderr
    if git rev-parse --abbrev-ref "$branch@{upstream}" >/dev/null 2>&1
        git fetch --quiet
        git log --pretty=format:'%C(yellow)%h %C(white)- %C(red)%an %C(white)- %C(cyan)%d%Creset %s %C(white)- %ar%Creset' .."$branch@{upstream}"
    else
        echo "No upstream configured for branch '$branch'"
    end
end

# Function: outgoing
# Description: Show commits in the current branch that have not yet been pushed to the remote
function outgoing --description "Show local commits not yet pushed to the remote"
    set branch (git_current_branch)

    # Suppress both stdout and stderr
    if git rev-parse --abbrev-ref "$branch@{upstream}" >/dev/null 2>&1
        git fetch --quiet
        git log --pretty=format:'%C(yellow)%h %C(white)- %C(red)%an %C(white)- %C(cyan)%d%Creset %s %C(white)- %ar%Creset' "$branch@{upstream}"..
    else
        echo "No upstream configured for branch '$branch'"
    end
end

# Function: delete-branches
# Description: Delete local branches not used in any git worktree (except main and develop)
# function delete-branches --description "Delete local branches not in use by any worktree (excluding main/develop)"
#     git worktree prune

#     for branch in (git branch | grep -v -E -w '(main|develop)$' | sed 's/^[* ]*//')
#         set delete_output (git branch -D "$branch" 2>&1)
#         if string match -q "*Deleted branch*" -- "$delete_output"
#             echo $delete_output
#         end
#     end
# end

function delete-branches --description "Delete local branches not in use by any worktree (excluding main/develop)"
    git worktree prune

    # Collect branches to delete
    set branches_to_delete
    for branch in (git branch | grep -v -E -w '(main|develop)$' | sed 's/^[* ]*//')
        set -a branches_to_delete "$branch"
    end

    # Check if there are branches to delete
    if test (count $branches_to_delete) -eq 0
        echo "No branches to delete."
        return 0
    end

    # Show list of branches
    echo "The following branches will be deleted:"
    echo ""
    for branch in $branches_to_delete
        echo "  • $branch"
    end
    echo ""

    # Ask for confirmation
    read -P "Do you want to proceed? [y/N] " -l confirmation

    if test "$confirmation" = y -o "$confirmation" = Y
        echo ""
        for branch in $branches_to_delete
            set delete_output (git branch -D "$branch" 2>&1)
            if string match -q "*Deleted branch*" -- "$delete_output"
                echo $delete_output
            end
        end
    else
        echo "Operation cancelled."
    end
end

# Function: gco
# Description: Fuzzy find and switch to a git branch using fzf
function gco --description "Switch to a branch using fzf for selection"
    set branch (git branch --format='%(refname:short)' | fzf)
    if test -n "$branch"
        git switch "$branch"
    end
end
