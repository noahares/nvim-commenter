if exists('g:loaded_commenter')
  finish
endif

command! SingleCommenter lua require'commenter'.single_commenter()
command! SingleUncommenter lua require'commenter'.single_uncommenter()
command! MultiCommenter lua require'commenter'.multi_commenter()
command! MultiUnommenter lua require'commenter'.multi_uncommenter()

let g:loaded_commenter = 1
