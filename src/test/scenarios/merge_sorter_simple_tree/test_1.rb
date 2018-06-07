require_relative '../scripts/scenario_writer.rb'

def test_1(file, i_num, sort_order, count)

  def sort_proc(a,b, sort_order)
    if    a.nil? and b.nil? then
      -1
    elsif a.nil? then
      1
    elsif b.nil? then
      -1
    elsif (sort_order == 0) then
      b <=> a
    else
      a <=> b
    end
  end

  title    = sprintf("Merge_Sorter_Tree(I_NUM=%d,SORT_ORDER=%d) TEST 1", i_num, sort_order)
  random   = Random.new
  merchal  = ScenarioWriter::Marchal.new("MARCHAL", file)
  intake   = (0..i_num-1).to_a.map{ |i|
               name = sprintf("I%02X", i)
               ScenarioWriter::IntakeStream.new(name, file)
             }
  outlet   = ScenarioWriter::OutletStream.new("O" , file)

  merchal.sync
  merchal.init
  merchal.say "#{title} Start."

  count.times do |test_num|
    merchal.sync
    merchal.say "#{title}.#{test_num+1} Start."
    random.rand(1..4).times do
    
      intake_data = intake.map{ |channel|
        size = random.rand(0..4)
        (size == 0)? [nil] : Array.new(size){|x| random.rand(0..1024)}.sort{|a,b| (sort_order == 0)? b <=> a : a <=> b}
      }
      outlet_data = intake_data.flatten.sort{|a,b| sort_proc(a,b,sort_order)}

      intake.each_with_index do |channel, index|
        channel.transfer(intake_data[index], true)
      end 
      outlet.transfer(outlet_data, true)
    end
  end

  merchal.sync
  merchal.say "#{title} Done."
  merchal.sync
  
end
