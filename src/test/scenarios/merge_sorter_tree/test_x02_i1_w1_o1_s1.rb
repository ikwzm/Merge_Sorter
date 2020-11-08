require_relative './test_1.rb'

ways               = 2
i_words            = 1
o_words            = 1
sort_order         = 1
sign               = true
scenario_file_name = File.basename(__FILE__, ".rb") + ".snr"

File.open(scenario_file_name,'w') do |file|
  test_1(file, ways, i_words, o_words, sort_order, sign, 100)
end

