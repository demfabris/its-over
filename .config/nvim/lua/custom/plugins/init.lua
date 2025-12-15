-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'supermaven-inc/supermaven-nvim',
    config = function()
      require('supermaven-nvim').setup({})
    end,
  },

  -- Rust development powertools
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
    ft = { 'rust' },
    init = function()
      vim.g.rustaceanvim = {
        tools = {
          float_win_config = {
            border = 'rounded',
          },
        },
        server = {
          on_attach = function(_, bufnr)
            local map = function(keys, func, desc)
              vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'Rust: ' .. desc })
            end
            -- Rust-specific keymaps
            map('<leader>re', function() vim.cmd.RustLsp('expandMacro') end, '[E]xpand macro')
            map('<leader>rc', function() vim.cmd.RustLsp('openCargo') end, 'Open [C]argo.toml')
            map('<leader>rp', function() vim.cmd.RustLsp('parentModule') end, '[P]arent module')
            map('<leader>rr', function() vim.cmd.RustLsp('runnables') end, '[R]unnables')
            map('<leader>rd', function() vim.cmd.RustLsp('debuggables') end, '[D]ebuggables')
            map('<leader>rt', function() vim.cmd.RustLsp('testables') end, '[T]estables')
            map('<leader>rm', function() vim.cmd.RustLsp('rebuildProcMacros') end, 'Rebuild proc [M]acros')
            map('<leader>rk', function() vim.cmd.RustLsp { 'moveItem', 'up' } end, 'Move item up')
            map('<leader>rj', function() vim.cmd.RustLsp { 'moveItem', 'down' } end, 'Move item down')
            map('<leader>ra', function() vim.cmd.RustLsp('codeAction') end, 'Code [A]ction')
            map('<leader>rh', function() vim.cmd.RustLsp { 'hover', 'actions' } end, '[H]over actions')
            map('J', function() vim.cmd.RustLsp('joinLines') end, 'Join lines')
            map('<leader>rE', function() vim.cmd.RustLsp('explainError') end, '[E]xplain error')
            map('<leader>rD', function() vim.cmd.RustLsp('renderDiagnostic') end, 'Render [D]iagnostic')
          end,
          default_settings = {
            ['rust-analyzer'] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = { enable = true },
              },
              checkOnSave = true,
              check = { command = 'clippy' },
              procMacro = {
                enable = true,
                ignored = {
                  ['async-trait'] = { 'async_trait' },
                  ['tokio'] = { 'main', 'test' },
                },
              },
            },
          },
        },
      }
    end,
  },

  -- Cargo.toml dependency management
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    tag = 'stable',
    config = function()
      local crates = require('crates')
      crates.setup {
        -- No cmp integration since we use blink.cmp
        completion = {
          cmp = { enabled = false },
        },
      }
      -- Keymaps for Cargo.toml
      vim.api.nvim_create_autocmd('BufRead', {
        pattern = 'Cargo.toml',
        callback = function(ev)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = 'Crates: ' .. desc })
          end
          map('<leader>ct', crates.toggle, '[T]oggle crates info')
          map('<leader>cr', crates.reload, '[R]eload crates')
          map('<leader>cv', crates.show_versions_popup, '[V]ersions popup')
          map('<leader>cf', crates.show_features_popup, '[F]eatures popup')
          map('<leader>cd', crates.show_dependencies_popup, '[D]ependencies popup')
          map('<leader>cu', crates.update_crate, '[U]pdate crate')
          map('<leader>cU', crates.upgrade_crate, '[U]pgrade crate')
          map('<leader>ca', crates.update_all_crates, 'Update [A]ll crates')
          map('<leader>cA', crates.upgrade_all_crates, 'Upgrade [A]ll crates')
          map('<leader>cH', crates.open_homepage, 'Open [H]omepage')
          map('<leader>cR', crates.open_repository, 'Open [R]epository')
          map('<leader>cD', crates.open_documentation, 'Open [D]ocs.rs')
          map('<leader>cC', crates.open_crates_io, 'Open [C]rates.io')
        end,
      })
    end,
  },
  -- Oil: edit filesystem like a buffer (with git status signs)
  {
    'stevearc/oil.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'refractalize/oil-git-status.nvim',
    },
    lazy = false,
    keys = {
      { '-', '<CMD>Oil<CR>', desc = 'Open parent directory' },
      { '<leader>e', function()
        local oil = require('oil')
        -- Find existing oil sidebar buffer
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == 'oil' then
            vim.api.nvim_win_close(win, true)
            return
          end
        end
        -- Open new sidebar
        vim.cmd('topleft 35vsplit')
        oil.open()
      end, desc = 'Toggle file explorer sidebar' },
    },
    config = function()
      require('oil').setup({
        default_file_explorer = true,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden = true,
          natural_order = true,
        },
        win_options = {
          signcolumn = 'yes:2',
        },
        float = {
          padding = 2,
          max_width = 90,
          max_height = 30,
          border = 'rounded',
        },
        keymaps = {
          ['g?'] = 'actions.show_help',
          ['<CR>'] = 'actions.select',
          ['<C-v>'] = 'actions.select_vsplit',
          ['<C-s>'] = 'actions.select_split',
          ['<C-t>'] = 'actions.select_tab',
          ['<C-p>'] = 'actions.preview',
          ['q'] = 'actions.close',
          ['-'] = 'actions.parent',
          ['_'] = 'actions.open_cwd',
          ['`'] = 'actions.cd',
          ['gs'] = 'actions.change_sort',
          ['gx'] = 'actions.open_external',
          ['g.'] = 'actions.toggle_hidden',
        },
        use_default_keymaps = false,
      })
      -- Setup git status AFTER oil is configured
      require('oil-git-status').setup()
    end,
  },

  -- Toggle terminal
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    keys = {
      { '<C-\\>', '<CMD>ToggleTerm<CR>', desc = 'Toggle terminal' },
      { '<C-\\>', '<CMD>ToggleTerm<CR>', mode = 't', desc = 'Toggle terminal' },
    },
    opts = {
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<C-\>]],
      direction = 'float',
      float_opts = {
        border = 'rounded',
        width = function() return math.floor(vim.o.columns * 0.85) end,
        height = function() return math.floor(vim.o.lines * 0.8) end,
      },
      shade_terminals = false,
    },
  },

  {
    'NvChad/nvim-colorizer.lua',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      filetypes = { '*' },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,       -- "Blue" etc - disabled for perf
        RRGGBBAA = true,     -- #RRGGBBAA
        AARRGGBB = true,     -- 0xAARRGGBB
        rgb_fn = true,       -- CSS rgb()
        hsl_fn = true,       -- CSS hsl()
        css = true,
        css_fn = true,
        mode = 'virtualtext', -- "background", "foreground", or "virtualtext"
        virtualtext = '■',
        virtualtext_inline = true,
        always_update = false,
      },
    },
  },
}