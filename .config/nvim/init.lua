vim.env.LUAROCKS_CONFIG = vim.fn.expand("~/.luarocks/config.lua")

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
