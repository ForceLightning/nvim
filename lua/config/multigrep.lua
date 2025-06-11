local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local conf = require "telescope.config".values

local M = {}

local live_multigrep = function(opts)
    opts = opts or {}
    -- opts.cwd = opts.cwd or vim.uv.cwd()
    opts.cwd = opts.cwd or vim.fn.systemlist("git rev-parse --show-toplevel")[1]

    local finder = finders.new_async_job {
        command_generator = function(prompt)
            if not prompt or prompt == "" then
                return nil
            end

            local pieces = vim.split(prompt, "  ")
            local args = { "ag" }
            if pieces[1] then
                table.insert(args, pieces[1])
            end

            if pieces[2] then
                table.insert(args, "-G")
                table.insert(args, pieces[2])
            end

            args = vim.tbl_flatten {
                args,
                { "--nocolor", "--noheading", "--numbers", "--column", "--smart-case", "--silent", "--vimgrep" }
            }

            return args
        end,
        entry_maker = make_entry.gen_from_vimgrep(opts),
        cwd = opts.cwd,
    }

    pickers.new(opts, {
        debounce = 100,
        prompt_title = "Multi-grep",
        finder = finder,
        previewer = conf.grep_previewer(opts),
        sorter = require("telescope.sorters").empty(),
    }):find()
end

M.setup = function()
    vim.keymap.set("n", "<leader>sm", live_multigrep, { desc = "[S]earch [M]ultigrep" })
end

return M
