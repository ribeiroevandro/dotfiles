function _initProject_setup_init_config_dir
    set -l config_dir ~/.config/initProject
    set -l config_file $config_dir/config.fish

    if not test -d $config_dir
      mkdir -p $config_dir
      touch $config_file
    end

    # Return config_dir and config_file for use in other functions
    printf "%s\n" $config_dir
    printf "%s\n" $config_file
end
