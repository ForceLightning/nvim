local ls = require("luasnip")

---Utility functions for LaTeX snippets.
---Taken from https://ejmastnak.com/tutorials/vim-latex/luasnip/#context-specific-expansion-for-latex
---@type table
local tex_utils = {}
tex_utils.in_mathzone = function() -- Mathzone detection
    return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

tex_utils.in_text = function() -- Text detection
    return not tex_utils.in_mathzone()
end

tex_utils.in_comment = function() -- Comment detection
    return vim.fn['vimtex#syntax#in_comment']() == 1
end

---Checks if a given environment is currently active.
---@param name string: The name of the environment to check.
---@return boolean: Whether the environment is active.
tex_utils.in_env = function(name)
    local is_inside = vim.fn['vimtex#env#is_inside'](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end

tex_utils.in_equation = function() -- Equation Environment detection
    return tex_utils.in_env('equation')
end

tex_utils.in_itemize = function() -- Itemize Environment detection
    return tex_utils.in_env('itemize')
end

tex_utils.in_tikz = function() -- TikZ Picture Environment detection
    return tex_utils.in_env('tikzpicture')
end

---List of Greek characters and LaTeX symbols
local GS = {
    greek = {
        "alpha",
        "beta",
        "gamma",
        "Gamma",
        "delta",
        "Delta",
        "epsilon",
        "varepsilon",
        "zeta",
        "eta",
        "theta",
        "Theta",
        "iota",
        "kappa",
        "lambda",
        "Lambda",
        "mu",
        "nu",
        "omicron",
        "xi",
        "Xi",
        "pi",
        "Pi",
        "rho",
        "sigma",
        "Sigma",
        "tau",
        "upsilon",
        "Upsilon",
        "varphi",
        "phi",
        "Phi",
        "chi",
        "psi",
        "Psi",
        "omega",
        "Omega",
    },
    symbol = {
        "hbar",
        "ell",
        "nabla",
        "infty",
        "dots",
        "leftrightarrow",
        "Leftrightarrow",
        "mapsto",
        "setminus",
        "mid",
        "bigcap",
        "bigcup",
        "cap",
        "cup",
        "land",
        "lor",
        "subseteq",
        "subset",
        "implies",
        "imbliedby",
        "iff",
        "exists",
        "forall",
        "equiv",
        "square",
        "neq",
        "geq",
        "leq",
        "gg",
        "ll",
        "sim",
        "simeq",
        "approx",
        "propto",
        "cdot",
        "oplus",
        "otimes",
        "times",
        "star",
        "perp",
        "det",
        "exp",
        "ln",
        "log",
        "partial",
        "vdots",
    },
    shortSymbol = {
        "to",
        "pm",
        "mp",
    },
}

---List of snippets for LaTeX. This list is based on the snippets from the LaTeX-Suite plugin for Obisidian.
---@type {trigger: string, replacement: string, options: string, priority: number?, description: string?}[]
local M = {
    -- Math mode
    { trigger = "mk",  replacement = "$$0$",                         options = "tA" },
    { trigger = "dm",  replacement = "$$\n$0\n$$",                   options = "tAw" },
    { trigger = "beg", replacement = "\\begin{$1}\n\t$0\n\\end{$1}", options = "A" },

    -- Greek letters
    { trigger = "@a",  replacement = "\\alpha",                      options = "mA" },
    { trigger = "@b",  replacement = "\\beta",                       options = "mA" },
    { trigger = "@g",  replacement = "\\gamma",                      options = "mA" },
    { trigger = "@G",  replacement = "\\Gamma",                      options = "mA" },
    { trigger = "@d",  replacement = "\\delta",                      options = "mA" },
    { trigger = "@e",  replacement = "\\epsilon",                    options = "mA" },
    { trigger = ":e",  replacement = "\\varepsilon",                 options = "mA" },
    { trigger = "@z",  replacement = "\\zeta",                       options = "mA" },
    { trigger = "@h",  replacement = "\\eta",                        options = "mA" },
    { trigger = "@q",  replacement = "\\theta",                      options = "mA" },
    { trigger = "@i",  replacement = "\\iota",                       options = "mA" },
    { trigger = "@k",  replacement = "\\kappa",                      options = "mA" },
    { trigger = "@l",  replacement = "\\lambda",                     options = "mA" },
    { trigger = "@m",  replacement = "\\mu",                         options = "mA" },
    { trigger = "@n",  replacement = "\\nu",                         options = "mA" },
    { trigger = "@x",  replacement = "\\xi",                         options = "mA" },
    { trigger = "@p",  replacement = "\\pi",                         options = "mA" },
    { trigger = "@r",  replacement = "\\rho",                        options = "mA" },
    { trigger = "@s",  replacement = "\\sigma",                      options = "mA" },
    { trigger = "@t",  replacement = "\\tau",                        options = "mA" },
    { trigger = "@u",  replacement = "\\upsilon",                    options = "mA" },
    { trigger = "@f",  replacement = "\\phi",                        options = "mA" },
    { trigger = "@c",  replacement = "\\chi",                        options = "mA" },
    { trigger = "@y",  replacement = "\\psi",                        options = "mA" },
    { trigger = "@w",  replacement = "\\omega",                      options = "mA" },
    { trigger = "@D",  replacement = "\\Delta",                      options = "mA" },
    { trigger = "@Q",  replacement = "\\Theta",                      options = "mA" },
    { trigger = "@L",  replacement = "\\Lambda",                     options = "mA" },
    { trigger = "@X",  replacement = "\\Xi",                         options = "mA" },
    { trigger = "@P",  replacement = "\\Pi",                         options = "mA" },
    { trigger = "@S",  replacement = "\\Sigma",                      options = "mA" },
    { trigger = "@U",  replacement = "\\Upsilon",                    options = "mA" },
    { trigger = "@F",  replacement = "\\Phi",                        options = "mA" },
    { trigger = "@Y",  replacement = "\\Psi",                        options = "mA" },
    { trigger = "@W",  replacement = "\\Omega",                      options = "mA" },

    {
        trigger = "\\\\(" .. table.concat(GS.greek, "|") .. "|" .. table.concat(GS.symbol, "|") .. ") Vec",
        replacement = "\\mathbf{[[1]]}",
        options = "rmA"
    },


    -- Text environment
    { trigger = "text",         replacement = "\\text{$1}$0",       options = "mA" },
    { trigger = "\"",           replacement = "\\text{$1}$0",       options = "mA" },

    -- Basic operations
    { trigger = "sr",           replacement = "^{2}",               options = "mA" },
    { trigger = "cb",           replacement = "^{3}",               options = "mA" },
    { trigger = "rd",           replacement = "^{$1}$0",            options = "mA" },
    { trigger = "_",            replacement = "_{$1}$0",            options = "mA" },
    { trigger = "sts",          replacement = "_\\text{$1}$0",      options = "mA" },
    { trigger = "sq",           replacement = "\\sqrt{ $1 }$2",     options = "mA" },
    { trigger = "//",           replacement = "\\frac{$1}{$2}$0",   options = "mA" },
    { trigger = "ee",           replacement = "e^{ $0 }$1",         options = "mA" },
    { trigger = "invs",         replacement = "^{-1}",              options = "mA" },
    { trigger = "\\\\\\",       replacement = "\\setminus",         options = "mA" },
    { trigger = "||",           replacement = "\\mid",              options = "mA" },
    { trigger = "and",          replacement = "\\cap",              options = "mA" },
    { trigger = "orr",          replacement = "\\cup",              options = "mA" },
    { trigger = "inn",          replacement = "\\in",               options = "mA" },
    { trigger = "notin",        replacement = "\\not\\in",          options = "mA" },
    { trigger = "\\subset eq",  replacement = "\\subseteq",         options = "mA" },
    { trigger = "eset",         replacement = "\\emptyset",         options = "mA" },
    { trigger = "set",          replacement = "\\{ $1 \\}$0",       options = "mA" },
    { trigger = "=>",           replacement = "\\implies",          options = "mA" },
    { trigger = "=<",           replacement = "\\impliedby",        options = "mA" },
    { trigger = "iff",          replacement = "\\iff",              options = "mA" },
    { trigger = "e\\xi sts",    replacement = "\\exists",           options = "mA", priority = 1 },
    { trigger = "===",          replacement = "\\equiv",            options = "mA" },
    { trigger = "Sq",           replacement = "\\square",           options = "mA" },
    { trigger = "!=",           replacement = "\\neq",              options = "mA" },
    { trigger = ">=",           replacement = "\\geq",              options = "mA" },
    { trigger = "<=",           replacement = "\\leq",              options = "mA" },
    { trigger = ">>",           replacement = "\\gg",               options = "mA" },
    { trigger = "<<",           replacement = "\\ll",               options = "mA" },
    { trigger = "~~",           replacement = "\\sim",              options = "mA" },
    { trigger = "prop",         replacement = "\\propto",           options = "mA" },
    { trigger = "nabl",         replacement = "\\nabla",            options = "mA" },
    { trigger = "del",          replacement = "\\nabla",            options = "mA" },
    { trigger = "xx",           replacement = "\\times",            options = "mA" },
    { trigger = "**",           replacement = "\\cdot",             options = "mA" },
    { trigger = "para",         replacement = "\\parallel",         options = "mA" },

    { trigger = "xnn",          replacement = "x_{n}",              options = "mA" },
    { trigger = "xii",          replacement = "x_{i}",              options = "mA" },
    { trigger = "xjj",          replacement = "x_{j}",              options = "mA" },
    { trigger = "xp1",          replacement = "x_{n+1}",            options = "mA" },
    { trigger = "ynn",          replacement = "y_{n}",              options = "mA" },
    { trigger = "yii",          replacement = "y_{i}",              options = "mA" },
    { trigger = "yjj",          replacement = "y_{j}",              options = "mA" },

    { trigger = "mcal",         replacement = "\\mathcal{$1}$0",    options = "mA" },
    { trigger = "mbb",          replacement = "\\mathbb{$1}$0",     options = "mA" },
    { trigger = "ell",          replacement = "\\ell",              options = "mA" },
    { trigger = "lll",          replacement = "\\ell",              options = "mA" },
    { trigger = "LL",           replacement = "\\mathcal{L}",       options = "mA" },
    { trigger = "HH",           replacement = "\\mathcal{H}",       options = "mA" },
    { trigger = "CC",           replacement = "\\mathbb{C}",        options = "mA" },
    { trigger = "RR",           replacement = "\\mathbb{R}",        options = "mA" },
    { trigger = "ZZ",           replacement = "\\mathbb{Z}",        options = "mA" },
    { trigger = "NN",           replacement = "\\mathbb{N}",        options = "mA" },
    { trigger = "II",           replacement = "\\mathbb{1}",        options = "mA" },
    { trigger = "\\mathbb{1}I", replacement = "\\hat{\\mathbb{1}}", options = "mA" },
    { trigger = "AA",           replacement = "\\mathcal{A}",       options = "mA" },
    { trigger = "BB",           replacement = "\\mathbf{B}",        options = "mA" },
    { trigger = "EE",           replacement = "\\mathbf{E}",        options = "mA" },

    -- Unit vectors
    { trigger = ":i",           replacement = "\\mathbf{i}",        options = "mA" },
    { trigger = ":j",           replacement = "\\mathbf{j}",        options = "mA" },
    { trigger = ":k",           replacement = "\\mathbf{k}",        options = "mA" },
    { trigger = ":v",           replacement = "\\mathbf{v}",        options = "mA" },
    { trigger = ":w",           replacement = "\\mathbf{w}",        options = "mA" },
    { trigger = ":x",           replacement = "\\hat{\\mathbf{x}}", options = "mA" },
    { trigger = ":y",           replacement = "\\hat{\\mathbf{y}}", options = "mA" },
    { trigger = ":z",           replacement = "\\hat{\\mathbf{z}}", options = "mA" },

    -- Derivatives
    {
        trigger = "par",
        replacement = "\\frac{ \\partial ${1:y} }{ \\partial ${2:x} }$0",
        options = "m"
    },
    {
        trigger = "pa2",
        replacement = "\\frac{ \\partial^{2} ${1:y} }{ \\partial ${2:x}^{2} }$0",
        options = "m"
    },
    {
        trigger = "pa3",
        replacement = "\\frac{ \\partial^{3} ${1:y} }{ \\partial ${2:x}^{3} }$0",
        options = "m"
    },
    {
        trigger = "pa(%a)(%a)",
        replacement = "\\frac{ \\partial [[1]] } { \\partial [[2]] }",
        options = "rmA"
    },
    {
        trigger = "pa(%a)(%a)(%a)",
        replacement = "\\frac{ \\partial^{2} [[1]] }{ \\partial [[2]] \\partial [[3]] }",
        options = "rmA"
    },
    {
        trigger = "pa(%a)(%a)2",
        replacement = "\\frac{ \\partial^{2} [[1]] }{ \\partial [[2]]^{2} }",
        options = "rmA"
    },
    {
        trigger = "de(%a)(%a)",
        replacement = "\\frac{ d[[1]] }{ d[[2]] } ",
        options = "rmA"
    },
    {
        trigger = "de(%a)(%a)2",
        replacement = "\\frac{ d^{2}[[1]] }{ d[[2]]^{2} } ",
        options = "rmA"
    },

    { trigger = "ddt",              replacement = "\\frac{d}{dt} ",                                  options = "mA" },

    -- Integrals
    { trigger = "oinf",             replacement = "\\int_{0}^{\\infty} $0 \\, d${1=x} $2",           options = "mA" },
    { trigger = "infi",             replacement = "\\int_{-\\infty}^{\\infty} $0 \\, d${1=x} $2",    options = "mA" },
    { trigger = "dint",             replacement = "\\int_{${0=0}}^{${1=\\infty}} $2 \\, d${3=x} $4", options = "mA" },
    { trigger = "oint",             replacement = "\\oint",                                          options = "mA" },
    { trigger = "iiint",            replacement = "\\iiint",                                         options = "mA" },
    { trigger = "iint",             replacement = "\\iint",                                          options = "mA" },
    { trigger = "int",              replacement = "\\int $1 \\, d${2=x} $3",                         options = "mA" },

    -- Physics
    { trigger = "kbt",              replacement = "k_{B}T",                                          options = "mA", },

    -- Quantum Mechanics
    { trigger = "hba",              replacement = "\\hbar",                                          options = "mA" },
    { trigger = "dag",              replacement = "^{\\dagger}",                                     options = "mA" },
    { trigger = "o+",               replacement = "\\oplus",                                         options = "mA" },
    { trigger = "ox",               replacement = "\\otimes",                                        options = "mA" },
    { trigger = "ot\\mathrm{Im}es", replacement = "\\otimes",                                        options = "mA" }, -- Handle conflict with "im" snippet
    { trigger = "bra",              replacement = "\\bra{$1} $2",                                    options = "mA" },
    { trigger = "ket",              replacement = "\\ket{$1} $2",                                    options = "mA" },
    { trigger = "brk",              replacement = "\\braket{$1 | $2} $3",                            options = "mA" },
    {
        trigger = "\\\\bra{([^|]+)\\|",
        replacement = "\\braket{ [[1]] | $1 ",
        options = "rmA",
        description = "Convert bra into braket"
    },
    {
        trigger = [[\\bra{(.+)}([^ ]+)>]],
        replacement = "\\braket{ [[1]] | $1 ",
        options = "rmA",
        description = "Convert bra into braket (alternate)"
    },
    { trigger = "outp",   replacement = "\\ket{${1:\\psi}} \\bra{${1:\\psi}} $2", options = "rmA" },

    -- Chemistry
    { trigger = "pu",     replacement = "\\pu{ $1 }",                             options = "mA" },
    { trigger = "msun",   replacement = "M_{\\odot}",                             options = "mA" },
    { trigger = "solm",   replacement = "M_{\\odot}",                             options = "mA" },
    { trigger = "cee",    replacement = "\\ce{ $1 }",                             options = "mA" },
    { trigger = "iso",    replacement = "{}^{${1:4}}_{${2:2}}${3:He}",            options = "mA" },
    { trigger = "hel4",   replacement = "{}^{4}_{2}He ",                          options = "mA" },
    { trigger = "hel3",   replacement = "{}^{3}_{2}He ",                          options = "mA" },

    -- Environments
    { trigger = "pmat",   replacement = [[\begin{pmatrix}\n$1\n\end{pmatrix}]],   options = "MA" },
    { trigger = "bmat",   replacement = [[\begin{bmatrix}\n$1\n\end{bmatrix}]],   options = "MA" },
    { trigger = "Bmat",   replacement = [[\begin{Bmatrix}\n$1\n\end{Bmatrix}]],   options = "MA" },
    { trigger = "vmat",   replacement = [[\begin{vmatrix}\n$1\n\end{vmatrix}]],   options = "MA" },
    { trigger = "Vmat",   replacement = [[\begin{Vmatrix}\n$1\n\end{Vmatrix}]],   options = "MA" },
    { trigger = "matrix", replacement = [[\begin{matrix}\n$1\n\end{matrix}]],     options = "MA" },

    { trigger = "pmat",   replacement = [[\begin{pmatrix}$1\end{pmatrix}]],       options = "nA" },
    { trigger = "bmat",   replacement = [[\begin{bmatrix}$1\end{bmatrix}]],       options = "nA" },
    { trigger = "Bmat",   replacement = [[\begin{Bmatrix}$1\end{Bmatrix}]],       options = "nA" },
    { trigger = "vmat",   replacement = [[\begin{vmatrix}$1\end{vmatrix}]],       options = "nA" },
    { trigger = "Vmat",   replacement = [[\begin{Vmatrix}$1\end{Vmatrix}]],       options = "nA" },
    { trigger = "matrix", replacement = [[\begin{matrix}$1\end{matrix}]],         options = "nA" },

    { trigger = "case",   replacement = "\\begin{cases}\n$1\n\\end{cases}",       options = "mA" },
    { trigger = "align",  replacement = "\\begin{align}\n$1\n\\end{align}",       options = "mA" },
    { trigger = "align*", replacement = "\\begin{align*}\n$1\n\\end{align*}",     options = "mA" },
    { trigger = "bsal",   replacement = "\\begin{align*}\n\t$0\n\\end{align*}",   options = "tA" },
    { trigger = "array",  replacement = "\\begin{array}\n\t$1\n\\end{array}",     options = "mA" },

    -- Brackets
    { trigger = "avg",    replacement = [[\langle $1 \rangle $2]],                options = "mA" },
    { trigger = "norm",   replacement = [[\lvert $1 \rvert $2]],                  options = "mA", priority = 1 },
    { trigger = "Norm",   replacement = [[\lVert $1 \rVert $2]],                  options = "mA", priority = 1 },
    { trigger = "ceil",   replacement = [[\lceil $1 \rceil $2]],                  options = "mA" },
    { trigger = "floor",  replacement = [[\lfloor $1 \rfloor $2]],                options = "mA" },
    { trigger = "mod",    replacement = "$1|$2",                                  options = "mA" },
    { trigger = "(",      replacement = "($1)$2",                                 options = "mA" },
    { trigger = "[",      replacement = "[$1]$2",                                 options = "mA" },
    { trigger = "{",      replacement = "{$1}$2",                                 options = "mA" },
    { trigger = "lr(",    replacement = [[\left( $1 \right)$2]],                  options = "mA" },
    { trigger = "lr[",    replacement = [[\left[ $1 \right]$2]],                  options = "mA" },
    { trigger = "lr{",    replacement = [[\left\{ $1 \right\}$2]],                options = "mA" },
    { trigger = "lra",    replacement = [[\left< $1 \right>$2]],                  options = "mA" },

    -- Misc
    {
        trigger = "tayl",
        replacement =
        "${1:f}(${2:x} + ${3:h}) = ${1:f}(${2:x}) + ${1:f}'(${2:x})$(3:h) + ${1:f}''(${2:x}) \\frac{${3:h}^{2}}{2!} + \\dots$4",
        options = "mA"
    },
}

---Parse an Obsidian LaTeX-Suite-like snippet fragment into a luasnip snippet.
---@param snippet {trigger: string, replacement: string, options: string, priority: number?, description: string?}: a JSON-like snippet fragment
---@return table: the snippet parsed by luasnip
local function parse_snippets(snippet)
    -- Check for options.
    -- t: Text mode. Only run this snippet outside math.
    -- m: Math mode. Only run this snippet inside math.
    -- M: Block math mode. Only run this snippet inside a $$ ... $$ block.
    -- n: Inline math mode. Only run this snippet inside a $ ... $ block.
    -- A: Auto-expand. Automatically expand the snippet.
    -- r: Regex. The `trigger` will be treated as a regular expression.
    -- v: Only run this snippet on a selection. The trigger should be a single character.
    -- W: Word boundary. Only run this snippet when the trigger is preceded (and followed by) a word delimiter, such as `.`, `,`, or `-`.
    -- c: Code mode. Only run this snippet inside a code block.

    local condition = nil

    if snippet.options:find("t") then
        condition = tex_utils.in_text
    elseif snippet.options:find("m") or snippet.options:find("n") then
        condition = tex_utils.in_mathzone
    elseif snippet.options:find("M") then
        condition = tex_utils.in_equation
    end

    local snippetType = "snippet"
    if snippet.options:find("A") then
        snippetType = "autosnippet"
    end

    -- print(snippet.trigger, snippet.replacement, snippetType)


    -- Check if the snippet uses regex
    if snippet.options:find("r") then
        -- Construct the LuaSnip snippet with regex captures
        local replacement = snippet.replacement
        local captures = {}
        -- Find all [[n]] patterns and replace them with capture functions
        for captureIndex in replacement:gmatch("%[%[(%d+)%]%]") do
            table.insert(captures, f(function(_, snip)
                return snip.captures[tonumber(captureIndex)]
            end))
        end
        -- Escape braces in the LaTeX string
        replacement = replacement:gsub("([{}])", "\\%1")
        -- Replace the [[n]] patterns with {} for fmt
        replacement = replacement:gsub("%[%[(%d+)%]%]", "<%1>")
        return s({
            trig = snippet.trigger,
            wordTrig = snippet.options:find("W"),
            regTrig = true,
            snippetType = snippetType,
            condition = condition,
            desc = snippet.description,
            priority = snippet.priority,
        }, fmt(replacement, captures, { delimiters = "<>" }))
    end


    -- TODO: Add support for snippet priorities

    -- Default case without regex
    return ls.parser.parse_snippet({
        trig = snippet.trigger,
        wordTrig = snippet.options:find("W"),
        regTrig = snippet.options:find("r"),
        snippetType = snippetType,
        condition = condition,
        desc = snippet.description,
        priority = snippet.priority,
    }, snippet.replacement)
end


---@type table[]: A list of parsed snippets
local R = {}

for _, snippet in ipairs(M) do
    table.insert(R, parse_snippets(snippet))
end

-- TODO: Add support for automatic backslash escaping of greek characters and other special characters in math mode.
for group, symbols in ipairs(GS) do
    for _, symbol in ipairs(symbols) do
        local replacement = [[\]] .. symbol
        table.insert(
            s({
                trig = symbol,
                wordTrig = false,
                regTrig = false,
                snippetType = "autosnippet",
                condition = tex_utils.in_mathzone,
                desc = "[" .. group .. "]" .. symbol,
                priority = nil,
            }, replacement)
        )
    end
end


return R
