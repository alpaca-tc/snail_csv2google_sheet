let s:V = vital#of('snail.vim')
let s:Date = s:V.import('DateTime')

function! snail#convert(path) " {{{
  let table = s:table.new(a:path)
  let result = snail#format#convert(table)
endfunction "}}}

function! s:initialize() "{{{
  if exists('s:initialized')
    return 0
  endif
  let s:initialized = 1

  ruby << EOF
  plugin_root_path = VIM.evaluate('g:snail#plugin_root_dir')
  $LOAD_PATH << File.expand_path("#{plugin_root_path}/lib")

  require 'snail'
  require 'core_ext/vim'
EOF
endfunction "}}}
function! s:parse_str(str, keyword, length, default) "{{{
  let date = split(a:str, a:keyword)
  let len = a:length - len(date) - 1
  let result = map(range(0, len), 'a:default')

  if empty(date)
    return join(result, a:keyword)
  else
    return join(date, a:keyword)
  endif
endfunction"}}}

let s:table = {} "{{{
function! s:table.new(path) "{{{
  let instance = copy(self)
  call instance.constructor(a:path)
  call remove(instance, 'new')

  return instance
endfunction"}}}

function! s:table.constructor(path) "{{{
  call s:initialize()

  " Convert CSV to vim dictionary
  ruby << EOF
  snail = SnailTable.new(VIM.evaluate('a:path'))
  header = snail.header
  tasks = snail.tasks
  VIM.let('header', header)
  VIM.let('tasks', tasks)
EOF

  let self.header = header
  let self.tasks = map(tasks, 's:row.new(v:val)')
endfunction"}}}
"}}}

let s:row = {}"{{{
function! s:row.new(row) "{{{
  let instance = copy(self)
  call instance.constructor(a:row)
  call remove(instance, 'new')

  return instance
endfunction"}}}

function! s:row.constructor(row) "{{{
  " line => {'Status': 'New', 'Completion Date': '', 'Start Date': '0025-11-11', 'Time Spent': '00:00:01', 'Title': 'westboosterのブログを内部へ組み込む'}
  let line = a:row
  let self.status = line['Status']
  let self.title = line['Title']

  let date = '%Y-%m-%d'
  let time = '%H:%M:%S'
  try
    let completion_date = s:parse_str(line['Completion Date'], '-', 3, '0')
    let start_date = s:parse_str(line['Start Date'], '-', 3, '0')
    let time_spent = s:parse_str(line['Time Spent'], ':', 3, '0')

    let self.completion_date = s:Date.from_format(completion_date, date)
    let self.start_date = s:Date.from_format(start_date, date)
    let self.time_spent = s:Date.from_format(time_spent, time)
  catch /.*/
    echomsg v:errmsg
    echomsg v:exception
  endtry
endfunction"}}}

function! s:row.is_complete() "{{{
  self.completion_date == 'Completed'
endfunction"}}}

function! s:row.is_new() "{{{
  self.completion_date == 'New'
endfunction"}}}
"}}}
