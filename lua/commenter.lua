local api = vim.api
local start_sel, end_sel, lines, comment, two_parts, c_first, c_second

local function get_comment_string()
  comment = vim.bo.commentstring
  c_i = comment:find("%%s")-1
  c_first = comment:sub(1, c_i)
  c_second = ""
  if c_i+2 < comment:len() then
    two_parts = true
    c_second = comment:sub(c_i+3)
  end
  -- handle - and * in commentstring
  c_first = c_first:gsub("%-", "%%-")
  c_first = c_first:gsub("%*", "%%*")
  c_second = c_second:gsub("%-", "%%-")
  c_second = c_second:gsub("%*", "%%*")
  -- TODO: handle tex string <05-12-20, @noahares> --
end

-- TODO handle indent
local function add_comment_string(line)
  return comment:format(line)
end

local function remove_comment_string(line)
  local first = line:find(c_first)
  c_first = c_first:gsub("%%", "")
  c_second = c_second:gsub("%%", "")
  if first then
    if two_parts then
      local second = line:find(c_second)
      return line:sub(first + c_first:len(), second-1)
    end
    return line:sub(first + c_first:len())
  else
    return line
  end
end

local function get_selection()
  start_sel = vim.fn.line("'<") - 1
  end_sel = vim.fn.line("'>")
  lines = api.nvim_buf_get_lines(0, start_sel, end_sel, true)
end

local function multi_commenter_toggle()
  get_selection()
  get_comment_string()
  if two_parts then
    if lines[1]:find(c_first) then
      c_first = c_first:gsub("%%", "")
      c_second = c_second:gsub("%%", "")
      if lines[1] == c_first and lines[#lines] == c_second then
        api.nvim_buf_set_lines(0, start_sel, start_sel+1, true, {})
        api.nvim_buf_set_lines(0, end_sel-2, end_sel-1, true, {})
      else
        for i,l in ipairs(lines) do
          lines[i] = remove_comment_string(l)
        end
      end
    else
      c_first = c_first:gsub("%%", "")
      c_second = c_second:gsub("%%", "")
      local front = {c_first, lines[1]}
      local back = {lines[#lines], c_second}
      api.nvim_buf_set_lines(0, start_sel, start_sel+1, true, front)
      api.nvim_buf_set_lines(0, end_sel, end_sel+1, true, back)
    end
  else
    if lines[1]:find(c_first) then
      for i,l in ipairs(lines) do
        lines[i] = remove_comment_string(l)
      end
    else
      for i,l in ipairs(lines) do
        lines[i] = add_comment_string(l)
      end
    end
    api.nvim_buf_set_lines(0, start_sel, end_sel, true, lines)
  end
end

local function single_commenter_toggle()
  get_comment_string()
  local line = api.nvim_get_current_line()
  if line:find(c_first) then
    line = remove_comment_string(line)
  else
    line = add_comment_string(line)
  end
  api.nvim_set_current_line(line)
end

return {
  multi_commenter_toggle = multi_commenter_toggle,
  single_commenter_toggle = single_commenter_toggle
}
