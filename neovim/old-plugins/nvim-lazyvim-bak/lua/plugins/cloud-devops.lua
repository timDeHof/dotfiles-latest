-- Cloud & DevOps Tools Configuration
-- Docker, Terraform, AWS, Cloudflare, YAML, JSON

return {
  -- Ensure cloud/devops LSPs are installed
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "dockerfile-language-server",
        "terraform-ls", -- Fixed: correct Mason package name
        "yaml-language-server", -- Fixed: correct Mason package name
        "json-lsp",
        "bash-language-server",
        "csharp-language-server", -- Fixed: correct Mason package name
        "netcoredbg",
      },
    },
  },

  -- Configure LSPs
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Docker
        dockerls = {
          filetypes = { "dockerfile", "docker-compose" },
        },
        -- Terraform
        terraformls = {
          filetypes = { "terraform", "hcl" },
        },
        -- YAML (for SAM, CloudFormation, Kubernetes)
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                ["https://raw.githubusercontent.com/aws/serverless-application-model/main/sam-schema/schema.json"] = "template.yaml",
                ["https://json.schemastore.org/cloudformation.json"] = "*cloudformation*.yaml",
              },
              hover = true,
              completion = true,
              validate = true,
            },
          },
        },
        -- JSON with CloudFormation schema
        jsonls = {
          settings = {
            json = {
              schemas = {
                {
                  name = "CloudFormation",
                  description = "AWS CloudFormation schema",
                  fileMatch = { "*cloudformation*.json" },
                  url = "https://json.schemastore.org/cloudformation.json",
                },
              },
            },
          },
        },
        -- Bash for deployment scripts
        bashls = {},
      },
    },
  },

  -- Docker integration
  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
