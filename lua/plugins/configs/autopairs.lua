local autopairs = require("nvim-autopairs")
local autopairs_rule = require("nvim-autopairs.rule")
local autopairs_cond = require('nvim-autopairs.conds')

autopairs.setup({})

-- note: careful, order of :with_pair seems to matter
autopairs.add_rules({
  autopairs_rule("__", "__", "python"),

  autopairs_rule(' ', ' ', 'lua')
    :with_pair(autopairs_cond.not_after_regex_check("[^%}]", 1))
    :with_pair(autopairs_cond.before_text_check("{"))
})

