# Função para obter o branch atual
function git_current_branch
    git rev-parse --abbrev-ref HEAD
end

# Função para dar push no branch atual
function push
    git push origin (git_current_branch) $argv
end

# Função para dar pull no branch atual
function pull
    git pull origin (git_current_branch) $argv
end

function incoming --description "Show commits available on the remote that have not yet been pulled into the current branch"
    # Get the current branch name
    set branch (git rev-parse --abbrev-ref HEAD)

    # Check if upstream is configured for this branch
    if git rev-parse --abbrev-ref "$branch@{upstream}" ^/dev/null
        # Fetch remote updates quietly
        git fetch --quiet

        # Display incoming commits (present on remote but not yet in local)
        git log --pretty=format:'%C(yellow)%h %C(white)- %C(red)%an %C(white)- %C(cyan)%d%Creset %s %C(white)- %ar%Creset' .."$branch@{upstream}"
    else
        echo "No upstream configured for branch '$branch'"
    end
end

function outgoing --description "Show commits in the current branch that have not yet been pushed to the remote"
    # Get the current branch name
    set branch (git rev-parse --abbrev-ref HEAD)

    # Check if upstream is configured for this branch
    if git rev-parse --abbrev-ref "$branch@{upstream}" ^/dev/null
        # Fetch remote updates quietly
        git fetch --quiet

        # Display outgoing commits (present locally but not yet pushed to remote)
        git log --pretty=format:'%C(yellow)%h %C(white)- %C(red)%an %C(white)- %C(cyan)%d%Creset %s %C(white)- %ar%Creset' "$branch@{upstream}"..
    else
        echo "No upstream configured for branch '$branch'"
    end
end


# Função para deletar branches que não estão sendo usados em worktrees
function delete-branches
    git worktree prune
    
    for branch in (git branch | grep -v -E -w '(main|develop)$' | sed 's/^[* ]*//')
        # Tenta excluir a branch e captura a saída
        set delete_output (git branch -D "$branch" 2>&1)
        
        # Se a saída contiver "Deleted branch", mostra apenas essa linha
        if string match -q "*Deleted branch*" -- "$delete_output"
            echo $delete_output
        end
        # Ignora silenciosamente quaisquer erros
    end
end

function gco
  set branch (git branch --format='%(refname:short)' | fzf)
  if test -n "$branch"
    git switch "$branch"
  end
end