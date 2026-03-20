-- Default theme used when omarchy is not available (e.g., macOS)
local default_theme = {
	{ "neanias/everforest-nvim" },
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "everforest",
		},
	},
}

-- If omarchy provides a theme file, use it instead
local omarchy_theme = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")
if vim.fn.filereadable(omarchy_theme) == 1 then
	local ok, theme = pcall(dofile, omarchy_theme)
	if ok and theme then
		return theme
	end
end

return default_theme
