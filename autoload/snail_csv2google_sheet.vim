function! s:initialize() "{{{
  if exists('s:initialized')
    return 0
  endif
  let s:initialized = 1

  ruby << EOF
  plugin_root_path = VIM.evaluate('g:snail_csv2google_sheet_plugin_root_dir')
  lib_path = File.expand_path("#{plugin_root_path}/lib")
  require "#{lib_path}/snail_csv2google_sheet.rb"
EOF
endfunction "}}}

function! snail_csv2google_sheet#convert(path) "{{{
  call s:initialize()
  ruby << EOF
  sum = 0
  path = VIM.evaluate('a:path')
  snail = SnailTable.new(path)
  snail.tasks.select { |task| task.is_completed? }.each do |task|
    column = []
    column << task.start_date
    column << nil
    column << nil
    column << nil
    column << task.time_spent.to_work_time
    column << HOURLY_YEN
    column << (task.time_spent.to_work_time * HOURLY_YEN).to_i
    column << task.title
    sum += (task.time_spent.to_work_time * HOURLY_YEN).to_i
    puts column.join("\t")
  end

  puts "今日もお疲れさま・T・"
  puts "#{sum}円の稼ぎだぜい！"
EOF
endfunction "}}}
