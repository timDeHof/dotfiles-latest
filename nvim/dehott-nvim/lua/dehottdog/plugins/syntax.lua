require("nvim-treesitter").install({
	"astro",
	"bash",
	"c",
	"cmake",
	"cpp",
	"css",
	"diff",
	"fish",
	"gitignore",
	"go",
	"graphql",
	"html",
	"http",
	"java",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"php",
	"printf",
	"python",
	"query",
	"regex",
	"rust",
	"scss",
	"sql",
	"svelte",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
})

vim.treesitter.language.register("markdown", "mdx")

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("dehottdog.treesitter", { clear = true }),
	desc = "Start Treesitter highlighting and indent when a parser exists",
	callback = function(ev)
		local lang = vim.treesitter.language.get_lang(ev.match)
		if not lang or not vim.treesitter.language.add(lang) then
			return
		end
		vim.treesitter.start(ev.buf, lang)
		vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

require("todo-comments").setup()

vim.lsp.document_color.enable(false)
require("nvim-highlight-colors").setup({
	enable_named_colors = false,
	enable_tailwind = false,
})
