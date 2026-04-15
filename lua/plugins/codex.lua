return {
    "johnseth97/codex.nvim",

    -- Load only when one of these commands is used.
    cmd = { "Codex", "CodexToggle" },

    -- Keymaps that also trigger lazy-loading.
    keys = {
        {
            "<leader>cc",
            function()
                require("codex").toggle()
            end,
            desc = "Toggle Codex",
            mode = { "n", "t" },
        },
    },

    opts = {
        keymaps = {
            -- Internal plugin toggle mapping.
            -- Keep this nil since we already define our own lazy.nvim keymap above.
            toggle = nil,

            -- Close the Codex window while focused inside it.
            quit = "<C-q>",
        },

        -- Floating window border style.
        -- Valid values from the README: "single", "double", "rounded"
        border = "rounded",

        -- Floating window width as a fraction of the editor width.
        width = 0.85,

        -- Floating window height as a fraction of the editor height.
        height = 0.85,

        -- Specific model to use.
        -- Leave nil to let Codex CLI decide / use its default configuration.
        model = nil,

        -- Auto-install the Codex CLI if it is missing.
        -- Set to false if you prefer managing the CLI yourself.
        autoinstall = false,

        -- false = floating popup
        -- true  = vertical side panel
        panel = false,

        -- false = terminal buffer
        -- true  = capture output in a normal editable buffer
        use_buffer = false,
    },

    config = function(_, opts)
        require("codex").setup(opts)
    end,
}
