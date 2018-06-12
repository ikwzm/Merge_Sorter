-----------------------------------------------------------------------------------
--!     @file    merge_sorter_core.vhd
--!     @brief   Merge Sorter Core Module :
--!     @version 0.0.9
--!     @date    2018/6/12
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
entity  Merge_Sorter_Core is
    generic (
        IN_NUM          :  integer :=    8;
        STM_ENABLE      :  boolean := TRUE;
        STM_IN_NUM      :  integer :=    1;
        STM_FEEDBACK    :  integer :=    1;
        MRG_ENABLE      :  boolean := TRUE;
        MRG_FIFO_SIZE   :  integer :=  128;
        MRG_LEVEL_SIZE  :  integer :=   64;
        SORT_ORDER      :  integer :=    0;
        DATA_BITS       :  integer :=   64;
        COMP_HIGH       :  integer :=   63;
        COMP_LOW        :  integer :=   32;
        ATRB_BITS       :  integer :=    4;
        ATRB_NONE_POS   :  integer :=    0;
        ATRB_PRIO_POS   :  integer :=    1;
        ATRB_POST_POS   :  integer :=    2;
        ATRB_DONE_POS   :  integer :=    3
    );
    port (
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
        STM_REQ_VALID   :  in  std_logic;
        STM_REQ_READY   :  out std_logic;
        STM_RES_VALID   :  out std_logic;
        STM_RES_READY   :  in  std_logic;
        STM_IN_DATA     :  in  std_logic_vector(STM_IN_NUM*DATA_BITS-1 downto 0);
        STM_IN_STRB     :  in  std_logic_vector(STM_IN_NUM          -1 downto 0);
        STM_IN_LAST     :  in  std_logic;
        STM_IN_VALID    :  in  std_logic;
        STM_IN_READY    :  out std_logic;
        STM_OUT_DATA    :  out std_logic_vector(           DATA_BITS-1 downto 0);
        STM_OUT_LAST    :  out std_logic;
        STM_OUT_VALID   :  out std_logic;
        STM_OUT_READY   :  in  std_logic;
        MRG_REQ_VALID   :  in  std_logic;
        MRG_REQ_READY   :  out std_logic;
        MRG_RES_VALID   :  out std_logic;
        MRG_RES_READY   :  in  std_logic;
        MRG_IN_DATA     :  in  std_logic_vector(    IN_NUM*DATA_BITS-1 downto 0);
        MRG_IN_ATRB     :  in  std_logic_vector(    IN_NUM*ATRB_BITS-1 downto 0);
        MRG_IN_LAST     :  in  std_logic_vector(    IN_NUM          -1 downto 0);
        MRG_IN_VALID    :  in  std_logic_vector(    IN_NUM          -1 downto 0);
        MRG_IN_READY    :  out std_logic_vector(    IN_NUM          -1 downto 0);
        MRG_IN_LEVEL    :  out std_logic_vector(    IN_NUM          -1 downto 0);
        MRG_OUT_DATA    :  out std_logic_vector(           DATA_BITS-1 downto 0);
        MRG_OUT_LAST    :  out std_logic;
        MRG_OUT_VALID   :  out std_logic;
        MRG_OUT_READY   :  in  std_logic
    );
