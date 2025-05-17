return {
  "j-hui/fidget.nvim",
  tag = "legacy",  -- Use 'legacy' if you're not using nightly or 0.10+
  config = function()
    require("fidget").setup({
      text = {
        spinner = "dots",         -- Animation spinner
        done = "✔",               -- Completion icon
      },
      align = {
        bottom = true,
        right = true,
      },
      timer = {
        spinner_rate = 125,
        fidget_decay = 2000,
        task_decay = 1000,
      },
      window = {
        relative = "editor",      -- Position relative to editor
        blend = 0,                -- Transparency
      },
    })
  end,
}
