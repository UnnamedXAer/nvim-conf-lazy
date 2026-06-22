function set_dap_elements()
  -- https://neovim.io/doc/user/builtin.html#sign_define()
  vim.fn.sign_define("DapBreakpoint", {
    text = "", -- nerdfonts icon here
    texthl = "yellow", -- color of the icon | color or some kind of group
    linehl = "", -- color of the line text (your code)
    numhl = "blue", -- color of the line number
    culhl = "", -- color of the icon defined above when the cursor in on that line
  })

  vim.fn.sign_define("DapBreakpointCondition", {
    text = "",
    texthl = "yellow", -- color of the icon | color or some kind of group
    linehl = "", -- color of the line text (your code)
    numhl = "blue", -- color of the line number
    culhl = "", -- color of the icon defined above when the cursor in on that line
  })

  vim.fn.sign_define("DapStopped", {
    text = "",
    texthl = "red",
    linehl = "",
    numhl = "orange",
  })

  -- vim.fn.sign_define("DapBreakpoint", {
  --   text = "", -- nerdfonts icon here
  --   texthl = "DapBreakpointSymbol",
  --   linehl = "DapBreakpoint",
  --   numhl = "DapBreakpoint",
  -- })

  -- vim.fn.sign_define("DapStopped", {
  --   text = "",
  --   texthl = "DapStoppedSymbol",
  --   linehl = "DapBreakpoint",
  --   numhl = "DapBreakpoint",
  -- })
end

return {
  "projekt0n/github-nvim-theme",
  name = "github-theme",
  lazy = false,
  priority = 1000,
  config = function()
    -- print("Loading github-theme...")
    -- require("github-theme").setup({})
    local theme_style = "github_light"
    local background_color = "light" -- or "dark" for dark mode

    local function apply_theme()
      vim.o.background = background_color
      local ok, err = pcall(vim.cmd.colorscheme, theme_style)
      -- local ok, err = vim.cmd.colorscheme(theme_style)

      -- print("Loading github-theme... ok: ", ok, " err: ", err)

      -- Recover from stale compiled cache (common after plugin/Nvim upgrades on Windows).
      if not ok then
        print("Failed to load theme, recompiling cache and retrying...")
        require("github-theme").compile(true)
        ok, err = pcall(vim.cmd.colorscheme, theme_style)
      end

      if not ok then
        print("Failed to load theme after recompilation: " .. err)
        error(err)
      end
      -- print("Loading github-theme... end")
    end

    apply_theme()
    -- Schedule to ensure it runs after all plugins are loaded.
    -- It looks like the nvim itself resets the colorscheme (maybe because it infers the colorscheme from the terminal or something) after this config runs, so we need to schedule it to run again after everything is loaded.
    vim.schedule(apply_theme)
    -- this is for when nvim is suspended and resumed, it can reset the colorscheme, so we need to reapply it when that happens.
    -- (Ctrl-Z to suspend, then fg to resume in the terminal)
    -- vim.api.nvim_create_autocmd({ "VimResume", "VimEnter" }, {
    --   callback = function()
    --     print("reapplying theme...")
    --     apply_theme()
    --     vim.schedule(apply_theme)
    --   end,
    -- })

    vim.api.nvim_create_autocmd("OptionSet", {
      callback = function()
        if vim.o.background ~= background_color then
          vim.schedule(function()
            apply_theme()
            -- vim.o.background = background_color
            -- vim.cmd.colorscheme(theme_style)
          end)
        end
      end,
    })
  end,
}
