-----------------------------------------------------------------------------------
--!     @file    merge_sorter_core_stream_intake.vhd
--!     @brief   Merge Sorter Core Stream Intake Module :
--!     @version 0.0.5
--!     @date    2018/2/14
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
entity  Merge_Sorter_Core_Stream_Intake is
    generic (
        O_NUM           :  integer :=  8;
        I_NUM           :  integer :=  1;
        FEEDBACK        :  integer :=  1;
        O_NUM_BITS      :  integer :=  3;
        SIZE_BITS       :  integer :=  6;
        DATA_BITS       :  integer := 64;
        INFO_BITS       :  integer :=  8;
        INFO_NONE_POS   :  integer :=  0;
        INFO_DONE_POS   :  integer :=  1;
        INFO_FBK_POS    :  integer :=  2;
        INFO_FBK_NUM_LO :  integer :=  3;
        INFO_FBK_NUM_HI :  integer :=  7
    );
    port (
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
        START           :  in  std_logic;
        BUSY            :  out std_logic;
        DONE            :  out std_logic;
        FBK_OUT_START   :  out std_logic;
        FBK_OUT_SIZE    :  out std_logic_vector(      SIZE_BITS-1 downto 0);
        FBK_OUT_LAST    :  out std_logic;
        I_DATA          :  in  std_logic_vector(I_NUM*DATA_BITS-1 downto 0);
        I_STRB          :  in  std_logic_vector(I_NUM          -1 downto 0);
        I_LAST          :  in  std_logic;
        I_VALID         :  in  std_logic;
        I_READY         :  out std_logic;
        O_DATA          :  out std_logic_vector(O_NUM*DATA_BITS-1 downto 0);
        O_INFO          :  out std_logic_vector(O_NUM*INFO_BITS-1 downto 0);
        O_LAST          :  out std_logic_vector(O_NUM          -1 downto 0);
        O_VALID         :  out std_logic_vector(O_NUM          -1 downto 0);
        O_READY         :  in  std_logic_vector(O_NUM          -1 downto 0)
    );
end Merge_Sorter_Core_Stream_Intake;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library PipeWork;
use     PipeWork.Components.REDUCER;
architecture RTL of Merge_Sorter_Core_Stream_Intake is
    signal    queue_valid       :  std_logic_vector(O_NUM          -1 downto 0);
    signal    intake_data       :  std_logic_vector(O_NUM*DATA_BITS-1 downto 0);
    signal    intake_last       :  std_logic;
    signal    intake_valid      :  std_logic;
    signal    intake_ready      :  std_logic;
    signal    intake_number     :  std_logic_vector(O_NUM_BITS     -1 downto 0);
    signal    intake_done       :  boolean;
    signal    outlet_valid      :  std_logic;
    signal    state_done        :  boolean;
    type      STATE_TYPE        is (IDLE_STATE, INTAKE_STATE, FLUSH_STATE);
    signal    curr_state        :  STATE_TYPE;
    signal    next_state        :  STATE_TYPE;
    signal    intake_first      :  std_logic;
