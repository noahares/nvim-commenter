local api = vim.api

local Utils = {}
function Utils.get_comment_string_parts(commentstring)
  local front_index = commentstring:find("%%s")-1
  local c_front = commentstring:sub(1, front_index)
  local c_back = ''
  if front_index+2 < #commentstring then
    c_back = commentstring:sub(front_index+3)
  end
  return c_front, c_back
end

function Utils.add_comment_string(line, commentstring)
  local front, back = Utils.get_comment_string_parts(commentstring)
  if line == nil or line == '' then
    return vim.trim(front)
  end
  if Utils.starts_with(line, front) then
    return line
  end
  local first_char = line:find("%S")
  first_char = first_char == nil and 1 or first_char
  local result = string.sub(line, 0, first_char - 1) .. front .. string.sub(line, first_char, #line) .. back
  return result
end

function Utils.remove_comment_string(line, commentstring)
  local front, back = Utils.get_comment_string_parts(commentstring)
  if line == nil or line == '' then
    return ''
  end
  local result = string.gsub(line, vim.pesc(front) .. "%s*", "", 1)
  if back ~= '' then
    result = string.sub(result, 0, Utils.index_last_occurence(result, vim.pesc(back)) - 1)
  end
  return result
end

function Utils.get_selection()
  local start_sel = vim.fn.getpos('v')[2]
  local end_sel = vim.fn.getcurpos()[2]
  if end_sel < start_sel then
    start_sel, end_sel = end_sel, start_sel
  end
  start_sel = start_sel - 1
  local lines = api.nvim_buf_get_lines(0, start_sel, end_sel, true)
  return start_sel, end_sel, lines
end

function Utils.starts_with(line, prefix)
  local line_trimmed = vim.fn.trim(line)
  return line_trimmed:sub(1, #prefix) == prefix
end

function Utils.index_last_occurence(str, pattern)
    local result = 0
    local i = 0
    while true do
        i = string.find(str, pattern, i+1)
        if i == nil then break end
        result = i
    end
    return result
end
return Utils
