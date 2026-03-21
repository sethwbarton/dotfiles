return {
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPost",
    opts = {
      user_default_options = {
        css = true,
        names = false,
        rgb_fn = true,
        hsl_fn = true,
        tailwind = true,
        mode = "virtualtext",
        virtualtext = "■",
        virtualtext_inline = "before",
      },
    },
  },
}
