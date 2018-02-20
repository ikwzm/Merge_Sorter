require_relative '../scripts/scenario_writer.rb'

def test_1(file, i_num, mrg_enable, stm_enable, stm_feedback)

  title    = sprintf("Merge_Sorter_Corte(I_NUM=%d,MRG_ENABLE=%s,STM_ENABLE=%s,STM_FEEDBACK=%d) TEST 1", i_num, mrg_enable.to_s, stm_enable.to_s, stm_feedback)
  random   = Random.new
  merchal  = ScenarioWriter::Marchal.new("MARCHAL", file)
  intake   = ScenarioWriter::IntakeStream.new("STM_I", file)
  outlet   = ScenarioWriter::OutletStream.new("STM_O", file)
  other    = ScenarioWriter::OutletStream.new("MRG_O", file)
  blk_size = i_num**(stm_feedback+1)
  
  merchal.sync
  merchal.init
  intake.init
  outlet.init
  other.init
  merchal.say "#{title} Start."

  if stm_enable == true then
    (1..2*blk_size+8).each_with_index do |size, index|
      intake_data = (1..size).to_a.map{|x| random.rand(0..1024)}
      outlet_data = []
      temp_data   = intake_data.dup
      while(not temp_data.empty?) do
        outlet_data.concat(temp_data.shift(blk_size).sort{|a,b| b <=> a})
      end
  
      merchal.sync
      merchal.say "#{title}.#{index+1} SIZE=#{size} Start."
      outlet.send_request
      intake.transfer(intake_data, true)
      outlet.transfer(outlet_data, true)
      outlet.wait_response
    end
  end 

  merchal.sync
  merchal.say "#{title} Done."
  merchal.sync
  
end
