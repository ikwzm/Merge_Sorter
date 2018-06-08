
module ScenarioWriter

  NONE_BIT = 0x01
  PRIO_BIT = 0x02
  POST_BIT = 0x04
  DONE_BIT = 0x08

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
          _user = NONE_BIT | POST_BIT
          _data = 0
        elsif data.kind_of?(Hash) then
          _user  = data.fetch(:User, 0)
          _user |= DONE_BIT if (data.fetch(:Done    , 0) == 1)
          _user |= POST_BIT if (data.fetch(:PostPend, 0) == 1)
          _user |= PRIO_BIT if (data.fetch(:Priority, 0) == 1)
          _user |= NONE_BIT if (data.fetch(:None    , 0) == 1)
          _data  = data.fetch(:Data, 0)
        else
          _user = 0
          _data = data
        end
        _user |= DONE_BIT if done == true
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
          _user = NONE_BIT | POST_BIT
          _data = 0
        elsif data.kind_of?(Hash) then
          _user  = data.fetch(:User, 0)
          _user |= DONE_BIT if (data.fetch(:Done    , 0) == 1)
          _user |= POST_BIT if (data.fetch(:PostPend, 0) == 1)
          _user |= PRIO_BIT if (data.fetch(:Priority, 0) == 1)
          _user |= NONE_BIT if (data.fetch(:None    , 0) == 1)
          _data  = data.fetch(:Data, 0)
        else
          _user = 0
          _data = data
        end
        _user |= DONE_BIT if done == true
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

