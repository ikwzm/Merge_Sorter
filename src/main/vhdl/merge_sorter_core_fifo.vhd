-----------------------------------------------------------------------------------
--!     @file    merge_sorter_core_fifo.vhd
--!     @brief   Merge Sorter Core Fifo Module :
--!     @version 0.0.4
--!     @date    2018/2/11
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
--
--      Copyright (C) 2018 Ichiro Kawazome
--      All rights reserved.
--
--      Redistribution and use in source and binary forms, with or without
--      modification, are permitted provided that the following conditions
--      are met:
--
--        1. Redistributions of source code must retain the above copyright
--           notice, this list of conditions and the following disclaimer.
--
--        2. Redistributions in binary form must reproduce the above copyright
--           notice, this list of conditions and the following disclaimer in
--           the documentation and/or other materials provided with the
--           distribution.
--
--      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
--      "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
--      LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
--      A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
--      OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
--      SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
--      LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
--      DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
--      THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
--      (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
--      OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  Merge_Sorter_Core_Fifo is
    generic (
        FBK_ENABLE      :  boolean := TRUE;
        MRG_ENABLE      :  boolean := TRUE;
        SIZE_BITS       :  integer :=    6;
        FIFO_SIZE       :  integer :=   64;
        DATA_BITS       :  integer :=   64;
        INFO_BITS       :  integer :=    8;
        INFO_NONE_POS   :  integer :=    0;
        INFO_DONE_POS   :  integer :=    1;
        INFO_FBK_POS    :  integer :=    2;
        INFO_I_NUM_LO   :  integer :=    3;
        INFO_I_NUM_HI   :  integer :=    7
    );
    port (
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
        FBK_REQ         :  in  std_logic := '0';
        FBK_ACK         :  out std_logic;
        FBK_DONE        :  out std_logic;
        FBK_OUT_START   :  in  std_logic := '0';
        FBK_OUT_SIZE    :  in  std_logic_vector(SIZE_BITS-1 downto 0);
        FBK_OUT_LAST    :  in  std_logic := '0';
        FBK_IN_DATA     :  in  std_logic_vector(DATA_BITS-1 downto 0);
        FBK_IN_NONE     :  in  std_logic := '0';
        FBK_IN_LAST     :  in  std_logic;
        FBK_IN_VALID    :  in  std_logic := '0';
        FBK_IN_READY    :  out std_logic;
        MRG_REQ         :  in  std_logic := '0';
        MRG_ACK         :  out std_logic;
        MRG_IN_DATA     :  in  std_logic_vector(DATA_BITS-1 downto 0);
        MRG_IN_NONE     :  in  std_logic := '0';
        MRG_IN_DONE     :  in  std_logic := '1';
        MRG_IN_LAST     :  in  std_logic;
        MRG_IN_VALID    :  in  std_logic := '0';
        MRG_IN_READY    :  out std_logic;
        OUTLET_DATA     :  out std_logic_vector(DATA_BITS-1 downto 0);
        OUTLET_INFO     :  out std_logic_vector(INFO_BITS-1 downto 0);
        OUTLET_LAST     :  out std_logic;
        OUTLET_VALID    :  out std_logic;
        OUTLET_READY    :  in  std_logic
    );
end Merge_Sorter_Core_Fifo;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
architecture RTL of Merge_Sorter_Core_Fifo is
    constant  WORD_BITS             :  integer := DATA_BITS+3;
    constant  WORD_DATA_LO          :  integer := 0;
    constant  WORD_DATA_HI          :  integer := DATA_BITS-1;
    constant  WORD_LAST_POS         :  integer := DATA_BITS;
    constant  WORD_NONE_POS         :  integer := DATA_BITS+1;
    constant  WORD_DONE_POS         :  integer := DATA_BITS+2;
    constant  DATA_NULL             :  std_logic_vector(DATA_BITS-1 downto 0) := (others => '0');
    signal    fifo_intake_valid     :  std_logic;
    signal    fifo_intake_ready     :  std_logic;
    signal    fifo_intake_enable    :  std_logic;
    signal    fifo_intake_word      :  std_logic_vector(WORD_BITS-1 downto 0);
    signal    fifo_outlet_valid     :  std_logic;
    signal    fifo_outlet_ready     :  std_logic;
    signal    fifo_outlet_word      :  std_logic_vector(WORD_BITS-1 downto 0);
    signal    fifo_outlet_enable    :  std_logic;
begin
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    NONE: if (FIFO_SIZE = 0) generate
        FBK_ACK      <= '0';
        FBK_DONE     <= '0';
        MRG_ACK      <= '0';
        OUTLET_DATA  <= (others => '0');
        OUTLET_INFO  <= (others => '0');
        OUTLET_LAST  <= '0';
        OUTLET_VALID <= '0';
    end generate;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    CTRL: if (FIFO_SIZE > 0) generate
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        constant  NUM_BITS          :  integer := INFO_I_NUM_HI-INFO_I_NUM_LO+1;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        type      STATE_TYPE        is (IDLE_STATE,
                                        FBK_RUN_STATE,
                                        FBK_ACK_STATE,
                                        MRG_RUN_STATE,
                                        MRG_ACK_STATE
                                       );
        signal    curr_state        :  STATE_TYPE;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        signal    fbk_intake_enable :  boolean;
        signal    fbk_intake_valid  :  std_logic;
        signal    fbk_intake_ready  :  std_logic;
        signal    fbk_intake_word   :  std_logic_vector(WORD_BITS-1 downto 0);
        signal    fbk_outlet_enable :  boolean;
        signal    fbk_outlet_done   :  std_logic;
        signal    fbk_outlet_next   :  std_logic;
        signal    fbk_outlet_last   :  std_logic;
        signal    fbk_outlet_num    :  std_logic_vector(NUM_BITS -1 downto 0);
        signal    fbk_state_done    :  boolean;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        signal    mrg_intake_enable :  boolean;
        signal    mrg_intake_valid  :  std_logic;
        signal    mrg_intake_ready  :  std_logic;
        signal    mrg_intake_word   :  std_logic_vector(WORD_BITS-1 downto 0);
        signal    mrg_outlet_enable :  boolean;
        signal    mrg_outlet_done   :  std_logic;
        signal    mrg_state_done    :  boolean;
    begin
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        FSM: process (CLK, RST) begin
            if (RST = '1') then
                    curr_state         <= IDLE_STATE;
                    fifo_outlet_enable <= '0';
            elsif (CLK'event and CLK = '1') then
                if (CLR = '1') then
                    curr_state         <= IDLE_STATE;
                    fifo_outlet_enable <= '0';
                else
                    case curr_state is
                        when IDLE_STATE =>
                            if    (FBK_ENABLE = TRUE and FBK_REQ = '1') then
                                if (FBK_OUT_START = '1' and unsigned(FBK_OUT_SIZE) = 0) then
                                    curr_state         <= FBK_ACK_STATE;
                                    fifo_outlet_enable <= '0';
                                else
                                    curr_state         <= FBK_RUN_STATE;
                                    fifo_outlet_enable <= '0';
                                end if;
                            elsif (MRG_ENABLE = TRUE and MRG_REQ = '1') then
                                curr_state         <= MRG_RUN_STATE;
                                fifo_outlet_enable <= '1';
                            else
                                curr_state         <= IDLE_STATE;
                                fifo_outlet_enable <= '0';
                            end if;
                        when FBK_RUN_STATE =>
                            if    (fbk_state_done = TRUE) or
                                  (FBK_OUT_START = '1' and unsigned(FBK_OUT_SIZE) = 0) then
                                curr_state         <= FBK_ACK_STATE;
                                fifo_outlet_enable <= '0';
                            elsif (FBK_OUT_START = '1') then
                                curr_state         <= FBK_RUN_STATE;
                                fifo_outlet_enable <= '1';
                            else
                                curr_state         <= FBK_RUN_STATE;
                                fifo_outlet_enable <= fifo_outlet_enable;
                            end if;
                        when FBK_ACK_STATE =>
                            if (FBK_REQ = '0') then
                                curr_state         <= IDLE_STATE;
                                fifo_outlet_enable <= '0';
                            else
                                curr_state         <= FBK_ACK_STATE;
                                fifo_outlet_enable <= '0';
                            end if;
                        when MRG_RUN_STATE =>
                            if (mrg_state_done = TRUE) then
                                curr_state         <= MRG_ACK_STATE;
                                fifo_outlet_enable <= '0';
                            else
                                curr_state         <= MRG_RUN_STATE;
                                fifo_outlet_enable <= '1';
                            end if;
                        when MRG_ACK_STATE =>
                            if (MRG_REQ = '0') then
                                curr_state         <= IDLE_STATE;
                                fifo_outlet_enable <= '0';
                            else
                                curr_state         <= MRG_ACK_STATE;
                                fifo_outlet_enable <= '0';
                            end if;
                        when others =>
                                curr_state         <= IDLE_STATE;
                                fifo_outlet_enable <= '0';
                    end case;
                end if;
            end if;
        end process;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        fifo_intake_word   <= fbk_intake_word  or mrg_intake_word;
        fifo_intake_valid  <= fbk_intake_valid or mrg_intake_valid;
        fifo_intake_enable <= '1' when (fbk_intake_enable or mrg_intake_enable) else '0';
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        FBK_CTRL: if (FBK_ENABLE = TRUE) generate
            signal    intake_enable  :  boolean;
            signal    outlet_counter :  std_logic_vector(SIZE_BITS-1 downto 0);
            signal    outlet_next    :  boolean;
            signal    outlet_last    :  boolean;
            signal    outlet_done    :  std_logic;
            signal    outlet_size    :  std_logic_vector(SIZE_BITS-1 downto 0);
        begin 
            -----------------------------------------------------------------------
            --
            -----------------------------------------------------------------------
            process (CLK, RST) begin
                if (RST = '1') then
                        outlet_size <= (others => '0');
                        outlet_done <= '0';
                elsif (CLK'event and CLK = '1') then
                    if (CLR = '1') then
                        outlet_size <= (others => '0');
                        outlet_done <= '0';
                    elsif (FBK_OUT_START = '1') then
                        outlet_size <= std_logic_vector(unsigned(FBK_OUT_SIZE) - 1);
                        outlet_done <= FBK_OUT_LAST;
                    end if;
                end if;
            end process;
            -----------------------------------------------------------------------
            --
            -----------------------------------------------------------------------
            process (CLK, RST)
                variable next_counter :  unsigned(SIZE_BITS downto 0);
            begin
                if (RST = '1') then
                        outlet_counter <= (others => '0');
                        outlet_next    <= FALSE;
                        outlet_last    <= FALSE;
                elsif (CLK'event and CLK = '1') then
                    if (CLR = '1') then
                        outlet_counter <= (others => '0');
                        outlet_next    <= FALSE;
                        outlet_last    <= FALSE;
                    elsif (curr_state = FBK_RUN_STATE) then
                        next_counter := "0" & unsigned(outlet_counter);
                        if (fifo_outlet_enable = '1') and
                           (fifo_outlet_valid  = '1') and
                           (fifo_outlet_ready  = '1') and
                           (fifo_outlet_word(WORD_LAST_POS) = '1') then
                            next_counter := next_counter + 1;
                        end if;
                        outlet_counter <= std_logic_vector(next_counter(outlet_counter'range));
                        outlet_next    <= (next_counter  < unsigned(outlet_size));
                        outlet_last    <= (next_counter >= unsigned(outlet_size));
                    else
                        outlet_counter <= (others => '0');
                        outlet_next    <= FALSE;
                        outlet_last    <= FALSE;
                    end if;
                end if;
            end process;
            -----------------------------------------------------------------------
            --
            -----------------------------------------------------------------------
            fbk_outlet_enable <= (curr_state = FBK_RUN_STATE and fifo_outlet_enable = '1');
            fbk_state_done    <= ((fbk_outlet_enable = TRUE) and
                                  (fbk_outlet_last   = '1' ) and
                                  (fifo_outlet_valid = '1' ) and
                                  (fifo_outlet_ready = '1' ) and
                                  (fifo_outlet_word(WORD_LAST_POS) = '1'));
            fbk_outlet_next   <= '1' when (outlet_next and fbk_outlet_enable) else '0';
            fbk_outlet_last   <= '1' when (outlet_last and fbk_outlet_enable) else '0';
            fbk_outlet_done   <= '1' when (fbk_outlet_last = '1' and outlet_done = '1') else '0';
            fbk_outlet_num    <= outlet_counter(NUM_BITS-1 downto 0) when (fbk_outlet_enable) else (others => '0');
            FBK_ACK           <= '1' when (curr_state = FBK_ACK_STATE) else '0';
            FBK_DONE          <= '1' when (curr_state = FBK_ACK_STATE and outlet_done = '1') else '0';
            -----------------------------------------------------------------------
            --
            -----------------------------------------------------------------------
            fbk_intake_enable <= (curr_state = FBK_RUN_STATE);
            fbk_intake_valid                                  <= FBK_IN_VALID      when (fbk_intake_enable) else '0';
            fbk_intake_word(WORD_DATA_HI downto WORD_DATA_LO) <= FBK_IN_DATA       when (fbk_intake_enable) else DATA_NULL;
            fbk_intake_word(WORD_LAST_POS)                    <= FBK_IN_LAST       when (fbk_intake_enable) else '0';
            fbk_intake_word(WORD_NONE_POS)                    <= FBK_IN_NONE       when (fbk_intake_enable) else '0';
            fbk_intake_word(WORD_DONE_POS)                    <= '0';
            fbk_intake_ready                                  <= fifo_intake_ready when (fbk_intake_enable) else '0';
            FBK_IN_READY                                      <= fifo_intake_ready when (fbk_intake_enable) else '0';
        end generate;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        FBK_NONE: if (FBK_ENABLE = FALSE) generate
            fbk_state_done    <= TRUE;
            fbk_outlet_enable <= FALSE;
            fbk_outlet_done   <= '0';
            fbk_outlet_next   <= '0';
            fbk_outlet_num    <= (others => '0');
            fbk_intake_enable <= FALSE;
            fbk_intake_valid  <= '0';
            fbk_intake_word   <= (others => '0');
            fbk_intake_ready  <= '0';
            FBK_IN_READY      <= '0';
            FBK_ACK           <= '0';
            FBK_DONE          <= '0';
        end generate;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        MRG_CTRL: if (MRG_ENABLE = TRUE) generate
            signal    fifo_flush    :  boolean;
        begin
            -----------------------------------------------------------------------
            --
            -----------------------------------------------------------------------
            process (CLK, RST) begin
                if (RST = '1') then
                        fifo_flush <= FALSE;
                elsif (CLK'event and CLK = '1') then
                    if (CLR = '1') then
                        fifo_flush <= FALSE;
                    elsif (curr_state = MRG_RUN_STATE) then
                        if (mrg_state_done = TRUE) then
                            fifo_flush <= FALSE;
                        elsif (mrg_intake_valid  = '1' and mrg_intake_ready = '1') and
                              (MRG_IN_LAST       = '1' and MRG_IN_DONE      = '1') then
                            fifo_flush <= TRUE;
                        end if;
                    else
                        fifo_flush <= FALSE;
                    end if;
                end if;
            end process;
            -----------------------------------------------------------------------
            --
            -----------------------------------------------------------------------
            mrg_outlet_enable <= (curr_state = MRG_RUN_STATE and fifo_outlet_enable = '1');
            mrg_outlet_done   <= fifo_outlet_word(WORD_DONE_POS) when (mrg_outlet_enable) else '0';
            -----------------------------------------------------------------------
            --
            -----------------------------------------------------------------------
            mrg_state_done    <= ((curr_state = MRG_RUN_STATE and fifo_flush = TRUE) and
                                  (fifo_outlet_enable = '1') and
                                  (fifo_outlet_valid  = '1') and
                                  (fifo_outlet_ready  = '1') and
                                  (fifo_outlet_word(WORD_LAST_POS) = '1') and
                                  (fifo_outlet_word(WORD_DONE_POS) = '1'));
            MRG_ACK           <= '1' when (curr_state = MRG_ACK_STATE) else '0';
            -----------------------------------------------------------------------
            --
            -----------------------------------------------------------------------
            mrg_intake_enable <= (curr_state = MRG_RUN_STATE and fifo_flush = FALSE);
            mrg_intake_valid                                  <= MRG_IN_VALID      when (mrg_intake_enable) else '0';
            mrg_intake_word(WORD_DATA_HI downto WORD_DATA_LO) <= MRG_IN_DATA       when (mrg_intake_enable) else DATA_NULL;
            mrg_intake_word(WORD_LAST_POS)                    <= MRG_IN_LAST       when (mrg_intake_enable) else '0';
            mrg_intake_word(WORD_NONE_POS)                    <= MRG_IN_NONE       when (mrg_intake_enable) else '0';
            mrg_intake_word(WORD_DONE_POS)                    <= MRG_IN_DONE       when (mrg_intake_enable) else '0';
            mrg_intake_ready                                  <= fifo_intake_ready when (mrg_intake_enable) else '0';
            MRG_IN_READY                                      <= fifo_intake_ready when (mrg_intake_enable) else '0';
        end generate;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        MRG_NONE: if (MRG_ENABLE = FALSE) generate
            mrg_state_done    <= TRUE;
            mrg_outlet_enable <= FALSE;
            mrg_outlet_done   <= '0';
            mrg_intake_enable <= FALSE;
            mrg_intake_valid  <= '0';
            mrg_intake_word   <= (others => '0');
            mrg_intake_ready  <= '0';
            MRG_IN_READY      <= '0';
            MRG_ACK           <= '0';
        end generate;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        OUTLET_INFO(INFO_DONE_POS)                      <= fbk_outlet_done or mrg_outlet_done;
        OUTLET_INFO(INFO_FBK_POS )                      <= fbk_outlet_next;
        OUTLET_INFO(INFO_I_NUM_HI downto INFO_I_NUM_LO) <= fbk_outlet_num;
        OUTLET_INFO(INFO_NONE_POS)                      <= fifo_outlet_word(WORD_NONE_POS) when (fifo_outlet_enable = '1') else '0';
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        OUTLET_DATA  <= fifo_outlet_word(WORD_DATA_HI downto WORD_DATA_LO) when (fifo_outlet_enable = '1') else (others => '0');
        OUTLET_LAST  <= fifo_outlet_word(WORD_LAST_POS)                    when (fifo_outlet_enable = '1') else '0';
        OUTLET_VALID <= fifo_outlet_valid                                  when (fifo_outlet_enable = '1') else '0';
        fifo_outlet_ready <= OUTLET_READY;
    end generate;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    FIFO: if (FIFO_SIZE > 0) generate
        function  NUM_TO_BITS(NUM:integer) return integer is
            variable value : integer;
        begin
            value := 0;
            while (2**value <= NUM) loop
                value := value + 1;
            end loop;
            return value;
        end function;
        constant  COUNT_BITS        :  integer := NUM_TO_BITS(FIFO_SIZE  );
        constant  PTR_BITS          :  integer := NUM_TO_BITS(FIFO_SIZE-1);
        type      MEM_TYPE          is array (integer range <>) of std_logic_vector(WORD_BITS-1 downto 0);
        signal    mem               :  MEM_TYPE(FIFO_SIZE -1 downto 0);
        signal    curr_counter      :  unsigned(COUNT_BITS-1 downto 0);
        signal    wr_ptr            :  unsigned(PTR_BITS  -1 downto 0);
        signal    rd_ptr            :  unsigned(PTR_BITS  -1 downto 0);
        signal    wr_addr           :  unsigned(PTR_BITS  -1 downto 0);
        signal    rd_addr           :  unsigned(PTR_BITS  -1 downto 0);
        signal    wr_ena            :  std_logic;
        signal    rd_ena            :  std_logic;
    begin
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        wr_ena  <= '1' when (fifo_intake_enable = '1' and fifo_intake_valid = '1' and fifo_intake_ready = '1') else '0';
        rd_ena  <= '1' when (fifo_outlet_enable = '1' and fifo_outlet_valid = '1' and fifo_outlet_ready = '1') else '0';
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (CLK, RST)
            variable next_counter : unsigned(COUNT_BITS downto 0);
        begin
            if (RST = '1') then
                    curr_counter      <= (others => '0');
                    fifo_intake_ready <= '0';
                    fifo_outlet_valid <= '0';
            elsif (CLK'event and CLK = '1') then
                if (CLR = '1') then
                    curr_counter      <= (others => '0');
                    fifo_intake_ready <= '0';
                    fifo_outlet_valid <= '0';
                else
                    next_counter := "0" & curr_counter;
                    if (wr_ena = '1') then
                        next_counter := next_counter + 1;
                    end if;
                    if (rd_ena = '1') then
                        next_counter := next_counter - 1;
                    end if;
                    if (next_counter < FIFO_SIZE) then
                        fifo_intake_ready <= '1';
                    else
                        fifo_intake_ready <= '0';
                    end if;
                    if (next_counter > 0) then
                        fifo_outlet_valid <= '1';
                    else
                        fifo_outlet_valid <= '0';
                    end if;
                    curr_counter <= next_counter(curr_counter'range);
                end if;
            end if;
        end process;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (CLK, RST) begin
            if (RST = '1') then
                    wr_ptr <= (others => '0');
            elsif (CLK'event and CLK = '1') then
                if (CLR = '1') then
                    wr_ptr <= (others => '0');
                elsif (wr_ena = '1') then
                    wr_ptr <= wr_ptr + 1;
                end if;
            end if;
        end process;
        wr_addr <= wr_ptr;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (CLK, RST) begin
            if (RST = '1') then
                    rd_ptr <= (others => '0');
            elsif (CLK'event and CLK = '1') then
                if (CLR = '1') then
                    rd_ptr <= (others => '0');
                else
                    rd_ptr <= rd_addr;
                end if;
            end if;
        end process;
        rd_addr <= rd_ptr + 1 when (rd_ena = '1') else rd_ptr;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (CLK) begin
            if (CLK'event and CLK = '1') then
                if (wr_ena = '1') then
                    mem(to_integer(to_01(wr_addr))) <= fifo_intake_word;
                end if;
            end if;
        end process;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (CLK) begin
            if (CLK'event and CLK = '1') then
                fifo_outlet_word <= mem(to_integer(to_01(rd_addr)));
            end if;
        end process;
    end generate;
end RTL;
