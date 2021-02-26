local api = vim.api
local utils = require("commenter.utils")

local function per_line_comment_toggle(lines, commentstring)
  local front, _ = utils.get_comment_string_parts(commentstring)
  local result = {}
  if utils.starts_with(lines[1], front) then
    for i,l in ipairs(lines) do
      result[i] = utils.remove_comment_string(l, commentstring)
    end
  else
    for i,l in ipairs(lines) do
      result[i] = utils.add_comment_string(l, commentstring)
    end
  end
  return result
end

local function block_comment(lines, commentstring)
  local front, back = utils.get_comment_string_parts(commentstring)
  local c_head = {front, lines[1]}
  local c_tail = {lines[#lines], back}
  return c_head, c_tail
end

local function block_uncomment(lines, commentstring)
  local front, back = utils.get_comment_string_parts(commentstring)
    local head = {}
    local tail = {}
    if vim.trim(lines[1]) ~= front then
      table.insert(head, utils.remove_comment_string(lines[1], commentstring))
    end
    if vim.trim(lines[#lines]) ~= back then
      table.insert(tail, utils.remove_comment_string(lines[#lines], commentstring))
    end
    return head, tail
end

local function single_commenter_toggle()
  local commentstring = vim.bo.commentstring
  local front, _ = utils.get_comment_string_parts(commentstring)
  local line = api.nvim_get_current_line()
  if utils.starts_with(line, front) then
    line = utils.remove_comment_string(line, commentstring)
  else
    line = utils.add_comment_string(line, commentstring)
  end
  api.nvim_set_current_line(line)
end

local function multi_commenter_toggle()
  local commentstring = vim.bo.commentstring
  local front, back = utils.get_comment_string_parts(commentstring)
  local first, last, lines = utils.get_selection()
  if #lines == 1 then
    return single_commenter_toggle()
  end
  if back == '' then
    api.nvim_buf_set_lines(0, first, last, true, per_line_comment_toggle(lines, commentstring))
  else
    if utils.starts_with(lines[1], front) then
      local head, tail = block_uncomment(lines, commentstring)
      api.nvim_buf_set_lines(0, first, first+1, true, head)
      if #head == 0 then
        last = last - 1
      end
      api.nvim_buf_set_lines(0, last-1, last, true, tail)
    else
      local c_head, c_tail = block_comment(lines, commentstring)
      api.nvim_buf_set_lines(0, first, first+1, true, c_head)
      api.nvim_buf_set_lines(0, last, last+1, true, c_tail)
    end
  end
end

return {
  multi_commenter_toggle = multi_commenter_toggle,
  single_commenter_toggle = single_commenter_toggle
}
