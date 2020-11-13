-----------------------------------------------------------------------------------
--!     @file    interface_controller.vhd
--!     @brief   Merge Sorter Interface Controller Module :
--!     @version 0.8.0
--!     @date    2020/11/11
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
--
--      Copyright (C) 2018-2020 Ichiro Kawazome
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
library Merge_Sorter;
use     Merge_Sorter.Interface;
entity  Interface_Controller is
    generic (
        WAYS                :  integer :=    8;
        WORDS               :  integer :=    8;
        WORD_BITS           :  integer :=   64;
        STM_FEEDBACK        :  integer :=    1;
        STM_RD_DATA_BITS    :  integer :=   32;
        STM_WR_DATA_BITS    :  integer :=   32;
        REG_RW_ADDR_BITS    :  integer :=   64;
        REG_RW_MODE_BITS    :  integer :=   32;
        REG_SIZE_BITS       :  integer :=   32;
        REG_MODE_BITS       :  integer :=   16;
        REG_STAT_BITS       :  integer :=    6;
        MRG_RD_REG_PARAM    :  Interface.Regs_Field_Type := Interface.Default_Regs_Param;
        MRG_WR_REG_PARAM    :  Interface.Regs_Field_Type := Interface.Default_Regs_Param;
        STM_RD_REG_PARAM    :  Interface.Regs_Field_Type := Interface.Default_Regs_Param;
        STM_WR_REG_PARAM    :  Interface.Regs_Field_Type := Interface.Default_Regs_Param
    );
    port (
    -------------------------------------------------------------------------------
    -- Clock/Reset Signals.
    -------------------------------------------------------------------------------
        CLK                 :  in  std_logic;
        RST                 :  in  std_logic;
        CLR                 :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Register Interface
    -------------------------------------------------------------------------------
        REG_RD_ADDR_L       :  in  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_RD_ADDR_D       :  in  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_RD_ADDR_Q       :  out std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_WR_ADDR_L       :  in  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_WR_ADDR_D       :  in  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_WR_ADDR_Q       :  out std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_T0_ADDR_L       :  in  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_T0_ADDR_D       :  in  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_T0_ADDR_Q       :  out std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_T1_ADDR_L       :  in  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_T1_ADDR_D       :  in  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_T1_ADDR_Q       :  out std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_RD_MODE_L       :  in  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_RD_MODE_D       :  in  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_RD_MODE_Q       :  out std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_WR_MODE_L       :  in  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_WR_MODE_D       :  in  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_WR_MODE_Q       :  out std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_T0_MODE_L       :  in  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_T0_MODE_D       :  in  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_T0_MODE_Q       :  out std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_T1_MODE_L       :  in  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_T1_MODE_D       :  in  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_T1_MODE_Q       :  out std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_SIZE_L          :  in  std_logic_vector(REG_SIZE_BITS   -1 downto 0);
        REG_SIZE_D          :  in  std_logic_vector(REG_SIZE_BITS   -1 downto 0);
        REG_SIZE_Q          :  out std_logic_vector(REG_SIZE_BITS   -1 downto 0);
        REG_START_L         :  in  std_logic := '0';
        REG_START_D         :  in  std_logic := '0';
        REG_START_Q         :  out std_logic;
        REG_RESET_L         :  in  std_logic := '0';
        REG_RESET_D         :  in  std_logic := '0';
        REG_RESET_Q         :  out std_logic;
        REG_DONE_EN_L       :  in  std_logic := '0';
        REG_DONE_EN_D       :  in  std_logic := '0';
        REG_DONE_EN_Q       :  out std_logic;
        REG_DONE_ST_L       :  in  std_logic := '0';
        REG_DONE_ST_D       :  in  std_logic := '0';
        REG_DONE_ST_Q       :  out std_logic;
        REG_ERR_ST_L        :  in  std_logic := '0';
        REG_ERR_ST_D        :  in  std_logic := '0';
        REG_ERR_ST_Q        :  out std_logic;
        REG_MODE_L          :  in  std_logic_vector(REG_MODE_BITS   -1 downto 0) := (others => '0');
        REG_MODE_D          :  in  std_logic_vector(REG_MODE_BITS   -1 downto 0) := (others => '0');
        REG_MODE_Q          :  out std_logic_vector(REG_MODE_BITS   -1 downto 0);
        REG_STAT_L          :  in  std_logic_vector(REG_STAT_BITS   -1 downto 0) := (others => '0');
        REG_STAT_D          :  in  std_logic_vector(REG_STAT_BITS   -1 downto 0) := (others => '0');
        REG_STAT_Q          :  out std_logic_vector(REG_STAT_BITS   -1 downto 0);
        REG_STAT_I          :  in  std_logic_vector(REG_STAT_BITS   -1 downto 0) := (others => '0');
    -------------------------------------------------------------------------------
    -- Merge Sorter Core Control Interface
    -------------------------------------------------------------------------------
        STM_REQ_VALID       :  out std_logic;
        STM_REQ_READY       :  in  std_logic;
        STM_RES_VALID       :  in  std_logic;
        STM_RES_READY       :  out std_logic;
        MRG_REQ_VALID       :  out std_logic;
        MRG_REQ_READY       :  in  std_logic;
        MRG_RES_VALID       :  in  std_logic;
        MRG_RES_READY       :  out std_logic;
    -------------------------------------------------------------------------------
    -- Stream Reader Control Register Interface
    -------------------------------------------------------------------------------
        STM_RD_REG_L        :  out std_logic_vector(           STM_RD_REG_PARAM.BITS-1 downto 0);
        STM_RD_REG_D        :  out std_logic_vector(           STM_RD_REG_PARAM.BITS-1 downto 0);
        STM_RD_REG_Q        :  in  std_logic_vector(           STM_RD_REG_PARAM.BITS-1 downto 0);
        STM_RD_BUSY         :  in  std_logic;
        STM_RD_DONE         :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Stream Writer Control Register Interface
    -------------------------------------------------------------------------------
        STM_WR_REG_L        :  out std_logic_vector(           STM_WR_REG_PARAM.BITS-1 downto 0);
        STM_WR_REG_D        :  out std_logic_vector(           STM_WR_REG_PARAM.BITS-1 downto 0);
        STM_WR_REG_Q        :  in  std_logic_vector(           STM_WR_REG_PARAM.BITS-1 downto 0);
        STM_WR_BUSY         :  in  std_logic;
        STM_WR_DONE         :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Merge Reader Control Register Interface
    -------------------------------------------------------------------------------
        MRG_RD_REG_L        :  out std_logic_vector(WAYS*MRG_RD_REG_PARAM.BITS-1 downto 0);
        MRG_RD_REG_D        :  out std_logic_vector(WAYS*MRG_RD_REG_PARAM.BITS-1 downto 0);
        MRG_RD_REG_Q        :  in  std_logic_vector(WAYS*MRG_RD_REG_PARAM.BITS-1 downto 0);
        MRG_RD_BUSY         :  in  std_logic_vector(WAYS                      -1 downto 0);
        MRG_RD_DONE         :  in  std_logic_vector(WAYS                      -1 downto 0);
    -------------------------------------------------------------------------------
    -- Merge Writer Control Register Interface
    -------------------------------------------------------------------------------
        MRG_WR_REG_L        :  out std_logic_vector(           MRG_WR_REG_PARAM.BITS-1 downto 0);
        MRG_WR_REG_D        :  out std_logic_vector(           MRG_WR_REG_PARAM.BITS-1 downto 0);
        MRG_WR_REG_Q        :  in  std_logic_vector(           MRG_WR_REG_PARAM.BITS-1 downto 0);
        MRG_WR_BUSY         :  in  std_logic;
        MRG_WR_DONE         :  in  std_logic
    );
