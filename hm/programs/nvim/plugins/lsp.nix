{ pkgs, config, ... }:

{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    cmp-vsnip
    cmp-nvim-lsp
    cmp-path
    cmp-buffer
    cmp-cmdline
    {
      plugin = nvim-cmp;
      type = "lua";
      config = ''
        local cmp = require 'cmp'

        cmp.setup({
          snippet = {
            expand = function(args)
              vim.fn["vsnip#anonymous"](args.body)
            end,
          },
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' },
            { name = 'path' },
          }, {
            { name = 'buffer' },
          })
        })

        cmp.setup.filetype('gitcommit', {
          sources = cmp.config.sources({
            { name = 'git' }, }, {
            { name = 'buffer' },
          })
        })

        cmp.setup.cmdline({ '/', '?' }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = 'buffer' }
          }
        })

        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            { name = 'cmdline' }
          })
        })
      '';
    }
    {
      plugin = nvim-lspconfig;
      type = "lua";
      config = ''
        -- Mappings.
        -- See `:help vim.diagnostic.*` for documentation on any of the below functions
        local opts = { noremap = true, silent = true }
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

        local on_attach = function(client, bufnr)
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local bufopts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, bufopts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
        end

        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lsp_flags = { debounce_text_changes = 150, }
        require('lspconfig')['pyright'].setup {
          on_attach = on_attach,
          flags = lsp_flags,
          capabilities = capabilities,
        }
        require('lspconfig')['tsserver'].setup {
          on_attach = on_attach,
          flags = lsp_flags,
          capabilities = capabilities,
        }
        require('lspconfig')['rust_analyzer'].setup {
          on_attach = on_attach,
          flags = lsp_flags,
          capabilities = capabilities,
          -- Server-specific settings...
          settings = {
            ["rust-analyzer"] = {}
          }
        }
        require('lspconfig')['lua_ls'].setup {
          on_attach = on_attach,
          flags = lsp_flags,
          capabilities = capabilities,
        }

        require('lspconfig')['bashls'].setup {
          on_attach = on_attach,
          flags = lsp_flags,
          capabilities = capabilities,
        }

        require('lspconfig')['rnix'].setup {
          on_attach = on_attach,
          flags = lsp_flags,
          capabilities = capabilities,
        }

        require('lspconfig')['ccls'].setup {
          on_attach = on_attach,
          flags = lsp_flags,
          capabilities = capabilities,
        }
        require('lspconfig')['r_language_server'].setup {
          on_attach = on_attach,
          flags = lsp_flags,
          capabilities = capabilities,
        }
        require('lspconfig')['texlab'].setup {
          on_attach = on_attach,
          flags = lsp_flags,
          filetypes = { "tex", "lytex" },
          capabilities = capabilities,
        }
        vim.diagnostic.config({
          virtual_text = {
            -- source = "always",  -- Or "if_many"
            prefix = '●', -- Could be '■', '▎', 'x'
          },
          severity_sort = true,
          float = {
            source = "always", -- Or "if_many"
          },
        })
      '';
    }
  ];
}
