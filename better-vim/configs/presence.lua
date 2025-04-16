return {
    auto_update = true,
    client_id = "1065760436861030400",
    neovim_image_text = "Neovim at its best",
    main_image = "neovim",
    workspace_text = "Neovim at its best",
    editing_text = ".",
    buttons = {
      { label = "My dotfiles", url = "https://github.com/ribeiroevandro/dotfiles" },
    },
    show_time = false,
    reading_text = function(buf_name)
      -- Extract the process name running in toggleterm from the given buffer name
      local toggleterm_process = buf_name:match(".+:(.+);#toggleterm")
  
      -- Return custom text
      if toggleterm_process == "lazygit" then
        return "Committing files"
      end
  
      return string.format("Reading %s", buf_name)
    end
  }