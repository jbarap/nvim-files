local utils = require('utils')
local Highlight = utils.Highlight

---- dark color palette
local darker = "#111111"
local dark = "#131313"
local almost_dark = "#151515"
local mid_dark = "#191919"
local light_dark = "#202020"
local lighter_dark = "#252525"


--            neovim
-- ──────────────────────────────

-- Backgrounds
Highlight:new("Normal"):set("guibg", dark):set("guifg", "#c9c9c9")
Highlight:new("NormalNC"):set("guibg", dark)
Highlight:new("EndOfBuffer"):set("guibg", dark)
Highlight:new("TabLineFill"):set("guibg", dark)
Highlight:new("DarkenedPanel"):set("guibg", darker)
Highlight:new("DarkenedStatusline"):set("guibg", darker)
Highlight:new("DarkenedStatuslineNC"):set("guibg", darker)

-- Syntax
Highlight:new("Search"):set("guibg", "#1c284a"):set("guifg", "NONE")
Highlight:new("IncSearch"):set("guibg", "#42888a"):set("guifg", "NONE")
Highlight:new("Substitute"):set("guibg", "#4d1d28"):set("guifg", "#c9c9c9")

-- Diffs
Highlight:new("DiffAdd"):set("guibg", "#212f25")
Highlight:new("DiffText"):set("guibg", "#394b70")
Highlight:new("DiffChange"):set("guibg", "#1F2231")
Highlight:new("DiffDelete"):set("guibg", "#37222C")

-- folds
Highlight:new("Folded"):set("guibg", "#1c202e"):set("guifg", "NONE")

-- gitsigns
Highlight:new("GitSignsAdd"):set("guibg", "NONE"):set("gui", "bold")
Highlight:new("GitSignsChange"):set("guibg", "NONE"):set("gui", "bold")
Highlight:new("GitSignsDelete"):set("guibg", "NONE"):set("gui", "bold")

-- Sign column
Highlight:new("SignColumn"):set("guibg", "NONE")
Highlight:new("LineNr"):set("guibg", "NONE")

-- Color column
Highlight:new("ColorColumn"):set("guibg", almost_dark)
Highlight:new("CursorLine"):set("guibg", almost_dark)

-- floating windows
Highlight:new("Pmenu"):set("guibg", light_dark)
Highlight:new("PmenuSbar"):set("guibg", lighter_dark):set("guifg", "#ffffff")
Highlight:new("NormalFloat"):set("guibg", mid_dark)
Highlight:new("FloatBorder"):set("guibg", mid_dark)

-- Lsp colors
Highlight:new("DiagnosticDefaultHint"):set("guibg", "NONE")
Highlight:new("DiagnosticDefaultWarning"):set("guibg", "NONE")
Highlight:new("DiagnosticDefaultError"):set("guibg", "NONE")
Highlight:new("DiagnosticVirtualTextInformation"):set("guibg", mid_dark)
Highlight:new("DiagnosticVirtualTextWarning"):set("guibg", mid_dark)
Highlight:new("DiagnosticVirtualTextError"):set("guibg", mid_dark)
Highlight:new("DiagnosticVirtualTextHint"):set("guibg", mid_dark)

-- Others
Highlight:new("VertSplit"):set("guifg", light_dark)


--            plugins
-- ──────────────────────────────

-- Barbar
Highlight:new("BufferTabpageFill"):set("guibg", almost_dark)
Highlight:new("BufferCurrent"):set("guibg", lighter_dark)
Highlight:new("BufferCurrentSign"):set("guibg", lighter_dark)
Highlight:new("BufferCurrentMod"):set("guibg", lighter_dark)
Highlight:new("BufferInactive"):set("guibg", mid_dark)
Highlight:new("BufferInactiveSign"):set("guibg", mid_dark)
Highlight:new("BufferInactiveMod"):set("guibg", mid_dark)

-- Dashboard
Highlight:new("DashboardHeader"):set("guifg", "#6585ba")

-- Telescope
Highlight:new("TelescopeMatching"):set("guifg", "#6585ba"):set("gui", "bold")
Highlight:new("TelescopeSelection"):set("guibg", "#12192b"):set("guifg", "#c9c9c9")
Highlight:new("TelescopeNormal"):set("guifg", "#919191")

-- Which-key
Highlight:new("WhichKeyFloat"):set("guibg", mid_dark)

-- LSP Trouble
Highlight:new("LspTroubleNormal"):set("guibg", dark)

-- Nvim tree
Highlight:new("NvimTreeNormal"):set("guibg", almost_dark)
Highlight:new("NvimTreeEndOfBuffer"):set("guibg", almost_dark):set("guifg", almost_dark)

-- Nvim cmp
Highlight:new("CmpItemMenu"):set("guibg", light_dark):set("guifg", "#c9c9c9")
Highlight:new("CmpItemAbbr"):set("guibg", light_dark):set("guifg", "#939393")

