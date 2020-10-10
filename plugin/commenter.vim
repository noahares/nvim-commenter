if exists('g:loaded_commenter')
  finish
endif

command! SingleCommenterToggle lua require'commenter'.single_commenter_toggle()
command! -range MultiCommenter lua require'commenter'.multi_commenter()
command! -range MultiUnommenter lua require'commenter'.multi_uncommenter()

let g:loaded_commenter = 1
