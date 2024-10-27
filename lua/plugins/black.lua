-- specified in the "conform"'s config

-- return {} -- sitisfy lazy.nvim

-- python formatter
return {
  "psf/black",
  -- "averms/black-nvim",
  ft = "python",
  config = function()
    -- auto format buffer on save
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      pattern = "*.py",
      callback = function()
        vim.cmd("Black")
      end,
    })
  end,
}
