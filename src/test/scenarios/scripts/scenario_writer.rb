
module ScenarioWriter

  class Writer
    def initialize(name, file)
      @name = name
      @file = file
    end

    def init
    end
      
    def my_name
      @file.puts "- #{@name}  : "
    end

    def say(message)
      my_name
      @file.puts "  - SAY     : #{message}"
    end

    def sync
      @file.puts "---"
    end

  end

  class Marchal      < Writer
  end
      
  class IntakeStream < Writer

    def init
      my_name
      @file.puts "  - OUT    : {GPO(0): 0, GPO(1): 0, GPO(2): 0, GPO(3): 0}"
    end

    def send_stream_request(timeout=nil)
      my_name
      if not timeout.nil? then
        _timeout = ", TIMEOUT: #{timeout}"
      end
      @file.puts "  - OUT    : {GPO(0): 1}"
      @file.puts "  - WAIT   : {GPI(0): 1#{_timeout}}"
      @file.puts "  - OUT    : {GPO(0): 0}"
    end

    def wait_stream_response(timeout=nil)
      my_name
      if not timeout.nil? then
        _timeout = ", TIMEOUT: #{timeout}"
      end
      @file.puts "  - OUT    : {GPO(1): 1}"
      @file.puts "  - WAIT   : {GPI(1): 1#{_timeout}}"
      @file.puts "  - OUT    : {GPO(1): 0}"
    end

    def transfer(vector,last=nil)
      my_name
      vector.each_with_index do |data, index|
        _last = (index == vector.length-1 and not last.nil?)? 1 : 0
        if data.nil? then
          @file.printf("  - XFER   : {DATA: 0x%08X, USER: 1, LAST: %d}\n", 0,    _last)
        else
          @file.printf("  - XFER   : {DATA: 0x%08X, USER: 0, LAST: %d}\n", data, _last)
        end 
      end
    end
  end

  class OutletStream < Writer
    def transfer(vector,last=nil)
      my_name
      vector.each_with_index do |data, index|
        _last = (index == vector.length-1 and not last.nil?)? 1 : 0
        if data.nil? then
          @file.printf("  - XFER   : {DATA: 32'h--------, USER: 1, LAST: %d}\n", _last)
        else
          @file.printf("  - XFER   : {DATA: 0x%08X, USER: 0, LAST: %d}\n", data, _last)
        end 
      end
    end
  end
    
end

