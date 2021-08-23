local utils = require('plugins_config.utils')

---- dark color palette
local dark = "#131313"
local almost_dark = "#151515"
local mid_dark = "#191919"
local light_dark = "#202020"
local lighter_dark = "#252525"

-- Backgrounds
utils.change_highlight_bg("Normal", dark)
utils.change_highlight_bg("NormalNC", dark)
utils.change_highlight_bg("Terminal", dark)
utils.change_highlight_bg("EndOfBuffer", dark)
utils.change_highlight_bg("TabLineFill", dark)

-- Syntax
utils.change_highlight_fg("Normal", "#c9c9c9")
utils.change_highlight_bg("Search", "#273866")
utils.change_highlight_fg("Search", "NONE")

-- gitsigns
utils.change_highlight_bg("GitSignsAdd", "NONE")
utils.change_highlight_bg("GitSignsChange", "NONE")
utils.change_highlight_bg("GitSignsDelete", "NONE")

-- Sign column
utils.change_highlight_bg("SignColumn", "NONE")
utils.change_highlight_bg("LineNr", "NONE")

-- Color column
utils.change_highlight_bg("ColorColumn", almost_dark)
utils.change_highlight_bg("CursorLine", almost_dark)

-- floating windows
utils.change_highlight_bg("Pmenu", light_dark)
utils.change_highlight_bg("NormalFloat", mid_dark)
utils.change_highlight_bg("FloatBorder", mid_dark)

-- Barbar
utils.change_highlight_bg("BufferTabpageFill", almost_dark)
utils.change_highlight_bg("BufferCurrent", lighter_dark)
utils.change_highlight_bg("BufferCurrentSign", lighter_dark)
utils.change_highlight_bg("BufferCurrentMod", lighter_dark)
utils.change_highlight_bg("BufferInactive", mid_dark)
utils.change_highlight_bg("BufferInactiveSign", mid_dark)
utils.change_highlight_bg("BufferInactiveMod", mid_dark)

-- Lsp colors
utils.change_highlight_bg("LSPDiagnosticsDefaultHint", "NONE")
utils.change_highlight_bg("LSPDiagnosticsDefaultWarning", "NONE")
utils.change_highlight_bg("LSPDiagnosticsDefaultError", "NONE")

-- Compe documentation lines
utils.change_highlight_bg("CompeDocumentation", utils.return_highlight_term('NormalFloat', 'bg'))
utils.change_highlight_fg("CompeDocumentation", "#aaaaaa")
utils.change_highlight_bg("CompeDocumentationBorder", utils.return_highlight_term('NormalFloat', 'bg'))
utils.change_highlight_fg("CompeDocumentationBorder", "#606060")

-- Dashboard
utils.change_highlight_fg("DashboardHeader", "#6585ba")

-- Telescope
utils.change_highlight_bg("TelescopeSelection", "#1a2440")

-- Which-key
utils.change_highlight_bg("WhichKeyFloat", mid_dark)

-- LSP Trouble
utils.change_highlight_bg("LspTroubleNormal", dark)

-- Nvim tree
utils.change_highlight_bg("NvimTreeNormal", dark)

-- Others
utils.change_highlight_fg("VertSplit", light_dark)

