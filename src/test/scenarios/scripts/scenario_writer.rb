
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
        _data += 2**32    if _data < 0
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
        _data += 2**32    if _data < 0
        @file.printf("  - XFER   : {DATA: 0x%08X, USER: %d, LAST: %d}\n", _data, _user, _last)
      end
    end

    def send_stm_request(timeout=nil)
      my_name
      if not timeout.nil? then
        _timeout = ", TIMEOUT: #{timeout}"
      end
      @file.puts "  - OUT    : {GPO(0): 1}"
      @file.puts "  - WAIT   : {GPI(0): 1#{_timeout}}"
      @file.puts "  - OUT    : {GPO(0): 0}"
    end

    def wait_stm_response(timeout=nil)
      my_name
      if not timeout.nil? then
        _timeout = ", TIMEOUT: #{timeout}"
      end
      @file.puts "  - OUT    : {GPO(1): 1}"
      @file.puts "  - WAIT   : {GPI(1): 1#{_timeout}}"
      @file.puts "  - OUT    : {GPO(1): 0}"
    end

    def send_mrg_request(timeout=nil)
      my_name
      if not timeout.nil? then
        _timeout = ", TIMEOUT: #{timeout}"
      end
      @file.puts "  - OUT    : {GPO(2): 1}"
      @file.puts "  - WAIT   : {GPI(2): 1#{_timeout}}"
      @file.puts "  - OUT    : {GPO(2): 0}"
    end

    def wait_mrg_response(timeout=nil)
      my_name
      if not timeout.nil? then
        _timeout = ", TIMEOUT: #{timeout}"
      end
      @file.puts "  - OUT    : {GPO(3): 1}"
      @file.puts "  - WAIT   : {GPI(3): 1#{_timeout}}"
      @file.puts "  - OUT    : {GPO(3): 0}"
    end

  end
    
  class AXI_Memory < Writer
    
    attr_reader   :name, :size, :addr_start, :addr_last, :read, :write
    def initialize(name, file, size, addr_start, read, write)
      super(name,file)
      @size       = size
      @addr_start = addr_start
      @addr_last  = addr_start + size - 1
      @read       = read
      @write      = write
      @timeout    = 100000
      @latency    = 1
      @read_delay = 12
    end

    def init
      my_name
      index = 0
      @file.puts   "  - {DOMAIN: {INDEX: #{index}, MAP: 0, READ: true, WRITE: true,"
      @file.printf "              ADDR: 0x%08X, LAST: 0x%08X, RESP: DECERR,\n", 0, 0xFFFFFFFF
      @file.puts   "              ASIZE: \"3'b---\", ALOCK: \"1'b-\"   , ACACHE:  \"4'b----\","
      @file.puts   "              APROT: \"3'b---\", AQOS:  \"4'b----\", AREGION: \"4'b----\","
      @file.puts   "              LATENCY: 8, TIMEOUT: 10000}}"
      index = index + 1
      if @read == true then
        @file.puts   "  - {DOMAIN: {INDEX: #{index}, MAP: 0, READ: true, WRITE: false,"
        @file.printf "              ADDR: 0x%08X, LAST: 0x%08X, RESP: OKAY,  \n", @addr_start, @addr_last
        @file.puts   "              ASIZE: \"3'b---\", ALOCK: \"1'b-\"   , ACACHE:  \"4'b----\","
        @file.puts   "              APROT: \"3'b---\", AQOS:  \"4'b----\", AREGION: \"4'b----\","
        @file.puts   "              LATENCY: #{@latency}, RDELAY: #{@read_delay}, TIMEOUT: #{@timeout}}}"
        index = index + 1
      end
      if @write == true then
        @file.puts   "  - {DOMAIN: {INDEX: #{index}, MAP: 0, READ: false, WRITE: true,"
        @file.printf "              ADDR: 0x%08X, LAST: 0x%08X, RESP: OKAY,  \n", @addr_start, @addr_last
        @file.puts   "              ASIZE: \"3'b---\", ALOCK: \"1'b-\"   , ACACHE:  \"4'b----\","
        @file.puts   "              APROT: \"3'b---\", AQOS:  \"4'b----\", AREGION: \"4'b----\","
        @file.puts   "              LATENCY: #{@latency}, RDELAY: #{@read_delay}, TIMEOUT: #{@timeout}}}"
        index = index + 1
      end
    end

    def clear(size=nil, org=0, data=0)
      if size.nil? then
        size = @last_addr - @start_addr + 1
      end
      my_name
      @file.puts "  - FILL  : #{size}"
      @file.puts "  - ORG   : #{org}"
      @file.puts "  - DB    : #{data}"
    end

    def run(timeout=100000)
      my_name
      @file.puts "  - WAIT  : {GPI(0): 1, TIMEOUT: #{timeout}}"
      @file.puts "  - START"
      @file.puts "  - WAIT  : {GPI(0): 0, TIMEOUT: #{timeout}}"
      @file.puts "  - STOP"
    end

    def word_data(data)
      remain_words = data.dup
      while remain_words.empty? == false do
        words = remain_words.shift(4).map{|word| sprintf("0x%08X", word & 0xFFFFFFFF)}
        @file.puts "  - DW    : [" + words.join(", ") + "]"
      end
    end

    def set_word_data(data, org=0)
      data_bytes = data.length*4
      warn "#{self.class}(#{@name}) data overflow (memory size = #{@size}, data size = #{data_bytes})" if (data_bytes > @size)
      my_name
      @file.puts   "  - SET"
      @file.printf "  - ORG   : 0x%04X\n", org
      word_data(data)
    end

    def check_word_data(data, org=0)
      data_end = data.length*4 + org
      warn "#{self.class}(#{@name}) data overflow (memory size = #{@size}, end of data = #{data_end})" if (data_end > @size)
      my_name
      @file.puts   "  - CHECK"
      @file.printf "  - ORG   : 0x%04X\n", org
      word_data(data)
    end
  end
end

