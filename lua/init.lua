-- Set <space> as leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal.
vim.g.have_nerd_font = true

require('lazy_init')

-- [[ Setting options ]]

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays `which-key` popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  See `:help 'listchars'`
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimum number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 3

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

-- Diagnostic Keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Delete shada files
vim.api.nvim_create_user_command("ClearShada", function()
    local shada_path = vim.fn.expand(vim.fn.stdpath("data") .. "/shada")
    local files = vim.fn.glob(shada_path .. "/*", false, true)
    local all_success = 0
    for _, file in ipairs(files) do
        local file_name = vim.fn.fnamemodify(file, ":t")
        if file_name == "main.shada" then
            goto continue
        end
        local success = vim.fn.delete(file)
        all_success = all_success + success
        if success ~= 0 then
            vim.notify("Couldn't delete file '" .. file_name .. "'", vim.log.levels.WARN)
        end
        ::continue::
    end
    if all_success == 0 then
        vim.print("Successfully deleted all temporary shada files")
    end
end, { desc = "Clears all the `.tmp` shada files." })

-- Centre the current line after jumping half a page.
vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true })

-- Highlight when yanking (copying) text.
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Spell checking
local function toggleSpellcheck()
    local spell = vim.opt_local.spell:get()
    vim.opt_local.spell = not spell
    if spell then
        vim.opt_local.spelllang = ""
    else
        vim.opt_local.spelllang = "en_gb"
    end
end

vim.keymap.set('n', [[<leader>\]], toggleSpellcheck, { desc = "Toggles spellchecking" })
vim.keymap.set('i', '<M-L>', '<C-g>u<Esc>[s1z=`]a<C-g>u', { desc = "Correct the most recent spellcheck error." })

-- Toggle conceal level
local function toggleConceal()
    local conceal = vim.opt_local.conceallevel:get()
    if conceal > 0 then
        vim.opt_local.conceallevel = 0
    else
        vim.opt_local.conceallevel = 2
    end
    vim.print("Conceal level: " .. vim.opt_local.conceallevel:get())
end
vim.keymap.set('n', '<leader>tcl', toggleConceal, { desc = "[T]oggle [C]onceal" })

-- -- LuaSnips
-- local M = {}
--
-- local nvim_snippets_path = "lua/snippets"
-- local luasnip_snippets_path = "lua/luasnip_snippets/snippets"
-- local nvim_snippets_modules = "snippets."
-- local luasnip_snippets_modules = "luasnip_snippets.snippets."
--
-- function str_2_table(s, delimiter)
--     result = {};
--     for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
--         table.insert(result, match);
--     end
--     return result;
-- end
--
-- function get_file_name(file)
--     return file:match("^.+/(.+)$")
-- end
--
-- function insert_snippets_into_table(t, modules_str, paths_table)
--     for _, snip_fpath in ipairs(paths_table) do
--         local snip_mname = get_file_name(snip_fpath):sub(1, -5)
--         local sm = require(modules_str .. snip_mname)
--
--         for ft, snips in pairs(sm) do
--             if t[ft] == nil then
--                 t[ft] = {}
--             else
--                 for _, snip in ipairs(snips) do
--                     table.insert(t[ft], snip)
--                 end
--             end
--         end
--     end
--     return t
-- end
--
-- function M.load_snippets()
--     print("load luasnip_snippets")
--     local t = {}
--
--     local nvim_snippets = vim.api.nvim_get_runtime_file(nvim_snippets_path .. "*.lua", true)
--     local luasnip_snippets = vim.api.nvim_get_runtime_file(luasnip_snippets_path .. "*.lua", true)
--
--     t = insert_snippets_into_table(t, nvim_snippets_modules, nvim_snippets)
--     t = insert_snippets_into_table(t, luasnip_snippets_modules, luasnip_snippets)
--
--     return t
-- end

local dap = require('dap')
local api = vim.api

---@type vim.api.keyset.keymap[]
local keymap_restore = {}

dap.listeners.after.event_initialized['me'] = function()
    for _, buf in pairs(api.nvim_list_bufs()) do
        local keymaps = api.nvim_buf_get_keymap(buf, 'n')
        for _, keymap in pairs(keymaps) do
            if keymap.lhs == "K" then
                table.insert(keymap_restore, keymap)
                api.nvim_buf_del_keymap(buf, "n", "K")
            end
        end
    end
    -- api.nvim_set_keymap('n', 'K', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
    api.nvim_set_keymap('n', 'K', '<Cmd> lua require("dapui").eval()<CR>', { silent = true })
    -- vim.keymap.set('n', 'K', function()
    --     require("dapui").eval()
    -- end, { silent = true })
end

dap.listeners.after.event_terminated['me'] = function()
    for _, keymap in pairs(keymap_restore) do
        api.nvim_buf_set_keymap(
            keymap.buffer,
            keymap.mode,
            keymap.lhs,
            keymap.rhs,
            { silent = keymap.silent == 1 }
        )
    end
    keymap_restore = {}
end

-- require("nvim-dap-projects").search_project_config()

-- Update this path
-- local extension_path = require("mason-registry").get_package("codelldb"):get_install_path() ..
--     "/extension"
local extension_path = vim.fn.expand("$MASON/packages/codelldb/extension/")
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb'
local this_os = vim.uv.os_uname().sysname;
-- This path is different on Windows
if this_os:find "Windows" then
    codelldb_path = extension_path .. [[adapter\codelldb.exe]]
    liblldb_path = extension_path .. [[lldb\bin\liblldb.dll]]
else
    liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
end

vim.g.rustaceanvim = function()
    local cfg = require("rustaceanvim.config")
    return {
        dap = {
            adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
        }
    }
end

-- Sourcing lua and .vim files
vim.keymap.set("n", "<space>xs", "<cmd>source %<CR>", { desc = "E[x]ecute ([s]ource) current file" })
vim.keymap.set("n", "<space>xl", ":.lua<CR>", { desc = "E[x]ecute (source) current [l]ua file" })
vim.keymap.set("v", "<space>xl", ":lua<CR>", { desc = "E[x]ecute (source) current [l]ua file lines" })

-- Terminal mode
vim.api.nvim_create_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end,
})

vim.keymap.set('t', '<C-w>h', [[<C-\><C-n><C-w>h]], { silent = true })

-- Small terminal
vim.keymap.set('n', '<leader>st', function()
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 10)
end)
