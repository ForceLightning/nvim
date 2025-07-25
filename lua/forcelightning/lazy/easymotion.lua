return {
    -- 'smoka7/hop.nvim',
    -- version = "v2.*",
    'myarcana/hop.nvim',
    version = "4599c7a", -- Fixes issues with linebreaks?
    opts = {
        keys = 'etovxqpdygfblzhckisuran',
        jump_on_sole_occurrence = true,
        case_insensitive = false,
    },
    config = function(opts)
        local hop = require('hop')
        local directions = require('hop.hint').HintDirection
        hop.setup(opts)
        vim.keymap.set('', 'f', function()
            hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
        end, { remap = true })

        vim.keymap.set('', 'F', function()
            hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
        end, { remap = true })

        vim.keymap.set('', 't', function()
            hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
        end, { remap = true })

        vim.keymap.set('', 'T', function()
            hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
        end, { remap = true })
    end
}
