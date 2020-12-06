# nvim-commenter

The goal was to get some auto-commenting to work. I also want to learn Lua. This plugin is the result.

Provides `SingleCommenterToggle`, `MultiCommenterToggle` and commands which perform their actions on the current line or the selection respectively.

To quickly comment out selected lines in visual mode use something like this: `vnoremap <leader>x :MultiCommenterToggle<cr>`
