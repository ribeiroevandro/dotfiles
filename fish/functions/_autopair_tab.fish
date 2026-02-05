function _autopair_tab
    commandline --paging-mode && commandline --function accept-autosuggestion && return

    string match --quiet --regex -- '\$[^\s]*"$' (commandline --current-token) &&
        commandline --function end-of-line --function backward-delete-char
    commandline --function complete
end