end Merge_Sorter_Core;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
architecture RTL of Merge_Sorter_Core is
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component Merge_Sorter_Single_Way_Tree
        generic (
            I_NUM           :  integer :=  8;
            DATA_BITS       :  integer := 64;
            INFO_BITS       :  integer :=  3;
            SORT_ORDER      :  integer :=  0;
            COMP_HIGH       :  integer := 63;
            COMP_LOW        :  integer := 32;
            QUEUE_SIZE      :  integer :=  2
        );
        port (
            CLK             :  in  std_logic;
            RST             :  in  std_logic;
            CLR             :  in  std_logic;
            I_DATA          :  in  std_logic_vector(I_NUM*DATA_BITS-1 downto 0);
            I_INFO          :  in  std_logic_vector(I_NUM*INFO_BITS-1 downto 0);
            I_LAST          :  in  std_logic_vector(I_NUM          -1 downto 0);
            I_VALID         :  in  std_logic_vector(I_NUM          -1 downto 0);
            I_READY         :  out std_logic_vector(I_NUM          -1 downto 0);
            O_DATA          :  out std_logic_vector(      DATA_BITS-1 downto 0);
            O_INFO          :  out std_logic_vector(      INFO_BITS-1 downto 0);
            O_LAST          :  out std_logic;
            O_VALID         :  out std_logic;
            O_READY         :  in  std_logic
        );
    end component;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component Merge_Sorter_Core_Fifo
        generic (
            FBK_ENABLE      :  boolean := TRUE;
            MRG_ENABLE      :  boolean := TRUE;
            SIZE_BITS       :  integer :=  6;
            FIFO_SIZE       :  integer := 64;
            LEVEL_SIZE      :  integer := 32;
            DATA_BITS       :  integer := 64;
            INFO_BITS       :  integer :=  8;
            INFO_NONE_POS   :  integer :=  0;
            INFO_PRIO_POS   :  integer :=  1;
            INFO_POST_POS   :  integer :=  2;
            INFO_DONE_POS   :  integer :=  3;
            INFO_FBK_POS    :  integer :=  4;
            INFO_FBK_NUM_LO :  integer :=  5;
            INFO_FBK_NUM_HI :  integer :=  9;
            ATRB_BITS       :  integer :=  4;
            ATRB_NONE_POS   :  integer :=  0;
            ATRB_PRIO_POS   :  integer :=  1;
            ATRB_POST_POS   :  integer :=  2;
            ATRB_DONE_POS   :  integer :=  3
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
            FBK_IN_ATRB     :  in  std_logic_vector(ATRB_BITS-1 downto 0) := (others => '0');
            FBK_IN_LAST     :  in  std_logic;
            FBK_IN_VALID    :  in  std_logic := '0';
            FBK_IN_READY    :  out std_logic;
            MRG_REQ         :  in  std_logic := '0';
            MRG_ACK         :  out std_logic;
            MRG_IN_DATA     :  in  std_logic_vector(DATA_BITS-1 downto 0);
            MRG_IN_ATRB     :  in  std_logic_vector(ATRB_BITS-1 downto 0) := (others => '0');
            MRG_IN_LAST     :  in  std_logic;
            MRG_IN_VALID    :  in  std_logic := '0';
            MRG_IN_READY    :  out std_logic;
            MRG_IN_LEVEL    :  out std_logic;
            OUTLET_DATA     :  out std_logic_vector(DATA_BITS-1 downto 0);
            OUTLET_INFO     :  out std_logic_vector(INFO_BITS-1 downto 0);
            OUTLET_LAST     :  out std_logic;
            OUTLET_VALID    :  out std_logic;
            OUTLET_READY    :  in  std_logic
        );
    end component;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component Merge_Sorter_Core_Stream_Intake
        generic (
            O_NUM           :  integer :=  8;
            I_NUM           :  integer :=  1;
            FEEDBACK        :  integer :=  1;
            O_NUM_BITS      :  integer :=  3;
            SIZE_BITS       :  integer :=  6;
            DATA_BITS       :  integer := 64;
            INFO_BITS       :  integer :=  8;
            INFO_NONE_POS   :  integer :=  0;
            INFO_PRIO_POS   :  integer :=  1;
            INFO_POST_POS   :  integer :=  2;
            INFO_DONE_POS   :  integer :=  3;
            INFO_FBK_POS    :  integer :=  4;
            INFO_FBK_NUM_LO :  integer :=  5;
            INFO_FBK_NUM_HI :  integer :=  9
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
    end component;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component Merge_Sorter_Queue 
        generic (
            QUEUE_SIZE      :  integer :=  2;
            DATA_BITS       :  integer := 64;
            INFO_BITS       :  integer :=  1
        );
        port (
            CLK             :  in  std_logic;
            RST             :  in  std_logic;
            CLR             :  in  std_logic;
            I_DATA          :  in  std_logic_vector(DATA_BITS-1 downto 0);
            I_INFO          :  in  std_logic_vector(INFO_BITS-1 downto 0);
            I_LAST          :  in  std_logic;
            I_VALID         :  in  std_logic;
            I_READY         :  out std_logic;
            O_DATA          :  out std_logic_vector(DATA_BITS-1 downto 0);
            O_INFO          :  out std_logic_vector(INFO_BITS-1 downto 0);
            O_LAST          :  out std_logic;
            O_VALID         :  out std_logic;
            O_READY         :  in  std_logic
        );
    end component;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component Merge_Sorter_Drop_None
        generic (
            DATA_BITS       :  integer := 64;
            INFO_BITS       :  integer :=  1
        );
        port (
            CLK             :  in  std_logic;
            RST             :  in  std_logic;
            CLR             :  in  std_logic;
            I_DATA          :  in  std_logic_vector(DATA_BITS-1 downto 0);
            I_INFO          :  in  std_logic_vector(INFO_BITS-1 downto 0);
            I_LAST          :  in  std_logic;
            I_VALID         :  in  std_logic;
            I_READY         :  out std_logic;
            O_DATA          :  out std_logic_vector(DATA_BITS-1 downto 0);
            O_INFO          :  out std_logic_vector(INFO_BITS-1 downto 0);
            O_LAST          :  out std_logic;
            O_VALID         :  out std_logic;
            O_READY         :  in  std_logic
        );
    end component;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function  or_reduce(Arg : std_logic_vector) return std_logic is
        variable result : std_logic;
    begin
        result := '0';
        for i in Arg'range loop
            result := result or Arg(i);
        end loop;
        return result;
    end function;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function  CALC_MAX_FBK_OUT_SIZE(FBK,NUM:integer) return integer is
        variable add  : integer;
        variable size : integer;
    begin
        if (FBK > 0) then
            size := 0;
            add  := 1;
            for i in 1 to FBK loop
                size := size + add;
                add  := add  * NUM;
            end loop;
        else
            size := 1;
        end if;
        return size;
    end function;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function  CALC_FIFO_SIZE return integer is
        variable fifo_size : integer;
    begin
        if (STM_ENABLE = TRUE) then
            if    (STM_FEEDBACK = 0) then
                fifo_size := 0;
            elsif (STM_FEEDBACK = 1) then
                fifo_size := IN_NUM;
            else
                fifo_size := 2*(IN_NUM**STM_FEEDBACK);
            end if;
        else
            fifo_size := 0;
        end if;
        if (MRG_ENABLE = TRUE and fifo_size < MRG_FIFO_SIZE) then
            fifo_size := MRG_FIFO_SIZE;
        end if;
        return fifo_size;
    end function;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function  NUM_TO_BITS(NUM:integer) return integer is
        variable value : integer;
    begin
        value := 0;
        while (2**value <= NUM) loop
            value := value + 1;
        end loop;
        return value;
    end function;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function  max(A,B:integer) return integer is
    begin
        if (A > B) then return A;
        else            return B;
        end if;
    end function;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    constant  FIFO_SIZE             :  integer := CALC_FIFO_SIZE;
    constant  MAX_FBK_OUT_SIZE      :  integer := CALC_MAX_FBK_OUT_SIZE(STM_FEEDBACK,IN_NUM);
    constant  SIZE_BITS             :  integer := NUM_TO_BITS(max(MAX_FBK_OUT_SIZE, max(IN_NUM**STM_FEEDBACK,IN_NUM)));
    constant  IN_NUM_BITS           :  integer := NUM_TO_BITS(IN_NUM-1);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    constant  INFO_NONE_POS         :  integer := ATRB_NONE_POS;
    constant  INFO_PRIO_POS         :  integer := ATRB_PRIO_POS;
    constant  INFO_POST_POS         :  integer := ATRB_POST_POS;
    constant  INFO_DONE_POS         :  integer := ATRB_DONE_POS;
    constant  INFO_FBK_POS          :  integer := ATRB_BITS;
    constant  INFO_FBK_NUM_LO       :  integer := INFO_FBK_POS    + 1;
    constant  INFO_FBK_NUM_HI       :  integer := INFO_FBK_NUM_LO + IN_NUM_BITS - 1;
    constant  INFO_BITS             :  integer := INFO_FBK_NUM_HI + 1;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal    stream_intake_data    :  std_logic_vector(IN_NUM*DATA_BITS-1 downto 0);
    signal    stream_intake_info    :  std_logic_vector(IN_NUM*INFO_BITS-1 downto 0);
    signal    stream_intake_last    :  std_logic_vector(IN_NUM-1 downto 0);
    signal    stream_intake_valid   :  std_logic_vector(IN_NUM-1 downto 0);
    signal    stream_intake_ready   :  std_logic_vector(IN_NUM-1 downto 0);
    signal    stream_intake_start   :  std_logic;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal    fifo_intake_data      :  std_logic_vector(IN_NUM*DATA_BITS-1 downto 0);
    signal    fifo_intake_info      :  std_logic_vector(IN_NUM*INFO_BITS-1 downto 0);
    signal    fifo_intake_last      :  std_logic_vector(IN_NUM-1 downto 0);
    signal    fifo_intake_valid     :  std_logic_vector(IN_NUM-1 downto 0);
    signal    fifo_intake_ready     :  std_logic_vector(IN_NUM-1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal    intake_word_data      :  std_logic_vector(IN_NUM*DATA_BITS-1 downto 0);
    signal    intake_word_info      :  std_logic_vector(IN_NUM*INFO_BITS-1 downto 0);
    signal    intake_word_last      :  std_logic_vector(IN_NUM-1 downto 0);
    signal    intake_word_valid     :  std_logic_vector(IN_NUM-1 downto 0);
    signal    intake_word_ready     :  std_logic_vector(IN_NUM-1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal    sorted_word_data      :  std_logic_vector(DATA_BITS-1 downto 0);
    signal    sorted_word_info      :  std_logic_vector(INFO_BITS-1 downto 0);
    signal    sorted_word_last      :  std_logic;
    signal    sorted_word_valid     :  std_logic;
    signal    sorted_word_ready     :  std_logic;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal    fifo_stream_req       :  std_logic;
    signal    fifo_stream_ack       :  std_logic_vector(IN_NUM-1 downto 0);
    signal    fifo_stream_done      :  std_logic_vector(IN_NUM-1 downto 0);
    signal    fifo_merge_req        :  std_logic;
    signal    fifo_merge_ack        :  std_logic_vector(IN_NUM-1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal    feedback_out_start    :  std_logic;
    signal    feedback_out_size     :  std_logic_vector(SIZE_BITS-1 downto 0);
    signal    feedback_out_last     :  std_logic;
    signal    feedback_data         :  std_logic_vector(DATA_BITS-1 downto 0);
    signal    feedback_atrb         :  std_logic_vector(ATRB_BITS-1 downto 0);
    signal    feedback_last         :  std_logic;
    signal    feedback_valid        :  std_logic_vector(IN_NUM   -1 downto 0);
    signal    feedback_ready        :  std_logic_vector(IN_NUM   -1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal    outlet_i_data         :  std_logic_vector(DATA_BITS-1 downto 0);
    signal    outlet_i_none         :  std_logic;
    signal    outlet_i_last         :  std_logic;
    signal    outlet_i_valid        :  std_logic;
    signal    outlet_i_ready        :  std_logic;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal    stream_out_req        :  std_logic;
    signal    stream_out_done       :  std_logic;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal    merge_out_req         :  std_logic;
    signal    merge_out_done        :  std_logic;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    type      STATE_TYPE            is (IDLE_STATE,
                                        STREAM_INIT_STATE,
                                        STREAM_RUN_STATE,
                                        STREAM_NEXT_STATE,
                                        STREAM_EXIT_STATE,
                                        STREAM_RES_STATE,
                                        MERGE_INIT_STATE,
                                        MERGE_RUN_STATE,
                                        MERGE_EXIT_STATE,
                                        MERGE_RES_STATE
                                       );
    signal    curr_state           :  STATE_TYPE;
    constant  ACK_ALL_1            :  std_logic_vector(IN_NUM-1 downto 0) := (others => '1');
begin
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    FSM: process (CLK, RST) begin
        if (RST = '1') then
                curr_state <= IDLE_STATE;
        elsif (CLK'event and CLK = '1') then
            if (CLR = '1') then
                curr_state <= IDLE_STATE;
            else
                case curr_state is
                    when IDLE_STATE         =>
                        if    (STM_ENABLE = TRUE and STM_REQ_VALID = '1') then
                            curr_state <= STREAM_INIT_STATE;
                        elsif (MRG_ENABLE = TRUE and MRG_REQ_VALID = '1') then
                            curr_state <= MERGE_INIT_STATE;
                        else
                            curr_state <= IDLE_STATE;
                        end if;
                    when STREAM_INIT_STATE  =>
                        if (STM_ENABLE = FALSE) then
                            curr_state <= IDLE_STATE;
                        else
                            curr_state <= STREAM_RUN_STATE;
                        end if;
                    when STREAM_RUN_STATE   =>
                        if    (STM_ENABLE = FALSE) then
                            curr_state <= IDLE_STATE;
                        elsif (STM_FEEDBACK = 0) then
                            if    (feedback_out_start = '1' and feedback_out_last = '1') then
                                curr_state <= STREAM_EXIT_STATE;
                            elsif (feedback_out_start = '1' and feedback_out_last = '0') then
                                curr_state <= STREAM_NEXT_STATE;
                            else
                                curr_state <= STREAM_RUN_STATE;
                            end if;
                        else
                            if    (fifo_stream_ack = ACK_ALL_1 and fifo_stream_done  = ACK_ALL_1) then
                                curr_state <= STREAM_EXIT_STATE;
                            elsif (fifo_stream_ack = ACK_ALL_1 and fifo_stream_done /= ACK_ALL_1) then
                                curr_state <= STREAM_NEXT_STATE;
                            else
                                curr_state <= STREAM_RUN_STATE;
                            end if;
                        end if;
                    when STREAM_NEXT_STATE  =>
                        if    (STM_ENABLE = FALSE) then
                            curr_state <= IDLE_STATE;
                        else
                            curr_state <= STREAM_RUN_STATE;
                        end if;
                    when STREAM_EXIT_STATE  =>
                        if    (STM_ENABLE = FALSE) then
                            curr_state <= IDLE_STATE;
                        elsif (stream_out_done = '1') then
                            curr_state <= STREAM_RES_STATE;
                        else
                            curr_state <= STREAM_EXIT_STATE;
                        end if;
                    when STREAM_RES_STATE   =>
                        if    (STM_ENABLE = FALSE) then
                            curr_state <= IDLE_STATE;
                        elsif (STM_RES_READY = '1') then
                            curr_state <= IDLE_STATE;
                        else
                            curr_state <= STREAM_RES_STATE;
                        end if;
                    when MERGE_INIT_STATE   =>
                        if (MRG_ENABLE = FALSE) then
                            curr_state <= IDLE_STATE;
                        else
                            curr_state <= MERGE_RUN_STATE;
                        end if;
                    when MERGE_RUN_STATE    =>
                        if    (MRG_ENABLE = FALSE) then
                            curr_state <= IDLE_STATE;
                        elsif (fifo_merge_ack = ACK_ALL_1) then
                            curr_state <= MERGE_EXIT_STATE;
                        else
                            curr_state <= MERGE_RUN_STATE;
                        end if;
                    when MERGE_EXIT_STATE   =>
                        if    (MRG_ENABLE = FALSE) then
                            curr_state <= IDLE_STATE;
                        elsif (merge_out_done = '1') then
                            curr_state <= MERGE_RES_STATE;
                        else
                            curr_state <= MERGE_EXIT_STATE;
                        end if;
                    when MERGE_RES_STATE   =>
                        if    (MRG_ENABLE = FALSE) then
                            curr_state <= IDLE_STATE;
                        elsif (MRG_RES_READY = '1') then
                            curr_state <= IDLE_STATE;
                        else
                            curr_state <= MERGE_RES_STATE;
                        end if;
                    when others =>
                        curr_state <= IDLE_STATE;
                end case;
            end if;
        end if;
    end process;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    STM_REQ_READY <= '1' when (curr_state = STREAM_INIT_STATE) else '0';
    STM_RES_VALID <= '1' when (curr_state = STREAM_RES_STATE ) else '0';
    MRG_REQ_READY <= '1' when (curr_state = MERGE_INIT_STATE ) else '0';
    MRG_RES_VALID <= '1' when (curr_state = MERGE_RES_STATE  ) else '0';
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    stream_intake_start <= '1' when (curr_state = STREAM_INIT_STATE) or
                                    (curr_state = STREAM_NEXT_STATE) else '0';
    fifo_stream_req     <= '1' when (curr_state = STREAM_INIT_STATE) or
                                    (curr_state = STREAM_NEXT_STATE) or
                                    (curr_state = STREAM_RUN_STATE and fifo_stream_ack /= ACK_ALL_1) else '0';
    fifo_merge_req      <= '1' when (curr_state = MERGE_INIT_STATE ) or
                                    (curr_state = MERGE_RUN_STATE  ) else '0';
    stream_out_req      <= '1' when (curr_state = STREAM_INIT_STATE) or
                                    (curr_state = STREAM_NEXT_STATE) or
                                    (curr_state = STREAM_RUN_STATE ) or
                                    (curr_state = STREAM_EXIT_STATE) else '0';
    merge_out_req       <= '1' when (curr_state = MERGE_INIT_STATE ) or
                                    (curr_state = MERGE_RUN_STATE  ) or
                                    (curr_state = MERGE_EXIT_STATE ) else '0';
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    STM_INTAKE: if (STM_ENABLE = TRUE) generate          -- 
        QUEUE: Merge_Sorter_Core_Stream_Intake           -- 
            generic map (                                -- 
                O_NUM           => IN_NUM              , -- 
                I_NUM           => STM_IN_NUM          , -- 
                FEEDBACK        => STM_FEEDBACK        , -- 
                O_NUM_BITS      => IN_NUM_BITS         , -- 
                SIZE_BITS       => SIZE_BITS           , -- 
                DATA_BITS       => DATA_BITS           , -- 
                INFO_BITS       => INFO_BITS           , -- 
                INFO_NONE_POS   => INFO_NONE_POS       , -- 
                INFO_PRIO_POS   => INFO_PRIO_POS       , -- 
                INFO_POST_POS   => INFO_POST_POS       , -- 
                INFO_DONE_POS   => INFO_DONE_POS       , -- 
                INFO_FBK_POS    => INFO_FBK_POS        , -- 
                INFO_FBK_NUM_LO => INFO_FBK_NUM_LO     , -- 
                INFO_FBK_NUM_HI => INFO_FBK_NUM_HI       -- 
            )                                            -- 
            port map (                                   -- 
                CLK             => CLK                 , -- In  :
                RST             => RST                 , -- In  :
                CLR             => CLR                 , -- In  :
                START           => stream_intake_start , -- In  :
                BUSY            => open                , -- Out :
                DONE            => open                , -- Out :
                FBK_OUT_START   => feedback_out_start  , -- Out :
                FBK_OUT_SIZE    => feedback_out_size   , -- Out :
                FBK_OUT_LAST    => feedback_out_last   , -- Out :
                I_DATA          => STM_IN_DATA         , -- In  :
                I_STRB          => STM_IN_STRB         , -- In  :
                I_LAST          => STM_IN_LAST         , -- In  :
                I_VALID         => STM_IN_VALID        , -- In  :
                I_READY         => STM_IN_READY        , -- Out :
                O_DATA          => stream_intake_data  , -- Out :
                O_INFO          => stream_intake_info  , -- Out :
                O_LAST          => stream_intake_last  , -- Out :
                O_VALID         => stream_intake_valid , -- Out :
                O_READY         => stream_intake_ready   -- In  :
            );
    end generate;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    STM_INTAKE_OFF: if (STM_ENABLE = FALSE) generate
        stream_intake_data  <= (others => '0');
        stream_intake_info  <= (others => '0');
        stream_intake_last  <= (others => '0');
        stream_intake_valid <= (others => '0');
        feedback_out_start  <= '0';
        feedback_out_size   <= (others => '0');
        feedback_out_last   <= '0';
        STM_IN_READY        <= '0';
    end generate;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    FIFO: for i in 0 to IN_NUM-1 generate                -- 
        U: Merge_Sorter_Core_Fifo                        -- 
            generic map (                                -- 
                FBK_ENABLE      => (STM_ENABLE = TRUE and STM_FEEDBACK > 0), -- 
                MRG_ENABLE      => MRG_ENABLE          , -- 
                SIZE_BITS       => SIZE_BITS           , -- 
                FIFO_SIZE       => FIFO_SIZE           , -- 
                LEVEL_SIZE      => MRG_LEVEL_SIZE      , -- 
                DATA_BITS       => DATA_BITS           , -- 
                INFO_BITS       => INFO_BITS           , -- 
                INFO_NONE_POS   => INFO_NONE_POS       , -- 
                INFO_PRIO_POS   => INFO_PRIO_POS       , -- 
                INFO_POST_POS   => INFO_POST_POS       , -- 
                INFO_DONE_POS   => INFO_DONE_POS       , -- 
                INFO_FBK_POS    => INFO_FBK_POS        , -- 
                INFO_FBK_NUM_LO => INFO_FBK_NUM_LO     , -- 
                INFO_FBK_NUM_HI => INFO_FBK_NUM_HI     , -- 
                ATRB_BITS       => ATRB_BITS           , -- 
                ATRB_NONE_POS   => ATRB_NONE_POS       , -- 
                ATRB_PRIO_POS   => ATRB_PRIO_POS       , -- 
                ATRB_POST_POS   => ATRB_POST_POS       , -- 
                ATRB_DONE_POS   => ATRB_DONE_POS         -- 
            )                                            -- 
            port map (                                   -- 
                CLK             => CLK                 , -- In  :
                RST             => RST                 , -- In  :
                CLR             => CLR                 , -- In  :
                FBK_REQ         => fifo_stream_req     , -- In  :
                FBK_ACK         => fifo_stream_ack  (i), -- Out :
                FBK_DONE        => fifo_stream_done (i), -- Out :
                FBK_OUT_START   => feedback_out_start  , -- In  :
                FBK_OUT_SIZE    => feedback_out_size   , -- In  :
                FBK_OUT_LAST    => feedback_out_last   , -- In  :
                FBK_IN_DATA     => feedback_data       , -- In  :
                FBK_IN_ATRB     => feedback_atrb       , -- In  :
                FBK_IN_LAST     => feedback_last       , -- In  :
                FBK_IN_VALID    => feedback_valid   (i), -- In  :
                FBK_IN_READY    => feedback_ready   (i), -- Out :
                MRG_REQ         => fifo_merge_req      , -- In  :
                MRG_ACK         => fifo_merge_ack   (i), -- Out :
                MRG_IN_DATA     => MRG_IN_DATA      ((i+1)*DATA_BITS-1 downto i*DATA_BITS), -- In  :
                MRG_IN_ATRB     => MRG_IN_ATRB      ((i+1)*ATRB_BITS-1 downto i*ATRB_BITS), -- In  :
                MRG_IN_LAST     => MRG_IN_LAST      (i), -- In  :
                MRG_IN_VALID    => MRG_IN_VALID     (i), -- In  :
                MRG_IN_READY    => MRG_IN_READY     (i), -- Out :
                MRG_IN_LEVEL    => MRG_IN_LEVEL     (i), -- Out :
                OUTLET_DATA     => fifo_intake_data ((i+1)*DATA_BITS-1 downto i*DATA_BITS), -- Out :
                OUTLET_INFO     => fifo_intake_info ((i+1)*INFO_BITS-1 downto i*INFO_BITS), -- Out :
                OUTLET_LAST     => fifo_intake_last (i), -- Out :
                OUTLET_VALID    => fifo_intake_valid(i), -- Out :
                OUTLET_READY    => fifo_intake_ready(i)  -- In  :
            );                                           -- 
    end generate;                                        -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    INTAKE_WORD_SELECT: block
    begin
        intake_word_data    <= stream_intake_data  or fifo_intake_data;
        intake_word_info    <= stream_intake_info  or fifo_intake_info;
        intake_word_last    <= stream_intake_last  or fifo_intake_last;
        intake_word_valid   <= stream_intake_valid or fifo_intake_valid;
        stream_intake_ready <= intake_word_ready;
        fifo_intake_ready   <= intake_word_ready;
    end block;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    SORT: block                                          -- 
    begin                                                -- 
        TREE: Merge_Sorter_Single_Way_Tree               -- 
            generic map (                                -- 
                SORT_ORDER      => SORT_ORDER          , -- 
                QUEUE_SIZE      => 2                   , -- 
                I_NUM           => IN_NUM              , -- 
                DATA_BITS       => DATA_BITS           , -- 
                COMP_HIGH       => COMP_HIGH           , -- 
                COMP_LOW        => COMP_LOW            , -- 
                INFO_BITS       => INFO_BITS             -- 
            )                                            -- 
            port map (                                   -- 
                CLK             => CLK                 , -- In  :
                RST             => RST                 , -- In  :
                CLR             => CLR                 , -- In  :
                I_DATA          => intake_word_data    , -- In  :
                I_INFO          => intake_word_info    , -- In  :
                I_LAST          => intake_word_last    , -- In  :
                I_VALID         => intake_word_valid   , -- In  :
                I_READY         => intake_word_ready   , -- Out :
                O_DATA          => sorted_word_data    , -- Out :
                O_INFO          => sorted_word_info    , -- Out :
                O_LAST          => sorted_word_last    , -- Out :
                O_VALID         => sorted_word_valid   , -- Out :
                O_READY         => sorted_word_ready     -- In  :
            );                                           -- 
    end block;                                           -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    FEEDBACK_ON: if (STM_ENABLE = TRUE and STM_FEEDBACK > 0) generate
        constant  QUEUE_INFO_NONE_POS   :  integer := 0;
        constant  QUEUE_INFO_PRIO_POS   :  integer := 1;
        constant  QUEUE_INFO_POST_POS   :  integer := 2;
        constant  QUEUE_INFO_MASK_LO    :  integer := QUEUE_INFO_POST_POS + 1;
        constant  QUEUE_INFO_MASK_HI    :  integer := QUEUE_INFO_MASK_LO  + IN_NUM - 1;
        signal    queue_i_info          :  std_logic_vector(QUEUE_INFO_MASK_HI downto 0);
        signal    queue_i_mask          :  std_logic_vector(IN_NUM-1           downto 0);
        signal    queue_i_valid         :  std_logic;
        signal    queue_i_ready         :  std_logic;
        signal    queue_o_info          :  std_logic_vector(QUEUE_INFO_MASK_HI downto 0);
        signal    queue_o_mask          :  std_logic_vector(IN_NUM-1           downto 0);
        signal    queue_o_valid         :  std_logic;
        signal    queue_o_ready         :  std_logic;
    begin
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (sorted_word_info)
            variable num : unsigned(IN_NUM_BITS-1 downto 0);
        begin
            num := to_01(unsigned(sorted_word_info(INFO_FBK_NUM_HI downto INFO_FBK_NUM_LO)), '0');
            for i in queue_i_mask'range loop
                if (i = num) then
                    queue_i_mask(i) <= '1';
                else
                    queue_i_mask(i) <= '0';
                end if;
            end loop;
        end process;
        sorted_word_ready <= '1' when (sorted_word_info(INFO_FBK_POS) = '0' and outlet_i_ready    = '1') or
                                      (sorted_word_info(INFO_FBK_POS) = '1' and queue_i_ready     = '1') else '0';
        outlet_i_valid    <= '1' when (sorted_word_info(INFO_FBK_POS) = '0' and sorted_word_valid = '1') else '0';
        queue_i_valid     <= '1' when (sorted_word_info(INFO_FBK_POS) = '1' and sorted_word_valid = '1') else '0';
        queue_i_info(QUEUE_INFO_MASK_HI downto QUEUE_INFO_MASK_LO) <= queue_i_mask;
        queue_i_info(QUEUE_INFO_NONE_POS                         ) <= sorted_word_info(INFO_NONE_POS);
        queue_i_info(QUEUE_INFO_PRIO_POS                         ) <= sorted_word_info(INFO_PRIO_POS);
        queue_i_info(QUEUE_INFO_POST_POS                         ) <= sorted_word_info(INFO_POST_POS);
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        QUEUE: Merge_Sorter_Queue                        -- 
            generic map (                                -- 
                QUEUE_SIZE      => 2                   , -- 
                DATA_BITS       => DATA_BITS           , -- 
                INFO_BITS       => queue_i_info'length   -- 
            )                                            -- 
            port map (                                   -- 
                CLK             => CLK                 , -- In  :
                RST             => RST                 , -- In  :
                CLR             => CLR                 , -- In  :
                I_DATA          => sorted_word_data    , -- In  :
                I_INFO          => queue_i_info        , -- In  :
                I_LAST          => sorted_word_last    , -- In  :
                I_VALID         => queue_i_valid       , -- In  :
                I_READY         => queue_i_ready       , -- Out :
                O_DATA          => feedback_data       , -- Out :
                O_INFO          => queue_o_info        , -- Out :
                O_LAST          => feedback_last       , -- Out :
                O_VALID         => queue_o_valid       , -- Out :
                O_READY         => queue_o_ready         -- In  :
            );                                           --
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        queue_o_mask                 <= queue_o_info(QUEUE_INFO_MASK_HI downto QUEUE_INFO_MASK_LO);
        feedback_atrb(ATRB_NONE_POS) <= queue_o_info(QUEUE_INFO_NONE_POS);
        feedback_atrb(ATRB_PRIO_POS) <= queue_o_info(QUEUE_INFO_PRIO_POS);
        feedback_atrb(ATRB_POST_POS) <= queue_o_info(QUEUE_INFO_POST_POS);
        feedback_atrb(ATRB_DONE_POS) <= '0';
        feedback_valid <= queue_o_mask when (queue_o_valid = '1') else (others => '0');
        queue_o_ready  <= or_reduce(queue_o_mask and feedback_ready);
    end generate;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    FEEDBACK_OFF: if (STM_ENABLE = FALSE or STM_FEEDBACK = 0) generate
        outlet_i_valid    <= sorted_word_valid;
        sorted_word_ready <= outlet_i_ready;
        feedback_data     <= (others => '0');
        feedback_atrb     <= (others => '0');
        feedback_valid    <= (others => '0');
        feedback_last     <= '0';
    end generate;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    OUTLET: block
        signal    queue_data     :  std_logic_vector(DATA_BITS-1 downto 0);
        signal    queue_last     :  std_logic;
        signal    queue_valid    :  std_logic;
        signal    queue_ready    :  std_logic;
        signal    stream_q_valid :  std_logic;
        signal    stream_q_ready :  std_logic;
        signal    merge_q_valid  :  std_logic;
        signal    merge_q_ready  :  std_logic;
    begin
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        outlet_i_data <= sorted_word_data;
        outlet_i_none <= sorted_word_info(INFO_NONE_POS);
        outlet_i_last <= '1' when (sorted_word_last                = '1') and
                                  (sorted_word_info(INFO_DONE_POS) = '1') else '0';
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        QUEUE: Merge_Sorter_Drop_None                    -- 
            generic map (                                -- 
                DATA_BITS       => DATA_BITS           , -- 
                INFO_BITS       => 1                     -- 
            )                                            -- 
            port map (                                   -- 
                CLK             => CLK                 , -- In  :
                RST             => RST                 , -- In  :
                CLR             => CLR                 , -- In  :
                I_DATA          => outlet_i_data       , -- In  :
                I_INFO(0)       => outlet_i_none       , -- In  :
                I_LAST          => outlet_i_last       , -- In  :
                I_VALID         => outlet_i_valid      , -- In  :
                I_READY         => outlet_i_ready      , -- Out :
                O_DATA          => queue_data          , -- Out :
                O_INFO          => open                , -- Out :
                O_LAST          => queue_last          , -- Out :
                O_VALID         => queue_valid         , -- Out :
                O_READY         => queue_ready           -- In  :
            );                                           --
        queue_ready <= stream_q_ready or merge_q_ready;  -- 
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        STM_ON: if (STM_ENABLE = TRUE) generate
            signal   stream_o_done :  std_logic;
            signal   stream_q_done :  std_logic;
        begin 
            STM_OUT_DATA    <= queue_data;
            STM_OUT_LAST    <= queue_last;
            STM_OUT_VALID   <= stream_q_valid;
            stream_q_valid  <= '1' when (stream_out_req = '1' and queue_valid    = '1') else '0';
            stream_q_ready  <= '1' when (stream_out_req = '1' and STM_OUT_READY  = '1') else '0';
            stream_o_done   <= '1' when (stream_q_valid = '1' and stream_q_ready = '1' and queue_last = '1') else '0';
            stream_out_done <= '1' when (stream_out_req = '1' and stream_o_done  = '1') or
                                        (stream_out_req = '1' and stream_q_done  = '1') else '0';
            process (CLK, RST) begin
                if (RST = '1') then
                    stream_q_done <= '0';
                elsif (CLK'event and CLK = '1') then
                    if (CLR = '1' or stream_out_req = '0') then
                        stream_q_done <= '0';
                    else
                        stream_q_done <= stream_o_done;
                    end if;
                end if;
            end process;
        end generate;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        STM_OFF: if (STM_ENABLE = FALSE) generate
            STM_OUT_DATA    <= (others => '0');
            STM_OUT_LAST    <= '0';
            STM_OUT_VALID   <= '0';
            stream_q_valid  <= '0';
            stream_q_ready  <= '0';
            stream_out_done <= '0';
        end generate;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        MRG_ON: if (MRG_ENABLE = TRUE) generate
            signal   merge_o_done :  std_logic;
            signal   merge_q_done :  std_logic;
        begin
            MRG_OUT_DATA    <= queue_data;
            MRG_OUT_LAST    <= queue_last;
            MRG_OUT_VALID   <= merge_q_valid;
            merge_q_valid   <= '1' when (merge_out_req = '1' and queue_valid   = '1') else '0';
            merge_q_ready   <= '1' when (merge_out_req = '1' and MRG_OUT_READY = '1') else '0';
            merge_o_done    <= '1' when (merge_q_valid = '1' and merge_q_ready = '1' and queue_last = '1') else '0';
            merge_out_done  <= '1' when (merge_out_req = '1' and merge_o_done  = '1') or
                                        (merge_out_req = '1' and merge_q_done  = '1') else '0';
            process (CLK, RST) begin
                if (RST = '1') then
                    merge_q_done <= '0';
                elsif (CLK'event and CLK = '1') then
                    if (CLR = '1' or merge_out_req = '0') then
                        merge_q_done <= '0';
                    else
                        merge_q_done <= merge_o_done;
                    end if;
                end if;
            end process;
        end generate;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        MRG_OFF: if (MRG_ENABLE = FALSE) generate
            MRG_OUT_DATA    <= (others => '0');
            MRG_OUT_LAST    <= '0';
            MRG_OUT_VALID   <= '0';
            merge_q_valid   <= '0';
            merge_q_ready   <= '0';
            merge_out_done  <= '0';
        end generate;
    end block;
end RTL;
