require_relative '../scripts/scenario_writer.rb'

File.open('test_1.snr','w') do |file|

  i_num    = 4
  feedback = 2
  blk_size = i_num**(feedback+1)
  random   = Random.new
  merchal  = ScenarioWriter::Marchal.new("MARCHAL", file)
  intake   = ScenarioWriter::IntakeStream.new("S" , file)
  outlet   = ScenarioWriter::OutletStream.new("O" , file)

  merchal.sync
  merchal.init
  intake.init
  outlet.init
  merchal.say "Merge_Sorter_Core TEST 1 Start."

  (1..2*blk_size+8).each_with_index do |size, index|
    intake_data = (1..size).to_a.map{|x| random.rand(0..1024)}
    outlet_data = []
    temp_data   = intake_data.dup
    while(not temp_data.empty?) do
      outlet_data.concat(temp_data.shift(blk_size).sort{|a,b| b <=> a})
    end

    merchal.sync
    merchal.say "Merge_Sorter_Core TEST 1.#{index+1} SIZE=#{size} Start."
    intake.send_stream_request
    intake.transfer(intake_data, true)
    intake.wait_stream_response
    outlet.transfer(outlet_data, true)
  end

  merchal.sync
  merchal.say "Merge_Sorter_Core TEST 1 Done."
  merchal.sync
  
end
