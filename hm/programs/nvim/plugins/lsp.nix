{ pkgs, ... }:

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
      config =
        #lua
        ''
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
      config =
        #lua
        ''
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
            vim.keymap.set('n', '<space>f', function()
              if vim.bo.filetype == "python" then
                vim.cmd("!black %")
              else
                vim.lsp.buf.format { async = true }
              end
            end, bufopts)

          end

          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          local lsp_flags = { debounce_text_changes = 150, }
          vim.lsp.enable('pyright')
          vim.lsp.config('pyright', {
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
          })
          vim.lsp.enable('ts_ls')
          vim.lsp.config('ts_ls', {
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
          })
          vim.lsp.enable('rust_analyzer')
          vim.lsp.config('rust_analyzer', {
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
            settings = {
              ["rust-analyzer"] = {}
            }
          })
          vim.lsp.enable('lua_ls')
          vim.lsp.config('lua_ls', {
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
          })
          vim.lsp.enable('bashls')
          vim.lsp.config('bashls', {
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
          })
          vim.lsp.enable('clangd')
          vim.lsp.config('clangd', {
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
            cmd = {
               "clangd",
               "--all-scopes-completion",
               "--recovery-ast",
               "--clang-tidy",
               "--background-index",
               "-j=64",
               "--log=verbose",
               "--cross-file-rename",
               "--suggest-missing-includes",
               "--enable-config",
            },
          })
          vim.lsp.enable('nixd')
          vim.lsp.config('nixd', {
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
          })
          vim.lsp.enable('r_language_server')
          vim.lsp.config('r_language_server', {
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
          })
          vim.lsp.enable('texlab')
          vim.lsp.config('texlab', {
            on_attach = on_attach,
            flags = lsp_flags,
            filetypes = { "tex", "lytex" },
            capabilities = capabilities,
          })
          local pid = vim.fn.getpid()
          vim.lsp.enable('omnisharp')
          vim.lsp.config('omnisharp', {
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
            cmd = { "OmniSharp", "--languageserver" , "--hostPID", tostring(pid) },
          })
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