end Interface_Controller;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library Merge_Sorter;
use     Merge_Sorter.Interface;
architecture RTL of Interface_Controller is
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    constant STM_RD_DATA_BYTES   :  integer := STM_RD_DATA_BITS/8;
    constant STM_WR_DATA_BYTES   :  integer := STM_WR_DATA_BITS/8;
    constant WORD_BYTES          :  integer := WORD_BITS/8;
    constant SIZE_BITS           :  integer := REG_SIZE_BITS+1;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   sort_block_size     :  unsigned(SIZE_BITS-1 downto 0);
    signal   sort_total_size     :  unsigned(SIZE_BITS-1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   stm_core_request    :  boolean;
    signal   stm_core_running    :  boolean;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   mrg_core_request    :  boolean;
    signal   mrg_core_running    :  boolean;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   stm_reader_request  :  boolean;
    signal   stm_reader_running  :  boolean;
    signal   stm_reader_addr     :  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
    signal   stm_reader_mode     :  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   stm_writer_request  :  boolean;
    signal   stm_writer_running  :  boolean;
    signal   stm_writer_addr     :  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
    signal   stm_writer_mode     :  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   mrg_reader_request  :  boolean;
    signal   mrg_reader_running  :  boolean;
    signal   mrg_reader_xsize    :  unsigned(SIZE_BITS-1 downto 0);
    signal   mrg_reader_addr     :  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
    signal   mrg_reader_mode     :  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
    signal   mrg_reader_busy     :  std_logic_vector(WAYS-1 downto 0);
    constant MRG_READER_ALL_IDLE :  std_logic_vector(WAYS-1 downto 0) := (others => '0');
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   mrg_writer_request  :  boolean;
    signal   mrg_writer_running  :  boolean;
    signal   mrg_writer_addr     :  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
    signal   mrg_writer_mode     :  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   tmp_0_base_addr     :  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
    signal   tmp_1_base_addr     :  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
    signal   tmp_0_xfer_mode     :  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
    signal   tmp_1_xfer_mode     :  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   done_en_bit         :  std_logic;
    signal   done_bit            :  std_logic;
    signal   error_bit           :  std_logic;
    signal   reset_bit           :  std_logic;
    signal   size_regs           :  std_logic_vector(REG_SIZE_BITS-1 downto 0);
    signal   mode_regs           :  std_logic_vector(REG_MODE_BITS-1 downto 0);
    signal   stat_regs           :  std_logic_vector(REG_STAT_BITS-1 downto 0);
begin
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    process (CLK, RST) begin
        if (RST = '1') then
                reset_bit <= '0';
        elsif (CLK'event and CLK = '1') then
            if (CLR = '1') then
                reset_bit <= '0';
            elsif (REG_RESET_L = '1') then
                reset_bit <= REG_RESET_D;
            end if;
        end if;
    end process;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    process (CLK, RST) begin
        if (RST = '1') then
                stm_reader_addr <= (others => '0');
                stm_reader_mode <= (others => '0');
                stm_writer_addr <= (others => '0');
                stm_writer_mode <= (others => '0');
                tmp_0_base_addr <= (others => '0');
                tmp_0_xfer_mode <= (others => '0');
                tmp_1_base_addr <= (others => '0');
                tmp_1_xfer_mode <= (others => '0');
                size_regs       <= (others => '0');
                mode_regs       <= (others => '0');
        elsif (CLK'event and CLK = '1') then
            if (CLR = '1' or reset_bit = '1') then
                stm_reader_addr <= (others => '0');
                stm_reader_mode <= (others => '0');
                stm_writer_addr <= (others => '0');
                stm_writer_mode <= (others => '0');
                tmp_0_base_addr <= (others => '0');
                tmp_0_xfer_mode <= (others => '0');
                tmp_1_base_addr <= (others => '0');
                tmp_1_xfer_mode <= (others => '0');
                size_regs       <= (others => '0');
                mode_regs       <= (others => '0');
            else
                for i in stm_reader_addr'range loop
                    if (REG_RD_ADDR_L(i) = '1') then
                        stm_reader_addr(i) <= REG_RD_ADDR_D(i);
                    end if;
                end loop;
                for i in stm_reader_mode'range loop
                    if (REG_RD_MODE_L(i) = '1') then
                        stm_reader_mode(i) <= REG_RD_MODE_D(i);
                    end if;
                end loop;
                for i in stm_writer_addr'range loop
                    if (REG_WR_ADDR_L(i) = '1') then
                        stm_writer_addr(i) <= REG_WR_ADDR_D(i);
                    end if;
                end loop;
                for i in stm_writer_mode'range loop
                    if (REG_WR_MODE_L(i) = '1') then
                        stm_writer_mode(i) <= REG_WR_MODE_D(i);
                    end if;
                end loop;
                for i in tmp_0_base_addr'range loop
                    if (REG_T0_ADDR_L(i) = '1') then
                        tmp_0_base_addr(i) <= REG_T0_ADDR_D(i);
                    end if;
                end loop;
                for i in tmp_0_xfer_mode'range loop
                    if (REG_T0_MODE_L(i) = '1') then
                        tmp_0_xfer_mode(i) <= REG_T0_MODE_D(i);
                    end if;
                end loop;
                for i in tmp_1_base_addr'range loop
                    if (REG_T1_ADDR_L(i) = '1') then
                        tmp_1_base_addr(i) <= REG_T1_ADDR_D(i);
                    end if;
                end loop;
                for i in tmp_1_xfer_mode'range loop
                    if (REG_T1_MODE_L(i) = '1') then
                        tmp_1_xfer_mode(i) <= REG_T1_MODE_D(i);
                    end if;
                end loop;
                for i in size_regs'range loop
                    if (REG_SIZE_L(i) = '1') then
                        size_regs(i) <= REG_SIZE_D(i);
                    end if;
                end loop;
                for i in mode_regs'range loop
                    if (REG_MODE_L(i) = '1') then
                        mode_regs(i) <= REG_MODE_D(i);
                    end if;
                end loop;
            end if;
        end if;
    end process;
    REG_RD_ADDR_Q <= stm_reader_addr;
    REG_RD_MODE_Q <= stm_reader_mode;
    REG_WR_ADDR_Q <= stm_writer_addr;
    REG_WR_MODE_Q <= stm_writer_mode;
    REG_T0_ADDR_Q <= tmp_0_base_addr;
    REG_T0_MODE_Q <= tmp_0_xfer_mode;
    REG_T1_ADDR_Q <= tmp_1_base_addr;
    REG_T1_MODE_Q <= tmp_1_xfer_mode;
    REG_SIZE_Q    <= size_regs;
    REG_RESET_Q   <= reset_bit;
    REG_DONE_EN_Q <= done_en_bit;
    REG_DONE_ST_Q <= done_bit;
    REG_ERR_ST_Q  <= '0';
    REG_MODE_Q    <= mode_regs;
    REG_STAT_Q    <= stat_regs;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    MAIN_CTRL: block
        type     MAIN_STATE_TYPE     is (IDLE_STATE, DONE_STATE, 
                                         STM_RD_CHK_STATE, STM_RD_REQ_STATE, STM_RD_RUN_STATE, STM_RD_END_STATE,
                                         MRG_RD_CHK_STATE, MRG_RD_REQ_STATE, MRG_RD_RUN_STATE, MRG_RD_END_STATE);
        signal   curr_state          :  MAIN_STATE_TYPE;
        signal   last_proc           :  boolean;
        signal   stm_writer_on       :  boolean;
        signal   mrg_writer_on       :  boolean;
        signal   core_running        :  boolean;
        signal   writer_running      :  boolean;
    begin 
        process (CLK, RST)
            variable  next_state     :  MAIN_STATE_TYPE;
        begin
            if (RST = '1') then
                    curr_state       <= IDLE_STATE;
                    last_proc        <= FALSE;
                    stm_writer_on    <= FALSE;
                    mrg_writer_on    <= FALSE;
                    mrg_reader_xsize <= (others => '0');
                    sort_block_size  <= (others => '0');
                    sort_total_size  <= (others => '0');
                    mrg_reader_addr  <= (others => '0');
                    mrg_reader_mode  <= (others => '0');
                    mrg_writer_addr  <= (others => '0');
                    mrg_writer_mode  <= (others => '0');
                    stat_regs        <= (others => '0');
                    done_en_bit      <= '0';
                    done_bit         <= '0';
                    error_bit        <= '0';
                    REG_START_Q      <= '0';
            elsif (CLK'event and CLK = '1') then
                if (CLR = '1' or reset_bit = '1') then
                    curr_state       <= IDLE_STATE;
                    last_proc        <= FALSE;
                    stm_writer_on    <= FALSE;
                    mrg_writer_on    <= FALSE;
                    mrg_reader_xsize <= (others => '0');
                    sort_block_size  <= (others => '0');
                    sort_total_size  <= (others => '0');
                    mrg_reader_addr  <= (others => '0');
                    mrg_reader_mode  <= (others => '0');
                    mrg_writer_addr  <= (others => '0');
                    mrg_writer_mode  <= (others => '0');
                    stat_regs        <= (others => '0');
                    done_en_bit      <= '0';
                    done_bit         <= '0';
                    error_bit        <= '0';
                    REG_START_Q      <= '0';
                else
                    case curr_state is
                        when IDLE_STATE =>
                            if (REG_START_L = '1' and REG_START_D = '1') then
                                next_state := STM_RD_CHK_STATE;
                            else
                                next_state := IDLE_STATE;
                            end if;
                            last_proc       <= FALSE;
                            stm_writer_on   <= FALSE;
                            mrg_writer_on   <= FALSE;
                            mrg_reader_addr <= tmp_1_base_addr;
                            mrg_reader_mode <= tmp_1_xfer_mode;
                            mrg_writer_addr <= tmp_0_base_addr;
                            mrg_writer_mode <= tmp_0_xfer_mode;
                            sort_total_size <= resize     (unsigned(size_regs)           , sort_total_size'length);
                            sort_block_size <= to_unsigned(WORDS*(WAYS**(STM_FEEDBACK+1)), sort_block_size'length);
                        when STM_RD_CHK_STATE =>
                            next_state  := STM_RD_REQ_STATE;
                            if (sort_block_size >= sort_total_size) then
                                last_proc     <= TRUE;
                                stm_writer_on <= TRUE;
                                mrg_writer_on <= FALSE;
                            else
                                last_proc     <= FALSE;
                                stm_writer_on <= FALSE;
                                mrg_writer_on <= TRUE;
                            end if;
                        when STM_RD_REQ_STATE =>
                            next_state := STM_RD_RUN_STATE;
                        when STM_RD_RUN_STATE =>
                            if (stm_reader_running or core_running or writer_running) then
                                next_state := STM_RD_RUN_STATE;
                            else
                                next_state := STM_RD_END_STATE;
                            end if;
                        when STM_RD_END_STATE =>
                            if (last_proc = TRUE) then
                                next_state := DONE_STATE;
                            else
                                next_state := MRG_RD_CHK_STATE;
                            end if;
                            mrg_reader_xsize <= resize(sort_block_size     , mrg_reader_xsize'length);
                            sort_block_size  <= resize(sort_block_size*WAYS, sort_block_size 'length);
                        when MRG_RD_CHK_STATE =>
                            next_state := MRG_RD_REQ_STATE;
                            if (sort_block_size >= sort_total_size) then
                                last_proc     <= TRUE;
                                stm_writer_on <= TRUE;
                                mrg_writer_on <= FALSE;
                            else
                                last_proc     <= FALSE;
                                stm_writer_on <= FALSE;
                                mrg_writer_on <= TRUE;
                            end if;
                            mrg_reader_addr <= mrg_writer_addr;
                            mrg_reader_mode <= mrg_writer_mode;
                            mrg_writer_addr <= mrg_reader_addr;
                            mrg_writer_mode <= mrg_reader_mode;
                        when MRG_RD_REQ_STATE =>
                            next_state := MRG_RD_RUN_STATE;
                        when MRG_RD_RUN_STATE =>
                            if (mrg_reader_running or core_running or writer_running) then
                                next_state := MRG_RD_RUN_STATE;
                            else
                                next_state := MRG_RD_END_STATE;
                            end if;
                        when MRG_RD_END_STATE =>
                            if (last_proc = TRUE) then
                                next_state := DONE_STATE;
                            else
                                next_state := MRG_RD_CHK_STATE;
                            end if;
                            mrg_reader_xsize <= resize(sort_block_size     , mrg_reader_xsize'length);
                            sort_block_size  <= resize(sort_block_size*WAYS, sort_block_size 'length);
                        when DONE_STATE =>
                            next_state := IDLE_STATE;
                    end case;
                    curr_state <= next_state;
                    if (next_state /= IDLE_STATE) then
                        REG_START_Q <= '1';
                    else
                        REG_START_Q <= '0';
                    end if;
                    if    (reset_bit = '1') then
                        done_en_bit  <= '0';
                    elsif (REG_DONE_EN_L  = '1') then
                        done_en_bit  <= REG_DONE_EN_D;
                    end if;
                    if    (reset_bit = '1') then
                        done_bit  <= '0';
                    elsif (done_en_bit = '1' and next_state = DONE_STATE) then
                         done_bit  <= '1';
                    elsif (REG_DONE_ST_L  = '1' and REG_DONE_ST_D = '0') then
                         done_bit  <= '0';
                    end if;
                    if    (reset_bit = '1') then
                        stat_regs <= (others => '0');
                    else
                        for i in stat_regs'range loop
                            if    (REG_STAT_L(i) = '1' and REG_STAT_D(i) = '0') then
                                stat_regs(i) <= '0';
                            elsif (REG_STAT_I(i) = '1') then
                                stat_regs(i) <= '1';
                            end if;
                        end loop;
                    end if;
                end if;
            end if;
        end process;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        stm_core_request   <= ((curr_state = STM_RD_REQ_STATE));
        stm_reader_request <= ((curr_state = STM_RD_REQ_STATE));
        mrg_core_request   <= ((curr_state = MRG_RD_REQ_STATE));
        mrg_reader_request <= ((curr_state = MRG_RD_REQ_STATE));
        stm_writer_request <= ((curr_state = STM_RD_REQ_STATE and stm_writer_on) or
                               (curr_state = MRG_RD_REQ_STATE and stm_writer_on));
        mrg_writer_request <= ((curr_state = STM_RD_REQ_STATE and mrg_writer_on) or
                               (curr_state = MRG_RD_REQ_STATE and mrg_writer_on));
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        core_running       <= ((stm_writer_on and stm_core_running  ) or
                               (mrg_writer_on and mrg_core_running  ));
        writer_running     <= ((stm_writer_on and stm_writer_running) or
                               (mrg_writer_on and mrg_writer_running));
        mrg_reader_running <= (mrg_reader_busy /= MRG_READER_ALL_IDLE);
    end block;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    STM_CORE_CTRL: block
        type     STATE_TYPE     is (IDLE_STATE, REQ_STATE, RES_STATE, DONE_STATE);
        signal   curr_state     :  STATE_TYPE;
    begin
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (CLK, RST) begin
            if (RST = '1') then
                    curr_state  <= IDLE_STATE;
            elsif (CLK'event and CLK = '1') then
                if (CLR = '1' or reset_bit = '1') then
                    curr_state  <= IDLE_STATE;
                else
                    case curr_state is
                        when IDLE_STATE =>
                            if (stm_core_request = TRUE) then
                                curr_state <= REQ_STATE;
                            else
                                curr_state <= IDLE_STATE;
                            end if;
                        when REQ_STATE =>
                            if (STM_REQ_READY = '1') then
                                curr_state <= RES_STATE;
                            else
                                curr_state <= REQ_STATE;
                            end if;
                        when RES_STATE =>
                            if (STM_RES_VALID = '1') then
                                curr_state <= DONE_STATE;
                            else
                                curr_state <= RES_STATE;
                            end if;
                        when DONE_STATE =>
                                curr_state <= IDLE_STATE;
                        when others =>
                                curr_state <= IDLE_STATE;
                    end case;
                end if;
            end if;
        end process;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        stm_core_running <= ((curr_state = REQ_STATE) or
                             (curr_state = RES_STATE));
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        STM_REQ_VALID <= '1' when (curr_state = REQ_STATE) else '0';
        STM_RES_READY <= '1' when (curr_state = RES_STATE) else '0';
    end block;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    MRG_CORE_CTRL: block
        type     STATE_TYPE     is (IDLE_STATE, REQ_STATE, RES_STATE, DONE_STATE);
        signal   curr_state     :  STATE_TYPE;
    begin
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (CLK, RST) begin
            if (RST = '1') then
                    curr_state  <= IDLE_STATE;
            elsif (CLK'event and CLK = '1') then
                if (CLR = '1' or reset_bit = '1') then
                    curr_state  <= IDLE_STATE;
                else
                    case curr_state is
                        when IDLE_STATE =>
                            if (mrg_core_request = TRUE) then
                                curr_state <= REQ_STATE;
                            else
                                curr_state <= IDLE_STATE;
                            end if;
                        when REQ_STATE =>
                            if (MRG_REQ_READY = '1') then
                                curr_state <= RES_STATE;
                            else
                                curr_state <= REQ_STATE;
                            end if;
                        when RES_STATE =>
                            if (MRG_RES_VALID = '1') then
                                curr_state <= DONE_STATE;
                            else
                                curr_state <= RES_STATE;
                            end if;
                        when DONE_STATE =>
                                curr_state <= IDLE_STATE;
                        when others =>
                                curr_state <= IDLE_STATE;
                    end case;
                end if;
            end if;
        end process;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        mrg_core_running <= ((curr_state = REQ_STATE) or
                             (curr_state = RES_STATE));
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        MRG_REQ_VALID <= '1' when (curr_state = REQ_STATE) else '0';
        MRG_RES_READY <= '1' when (curr_state = RES_STATE) else '0';
    end block;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    STM_RD_CTRL: block
        type     STATE_TYPE     is (IDLE_STATE, REQ_STATE, RUN0_STATE, RUN1_STATE, DONE_STATE);
        signal   curr_state     :  STATE_TYPE;
        signal   read_addr      :  unsigned(STM_RD_REG_PARAM.ADDR_BITS-1 downto 0);
        signal   read_bytes     :  unsigned(STM_RD_REG_PARAM.SIZE_BITS-1 downto 0);
        signal   reg_data       :  std_logic_vector(STM_RD_REG_PARAM.BITS-1 downto 0);
        signal   reg_load       :  std_logic_vector(STM_RD_REG_PARAM.BITS-1 downto 0);
    begin
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (CLK, RST) begin
            if (RST = '1') then
                    curr_state  <= IDLE_STATE;
                    read_addr   <= (others => '0');
                    read_bytes  <= (others => '0');
            elsif (CLK'event and CLK = '1') then
                if (CLR = '1' or reset_bit = '1') then
                    curr_state  <= IDLE_STATE;
                    read_addr   <= (others => '0');
                    read_bytes  <= (others => '0');
                else
                    case curr_state is
                        when IDLE_STATE =>
                            if (stm_reader_request = TRUE) then
                                curr_state <= REQ_STATE;
                            else
                                curr_state <= IDLE_STATE;
                            end if;
                            read_addr  <= resize(unsigned(stm_reader_addr)        , read_addr 'length);
                            read_bytes <= resize(sort_total_size*STM_RD_DATA_BYTES, read_bytes'length);
                        when REQ_STATE =>
                                curr_state <= RUN0_STATE;
                        when RUN0_STATE =>
                            if    (STM_RD_DONE = '1') then
                                curr_state <= DONE_STATE;
                            elsif (STM_RD_BUSY = '1') then
                                curr_state <= RUN1_STATE;
                            else
                                curr_state <= RUN0_STATE;
                            end if;
                        when RUN1_STATE =>
                            if    (STM_RD_DONE = '1') then
                                curr_state <= DONE_STATE;
                            elsif (STM_RD_BUSY = '1') then
                                curr_state <= RUN1_STATE;
                            else
                                curr_state <= DONE_STATE;
                            end if;
                        when DONE_STATE =>
                                curr_state <= IDLE_STATE;
                    end case;
                end if;
            end if;
        end process;
        ---------------------------------------------------------------------------
        -- stm_reader_running
        ---------------------------------------------------------------------------
        stm_reader_running <= ((curr_state = REQ_STATE ) or
                               (curr_state = RUN0_STATE) or
                               (curr_state = RUN1_STATE));
        ---------------------------------------------------------------------------
        -- reg_data
        ---------------------------------------------------------------------------
        process (reset_bit, read_addr, read_bytes, stm_reader_mode) begin
            reg_data <= (others => '0');
            reg_data(STM_RD_REG_PARAM.ADDR_HI downto STM_RD_REG_PARAM.ADDR_LO) <= std_logic_vector(read_addr);
            reg_data(STM_RD_REG_PARAM.SIZE_HI downto STM_RD_REG_PARAM.SIZE_LO) <= std_logic_vector(read_bytes);
            reg_data(STM_RD_REG_PARAM.MODE_HI downto STM_RD_REG_PARAM.MODE_LO) <= std_logic_vector(resize(unsigned(stm_reader_mode), STM_RD_REG_PARAM.MODE_BITS));
            reg_data(STM_RD_REG_PARAM.STAT_HI downto STM_RD_REG_PARAM.STAT_LO) <= (STM_RD_REG_PARAM.STAT_HI downto STM_RD_REG_PARAM.STAT_LO => '0');
            reg_data(STM_RD_REG_PARAM.CTRL_RESET_POS) <= reset_bit;
            reg_data(STM_RD_REG_PARAM.CTRL_PAUSE_POS) <= '0';
            reg_data(STM_RD_REG_PARAM.CTRL_STOP_POS ) <= '0';
            reg_data(STM_RD_REG_PARAM.CTRL_START_POS) <= '1';
            reg_data(STM_RD_REG_PARAM.CTRL_FIRST_POS) <= '1';
            reg_data(STM_RD_REG_PARAM.CTRL_LAST_POS ) <= '1';
            reg_data(STM_RD_REG_PARAM.CTRL_DONE_POS ) <= '1';
            reg_data(STM_RD_REG_PARAM.CTRL_EBLK_POS ) <= '0';
        end process;
        ---------------------------------------------------------------------------
        -- reg_load
        ---------------------------------------------------------------------------
        process (curr_state, reset_bit) begin
            if (curr_state = REQ_STATE) then
                reg_load <= (others => '1');
            else
                reg_load <= (others => '0');
                reg_load(STM_RD_REG_PARAM.CTRL_RESET_POS) <= reset_bit;
            end if;
        end process;
        ---------------------------------------------------------------------------
        -- STM_RD_REG_L
        -- STM_RD_REG_D
        ---------------------------------------------------------------------------
        STM_RD_REG_L <= reg_load;
        STM_RD_REG_D <= reg_data;
    end block;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    MRG_RD_CTRL: for channel in 0 to WAYS-1 generate
        type     STATE_TYPE     is (IDLE_STATE, S0_STATE, S1_STATE, S2_STATE, REQ_STATE, RUN_STATE);
        signal   curr_state     :  STATE_TYPE;
        signal   curr_base      :  unsigned(SIZE_BITS-1 downto 0);
        signal   next_base      :  unsigned(SIZE_BITS-1 downto 0);
        signal   offset         :  unsigned(SIZE_BITS-1 downto 0);
        signal   offset_size    :  unsigned(SIZE_BITS-1 downto 0);
        signal   remain_size    :  unsigned(SIZE_BITS-1 downto 0);
        signal   remain_zero    :  boolean;
        signal   read_addr      :  unsigned(MRG_RD_REG_PARAM.ADDR_BITS-1 downto 0);
        signal   read_bytes     :  unsigned(MRG_RD_REG_PARAM.SIZE_BITS-1 downto 0);
        signal   read_last      :  boolean;
        type     READER_STATE_TYPE is (READER_IDLE, READER_RUN0, READER_RUN1);
        signal   reader_state   :  READER_STATE_TYPE;
        signal   reg_data       :  std_logic_vector(MRG_RD_REG_PARAM.BITS-1 downto 0);
        signal   reg_load       :  std_logic_vector(MRG_RD_REG_PARAM.BITS-1 downto 0);
    begin
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (CLK, RST) begin
            if (RST = '1') then
                    curr_state  <= IDLE_STATE;
                    curr_base   <= (others => '0');
                    next_base   <= (others => '0');
                    offset      <= (others => '0');
                    offset_size <= (others => '0');
                    remain_zero <= FALSE;
                    remain_size <= (others => '0');
                    read_addr   <= (others => '0');
                    read_bytes  <= (others => '0');
                    read_last   <= FALSE;
            elsif (CLK'event and CLK = '1') then
                if (CLR = '1' or reset_bit = '1') then
                    curr_state  <= IDLE_STATE;
                    curr_base   <= (others => '0');
                    next_base   <= (others => '0');
                    offset      <= (others => '0');
                    offset_size <= (others => '0');
                    remain_zero <= FALSE;
                    remain_size <= (others => '0');
                    read_addr   <= (others => '0');
                    read_bytes  <= (others => '0');
                    read_last   <= FALSE;
                else
                    case curr_state is
                        when IDLE_STATE =>
                            if (mrg_reader_request = TRUE) then
                                curr_state <= S0_STATE;
                            else
                                curr_state <= IDLE_STATE;
                            end if;
                            curr_base    <= (others => '0');
                            next_base    <= sort_block_size;
                            offset       <= (others => '0');
                            offset_size  <= resize(channel * mrg_reader_xsize, offset_size'length);
                            remain_zero  <= FALSE;
                            remain_size  <= (others => '0');
                            read_addr    <= (others => '0');
                            read_bytes   <= (others => '0');
                            read_last    <= FALSE;
                        when S0_STATE =>
                            curr_state   <= S1_STATE;
                            offset       <= resize(curr_base + offset_size, offset'length);
                            read_last    <= (sort_total_size <= next_base);
                        when S1_STATE =>
                            curr_state   <= S2_STATE;
                            if (offset > sort_total_size) then
                                remain_zero <= TRUE;
                                remain_size <= (others => '0');
                            else
                                remain_zero <= FALSE;
                                remain_size <= resize(sort_total_size - offset, remain_size'length);
                            end if;
                        when S2_STATE =>
                            if (reader_state = READER_IDLE) then
                                curr_state <= REQ_STATE;
                            else
                                curr_state <= S2_STATE;
                            end if;
                            if (remain_zero = TRUE) or
                               (remain_size <= mrg_reader_xsize) then
                                read_bytes <= resize(remain_size      * WORD_BYTES, read_bytes'length);
                            else
                                read_bytes <= resize(mrg_reader_xsize * WORD_BYTES, read_bytes'length);
                            end if;
                            read_addr <= resize(unsigned(mrg_reader_addr) + offset*WORD_BYTES, read_addr'length);
                        when REQ_STATE =>
                            if    (read_last = TRUE) then
                                curr_state <= RUN_STATE;
                            else
                                curr_state <= S0_STATE;
                                curr_base  <= next_base;
                                next_base  <= resize(next_base + sort_block_size, next_base'length);
                            end if;
                        when RUN_STATE =>
                            if (reader_state = READER_IDLE) then
                                curr_state <= IDLE_STATE;
                            else
                                curr_state <= RUN_STATE;
                            end if;
                    end case;
                end if;
            end if;
        end process;
        ---------------------------------------------------------------------------
        -- mrg_reader_busy
        ---------------------------------------------------------------------------
        mrg_reader_busy(channel) <= '1' when (curr_state /= IDLE_STATE) else '0';
        ---------------------------------------------------------------------------
        -- reader_state
        ---------------------------------------------------------------------------
        process (CLK, RST) begin
            if (RST = '1') then
                    reader_state <= READER_IDLE;
            elsif (CLK'event and CLK = '1') then
                if (CLR = '1') then
                    reader_state <= READER_IDLE;
                else
                    case reader_state is
                        when READER_IDLE =>
                            if (curr_state = REQ_STATE) then
                                reader_state <= READER_RUN0;
                            else
                                reader_state <= READER_IDLE;
                            end if;
                        when READER_RUN0 =>
                            if    (MRG_RD_DONE(channel) = '1') then
                                reader_state <= READER_IDLE;
                            elsif (MRG_RD_BUSY(channel) = '1') then
                                reader_state <= READER_RUN1;
                            else
                                reader_state <= READER_RUN0;
                            end if;
                        when READER_RUN1 =>
                            if    (MRG_RD_DONE(channel) = '1') then
                                reader_state <= READER_IDLE;
                            elsif (MRG_RD_BUSY(channel) = '1') then
                                reader_state <= READER_RUN1;
                            else
                                reader_state <= READER_IDLE;
                            end if;
                        when others =>
                                reader_state <= READER_IDLE;
                    end case;
                end if;
            end if;
        end process;
        ---------------------------------------------------------------------------
        -- reg_data
        ---------------------------------------------------------------------------
        process (read_addr, read_bytes, read_last, mrg_reader_mode, reset_bit) begin
            reg_data <= (others => '0');
            reg_data(MRG_RD_REG_PARAM.ADDR_HI downto MRG_RD_REG_PARAM.ADDR_LO) <= std_logic_vector(read_addr);
            reg_data(MRG_RD_REG_PARAM.SIZE_HI downto MRG_RD_REG_PARAM.SIZE_LO) <= std_logic_vector(read_bytes);
            reg_data(MRG_RD_REG_PARAM.MODE_HI downto MRG_RD_REG_PARAM.MODE_LO) <= std_logic_vector(resize(unsigned(mrg_reader_mode), MRG_RD_REG_PARAM.MODE_BITS));
            reg_data(MRG_RD_REG_PARAM.STAT_HI downto MRG_RD_REG_PARAM.STAT_LO) <= (MRG_RD_REG_PARAM.STAT_HI downto MRG_RD_REG_PARAM.STAT_LO => '0');
            reg_data(MRG_RD_REG_PARAM.CTRL_RESET_POS) <= reset_bit;
            reg_data(MRG_RD_REG_PARAM.CTRL_PAUSE_POS) <= '0';
            reg_data(MRG_RD_REG_PARAM.CTRL_STOP_POS ) <= '0';
            reg_data(MRG_RD_REG_PARAM.CTRL_START_POS) <= '1';
            reg_data(MRG_RD_REG_PARAM.CTRL_FIRST_POS) <= '1';
            reg_data(MRG_RD_REG_PARAM.CTRL_LAST_POS ) <= '1';
            if (read_last = TRUE) then
                reg_data(MRG_RD_REG_PARAM.CTRL_DONE_POS ) <= '1';
                reg_data(MRG_RD_REG_PARAM.CTRL_EBLK_POS ) <= '1';
            else
                reg_data(MRG_RD_REG_PARAM.CTRL_DONE_POS ) <= '0';
                reg_data(MRG_RD_REG_PARAM.CTRL_EBLK_POS ) <= '0';
            end if;
        end process;
        ---------------------------------------------------------------------------
        -- reg_load
        ---------------------------------------------------------------------------
        process (curr_state, reset_bit) begin
            if (curr_state = REQ_STATE) then
                reg_load <= (others => '1');
            else
                reg_load <= (others => '0');
                reg_load(MRG_RD_REG_PARAM.CTRL_RESET_POS) <= reset_bit;
            end if;
        end process;
        ---------------------------------------------------------------------------
        -- MRG_RD_REG_L
        -- MRG_RD_REG_D
        ---------------------------------------------------------------------------
        MRG_RD_REG_L((channel+1)*MRG_RD_REG_PARAM.BITS-1 downto channel*MRG_RD_REG_PARAM.BITS) <= reg_load;
        MRG_RD_REG_D((channel+1)*MRG_RD_REG_PARAM.BITS-1 downto channel*MRG_RD_REG_PARAM.BITS) <= reg_data;
    end generate;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    STM_WR_CTRL: block
        type     STATE_TYPE     is (IDLE_STATE, REQ_STATE, RUN0_STATE, RUN1_STATE, DONE_STATE);
        signal   curr_state     :  STATE_TYPE;
        signal   write_addr     :  unsigned(STM_WR_REG_PARAM.ADDR_BITS-1 downto 0);
        signal   write_bytes    :  unsigned(STM_WR_REG_PARAM.SIZE_BITS-1 downto 0);
        signal   reg_data       :  std_logic_vector(STM_WR_REG_PARAM.BITS-1 downto 0);
        signal   reg_load       :  std_logic_vector(STM_WR_REG_PARAM.BITS-1 downto 0);
    begin
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (CLK, RST) begin
            if (RST = '1') then
                    curr_state  <= IDLE_STATE;
                    write_addr  <= (others => '0');
                    write_bytes <= (others => '0');
            elsif (CLK'event and CLK = '1') then
                if (CLR = '1' or reset_bit = '1') then
                    curr_state  <= IDLE_STATE;
                    write_addr  <= (others => '0');
                    write_bytes <= (others => '0');
                else
                    case curr_state is
                        when IDLE_STATE =>
                            if (stm_writer_request = TRUE) then
                                curr_state <= REQ_STATE;
                            else
                                curr_state <= IDLE_STATE;
                            end if;
                            write_addr  <= resize(unsigned(stm_writer_addr)        , write_addr 'length);
                            write_bytes <= resize(sort_total_size*STM_WR_DATA_BYTES, write_bytes'length);
                        when REQ_STATE =>
                                curr_state <= RUN0_STATE;
                        when RUN0_STATE =>
                            if    (STM_WR_DONE = '1') then
                                curr_state <= DONE_STATE;
                            elsif (STM_WR_BUSY = '1') then
                                curr_state <= RUN1_STATE;
                            else
                                curr_state <= RUN0_STATE;
                            end if;
                        when RUN1_STATE =>
                            if    (STM_WR_DONE = '1') then
                                curr_state <= DONE_STATE;
                            elsif (STM_WR_BUSY = '1') then
                                curr_state <= RUN1_STATE;
                            else
                                curr_state <= DONE_STATE;
                            end if;
                        when DONE_STATE =>
                                curr_state <= IDLE_STATE;
                    end case;
                end if;
            end if;
        end process;
        ---------------------------------------------------------------------------
        -- stm_writer_running
        ---------------------------------------------------------------------------
        stm_writer_running <= ((curr_state = REQ_STATE ) or
                               (curr_state = RUN0_STATE) or
                               (curr_state = RUN1_STATE));
        ---------------------------------------------------------------------------
        -- reg_data
        ---------------------------------------------------------------------------
        process (reset_bit, write_addr, write_bytes, stm_writer_mode) begin
            reg_data <= (others => '0');
            reg_data(STM_WR_REG_PARAM.ADDR_HI downto STM_WR_REG_PARAM.ADDR_LO) <= std_logic_vector(write_addr);
            reg_data(STM_WR_REG_PARAM.SIZE_HI downto STM_WR_REG_PARAM.SIZE_LO) <= std_logic_vector(write_bytes);
            reg_data(STM_WR_REG_PARAM.MODE_HI downto STM_WR_REG_PARAM.MODE_LO) <= std_logic_vector(resize(unsigned(stm_writer_mode), STM_WR_REG_PARAM.MODE_BITS));
            reg_data(STM_WR_REG_PARAM.STAT_HI downto STM_WR_REG_PARAM.STAT_LO) <= (STM_WR_REG_PARAM.STAT_HI downto STM_WR_REG_PARAM.STAT_LO => '0');
            reg_data(STM_WR_REG_PARAM.CTRL_RESET_POS) <= reset_bit;
            reg_data(STM_WR_REG_PARAM.CTRL_PAUSE_POS) <= '0';
            reg_data(STM_WR_REG_PARAM.CTRL_STOP_POS ) <= '0';
            reg_data(STM_WR_REG_PARAM.CTRL_START_POS) <= '1';
            reg_data(STM_WR_REG_PARAM.CTRL_FIRST_POS) <= '1';
            reg_data(STM_WR_REG_PARAM.CTRL_LAST_POS ) <= '1';
            reg_data(STM_WR_REG_PARAM.CTRL_DONE_POS ) <= '1';
            reg_data(STM_WR_REG_PARAM.CTRL_EBLK_POS ) <= '0';
        end process;
        ---------------------------------------------------------------------------
        -- reg_load
        ---------------------------------------------------------------------------
        process (curr_state, reset_bit) begin
            if (curr_state = REQ_STATE) then
                reg_load <= (others => '1');
            else
                reg_load <= (others => '0');
                reg_load(STM_WR_REG_PARAM.CTRL_RESET_POS) <= reset_bit;
            end if;
        end process;
        ---------------------------------------------------------------------------
        -- STM_WR_REG_L
        -- STM_WR_REG_D
        ---------------------------------------------------------------------------
        STM_WR_REG_L <= reg_load;
        STM_WR_REG_D <= reg_data;
    end block;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    MRG_WR_CTRL: block
        type     STATE_TYPE     is (IDLE_STATE, REQ_STATE, RUN0_STATE, RUN1_STATE, DONE_STATE);
        signal   curr_state     :  STATE_TYPE;
        signal   write_addr     :  unsigned(MRG_WR_REG_PARAM.ADDR_BITS-1 downto 0);
        signal   write_bytes    :  unsigned(MRG_WR_REG_PARAM.SIZE_BITS-1 downto 0);
        signal   reg_data       :  std_logic_vector(MRG_WR_REG_PARAM.BITS-1 downto 0);
        signal   reg_load       :  std_logic_vector(MRG_WR_REG_PARAM.BITS-1 downto 0);
    begin
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (CLK, RST) begin
            if (RST = '1') then
                    curr_state  <= IDLE_STATE;
                    write_addr  <= (others => '0');
                    write_bytes <= (others => '0');
            elsif (CLK'event and CLK = '1') then
                if (CLR = '1' or reset_bit = '1') then
                    curr_state  <= IDLE_STATE;
                    write_addr  <= (others => '0');
                    write_bytes <= (others => '0');
                else
                    case curr_state is
                        when IDLE_STATE =>
                            if (mrg_writer_request = TRUE) then
                                curr_state <= REQ_STATE;
                            else
                                curr_state <= IDLE_STATE;
                            end if;
                            write_addr  <= resize(unsigned(mrg_writer_addr) , write_addr 'length);
                            write_bytes <= resize(sort_total_size*WORD_BYTES, write_bytes'length);
                        when REQ_STATE =>
                                curr_state <= RUN0_STATE;
                        when RUN0_STATE =>
                            if    (MRG_WR_DONE = '1') then
                                curr_state <= DONE_STATE;
                            elsif (MRG_WR_BUSY = '1') then
                                curr_state <= RUN1_STATE;
                            else
                                curr_state <= RUN0_STATE;
                            end if;
                        when RUN1_STATE =>
                            if    (MRG_WR_DONE = '1') then
                                curr_state <= DONE_STATE;
                            elsif (MRG_WR_BUSY = '1') then
                                curr_state <= RUN1_STATE;
                            else
                                curr_state <= DONE_STATE;
                            end if;
                        when DONE_STATE =>
                                curr_state <= IDLE_STATE;
                    end case;
                end if;
            end if;
        end process;
        ---------------------------------------------------------------------------
        -- mrg_writer_running
        ---------------------------------------------------------------------------
        mrg_writer_running <= ((curr_state = REQ_STATE ) or
                               (curr_state = RUN0_STATE) or
                               (curr_state = RUN1_STATE));
        ---------------------------------------------------------------------------
        -- reg_data
        ---------------------------------------------------------------------------
        process (reset_bit, write_addr, write_bytes, mrg_writer_mode) begin
            reg_data <= (others => '0');
            reg_data(MRG_WR_REG_PARAM.ADDR_HI downto MRG_WR_REG_PARAM.ADDR_LO) <= std_logic_vector(write_addr );
            reg_data(MRG_WR_REG_PARAM.SIZE_HI downto MRG_WR_REG_PARAM.SIZE_LO) <= std_logic_vector(write_bytes);
            reg_data(MRG_WR_REG_PARAM.MODE_HI downto MRG_WR_REG_PARAM.MODE_LO) <= std_logic_vector(resize(unsigned(mrg_writer_mode), MRG_WR_REG_PARAM.MODE_BITS));
            reg_data(MRG_WR_REG_PARAM.STAT_HI downto MRG_WR_REG_PARAM.STAT_LO) <= (MRG_WR_REG_PARAM.STAT_HI downto MRG_WR_REG_PARAM.STAT_LO => '0');
            reg_data(MRG_WR_REG_PARAM.CTRL_RESET_POS) <= reset_bit;
            reg_data(MRG_WR_REG_PARAM.CTRL_PAUSE_POS) <= '0';
            reg_data(MRG_WR_REG_PARAM.CTRL_STOP_POS ) <= '0';
            reg_data(MRG_WR_REG_PARAM.CTRL_START_POS) <= '1';
            reg_data(MRG_WR_REG_PARAM.CTRL_FIRST_POS) <= '1';
            reg_data(MRG_WR_REG_PARAM.CTRL_LAST_POS ) <= '1';
            reg_data(MRG_WR_REG_PARAM.CTRL_DONE_POS ) <= '1';
            reg_data(MRG_WR_REG_PARAM.CTRL_EBLK_POS ) <= '0';
        end process;
        ---------------------------------------------------------------------------
        -- reg_load
        ---------------------------------------------------------------------------
        process (curr_state, reset_bit) begin
            if (curr_state = REQ_STATE) then
                reg_load <= (others => '1');
            else
                reg_load <= (others => '0');
                reg_load(MRG_WR_REG_PARAM.CTRL_RESET_POS) <= reset_bit;
            end if;
        end process;
        ---------------------------------------------------------------------------
        -- MRG_WR_REG_L
        -- MRG_WR_REG_D
        ---------------------------------------------------------------------------
        MRG_WR_REG_L <= reg_load;
        MRG_WR_REG_D <= reg_data;
    end block;
end RTL;