begin
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    process (curr_state, START, state_done, intake_done, intake_first) begin
        case curr_state is
            when IDLE_STATE   =>
                if (START = '1') then
                    next_state <= INTAKE_STATE;
                else
                    next_state <= IDLE_STATE;
                end if;
                DONE          <= '0';
                BUSY          <= '0';
                FBK_OUT_START <= '0';
            when INTAKE_STATE =>
                if    (state_done  = TRUE) then
                    next_state <= IDLE_STATE;
                    DONE          <= '1';
                    FBK_OUT_START <= '1';
                elsif (intake_done = TRUE) then
                    next_state    <= FLUSH_STATE;
                    DONE          <= '0';
                    FBK_OUT_START <= '0';
                else
                    next_state    <= INTAKE_STATE;
                    DONE          <= '0';
                    FBK_OUT_START <= '0';
                end if;
                BUSY <= '1';
            when FLUSH_STATE  =>
                if (state_done = TRUE) then
                    next_state    <= IDLE_STATE;
                    DONE          <= '1';
                    FBK_OUT_START <= '1';
                else
                    next_state <= FLUSH_STATE;
                    DONE          <= '0';
                    FBK_OUT_START <= '0';
                end if;
            when others       =>
                    next_state <= IDLE_STATE;
                    DONE          <= '0';
                    BUSY          <= '0';
                    FBK_OUT_START <= '0';
        end case;
    end process;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    process (CLK, RST) begin
        if (RST = '1') then
                curr_state <= IDLE_STATE;
        elsif (CLK'event and CLK = '1') then
            if (CLR = '1') then
                curr_state <= IDLE_STATE;
            else
                curr_state <= next_state;
            end if;
        end if;
    end process;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    QUEUE: REDUCER                                   -- 
        generic map (                                -- 
            WORD_BITS       => DATA_BITS           , --
            STRB_BITS       => 1                   , -- 
            I_WIDTH         => I_NUM               , -- 
            O_WIDTH         => O_NUM               , -- 
            QUEUE_SIZE      => 0                   , --
            VALID_MIN       => queue_valid'low     , -- 
            VALID_MAX       => queue_valid'high    , -- 
            O_VAL_SIZE      => O_NUM               , -- 
            O_SHIFT_MIN     => O_NUM               , -- 
            O_SHIFT_MAX     => O_NUM               , -- 
            I_JUSTIFIED     => 1                   , -- 
            FLUSH_ENABLE    => 0                     -- 
        )                                            -- 
        port map (                                   -- 
            CLK             => CLK                 , -- In  :
            RST             => RST                 , -- In  :
            CLR             => CLR                 , -- In  :
            VALID           => queue_valid         , -- Out :
            I_DATA          => I_DATA              , -- In  :
            I_STRB          => I_STRB              , -- In  :
            I_DONE          => I_LAST              , -- In  :
            I_VAL           => I_VALID             , -- In  :
            I_RDY           => I_READY             , -- Out :
            O_DATA          => intake_data         , -- Out :
            O_DONE          => intake_last         , -- Out :
            O_VAL           => intake_valid        , -- Out :
            O_RDY           => intake_ready          -- In  :
        );                                           -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    O_DATA <= intake_data when (curr_state = INTAKE_STATE) else (others => '0');
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    process (curr_state, intake_number, queue_valid, intake_first, intake_last) begin
        if (curr_state = INTAKE_STATE) then
            for i in 0 to O_NUM-1 loop
                if (queue_valid(i) = '0') then
                    O_INFO(i*INFO_BITS+INFO_NONE_POS) <= '1';
                else
                    O_INFO(i*INFO_BITS+INFO_NONE_POS) <= '0';
                end if;
                if  (FEEDBACK     =  0  and intake_last = '1') or
                    (intake_first = '1' and intake_last = '1') then
                    O_INFO(i*INFO_BITS+INFO_DONE_POS) <= '1';
                else
                    O_INFO(i*INFO_BITS+INFO_DONE_POS) <= '0';
                end if;
                if  (FEEDBACK     =  0                       ) or
                    (intake_first = '1' and intake_last = '1') then
                    O_INFO(i*INFO_BITS+INFO_FBK_POS)  <= '0';
                else
                    O_INFO(i*INFO_BITS+INFO_FBK_POS)  <= '1';
                end if;
                O_INFO(i*INFO_BITS+INFO_FBK_NUM_HI downto i*INFO_BITS+INFO_FBK_NUM_LO) <= intake_number;
            end loop;
        elsif (FEEDBACK > 0 and curr_state = FLUSH_STATE) then
            for i in 0 to O_NUM-1 loop
                O_INFO(i*INFO_BITS+INFO_DONE_POS) <= '0';
                O_INFO(i*INFO_BITS+INFO_NONE_POS) <= '1';
                O_INFO(i*INFO_BITS+INFO_FBK_POS ) <= '1';
                O_INFO(i*INFO_BITS+INFO_FBK_NUM_HI downto i*INFO_BITS+INFO_FBK_NUM_LO) <= intake_number;
            end loop;
        else
            O_INFO <= (others => '0');
        end if;
    end process;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    process(curr_state, O_READY, intake_valid)
        constant O_READY_ALL_1 :  std_logic_vector(O_READY'range) := (others => '1');
    begin
        if (curr_state = INTAKE_STATE) then
            if (O_READY = O_READY_ALL_1 and intake_valid = '1') then
                O_VALID      <= (others => '1');
                outlet_valid <= '1';
                intake_ready <= '1';
            else
                O_VALID      <= (others => '0');
                outlet_valid <= '0';
                intake_ready <= '0';
            end if;
            O_LAST <= (others => '1');
        elsif (FEEDBACK > 0 and curr_state = FLUSH_STATE) then
            if (O_READY = O_READY_ALL_1) then
                O_VALID      <= (others => '1');
                outlet_valid <= '1';
            else
                O_VALID      <= (others => '0');
                outlet_valid <= '0';
            end if;
            O_LAST       <= (others => '1');
            intake_ready <= '0';
        else
            O_VALID      <= (others => '0');
            O_LAST       <= (others => '0');
            outlet_valid <= '0';
            intake_ready <= '0';
        end if;
    end process;
    intake_done <= (intake_valid = '1' and intake_ready = '1' and intake_last = '1');
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    NONE:  if (FEEDBACK = 0) generate
        intake_number <= (others => '0');
        intake_first  <= '1';
        state_done    <= (curr_state = INTAKE_STATE and intake_valid = '1' and intake_ready = '1') or
                         (curr_state = FLUSH_STATE  and intake_valid = '1' and intake_ready = '1');
        FBK_OUT_SIZE  <= (others => '0');
        FBK_OUT_LAST  <= '1' when (curr_state = INTAKE_STATE and intake_done = TRUE) or
                                  (curr_state = FLUSH_STATE) else '0';
    end generate;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    COUNT: if (FEEDBACK > 0) generate
        subtype   COUNTER_TYPE    is unsigned(O_NUM_BITS-1 downto 0);
        type      COUNTER_VECTOR  is array (integer range <>) of COUNTER_TYPE;
        signal    counter         :  COUNTER_VECTOR  (1 to FEEDBACK);
        signal    count_up        :  std_logic_vector(1 to FEEDBACK);
        signal    count_zero      :  std_logic_vector(1 to FEEDBACK);
        signal    count_last      :  std_logic_vector(1 to FEEDBACK);
        signal    delimiter       :  std_logic;
        signal    count_all_zero  :  std_logic;
        signal    count_all_last  :  std_logic;
        signal    feedback_size   :  unsigned(SIZE_BITS-1 downto 0);
        signal    feedback_add    :  unsigned(SIZE_BITS-1 downto 0);
        constant  ALL_1           :  std_logic_vector(1 to FEEDBACK) := (others => '1');
    begin
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (curr_state, count_last, outlet_valid)
            variable next_count_up : boolean;
        begin
            if (curr_state = INTAKE_STATE or curr_state = FLUSH_STATE) and
               (outlet_valid = '1') then
                next_count_up := TRUE;
                for i in 1 to FEEDBACK loop
                    if (next_count_up) then
                        count_up(i)   <= '1';
                        next_count_up := (count_last(i) = '1');
                    else
                        count_up(i)   <= '0';
                        next_count_up := FALSE;
                    end if;
                end loop;
            else
                count_up <= (others => '0');
            end if;
        end process;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (CLK, RST)
            variable  next_counter   :  COUNTER_TYPE;
            variable  next_zero      :  std_logic_vector(count_zero'range);
            variable  next_last      :  std_logic_vector(count_last'range);
            variable  upper_mask     :  std_logic_vector(counter'range);
            variable  lower_mask     :  std_logic_vector(counter'range);
            variable  next_delimiter :  std_logic;
            variable  upper_all_zero :  boolean;
            variable  lower_all_last :  boolean;
        begin
            if (RST = '1') then
                    counter        <= (others => (others => '0'));
                    count_zero     <= (others => '1');
                    count_last     <= (others => '0');
                    delimiter      <= '1';
                    count_all_zero <= '1';
                    count_all_last <= '0';
            elsif (CLK'event and CLK = '1') then
                if (CLR = '1') or
                   (curr_state = IDLE_STATE) then
                    counter        <= (others => (others => '0'));
                    count_zero     <= (others => '1');
                    count_last     <= (others => '0');
                    delimiter      <= '1';
                    count_all_zero <= '1';
                    count_all_last <= '0';
                else
                    for i in counter'range loop
                        if (count_up(i) = '1') then
                            if (count_last(i) = '1') then
                                next_counter := (others => '0');
                            else
                                next_counter := counter(i) + 1;
                            end if;
                        else
                                next_counter := counter(i);
                        end if;
                        if (next_counter = 0) then
                            next_zero(i) := '1';
                        else
                            next_zero(i) := '0';
                        end if;
                        if (next_counter = O_NUM-1) then
                            next_last(i) := '1';
                        else
                            next_last(i) := '0';
                        end if;
                        counter(i)    <= next_counter;
                        count_zero(i) <= next_zero(i);
                        count_last(i) <= next_last(i);
                    end loop;
                    if (next_zero = ALL_1) then
                        count_all_zero <= '1';
                    else
                        count_all_zero <= '0';
                    end if;
                    if (next_last = ALL_1) then
                        count_all_last <= '1';
                    else
                        count_all_last <= '0';
                    end if;
                    next_delimiter := '0';
                    for i in counter'range loop
                        for n in upper_mask'range loop
                            if (n >= i) then
                                upper_mask(n) := '1';
                                lower_mask(n) := '0';
                            else
                                upper_mask(n) := '0';
                                lower_mask(n) := '1';
                            end if;
                        end loop;
                        upper_all_zero := ((next_zero and upper_mask) = upper_mask);
                        lower_all_last := ((next_last and lower_mask) = lower_mask);
                        if (upper_all_zero and lower_all_last) then
                            next_delimiter := next_delimiter or '1';
                        end if;
                    end loop;
                    delimiter <= next_delimiter;
                end if;
            end if;
        end process;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        intake_number <= std_logic_vector(counter(counter'low));
        intake_first  <= '1' when (count_all_zero = '1') else '0';
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (curr_state, intake_done, count_all_last, delimiter, outlet_valid) begin
            if (curr_state = INTAKE_STATE) then
                if  (outlet_valid = '1' and delimiter      = '1' and intake_done = TRUE) or
                    (outlet_valid = '1' and count_all_last = '1') then
                    state_done <= TRUE;
                else
                    state_done <= FALSE;
                end if;
            elsif (curr_state = FLUSH_STATE) then
                if  (outlet_valid = '1' and delimiter      = '1') or
                    (outlet_valid = '1' and count_all_last = '1') then
                    state_done <= TRUE;
                else
                    state_done <= FALSE;
                end if;
            else
                    state_done <= FALSE;
            end if;
        end process;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (CLK, RST) begin
            if (RST = '1') then
                    feedback_size <= (others => '0');
                    feedback_add  <= to_unsigned(1, SIZE_BITS);
            elsif (CLK'event and CLK = '1') then
                if (CLR = '1') then
                    feedback_size <= (others => '0');
                    feedback_add  <= to_unsigned(1, SIZE_BITS);
                elsif (curr_state = FLUSH_STATE or curr_state = INTAKE_STATE) then
                    if (delimiter = '1' and outlet_valid = '1') then
                        feedback_size <= resize((feedback_size + feedback_add), SIZE_BITS);
                        feedback_add  <= resize((feedback_add  * O_NUM       ), SIZE_BITS);
                    end if;
                else
                    feedback_size <= (others => '0');
                    feedback_add  <= to_unsigned(1, SIZE_BITS);
                end if;
            end if;
        end process;
        FBK_OUT_SIZE <= std_logic_vector(feedback_size);
        FBK_OUT_LAST <= '1' when (curr_state = INTAKE_STATE and intake_done = TRUE) or
                                 (curr_state = FLUSH_STATE) else '0';
    end generate;
end RTL;

