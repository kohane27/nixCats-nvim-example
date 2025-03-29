local M = {}

function M.get_visual_selection()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg("v")
  vim.fn.setreg("v", {})
  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ""
  end
end

-- ╭─────────────────────────────────────────────────────────╮
-- │ START: grep                                             │
-- ╰─────────────────────────────────────────────────────────╯
local function is_in_home_directory()
  if vim.fn.getcwd() == os.getenv("HOME") then
    print("Current directory is home. Exiting")
    return true
  end
  return false
end

local function is_git_repo()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end

local common_glob_patterns = {
  "--glob=!**/.git/*",
  "--glob=!**/node_modules/*",
  "--glob=!**/.direnv/*",
  "--glob=!**/.terraform/*",
  "--glob=!**/build/*",
  "--glob=!**/dist/*",
  "--glob=!**/yarn.lock",
  "--glob=!**/package-lock.json",
}

function M.live_grep_from_project_git_root(custom_opts)
  local opts = {}
  if is_in_home_directory() then
    return
  end
  if is_git_repo() then
    opts = {
      cwd = Snacks.git.get_root(),
      vimgrep_arguments = vim.list_extend({
        "rg", -- use `ripgrep`
        "--ignore-case", -- all patterns will be searched case insensitively
        "--follow", -- follow symbolic links
        "--hidden", -- Search hidden files and directories
        -- "--no-ignore", -- do NOT respect .gitignore
        -- "--no-heading", -- don't group matches by each file
        -- "--with-filename", -- print the file path with the matched lines
        -- "--line-number", -- show line numbers
        -- "--column", -- show column numbers
      }, common_glob_patterns),
    }
  end
  if custom_opts then
    opts = vim.tbl_extend("force", opts, custom_opts)
  end
  require("telescope").extensions.egrepify.egrepify(opts)
end

function M.find_files_from_project_git_root()
  local opts = {}
  if is_in_home_directory() then
    return
  end
  if is_git_repo() then
    opts = {
      cwd = Snacks.git.get_root(),
      hidden = true,
      find_command = vim.list_extend({
        "rg",
        "--ignore-case", -- all patterns will be searched case insensitively
        "--follow", -- follow symbolic links
        "--files", -- Print each file that would be searched without actually performing the search
        "--hidden", -- Search hidden files and directories
        -- "--no-ignore", -- do NOT respect .gitignore
      }, common_glob_patterns),
    }
  end
  require("telescope.builtin").find_files(opts)
end

-- ╭─────────────────────────────────────────────────────────╮
-- │ END: grep                                               │
-- ╰─────────────────────────────────────────────────────────╯

function M.markdown_preview()
  local buf = vim.api.nvim_create_buf(false, true)
  local current_buf = vim.api.nvim_get_current_buf()

  local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)
  local markdownm = table.concat(lines, "\n")

  local sanitized = markdownm:gsub("'", "'\\''")
  local sanitized_final = "'" .. sanitized .. "'"

  vim.cmd("rightbelow vert sbuffer " .. buf)

  local new_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_option(new_win, "number", false)
  vim.api.nvim_win_set_option(new_win, "cursorline", false)
  vim.api.nvim_win_set_option(new_win, "relativenumber", false)

  vim.fn.termopen("glow <( echo " .. sanitized_final .. ")\n")
end

function M.execute_command(cmd)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, true, true), "t", true)
end

function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

function M.search_chats(chat_dir)
  local actions = require("telescope.actions")
  local builtin = require("telescope.builtin")

  builtin.find_files({
    cwd = chat_dir,
    attach_mappings = function(prompt_bufnr, map)
        -- Switch to live_grep on any character input
        -- stylua: ignore
        for _, char in ipairs({"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
                             "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
                             "1","2","3","4","5","6","7","8","9","0","!","@","#","$","%","^","&","*","(",")","-","_","=","+","[","]",
                             "{","}",";",":","'","\"",",","<",".",">","/","?"}) do
            map("i", char, function()
                actions.close(prompt_bufnr)
                require("custom.core.utils").live_grep_from_project_git_root({
                    search_dirs = { chat_dir },
                    default_text = char
                })
            end)
        end
      return true
    end,
  })
end

function M.copy_project_structure()
  if is_in_home_directory() then
    return
  end
  if not is_git_repo() then
    vim.notify("Not in a git repository!", vim.log.levels.ERROR)
    return
  end

  local root_dir = Snacks.git.get_root()
  vim.system({
    "sh",
    "-c",
    string.format("cd %s && eza --tree --level=10 --all --git-ignore | wl-copy", vim.fn.shellescape(root_dir)),
  })

  vim.notify("Project structure copied to clipboard.", vim.log.levels.INFO)
end

return M
