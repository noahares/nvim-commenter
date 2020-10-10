local api = vim.api
local start_sel, end_sel, lines, comment, comment_stripped

local function get_comment_string()
  comment = api.nvim_eval('&commentstring')
  comment_stripped = string.format(comment, "")
  -- stupid c,cpp default comment string
  if comment_stripped == "/**/" then
   comment = "//%s"
   comment_stripped = "//"
  end
  -- more stupid stuff, this time lua, '-' is treated special in strings
  comment_stripped = string.gsub(comment_stripped, "%-", "%%-")
end

local function add_comment_string(line)
  get_comment_string()
  return string.format(comment, line)
end

local function remove_comment_string(line)
  get_comment_string()
  local indices = string.find(line, comment_stripped)
  if comment_stripped == "%-%-" then
   comment_stripped = "--"
  end
  return string.sub(line, indices + string.len(comment_stripped))
end

local function get_selection()
  start_sel = vim.fn.line("'<") - 1
  end_sel = vim.fn.line("'>")
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

local function single_commenter_toggle()
  local line = api.nvim_get_current_line()
  get_comment_string()
    if string.find(line, comment_stripped) then
    line = remove_comment_string(line)
  else
    line = add_comment_string(line)
  end
  api.nvim_set_current_line(line)
end

return {
  multi_commenter = multi_commenter,
  multi_uncommenter = multi_uncommenter,
  single_commenter_toggle = single_commenter_toggle
}
