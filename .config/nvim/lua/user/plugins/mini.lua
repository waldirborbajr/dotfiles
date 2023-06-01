return{
  {
    'echasnovski/mini.trailspace',
    version = false,
    config = function()
      require('mini.trailspace').setup()
    end
  },
  {
    'echasnovski/mini.comment',
    version = false,
    config = function()
      require('mini.comment').setup({
        mappings = {
          -- C-/ to comment
          comment_line = "<C-_>",
          comment = "<C-_>",
        },
        options = {
          ignore_blank_line = true,
        },
      })
    end
  },
  {
    'echasnovski/mini.move',
    version = false,
    config = function()
      require('mini.move').setup({
        mappings = {
          -- Move visual selection in Visual mode.
          left = "<M-Left>",
          right = "<M-Right>",
          down = "<M-Down>",
          up = "<M-Up>",
          -- Move current line in Normal mode
          line_left = "<M-Left>",
          line_right = "<M-Right>",
          line_down = "<M-Down>",
          line_up = "<M-Up>",
        },
      })
    end
  },
}
