return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'leoluz/nvim-dap-go',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
    },
    config = function()
      local dap = require 'dap'
      local ui = require 'dapui'

      require('dap-go').setup()
      require('nvim-dap-virtual-text').setup()

      -- 1. DAP UI Setup (Toolbar & Window Icons)
      ui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '▸' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      -- 2. Gutter Sign Icons (Breakpoints & Current Line Arrow)
      vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DiagnosticError', linehl = '', numhl = '' })
      vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DiagnosticInfo', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '', texthl = 'DiagnosticOk', linehl = 'Visual', numhl = 'DiagnosticOk' })

      -- 3. Codelldb Adapter & C++ Configuration
      local codelldb_path = vim.fn.stdpath 'data' .. '/mason/packages/codelldb/extension/adapter/codelldb'
      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = codelldb_path,
          args = { '--port', '${port}' },
        },
      }

      dap.configurations.cpp = {
        {
          name = 'Launch SDL3 Game',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          reverseDebugging = true,
        },
      }

      -- 4. Keymaps
      vim.keymap.set('n', '<space>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<space>gb', dap.run_to_cursor, { desc = 'Debug: Run to Cursor' })
      vim.keymap.set('n', '<space>?', function()
        ui.eval(nil, { enter = true })
      end, { desc = 'Debug: Eval Var Under Cursor' })

      vim.keymap.set('n', '<F1>', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<F2>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F3>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F4>', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<F5>', dap.step_back, { desc = 'Debug: Step Back' })
      vim.keymap.set('n', '<F13>', dap.restart, { desc = 'Debug: Restart' })

      -- 5. Auto-open/close UI
      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
}
