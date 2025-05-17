return {
  "folke/flash.nvim",
  event = "VeryLazy",  -- Lazy-load on demand
  opts = {
    labels = "asdfghjklqwertyuiopzxcvbnm",  -- Jump labels
    modes = {
      char = {
        jump_labels = true,
      },
    },
  },
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function() require("flash").jump() end,
      desc = "Flash",
    },
    {
      "S",
      mode = { "n", "x", "o" },
      function() require("flash").treesitter() end,
      desc = "Flash Treesitter",
    },
  },
}
