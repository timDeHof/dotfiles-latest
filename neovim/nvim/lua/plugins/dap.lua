return {
  { import = "lazyvim.plugins.extras.dap.core" },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "js" },
    },
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    config = function()
      local dap = require("dap")
      if vim.fn.executable("js-debug-adapter") == 1 then
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "127.0.0.1",
          port = "${port}",
          executable = {
            command = "js-debug-adapter",
            args = { "${port}" },
          },
        }
        for _, type in ipairs({ "pwa-node", "pwa-chrome", "pwa-msedge", "node", "chrome", "msedge" }) do
          dap.adapters[type] = function(cb, config)
            cb(dap.adapters["pwa-node"])
          end
        end
        dap.configurations.typescript = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },
}
