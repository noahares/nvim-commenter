# nvim-commenter

This is more of an experiment than a serious plugin. Might fully develop it, if I have the time.
The goal was to get some auto-commenting to work. I also want to learn Lua. This plugin is the result.

Provides `SingleCommenterToggle`, `MultiCommenterToggle` and commands which perform their actions on the current line or the selection respectively.

To quickly comment out selected lines in visual mode use something like this: `vnoremap <leader>x :MultiCommenterToggle<cr>`

# TODO

* tex comments do not work
