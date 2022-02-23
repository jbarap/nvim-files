require("neogen").setup({
  input_after_comment = true,
  languages = {
    lua = {
      template = {
        annotation_convention = "emmylua"
      },
    },
    python = {
      template = {
        annotation_convention = "google_docstrings"
      },
    },
  },
})
