local api = vim.api
local start_sel, end_sel, lines, comment, comment_stripped

local function get_comment_string()
  comment = api.nvim_eval('&commentstring')
  comment_stripped = string.format(comment, "")
end

local function add_comment_string(line)
  get_comment_string()
  return string.format(comment, line)
end

local function remove_comment_string(line)
  get_comment_string()
  local first_char = string.find(line, '%w')
  local indices = string.find(line, comment_stripped, 1, first_char)
  return string.sub(line, indices + string.len(comment_stripped))
end

local function get_selection()
  -- TODO handle reverse selection and single line selection
  start_sel = api.nvim_eval('getpos("\'<")[1]') - 1
  end_sel = api.nvim_eval('getpos("\'>")[1]')
  lines = api.nvim_buf_get_lines(0, start_sel, end_sel, true)
end

local function multi_commenter()
  get_selection()
  for i,l in ipairs(lines) do
    lines[i] = add_comment_string(l)
  end
  api.nvim_buf_set_lines(0, start_sel, end_sel, true, lines)
end

local function multi_uncommenter()
  get_selection()
  for i,l in ipairs(lines) do
    lines[i] = remove_comment_string(l)
  end
  api.nvim_buf_set_lines(0, start_sel, end_sel, true, lines)
end

local function single_commenter()
  local line = api.nvim_get_current_line()
  line = add_comment_string(line)
  api.nvim_set_current_line(line)
end

local function single_uncommenter()
  local line = api.nvim_get_current_line()
  line = remove_comment_string(line)
  api.nvim_set_current_line(line)
end

return {
  multi_commenter = multi_commenter,
  multi_uncommenter = multi_uncommenter,
  single_commenter = single_commenter,
  single_uncommenter = single_uncommenter
}
