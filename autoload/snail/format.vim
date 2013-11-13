let s:definition_row = {
      \ '%START_DATE%':             's:get_date(row.start_date)',
      \ '%START_DATE::YEAR%':       'row.start_date.year()',
      \ '%START_DATE::MONTH%':      'row.start_date.month()',
      \ '%START_DATE::DAY%':        'row.start_date.day()',
      \ '%COMPLETION_DATE%':        's:get_date(row.completion_date)',
      \ '%COMPLETION_DATE::YEAR%':  'row.completion_date.year()',
      \ '%COMPLETION_DATE::MONTH%': 'row.completion_date.month()',
      \ '%COMPLETION_DATE::DAY%':   'row.completion_date.day()',
      \ '%TIME_SPENT%':             's:get_time(row.time_spent)',
      \ '%TIME_SPENT::HOUR%':       'row.time_spent.hour()',
      \ '%TIME_SPENT::MINUTE%':     'row.time_spent.minute()',
      \ '%TIME_SPENT::SECOND%':     'row.time_spent.second()',
      \ '%TIME_SPENT::TO_HOUR%':    's:get_hour(row.time_spent)',
      \ '%TITLE%':                  'row.title',
      \ '%TAB%':                    '"	"',
      \ '%CR%':                     '""',
      \ '%HOURY_RATE%':             'g:snail#hourly_rete',
      \ '%SUM_PAYOFF%':             's:get_payoff(s:tasks)',
      \ '%PAYOFF%':                 's:get_payoff(row.time_spent)',
      \ }
call extend(s:definition_row, g:snail#format#definition_row)

function! snail#format#convert(table) "{{{
  let s:table = a:table
  let s:header = a:table.header
  let s:tasks = a:table.tasks
  let s:tasks_converted = map(copy(s:tasks), 's:convert_row(v:val)')
endfunction"}}}

function! s:sum_payoff(tasks) "{{{
  let sum = 0
  for row in copy(a:tasks)
    let sum += s:get_payoff(v:val.time_spent)
  endfor

  return sum
endfunction"}}}

function! s:get_time(time) " {{{
  return join(
        \ [a:time.hour(), a:time.minute(), a:time.second()],
        \ ':')
endfunction"}}}

function! s:get_hour(time) "{{{
  return a:time.hour() + (a:time.minute() / 60)
endfunction"}}}

function! s:get_date(date) " {{{
  return join(
        \ [a:date.year(), a:date.month(), a:date.day()],
        \ '/')
endfunction"}}}

function! s:get_payoff(time) "{{{
  let rate = g:snail#hourly_rete
  let time = s:get_hour(a:time)

  return rate * time
endfunction"}}}

function! s:parse_format(format) "{{{
  let format = a:format
  let s:format_memo = get(s:, 'format_memo', {})

  if !has_key(s:format_memo, format)
    let result = []
    let matched_len = 1
    let remain = format

    while matched_len
      let matched_len = len(matchstr(remain, '^\(%[^%]\+%\|[^%]\+\)'))

      if matched_len == 0 || empty(remain)
        break
      else
        call add(result, remain[: matched_len - 1])
      endif

      let remain = remain[matched_len :]
    endwhile

    let s:format_memo[format] = result
  endif

  return s:format_memo[format]
endfunction"}}}

function! s:reprase(target, format) "{{{
  let format_replaced = s:parse_format(a:format)
  let row = a:target

  let result = []
  for format in format_replaced
    sandbox let str = eval(s:definition_row[format])
    call add(result, str)
  endfor

  return join(result, '')
endfunction"}}}

function! s:convert_row(row) "{{{
  return s:reprase(a:row, g:snail#format#row)
endfunction"}}}
