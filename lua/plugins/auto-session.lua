-- look at this:
-- https://github.com/josean-dev/dev-environment-files/blob/main/.config/nvim/lua/josean/plugins/auto-session.lua

return {
  "rmagatti/auto-session",
  enabled = false,
  lazy = false,

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    -- cwd_change_handling = {
    --   restore_upcoming_session = false,
    -- },
    -- log_level = 'debug',
  },

  pre_save_cmds = {
    -- "Trouble close",
    -- "DapTerminate",
  },
}
