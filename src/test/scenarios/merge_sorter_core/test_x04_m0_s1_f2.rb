require_relative './test_1.rb'

mrg_ways           = 4
mrg_enable         = false
stm_enable         = true
stm_feedback       = 2
sort_order         = 0
scenario_file_name = sprintf("test_x%02d_m%d_s%d_f%d.snr", mrg_ways, (mrg_enable)? 1 : 0, (stm_enable)? 1 : 0, stm_feedback)

File.open(scenario_file_name,'w') do |file|
  test_1(file, mrg_ways, mrg_enable, stm_enable, stm_feedback, sort_order)
end

