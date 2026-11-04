-- C# / .NET Development Configuration
-- Enables C# LSP (csharp-ls) and debugger (netcoredbg)

return {
  -- Configure C# LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        csharp_ls = {
          -- C# Dev Kit / Roslyn-based LSP
          -- Auto-installed by Mason (package name: csharp-language-server)
          on_attach = function(client, buffer)
            -- C# specific keybindings
            vim.keymap.set("n", "<leader>co", "<cmd>OmniSharpClientCommands<CR>", {
              buffer = buffer,
              desc = "C# Commands",
            })
          end,
        },
      },
    },
  },

  -- Debugger configuration for .NET
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mason-org/mason.nvim",
    },
    config = function()
      local dap = require("dap")

      -- C# debugger configuration
      dap.adapters.coreclr = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg",
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = false,
        },
      }

      -- Keybindings for debugging
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Conditional Breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
      vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step Out" })
    end,
  },

  -- Ensure C# tools are installed
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "csharp-language-server", -- Fixed: correct Mason package name
        "netcoredbg",
      },
    },
  },
}
