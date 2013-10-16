function! s:initialize() "{{{
  if exists('s:initialized')
    return 0
  endif
  let s:initialized = 1

  ruby << EOF
  plugin_root_path = VIM.evaluate('g:snail_csv2google_sheet_plugin_root_dir')
  $: << File.expand_path("#{plugin_root_path}/lib")
  require 'snail_csv2google_sheet.rb'
EOF
endfunction "}}}

function! snail_csv2google_sheet#convert(path) "{{{
  call s:initialize()
  ruby << EOF
  sum = 0
  path = VIM.evaluate('a:path')
  snail = SnailTable.new(path)
  yen_per_hour = VIM.get('g:snail_csv2google_sheet_hourly_rete')
  result = ''
  snail.tasks.select { |task| task.is_completed? }.each do |task|
    column = []
    column << task.start_date
    column << nil
    column << nil
    column << nil
    column << task.time_spent.to_work_time
    column << yen_per_hour
    column << (task.time_spent.to_work_time * yen_per_hour).to_i
    column << task.title
    puts column.join("\t")
    sum += (task.time_spent.to_work_time * yen_per_hour).to_i
    result += column.join("\t") + "\n"
  end

  puts "今日もお疲れさま・T・"
  puts "#{sum}円の稼ぎだぜい！"
  VIM.command("let @* = '#{result}'")
EOF
endfunction "}}}
