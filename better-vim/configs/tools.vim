" Emmet
let g:user_emmet_mode='a'    "enable all function in all mode.
autocmd FileType html,css,typescriptreact,vue,rescript,php EmmetInstall

" Styled Components
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" Syntastic
let g:syntastic_javascript_checkers=['eslint']

" vim-prettier
let g:prettier#autoformat = 0

" Active Git Blame
let g:blamer_enabled = 0

" Autocomplete
set omnifunc=rescript#Complete

" When preview is enabled, omnicomplete will display additional
" information for a selected item
set completeopt+=preview
