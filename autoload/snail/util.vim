function! snail#util#to_clipboard(text) " {{{
  if exists('g:gist_clip_command')
    call system(g:gist_clip_command, a:text)
  elseif has('unix') && !has('xterm_clipboard')
    let @" = a:text
  else
    let @+ = a:text
  endif
endfunction "}}}
