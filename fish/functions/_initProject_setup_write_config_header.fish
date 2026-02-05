function _initProject_setup_write_config_header --argument config_file use_git_bool github_user expanded_base_path
    echo "# Configurações principais" > "$config_file"
    echo "set -g initProject.use_git $use_git_bool" >> "$config_file"
    echo "set -g initProject.github_user "$github_user"" >> "$config_file"
    echo "set -g initProject.base_path "$expanded_base_path"" >> "$config_file"
    echo "" >> "$config_file"
end
