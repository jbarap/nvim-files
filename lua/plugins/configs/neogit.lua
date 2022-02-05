local neogit = require("neogit")

neogit.setup({
  kind = "split",
  disable_context_highlighting = true,
  disable_commit_confirmation = false,
  disable_insert_on_commit = false,
  disable_hint = true,
  integrations = {
    diffview = true,
  },
  sections = {
    stashes = {
      folded = true
    },
    recent = {
      folded = true,
    },
  }
})
