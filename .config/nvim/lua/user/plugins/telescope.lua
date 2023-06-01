return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-hop.nvim",
    "nvim-telescope/telescope-bibtex.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    "nvim-telescope/telescope-media-files.nvim",
    "nvim-telescope/telescope-project.nvim",
    "debugloop/telescope-undo.nvim",
    "jvgrootveld/telescope-zoxide",
    "tsakirist/telescope-lazy.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    {
      "ahmedkhalf/project.nvim",
      config = function(_, opts) require("project_nvim").setup(opts) end,
      opts = {
        ignore_lsp = { "lua_ls" },
      },
    },
  },
  keys = {
    -- telescope plugin mappings
    { "<leader>fB", "<cmd>Telescope bibtex<cr>",       desc = "Find BibTeX" },
    { "<leader>fe", "<cmd>Telescope file_browser<cr>", desc = "File explorer" },
    { "<leader>fM", "<cmd>Telescope media_files<cr>",  desc = "Find media" },
    {
      "<leader>fp",
      function() require("telescope").extensions.projects.projects {} end,
      desc = "Find projects",
    },
    { "<leader>fu", "<cmd>Telescope undo<cr>",        desc = "Undo" },
    { "<leader>fz", "<cmd>Telescope zoxide list<cr>", desc = "Zoxide" },
    { "<leader>fl", "<cmd>Telescope lazy<cr>",        desc = "Lazy" },

    -- open buffers
    {
      "<Tab>",
      function()
        if #vim.t.bufs > 1 then require("telescope.builtin").buffers { previewer = false, sort_lastused = true } end
      end,
      desc = "Switch Buffers",
    },
  },
  opts = function(_, opts)
    local telescope = require "telescope"
    local actions = require "telescope.actions"
    local previewers = require "telescope.previewers"
    local fb_actions = require("telescope").extensions.file_browser.actions
    local hop = telescope.extensions.hop
    return require("astronvim.utils").extend_tbl(opts, {
      live_grep = {
        border = true,
        previewer = false,
        shorten_path = false,
        layout_strategy = "flex",
        layout_config = {
          width = 0.9,
          height = 0.8,
          horizontal = { width = { padding = 0.15 } },
          vertical = { preview_height = 0.75 },
        },
      },
      defaults = {
        file_previewer = previewers.cat.new,
        grep_previewer = previewers.vimgrep.new,
        qflist_previewer = previewers.qflist.new,
        selection_caret = "  ",
        file_ignore_patterns = {
          "vendor/*",
          "node%_modules/.*",
          "node_modules",
          "**/node_modules/**",
          "%.jpg",
          "%.jpeg",
          "%.png",
          "%.svg",
          "%.otf",
          "%.ttf",
          ".git/*",
          "spell/*",
        },
        layout_config = {
          width = 0.90,
          height = 0.85,
          preview_cutoff = 120,
          prompt_position = "bottom",
          horizontal = {
            preview_width = function(_, cols, _) return math.floor(cols * 0.6) end,
          },
          vertical = {
            width = 0.9,
            height = 0.95,
            preview_height = 0.5,
          },

          flex = {
            horizontal = {
              preview_width = 0.9,
            },
          },
        },
        mappings = {
          i = {
            -- ["<C-h>"] = hop.hop,
            ["<C-space>"] = function(prompt_bufnr)
              hop._hop_loop(
                prompt_bufnr,
                { callback = actions.toggle_selection, loop_callback = actions.send_selected_to_qflist }
              )
            end,
          },
        },
      },
      extensions = {
        bibtex = { context = true, context_fallback = false },
        media_files = {
          filetypes = { "png", "jpg", "mp4", "webm", "pdf" },
          find_cmd = "rg",
        },
        file_browser = {
          mappings = {
            i = {
              -- Create file/folder at current path (trailing path separator creates folder)
              ["A-a"] = fb_actions.create,
              -- Rename multi-selected files/folders
              ["A-r"] = fb_actions.rename,
              -- Move multi-selected files/folders to current path
              ["A-m"] = fb_actions.move,
              -- Copy (multi-)selected files/folders to current path
              ["A-y"] = fb_actions.copy,
              -- Delete (multi-)selected files/folders
              ["A-d"] = fb_actions.remove,
              -- Open file/folder with default system application
              ["C-o"] = fb_actions.open,
              -- Go to parent directory
              ["C-g"] = fb_actions.goto_parent_dir,
              -- Go to home directory
              ["C-e"] = fb_actions.goto_home_dir,
              -- Go to current working directory (cwd)
              ["C-w"] = fb_actions.goto_cwd,
              -- Change nvim's cwd to selected folder/file(parent)
              ["C-t"] = fb_actions.change_cwd,
              -- Toggle between file and folder browser
              ["C-f"] = fb_actions.toggle_browser,
              -- Toggle hidden files/folders
              ["C-h"] = fb_actions.toggle_hidden,
              -- Toggle all entries ignoring ./ and ../
              ["C-s"] = fb_actions.toggle_all,
              ["<bs>"] = fb_actions.backspace,
            },
            n = {
              ["a"] = fb_actions.create,
              ["r"] = fb_actions.rename,
              ["m"] = fb_actions.move,
              ["y"] = fb_actions.copy,
              ["d"] = fb_actions.remove,
              ["o"] = fb_actions.open,
              ["g"] = fb_actions.goto_parent_dir,
              ["e"] = fb_actions.goto_home_dir,
              ["w"] = fb_actions.goto_cwd,
              ["t"] = fb_actions.change_cwd,
              ["f"] = fb_actions.toggle_browser,
              ["h"] = fb_actions.toggle_hidden,
              ["s"] = fb_actions.toggle_all,
              ["<bs>"] = fb_actions.backspace,
            },

          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        buffers = {
          path_display = { "smart" },
          mappings = {
            i = { ["<c-d>"] = actions.delete_buffer },
            n = { ["d"] = actions.delete_buffer },
          },
        },
      },
    })
  end,
  config = function(...)
    require "plugins.configs.telescope" (...)
    local telescope = require "telescope"
    telescope.load_extension "bibtex"
    telescope.load_extension "file_browser"
    telescope.load_extension "media_files"
    telescope.load_extension "projects"
    telescope.load_extension "undo"
    telescope.load_extension "zoxide"
    telescope.load_extension "lazy"
    telescope.load_extension "fzf"
  end,
}
