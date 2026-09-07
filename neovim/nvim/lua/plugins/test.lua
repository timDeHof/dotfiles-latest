return {
  { import = "lazyvim.plugins.extras.test.core" },
  {
    "nvim-neotest/neotest",
    opts = {
      adapters = {
        ["neotest-vitest"] = {},
      },
    },
    dependencies = {
      "marilari88/neotest-vitest",
    },
  },
}
