return {
    {
        "danymat/neogen",
        config = function()
            local neogen = require('neogen')
            neogen.setup {
                enabled = true,
                languages = {
                    ['cpp.doxygen'] = require('neogen.configurations.cpp'),
                }
            }
        end,
    },
}
