return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ruby_lsp = {
        mason = false,
        cmd = { "~/.asdf/shims/ruby-lsp" },
      },
      rubocop = {
        enabled = false, -- it runs as a part of ruby-lsp
      },
    },
  },
}
