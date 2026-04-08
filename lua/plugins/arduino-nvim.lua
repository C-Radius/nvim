return {
    "glebzlat/arduino-nvim",
    ft = "arduino",
    config = function()
        require("arduino-nvim").setup()
    end,
}
