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
