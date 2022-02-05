vim.g.dashboard_default_executive = "telescope"

vim.g.dashboard_custom_section = {
  a = { description = { "  New File                  SPC f n" }, command = "DashboardNewFile" },
  b = { description = { "  Recents                   SPC f o" }, command = "Telescope oldfiles" },
  c = { description = { "  Find File                 SPC f f" }, command = "Telescope find_files" },
  d = { description = { "  Find Word                 SPC f g" }, command = "Telescope live_grep" },
  e = { description = { "  Bookmarks                 SPC b m" }, command = "Telescope marks" },
  f = { description = { "  Load Last Session         SPC s l" }, command = "SessionLoad" },
}
vim.g.dashboard_custom_header = {
  "                    ",
  "          ^ ^       ",
  "         (O,O)      ",
  "         (   )      ",
  '         -"-"-      ',
  "                    ",
}
vim.g.dashboard_custom_footer = { "Better than yesterday." }
