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

---List of snippets for LaTeX. This list is based on the snippets from the LaTeX-Suite plugin for Obisidian.
---@type {trigger: string, replacement: string, options: string, priority: number?}[]
M = {
    -- Math mode
    { trigger = "mk",                               replacement = "$$0$",                                                             options = "tA" },
    { trigger = "dm",                               replacement = "$$\n$0\n$$",                                                       options = "tAw" },
    { trigger = "beg",                              replacement = "\\begin{$0}\n$1\n\\end{$0}",                                       options = "mA" },

    -- Greek letters
    { trigger = "@a",                               replacement = "\\alpha",                                                          options = "mA" },
    { trigger = "@b",                               replacement = "\\beta",                                                           options = "mA" },
    { trigger = "@g",                               replacement = "\\gamma",                                                          options = "mA" },
    { trigger = "@G",                               replacement = "\\Gamma",                                                          options = "mA" },
    { trigger = "@d",                               replacement = "\\delta",                                                          options = "mA" },
    { trigger = "@e",                               replacement = "\\epsilon",                                                        options = "mA" },
    { trigger = ":e",                               replacement = "\\varepsilon",                                                     options = "mA" },
    { trigger = "@z",                               replacement = "\\zeta",                                                           options = "mA" },
    { trigger = "@h",                               replacement = "\\eta",                                                            options = "mA" },
    { trigger = "@q",                               replacement = "\\theta",                                                          options = "mA" },
    { trigger = "@i",                               replacement = "\\iota",                                                           options = "mA" },
    { trigger = "@k",                               replacement = "\\kappa",                                                          options = "mA" },
    { trigger = "@l",                               replacement = "\\lambda",                                                         options = "mA" },
    { trigger = "@m",                               replacement = "\\mu",                                                             options = "mA" },
    { trigger = "@n",                               replacement = "\\nu",                                                             options = "mA" },
    { trigger = "@x",                               replacement = "\\xi",                                                             options = "mA" },
    { trigger = "@p",                               replacement = "\\pi",                                                             options = "mA" },
    { trigger = "@r",                               replacement = "\\rho",                                                            options = "mA" },
    { trigger = "@s",                               replacement = "\\sigma",                                                          options = "mA" },
    { trigger = "@t",                               replacement = "\\tau",                                                            options = "mA" },
    { trigger = "@u",                               replacement = "\\upsilon",                                                        options = "mA" },
    { trigger = "@f",                               replacement = "\\phi",                                                            options = "mA" },
    { trigger = "@c",                               replacement = "\\chi",                                                            options = "mA" },
    { trigger = "@y",                               replacement = "\\psi",                                                            options = "mA" },
    { trigger = "@w",                               replacement = "\\omega",                                                          options = "mA" },
    { trigger = "@D",                               replacement = "\\Delta",                                                          options = "mA" },
    { trigger = "@Q",                               replacement = "\\Theta",                                                          options = "mA" },
    { trigger = "@L",                               replacement = "\\Lambda",                                                         options = "mA" },
    { trigger = "@X",                               replacement = "\\Xi",                                                             options = "mA" },
    { trigger = "@P",                               replacement = "\\Pi",                                                             options = "mA" },
    { trigger = "@S",                               replacement = "\\Sigma",                                                          options = "mA" },
    { trigger = "@U",                               replacement = "\\Upsilon",                                                        options = "mA" },
    { trigger = "@F",                               replacement = "\\Phi",                                                            options = "mA" },
    { trigger = "@Y",                               replacement = "\\Psi",                                                            options = "mA" },
    { trigger = "@W",                               replacement = "\\Omega",                                                          options = "mA" },

    -- Text environment
    { trigger = "text",                             replacement = "\\text{$1}$0",                                                     options = "mA" },
    { trigger = "\"",                               replacement = "\\text{$1}$0",                                                     options = "mA" },

    -- Basic operations
    { trigger = "sr",                               replacement = "^{2}",                                                             options = "mA" },
    { trigger = "cb",                               replacement = "^{3}",                                                             options = "mA" },
    { trigger = "rd",                               replacement = "^{$1}$0",                                                          options = "mA" },
    { trigger = "_",                                replacement = "_{$1}$0",                                                          options = "mA" },
    { trigger = "sts",                              replacement = "_\\text{$1}$0",                                                    options = "mA" },
    { trigger = "sq",                               replacement = "\\sqrt{ $1 }$2",                                                   options = "mA" },
    { trigger = "//",                               replacement = "\\frac{$1}{$2}$0",                                                 options = "mA" },
    { trigger = "ee",                               replacement = "e^{ $0 }$1",                                                       options = "mA" },
    { trigger = "invs",                             replacement = "^{-1}",                                                            options = "mA" },
    { trigger = "\\\\\\",                           replacement = "\\setminus",                                                       options = "mA" },
    { trigger = "||",                               replacement = "\\mid",                                                            options = "mA" },
    { trigger = "and",                              replacement = "\\cap",                                                            options = "mA" },
    { trigger = "orr",                              replacement = "\\cup",                                                            options = "mA" },
    { trigger = "inn",                              replacement = "\\in",                                                             options = "mA" },
    { trigger = "notin",                            replacement = "\\not\\in",                                                        options = "mA" },
    { trigger = "\\subset eq",                      replacement = "\\subseteq",                                                       options = "mA" },
    { trigger = "eset",                             replacement = "\\emptyset",                                                       options = "mA" },
    { trigger = "set",                              replacement = "\\{ $1 \\}$0",                                                     options = "mA" },
    { trigger = "=>",                               replacement = "\\implies",                                                        options = "mA" },
    { trigger = "=<",                               replacement = "\\impliedby",                                                      options = "mA" },
    { trigger = "iff",                              replacement = "\\iff",                                                            options = "mA" },
    { trigger = "e\\xi sts",                        replacement = "\\exists",                                                         options = "mA", priority = 1 },
    { trigger = "===",                              replacement = "\\equiv",                                                          options = "mA" },
    { trigger = "Sq",                               replacement = "\\square",                                                         options = "mA" },
    { trigger = "!=",                               replacement = "\\neq",                                                            options = "mA" },
    { trigger = ">=",                               replacement = "\\geq",                                                            options = "mA" },
    { trigger = "<=",                               replacement = "\\leq",                                                            options = "mA" },
    { trigger = ">>",                               replacement = "\\gg",                                                             options = "mA" },
    { trigger = "<<",                               replacement = "\\ll",                                                             options = "mA" },
    { trigger = "~~",                               replacement = "\\sim",                                                            options = "mA" },
    { trigger = "prop",                             replacement = "\\propto",                                                         options = "mA" },
    { trigger = "nabl",                             replacement = "\\nabla",                                                          options = "mA" },
    { trigger = "del",                              replacement = "\\nabla",                                                          options = "mA" },
    { trigger = "xx",                               replacement = "\\times",                                                          options = "mA" },
    { trigger = "**",                               replacement = "\\cdot",                                                           options = "mA" },
    { trigger = "para",                             replacement = "\\parallel",                                                       options = "mA" },

    { trigger = "xnn",                              replacement = "x_{n}",                                                            options = "mA" },
    { trigger = "xii",                              replacement = "x_{i}",                                                            options = "mA" },
    { trigger = "xjj",                              replacement = "x_{j}",                                                            options = "mA" },
    { trigger = "xp1",                              replacement = "x_{n+1}",                                                          options = "mA" },
    { trigger = "ynn",                              replacement = "y_{n}",                                                            options = "mA" },
    { trigger = "yii",                              replacement = "y_{i}",                                                            options = "mA" },
    { trigger = "yjj",                              replacement = "y_{j}",                                                            options = "mA" },

    { trigger = "mcal",                             replacement = "\\mathcal{$1}$0",                                                  options = "mA" },
    { trigger = "mbb",                              replacement = "\\mathbb{$1}$0",                                                   options = "mA" },
    { trigger = "ell",                              replacement = "\\ell",                                                            options = "mA" },
    { trigger = "lll",                              replacement = "\\ell",                                                            options = "mA" },
    { trigger = "LL",                               replacement = "\\mathcal{L}",                                                     options = "mA" },
    { trigger = "HH",                               replacement = "\\mathcal{H}",                                                     options = "mA" },
    { trigger = "CC",                               replacement = "\\mathbb{C}",                                                      options = "mA" },
    { trigger = "RR",                               replacement = "\\mathbb{R}",                                                      options = "mA" },
    { trigger = "ZZ",                               replacement = "\\mathbb{Z}",                                                      options = "mA" },
    { trigger = "NN",                               replacement = "\\mathbb{N}",                                                      options = "mA" },
    { trigger = "II",                               replacement = "\\mathbb{1}",                                                      options = "mA" },
    { trigger = "\\mathbb{1}I",                     replacement = "\\hat{\\mathbb{1}}",                                               options = "mA" },
    { trigger = "AA",                               replacement = "\\mathcal{A}",                                                     options = "mA" },
    { trigger = "BB",                               replacement = "\\mathbf{B}",                                                      options = "mA" },
    { trigger = "EE",                               replacement = "\\mathbf{E}",                                                      options = "mA" },

    -- Unit vectors
    { trigger = ":i",                               replacement = "\\mathbf{i}",                                                      options = "mA" },
    { trigger = ":j",                               replacement = "\\mathbf{j}",                                                      options = "mA" },
    { trigger = ":k",                               replacement = "\\mathbf{k}",                                                      options = "mA" },
    { trigger = ":v",                               replacement = "\\mathbf{v}",                                                      options = "mA" },
    { trigger = ":w",                               replacement = "\\mathbf{w}",                                                      options = "mA" },
    { trigger = ":x",                               replacement = "\\hat{\\mathbf{x}}",                                               options = "mA" },
    { trigger = ":y",                               replacement = "\\hat{\\mathbf{y}}",                                               options = "mA" },
    { trigger = ":z",                               replacement = "\\hat{\\mathbf{z}}",                                               options = "mA" },

    -- Derivatives
    { trigger = "par",                              replacement = "\\frac{ \\partial ${1:y} }{ \\partial ${2:x} }$0",                 options = "m" },
    { trigger = "pa2",                              replacement = "\\frac{ \\partial^{2} ${1:y} }{ \\partial ${2:x}^{2} }$0",         options = "m" },
    { trigger = "pa3",                              replacement = "\\frac{ \\partial^{3} ${1:y} }{ \\partial ${2:x}^{3} }$0",         options = "m" },
    { trigger = "pa([A-Za-z])([A-Za-z])",           replacement = "\\frac{ \\partial [[0]] } { \\partial [[1]] }",                    options = "rm" },
    { trigger = "pa([A-Za-z])([A-Za-z])([A-Za-z])", replacement = "\\frac{ \\partial^{2} [[0]] }{ \\partial [[1]] \\partial [[2]] }", options = "rm" },
    { trigger = "pa([A-Za-z])([A-Za-z])2",          replacement = "\\frac{ \\partial^{2} [[0]] }{ \\partial [[1]]^{2} }",             options = "rm" },
    { trigger = "de([A-Za-z])([A-Za-z])",           replacement = "\\frac{ d[[0]] }{ d[[1]] } ",                                      options = "rm" },
    { trigger = "de([A-Za-z])([A-Za-z])2",          replacement = "\\frac{ d^{2}[[0]] }{ d[[1]]^{2} } ",                              options = "rmA" },
    { trigger = "ddt",                              replacement = "\\frac{d}{dt} ",                                                   options = "mA" },

    -- Integrals
    { trigger = "oinf",                             replacement = "\\int_{0}^{\\infty} $0 \\, d${1=x} $2",                            options = "mA" },
    { trigger = "infi",                             replacement = "\\int_{-\\infty}^{\\infty} $0 \\, d${1=x} $2",                     options = "mA" },
    { trigger = "dint",                             replacement = "\\int_{${0=0}}^{${1=\\infty}} $2 \\, d${3=x} $4",                  options = "mA" },
    { trigger = "oint",                             replacement = "\\oint",                                                           options = "mA" },
    { trigger = "iiint",                            replacement = "\\iiint",                                                          options = "mA" },
    { trigger = "iint",                             replacement = "\\iint",                                                           options = "mA" },
    { trigger = "int",                              replacement = "\\int $0 \\, d${1=x} $2",                                          options = "mA" },
}

---Parse an Obsidian LaTeX-Suite-like snippet fragment into a luasnip snippet.
---@param snippet {trigger: string, replacement: string, options: string, priority: number?}: a JSON-like snippet fragment
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

    -- TODO: Add support for regex captures with the format [[0]], [[1]], etc.
    --
    -- if snippet.options:find("r") then
    --     return s(
    --         { trig = snippet.trigger, snippetType = snippetType },
    --         -- TODO: Construct the rhs of the fmt function with a table of functions that return the captures.
    --         --
    --         { fmt({ snippet.replacement }, {
    --             f(function(_, snip)
    --                 return snip.captures[i]
    --             end)
    --         })
    --     )
    -- end

    -- TODO: Add support for snippet priorities

    return ls.parser.parse_snippet({
        trig = snippet.trigger,
        wordTrig = snippet.options:find("W"),
        regTrig = snippet.options:find("r"),
        snippetType = snippetType,
    }, snippet.replacement, { condition = condition })
end


---@type table[]: A list of parsed snippets
local R = {}

for _, snippet in ipairs(M) do
    table.insert(R, parse_snippets(snippet))
end

-- TODO: Add support for automatic backslash escaping of greek characters and other special characters in math mode.

return R
