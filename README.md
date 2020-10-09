# nvim-commenter

This is more of an experiment than a serious plugin. Might fully develop it, if I have the time.
The goal was to get some auto-commenting to work. I also want to learn Lua. This plugin is the result.

Provides `SingleCommenter`, `MultiCommenter`, `SingleUncommenter` and `MultiUncommenter` commands which perform their actions on the current line or the selection respectively.

This plugin uses the '< and '> marks for commenting out blocks in visual mode. As these only get updated after exiting visual mode, the commands need to be prepended with `<C-u>` when used as mappings.

E.g: `vnoremap <leader>x :<C-u>MultiCommenter<cr>`
