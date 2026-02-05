function copy --description "Copy files path"
  
   set -l CURRENT_PATH (string replace -r "^$HOME" "~" $PWD)
  
   set -l destination $CURRENT_PATH/$argv[1]
  
  if test "$argv[1]" = "." -o -z "$argv[1]"
    echo -n $CURRENT_PATH | pbcopy
    formating success "Copied current path"
    return 1
  end

   if test (count $argv) -eq 0
      formating warning "Nenhum arquivo ou pasta foi passado"
    end

   if test -e $PWD/$argv[1]
        echo -n $destination | pbcopy
        formating success "Copied: $destination"
    else
        formating error "O ($argv[1]) não existe" >&2
    end
end