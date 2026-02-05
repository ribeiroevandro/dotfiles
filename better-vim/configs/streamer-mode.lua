return {
  "laytan/cloak.nvim",
  opts = {
    patterns = {
      {
        file_pattern = ".env*",
        cloak_pattern = "=.+",
      },
      {
        file_pattern = "config*",
        cloak_pattern = "=.+",
      },
      {
        file_pattern = "config.json",
        cloak_pattern = ': ".+"',
      },
      {
        file_pattern = "docker-compose.yml",
        cloak_pattern = "PASSWORD=.+",
      },
      {
        file_pattern = "secrets.*",
        cloak_pattern = "=.+",
      },
    },
  },
}