-- You can also add or configure plugins by creating files in this `plugins/` folder

---@type LazySpec
return {

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    ft = { "markdown" },
    init = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_open_ip = ""
      vim.g.mkdp_browser = ""
      vim.g.mkdp_echo_preview_url = 0
      vim.g.mkdp_browserfunc = ""
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {},
      }
      vim.g.mkdp_markdown_css = ""
      vim.g.mkdp_highlight_css = ""
      vim.g.mkdp_port = ""
      vim.g.mkdp_page_title = "「${name}」"
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_theme = "dark"
      vim.g.mkdp_combine_preview = 0
      vim.g.mkdp_combine_preview_auto_refresh = 1
    end,
  },

  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    config = function()
      require("claude-code").setup()
    end,
  },

  -- Flutter tools
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    ft = "dart",
    opts = {
      hot_reload_on_save = true, -- Enable hot reload when files are saved
      ui = {
        border = "rounded",
        notification_style = "nvim-notify",
      },
      decorations = {
        statusline = {
          app_version = true,
          device = true,
          project_config = true,
        },
      },
      widget_guides = {
        enabled = true,
      },
      dev_log = {
        enabled = true,
        open_cmd = "tabedit",
        focus_on_open = true, -- focus on the newly opened log window
      },
      lsp = {
        color = {
          enabled = true,
          background = true,
        },
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
        },
        on_attach = function(client, bufnr)
          -- Enable formatting on save
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end,
      },
    },
  },

  -- Dependencies for flutter-tools
  "nvim-lua/plenary.nvim",
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        enabled = true,
        default_prompt = "Input:",
        prompt_align = "left",
        insert_only = true,
        border = "rounded",
        relative = "cursor",
        prefer_width = 40,
        width = nil,
        max_width = { 140, 0.9 },
        min_width = { 20, 0.2 },
      },
      select = {
        enabled = true,
        backend = { "telescope", "fzf", "builtin" },
        trim_prompt = true,
        border = "rounded",
      },
    },
  },

  -- == Examples of Overriding Plugins ==

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            " █████  ███████ ████████ ██████   ██████ ",
            "██   ██ ██         ██    ██   ██ ██    ██",
            "███████ ███████    ██    ██████  ██    ██",
            "██   ██      ██    ██    ██   ██ ██    ██",
            "██   ██ ███████    ██    ██   ██  ██████ ",
            "",
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
  },

  -- BetterEscape configuration
  {
    "max397574/better-escape.nvim",
    opts = {
      timeout = vim.o.timeoutlen, -- after `timeout` passes, you can press the escape key and the plugin will ignore it
      default_mappings = true, -- setting this to false removes all the default mappings
    },
  },

  -- ToggleTerm configuration - use fish shell
  {
    "akinsho/toggleterm.nvim",
    opts = {
      shell = "/usr/bin/fish",
    },
  },
}
