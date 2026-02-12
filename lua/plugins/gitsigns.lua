-- -- --

return { -- Adds git related signs to the gutter, as well as utilities for managing changes
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "navigate to next hunk (Gitsigns)" })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "navigate to previous hunk (Gitsigns)" })

        map("n", "hp", gs.preview_hunk, { desc = "preview hunk (Gitsigns)" })

        map("n", "<leader>hs", gs.stage_hunk, { desc = "stage (unstage) hunk((Gitsigns)" })
        map("v", "<leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "stage (unstage) hunk - selected line (Gitsigns)" })

        map(
          "n",
          "<leader>hu",
          gs.undo_stage_hunk,
          { desc = "undo stage hunk (this only reverses last stage/unstage action, similar what 'u' does) (Gitsigns)" }
        )
        map("n", "<leader>hr", gs.reset_hunk, { desc = "reset hunk - discards the changes! (Gitsigns)" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "stage buffer (Gitsigns)" })
        -- map("n", "<leader>hR", gs.reset_buffer, { desc = "reset buffer (Gitsigns)" })

        map("n", "<leader>gb", function()
          gs.blame_line({ full = true })
        end, { desc = "blame line (Gitsigns)" })
      end,

      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
      },
    })
  end,
}
