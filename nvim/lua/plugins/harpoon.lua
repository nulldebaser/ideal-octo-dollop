return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup()

        -- Example keybindings (you can change them to your preferences)
        local keymap = vim.keymap.set
        keymap("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon: Add file" })
        keymap("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
            { desc = "Harpoon: Toggle menu" })
        keymap("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon: File 1" })
        keymap("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon: File 2" })
        keymap("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon: File 3" })
        keymap("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon: File 4" })
    end,
}
