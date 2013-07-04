if exists('g:snail_csv2google_sheet') || !has('ruby')
  finish
endif
let g:snail_csv2google_sheet = 1

let s:save_cpo = &cpo
set cpo&vim

let g:snail_csv2google_sheet_hourly_rete = get(g:, 'snail_csv2google_sheet_hourly_rete', 1200)
let g:snail_csv2google_sheet_plugin_root_dir = expand("<sfile>:p:h:h")

command! -nargs=1 -complete=file CSnail call snail_csv2google_sheet#convert(<q-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
