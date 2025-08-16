return {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    event = {
        "BufReadPre " .. vim.fn.expand "~" .. "/OneDrive - Singapore Institute of Technolgy/Obsidian/*.md",
        "BufNewFile " .. vim.fn.expand "~" .. "/OneDrive - Singapore Institute of Technolgy/Obsidian/*.md",
        "BufReadPre " .. "X:/Repos/obsidian-notes/*.md",
        "BufNewFile " .. "X:/Repos/obsidian-notes/*.md"
    },
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
        workspaces = {
            {
                name = "SIT",
                path = "~/OneDrive - Singapore Institute Of Technology/Obsidian/SIT/"
            },
            {
                name = "Default",
                path = "X:/Repos/obsidian-notes",
            }
        },
        daily_notes = {
            folder = "02 Zettelkasten",
            date_format = "%Y-%m-%d",
            alias_format = "%B %-d, %Y",
            default_tags = { "daily-notes" },
            template = nil,
        },
        completion = {
            nvim_cmp = true,
            min_chars = 2,
        },
        new_notes_location = "notes_subdir",
        preferred_link_style = "wiki",
        picker = {
            name = "telescope.nvim",
            note_mappings = {
                new = "<C-x>",
                insert_link = "<C-l>",
            },
            tag_mappings = {
                tag_note = "<C-x>",
                insert_tag = "<C-l>",
            }
        },

    }
}
