-- Print surround for cpp
require("nvim-surround").buffer_setup({
  surrounds = {
    ["p"] = {
      add = function()
        for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
          if line == "using namespace std;" then
            return { { "cout << " }, { " << endl;" } }
          end
        end
        return { { "std::cout << " }, { " << std::endl;" } }
      end,
      find = function()
        local config = require("nvim-surround.config")
        for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
          if line == "using namespace std;" then
            return config.get_selection({ pattern = "cout << .- << endl;" })
          end
        end
        return config.get_selection({ pattern = "std::cout << .- << std::endl;" })
      end,
      delete = function()
        local config = require("nvim-surround.config")
        for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
          if line == "using namespace std;" then
            return config.get_selections({
              char = "p",
              pattern = "^(cout << )().-( << endl;)()$",
            })
          end
        end
        return config.get_selections({
          char = "p",
          pattern = "^(std::cout << )().-( << std::endl;)()$",
        })
      end,
    },
  },
})

-- Switch to header using clangd
vim.keymap.set("n", "<leader>sh", [[<cmd>ClangdSwitchSourceHeader<CR>]], { silent = true })
