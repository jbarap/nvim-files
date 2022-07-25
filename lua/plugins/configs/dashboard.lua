local db = require("dashboard")

db.custom_header = {
  "                 ",
  "                 ",
  "                 ",
  "                 ",
  "       ^ ^       ",
  "      (O,O)      ",
  "      (   )      ",
  '      -"-"-      ',
  "                 ",
  "                 ",
  "                 ",
}

db.custom_footer = {
  "                      ",
  "                      ",
  "                      ",
  "Better than yesterday.",
}

db.custom_center = {
  {
    icon = "  ",
    desc = "New File                  ",
    shortcut = "SPC f n",
    action = "DashboardNewFile",
  },
  {
    icon = "  ",
    desc = "Recents                   ",
    shortcut = "SPC f o",
    action = "Telescope oldfiles",
  },
  {
    icon = "  ",
    desc = "Find File                 ",
    shortcut = "SPC f f",
    action = "Telescope find_files",
  },
  {
    icon = "  ",
    desc = "Find Word                 ",
    shortcut = "SPC f g",
    action = "Telescope live_grep",
  },
  {
    icon = "  ",
    desc = "Bookmarks                 ",
    shortcut = "SPC b m",
    action = "Telescope marks",
  },
  {
    icon = "  ",
    desc = "Load Last Session         ",
    shortcut = "SPC s l",
    action = "SessionLoad",
  },
}
