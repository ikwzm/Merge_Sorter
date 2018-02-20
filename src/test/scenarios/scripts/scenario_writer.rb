
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

    def transfer(vector, last=false, done=false)
      my_name
      vector.each_with_index do |data, index|
        _last = (index == vector.length-1 and last == true)? 1 : 0
        if data.nil? then
          _user = 1
          _data = 0
        else
          _user = 0
          _data = data
        end
        _user |= 0x02 if done == true
        @file.printf("  - XFER   : {DATA: 0x%08X, USER: %d, LAST: %d}\n", _data, _user, _last)
      end
    end
  end

  class OutletStream < Writer

    def init
      my_name
      @file.puts "  - OUT    : {GPO(0): 0, GPO(1): 0}"
    end

    def transfer(vector, last=false, done=false)
      my_name
      vector.each_with_index do |data, index|
        _last = (index == vector.length-1 and last == true)? 1 : 0
        if data.nil? then
          _user = 1
          _data = 0
        else
          _user = 0
          _data = data
        end
        _user |= 0x02 if done == true
        @file.printf("  - XFER   : {DATA: 0x%08X, USER: %d, LAST: %d}\n", _data, _user, _last)
      end
    end

    def send_request(timeout=nil)
      my_name
      if not timeout.nil? then
        _timeout = ", TIMEOUT: #{timeout}"
      end
      @file.puts "  - OUT    : {GPO(0): 1}"
      @file.puts "  - WAIT   : {GPI(0): 1#{_timeout}}"
      @file.puts "  - OUT    : {GPO(0): 0}"
    end

    def wait_response(timeout=nil)
      my_name
      if not timeout.nil? then
        _timeout = ", TIMEOUT: #{timeout}"
      end
      @file.puts "  - OUT    : {GPO(1): 1}"
      @file.puts "  - WAIT   : {GPI(1): 1#{_timeout}}"
      @file.puts "  - OUT    : {GPO(1): 0}"
    end

  end
    
end

