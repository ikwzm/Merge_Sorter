require_relative './test_1.rb'

i_num              = 4
sort_order         = 0
sign               = true
scenario_file_name = sprintf("test_x%02d_o%d_s1.snr", i_num, sort_order)

File.open(scenario_file_name,'w') do |file|
  test_1(file, i_num, sort_order, sign, 100)
end

