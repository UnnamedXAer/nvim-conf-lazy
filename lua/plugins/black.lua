-- specified in the "conform"'s config

-- -- python formatter
-- return {
-- 	"psf/black",
-- 	ft = "python",
-- 	config = function()
-- 		-- auto format buffer on save
-- 		vim.api.nvim_create_autocmd({ "BufferWritePre" }, {
-- 			pattern = "*.py",
-- 			callback = function()
-- 				vim.cmd("Black")
-- 			end,
-- 		})
-- 	end,
-- }