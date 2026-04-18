return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      opts.automatic_installation = false
      opts.ensure_installed = vim.tbl_filter(function(adapter)
        return adapter ~= "codelldb"
      end, opts.ensure_installed or {})
    end,
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      local lldb_dap = vim.fn.exepath("lldb-dap")

      if lldb_dap ~= "" then
        dap.adapters.lldb = {
          type = "executable",
          command = lldb_dap,
          name = "lldb",
        }

        local native_launch = {
          name = "Launch native executable",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = function()
            local args = vim.fn.input("Args: ")
            return args ~= "" and vim.split(args, " ", { trimempty = true }) or {}
          end,
        }

        local native_attach = {
          name = "Attach to native process",
          type = "lldb",
          request = "attach",
          pid = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        }

        dap.configurations.c = { native_launch, native_attach }
        dap.configurations.cpp = dap.configurations.c
        dap.configurations.rust = dap.configurations.c
      end
    end,
  },
}
