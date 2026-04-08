return {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "*",
    config = function()
        require("window-picker").setup({
            hint = "statusline-winbar",
            selection_chars = "FJDKSLA;CMRUEIWOQP",
            picker_config = {
                handle_mouse_click = false,
                statusline_winbar_picker = {
                    selection_display = function(char)
                        return "%=" .. char .. "%="
                    end,
                    use_winbar = "never",
                },
                floating_big_letter = {
                    font = "ansi-shadow",
                },
            },
            show_prompt = true,
            prompt_message = "Pick window: ",
            filter_func = nil,
            filter_rules = {
                autoselect_one = true,
                include_current_win = false,
                include_unfocusable_windows = false,
                bo = {
                    filetype = { "NvimTree", "neo-tree", "notify", "snacks_notif" },
                    buftype = { "terminal" },
                },
                wo = {},
                file_path_contains = {},
                file_name_contains = {},
            },
            highlights = {
                enabled = true,
                statusline = {
                    focused = {
                        fg = "#ededed",
                        bg = "#e35e4f",
                        bold = true,
                    },
                    unfocused = {
                        fg = "#ededed",
                        bg = "#44cc41",
                        bold = true,
                    },
                },
                winbar = {
                    focused = {
                        fg = "#ededed",
                        bg = "#e35e4f",
                        bold = true,
                    },
                    unfocused = {
                        fg = "#ededed",
                        bg = "#44cc41",
                        bold = true,
                    },
                },
            },
        })
    end,
}
