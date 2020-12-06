local api = vim.api
local start_sel, end_sel, lines, comment, two_parts, c_front, c_back, c_front_format, c_back_format

local function get_comment_string()
  comment = vim.bo.commentstring
  local c_i = comment:find("%%s")-1
  c_front = comment:sub(1, c_i)
  c_back = ""
  if c_i+2 < comment:len() then
    two_parts = true
    c_back = comment:sub(c_i+3)
  end
  -- handle -, % and * in commentstring
  c_front_format = c_front:gsub("%%", "%%%%")
  c_front_format = c_front_format:gsub("%-", "%%-")
  c_front_format = c_front_format:gsub("%*", "%%*")
  c_back_format = c_back:gsub("%-", "%%-")
  c_back_format = c_back_format:gsub("%*", "%%*")
end

local function add_comment_string(line)
  -- special case for tex comments
  if comment == "%%s" then
    comment = "%%%s"
  end
  local first_char = line:find("%g")
  local indent = line:sub(1, first_char-1)
  local line_stripped = line:sub(first_char)
  return indent..comment:format(line_stripped)
end

local function remove_comment_string(line)
  local first = line:find(c_front_format)
  local indent = line:sub(1, line:find("%g")-1)
  if first then
    if two_parts then
      local back = line:find(c_back)
      return indent..line:sub(first + c_front:len(), back-1)
    end
    return indent..line:sub(first + c_front:len())
  else
    return line
  end
end

local function get_selection()
  start_sel = vim.fn.line("'<") - 1
  end_sel = vim.fn.line("'>")
  lines = api.nvim_buf_get_lines(0, start_sel, end_sel, true)
end

local function single_commenter_toggle()
  get_comment_string()
  local line = api.nvim_get_current_line()
  if line:find(c_front_format) then
    line = remove_comment_string(line)
  else
    line = add_comment_string(line)
  end
  api.nvim_set_current_line(line)
end

local function multi_commenter_toggle()
  get_selection()
  get_comment_string()
  if #lines == 1 then
    return single_commenter_toggle()
  end
  if two_parts then
    if lines[1]:find(c_front_format) then
      if lines[1] == c_front and lines[#lines] == c_back then
        api.nvim_buf_set_lines(0, start_sel, start_sel+1, true, {})
        api.nvim_buf_set_lines(0, end_sel-2, end_sel-1, true, {})
      else
        local first = lines[1]:find(c_front_format)
        local indent = lines[1]:sub(1, lines[1]:find("%g")-1)
        local first_line = indent..lines[1]:sub(first + c_front:len())
        local back = lines[#lines]:find(c_back_format)
        local last_line = lines[#lines]:sub(1, back-1)
        api.nvim_buf_set_lines(0, start_sel, start_sel+1, true, {first_line})
        api.nvim_buf_set_lines(0, end_sel-1, end_sel, true, {last_line})
      end
    else
      local front = {c_front, lines[1]}
      local back = {lines[#lines], c_back}
      api.nvim_buf_set_lines(0, start_sel, start_sel+1, true, front)
      api.nvim_buf_set_lines(0, end_sel, end_sel+1, true, back)
    end
  else
    if lines[1]:find(c_front_format) then
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

return {
  multi_commenter_toggle = multi_commenter_toggle,
  single_commenter_toggle = single_commenter_toggle
}
