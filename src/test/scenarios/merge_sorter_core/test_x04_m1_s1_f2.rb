require_relative './test_1.rb'
require_relative './test_2.rb'

i_num              = 4
mrg_enable         = true
stm_enable         = true
stm_feedback       = 2
sort_order         = 0
scenario_file_name = sprintf("test_x%02d_m%d_s%d_f%d.snr", i_num, (mrg_enable)? 1 : 0, (stm_enable)? 1 : 0, stm_feedback)

File.open(scenario_file_name,'w') do |file|
  test_1(file, i_num, mrg_enable, stm_enable, stm_feedback)
  test_2(file, i_num, mrg_enable, stm_enable, stm_feedback)
end

