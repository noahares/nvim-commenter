local api = vim.api
local comment_strings = {}
comment_strings['cpp'] = "//"
comment_strings['sh'] = "#"
comment_strings['lua'] = "--"
comment_strings['vim'] = '"'
comment_strings['tex'] = "%"
local filetype, start_sel, end_sel, lines

local function add_comment_string(line)
  return comment_strings[filetype] .. line
end

local function remove_comment_string(line)
  local first_char = string.find(line, '%w')
  local indices = string.find(line, comment_strings[filetype], 1, first_char)
  return string.sub(line, indices + string.len(comment_strings[filetype]))
end

local function get_vars()
  filetype = api.nvim_eval('&filetype')
  start_sel = api.nvim_eval('getpos("\'<")[1]') - 1
  end_sel = api.nvim_eval('getpos("\'>")[1]')
  lines = api.nvim_buf_get_lines(0, start_sel, end_sel, true)
end

local function multi_commenter()
  get_vars()
  for i,l in ipairs(lines) do
    lines[i] = add_comment_string(l)
  end
  api.nvim_buf_set_lines(0, start_sel, end_sel, true, lines)
end

local function multi_uncommenter()
  for i,l in ipairs(lines) do
    lines[i] = remove_comment_string(l)
  end
  api.nvim_buf_set_lines(0, start_sel, end_sel, true, lines)
end

local function single_commenter()
  filetype = api.nvim_eval('&filetype')
  local line = api.nvim_get_current_line()
  line = add_comment_string(line)
  api.nvim_set_current_line(line)
end

local function single_uncommenter()
  filetype = api.nvim_eval('&filetype')
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
