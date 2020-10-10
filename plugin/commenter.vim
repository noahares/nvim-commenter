if exists('g:loaded_commenter')
  finish
endif

command! SingleCommenterToggle lua require'commenter'.single_commenter_toggle()
command! -range MultiCommenterToggle lua require'commenter'.multi_commenter_toggle()

let g:loaded_commenter = 1
