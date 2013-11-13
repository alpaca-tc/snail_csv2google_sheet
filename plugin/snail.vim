"=============================================================================
" FILE: snail.vim
" AUTHOR: Ishii Hiroyuki <alprhcp666@gmail.com>
" Last Modified: 2013-11-12
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

if exists('g:loaded_snail')
  finish
endif
let g:loaded_snail = 1

let s:save_cpo = &cpo
set cpo&vim

let g:snail#hourly_rete = get(g:, 'snail#hourly_rete', 1000)
let g:snail#plugin_root_dir = expand('<sfile>:p:h:h')
let g:snail#format#definition_row
      \ = get(g:, 'snail#format#definition_row', {})
let g:snail#format#definition_result
      \ = get(g:, 'snail#format#definition_result', {})
let g:snail#format#row =
      \ join(['%START_DATE%', '%TITLE%', '%TIME_SPENT::TO_HOUR%', '%PAY%'], '%TAB%')
let g:snail#format#result =
      \ join(['%YEAR%/%MONTH%/%DAY', '%TITLE%', '%WORK_TIME%', '%TASK_YEN%'], '%TAB%')

command! -nargs=1 -complete=file Snail call snail#convert(<q-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
