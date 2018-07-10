-----------------------------------------------------------------------------------
--!     @file    merge_sorter_merge_reader.vhd
--!     @brief   Merge Sorter Merge Reader Module :
--!     @version 0.1.0
--!     @date    2018/7/10
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
library Merge_Sorter;
use     Merge_Sorter.Merge_Sorter_Interface;
entity  Merge_Sorter_Merge_Reader is
    generic (
        IN_NUM          :  integer :=  8;
        REG_PARAM       :  Merge_Sorter_Interface.Regs_Field_Type := Merge_Sorter_Interface.Default_Regs_Param;
        REQ_ADDR_BITS   :  integer := 32;
        REQ_SIZE_BITS   :  integer := 32;
        MRG_DATA_BITS   :  integer := 64;
        BUF_DATA_BITS   :  integer := 64;
        BUF_DEPTH       :  integer := 13;
        MAX_XFER_SIZE   :  integer := 12
    );
    port (
    -------------------------------------------------------------------------------
    -- Clock/Reset Signals.
    -------------------------------------------------------------------------------
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Register Interface
    -------------------------------------------------------------------------------
        REG_L           :  in  std_logic_vector(IN_NUM*REG_PARAM.BITS-1 downto 0);
        REG_D           :  in  std_logic_vector(IN_NUM*REG_PARAM.BITS-1 downto 0);
        REG_Q           :  out std_logic_vector(IN_NUM*REG_PARAM.BITS-1 downto 0);
    -------------------------------------------------------------------------------
    -- Transaction Command Request Signals.
    -------------------------------------------------------------------------------
        REQ_VALID       :  out std_logic_vector(IN_NUM               -1 downto 0);
        REQ_ADDR        :  out std_logic_vector(REQ_ADDR_BITS        -1 downto 0);
        REQ_SIZE        :  out std_logic_vector(REQ_SIZE_BITS        -1 downto 0);
        REQ_BUF_PTR     :  out std_logic_vector(BUF_DEPTH            -1 downto 0);
        REQ_MODE        :  out std_logic_vector(REG_PARAM.MODE_BITS  -1 downto 0);
        REQ_FIRST       :  out std_logic;
        REQ_LAST        :  out std_logic;
        REQ_READY       :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transaction Command Acknowledge Signals.
    -------------------------------------------------------------------------------
        ACK_VALID       :  in  std_logic_vector(IN_NUM               -1 downto 0);
        ACK_SIZE        :  in  std_logic_vector(BUF_DEPTH               downto 0);
        ACK_ERROR       :  in  std_logic := '0';
        ACK_NEXT        :  in  std_logic;
        ACK_LAST        :  in  std_logic;
        ACK_STOP        :  in  std_logic;
        ACK_NONE        :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transfer Status Signals.
    -------------------------------------------------------------------------------
        XFER_BUSY       :  in  std_logic_vector(IN_NUM               -1 downto 0);
        XFER_DONE       :  in  std_logic_vector(IN_NUM               -1 downto 0);
        XFER_ERROR      :  in  std_logic_vector(IN_NUM               -1 downto 0) := (others => '0');
    -------------------------------------------------------------------------------
    -- Intake Flow Control Signals.
    -------------------------------------------------------------------------------
        FLOW_READY      :  out std_logic;
        FLOW_PAUSE      :  out std_logic;
        FLOW_STOP       :  out std_logic;
        FLOW_LAST       :  out std_logic;
        FLOW_SIZE       :  out std_logic_vector(BUF_DEPTH               downto 0);
        PUSH_FIN_VALID  :  in  std_logic_vector(IN_NUM               -1 downto 0);
        PUSH_FIN_LAST   :  in  std_logic;
        PUSH_FIN_ERROR  :  in  std_logic := '0';
        PUSH_FIN_SIZE   :  in  std_logic_vector(BUF_DEPTH               downto 0);
        PUSH_BUF_RESET  :  in  std_logic_vector(IN_NUM               -1 downto 0) := (others => '0');
        PUSH_BUF_VALID  :  in  std_logic_vector(IN_NUM               -1 downto 0) := (others => '0');
        PUSH_BUF_LAST   :  in  std_logic;
        PUSH_BUF_ERROR  :  in  std_logic := '0';
        PUSH_BUF_SIZE   :  in  std_logic_vector(BUF_DEPTH               downto 0);
        PUSH_BUF_READY  :  out std_logic_vector(IN_NUM               -1 downto 0);
    -------------------------------------------------------------------------------
    -- Buffer Interface Signals.
    -------------------------------------------------------------------------------
        BUF_WEN         :  in  std_logic_vector(IN_NUM               -1 downto 0);
        BUF_BEN         :  in  std_logic_vector(BUF_DATA_BITS/8      -1 downto 0);
        BUF_DATA        :  in  std_logic_vector(BUF_DATA_BITS        -1 downto 0);
        BUF_PTR         :  in  std_logic_vector(BUF_DEPTH               downto 0);
    -------------------------------------------------------------------------------
    -- Merge Outlet Signals.
    -------------------------------------------------------------------------------
        MRG_DATA        :  out std_logic_vector(IN_NUM*MRG_DATA_BITS -1 downto 0);
        MRG_NONE        :  out std_logic_vector(IN_NUM               -1 downto 0);
        MRG_EBLK        :  out std_logic_vector(IN_NUM               -1 downto 0);
        MRG_LAST        :  out std_logic_vector(IN_NUM               -1 downto 0);
        MRG_VALID       :  out std_logic_vector(IN_NUM               -1 downto 0);
        MRG_READY       :  in  std_logic_vector(IN_NUM               -1 downto 0);
        MRG_LEVEL       :  in  std_logic_vector(IN_NUM               -1 downto 0);
    -------------------------------------------------------------------------------
    -- Intake Status Output.
    -------------------------------------------------------------------------------
        I_OPEN          :  out std_logic_vector(IN_NUM               -1 downto 0);
        I_RUNNING       :  out std_logic_vector(IN_NUM               -1 downto 0);
        I_DONE          :  out std_logic_vector(IN_NUM               -1 downto 0);
        I_ERROR         :  out std_logic_vector(IN_NUM               -1 downto 0);
        I_IRQ           :  out std_logic_vector(IN_NUM               -1 downto 0)
    );
end Merge_Sorter_Merge_Reader;
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library Merge_Sorter;
use     Merge_Sorter.Merge_Sorter_Interface;
library PIPEWORK;
use     PIPEWORK.PUMP_COMPONENTS.PUMP_STREAM_INTAKE_CONTROLLER;
use     PIPEWORK.COMPONENTS.QUEUE_ARBITER;
use     PIPEWORK.COMPONENTS.SDPRAM;
architecture RTL of Merge_Sorter_Merge_Reader is
    ------------------------------------------------------------------------------
    -- 入力側のフロー制御用定数.
    ------------------------------------------------------------------------------
    constant  I_FLOW_READY_LEVEL    :  std_logic_vector(BUF_DEPTH downto 0)
                                    := std_logic_vector(to_unsigned(2**BUF_DEPTH-2**MAX_XFER_SIZE   , BUF_DEPTH+1));
    constant  I_BUF_READY_LEVEL     :  std_logic_vector(BUF_DEPTH downto 0)
                                    := std_logic_vector(to_unsigned(2**BUF_DEPTH-2*(BUF_DATA_BITS/8), BUF_DEPTH+1));
    constant  I_STAT_RESV_NULL      :  std_logic_vector(REG_PARAM.STAT_RESV_BITS downto 0) := (others => '0');
    -------------------------------------------------------------------------------
    -- データバスのビット数の２のべき乗値を計算する.
    -------------------------------------------------------------------------------
    function CALC_DATA_WIDTH(BITS:integer) return integer is
        variable value : integer;
    begin
        value := 0;
        while (2**(value) < BITS) loop
            value := value + 1;
        end loop;
        return value;
    end function;
    ------------------------------------------------------------------------------
    -- 
    ------------------------------------------------------------------------------
    constant  BUF_DATA_WIDTH        :  integer := CALC_DATA_WIDTH(BUF_DATA_BITS);
    ------------------------------------------------------------------------------
    -- 
    ------------------------------------------------------------------------------
    type      REQ_ADDR_VECTOR       is array (integer range <>) of std_logic_vector(REQ_ADDR_BITS      -1 downto 0);
    type      REQ_SIZE_VECTOR       is array (integer range <>) of std_logic_vector(REQ_SIZE_BITS      -1 downto 0);
    type      REQ_MODE_VECTOR       is array (integer range <>) of std_logic_vector(REG_PARAM.MODE_BITS-1 downto 0);
    type      REQ_BUF_PTR_VECTOR    is array (integer range <>) of std_logic_vector(BUF_DEPTH             downto 0);
    ------------------------------------------------------------------------------
    -- 
    ------------------------------------------------------------------------------
    function  SELECT_REQ_FLAG(SEL: std_logic_vector; VEC: std_logic_vector) return std_logic is
        variable req_flag  :  std_logic;
    begin
        req_flag := '0';
        for i in VEC'range loop
            if (SEL(i) = '1') then
                req_flag := req_flag or VEC(i);
            end if;
        end loop;
        return req_flag;
    end function;
    ------------------------------------------------------------------------------
    -- 
    ------------------------------------------------------------------------------
    function  SELECT_REQ_ADDR(SEL: std_logic_vector; VEC: REQ_ADDR_VECTOR) return std_logic_vector is
        variable req_addr  :  std_logic_vector(REQ_ADDR_BITS-1 downto 0);
    begin
        req_addr := (others => '0');
        for i in VEC'range loop
            if (SEL(i) = '1') then
                req_addr := req_addr or VEC(i);
            end if;
        end loop;
        return req_addr;
    end function;
    ------------------------------------------------------------------------------
    -- 
    ------------------------------------------------------------------------------
    function  SELECT_REQ_SIZE(SEL: std_logic_vector; VEC: REQ_SIZE_VECTOR) return std_logic_vector is
        variable req_size  :  std_logic_vector(REQ_SIZE_BITS-1 downto 0);
    begin
        req_size := (others => '0');
        for i in VEC'range loop
            if (SEL(i) = '1') then
                req_size := req_size or VEC(i);
            end if;
        end loop;
        return req_size;
    end function;
    ------------------------------------------------------------------------------
    -- 
    ------------------------------------------------------------------------------
    function  SELECT_REQ_MODE(SEL: std_logic_vector; VEC: REQ_MODE_VECTOR) return std_logic_vector is
        variable req_mode  :  std_logic_vector(REG_PARAM.MODE_BITS-1 downto 0);
    begin
        req_mode := (others => '0');
        for i in VEC'range loop
            if (SEL(i) = '1') then
                req_mode := req_mode or VEC(i);
            end if;
        end loop;
        return req_mode;
    end function;
    ------------------------------------------------------------------------------
    -- 
    ------------------------------------------------------------------------------
    function  SELECT_REQ_BUF_PTR(SEL: std_logic_vector; VEC: REQ_BUF_PTR_VECTOR) return std_logic_vector is
        variable req_buf_ptr :  std_logic_vector(BUF_DEPTH downto 0);
    begin
        req_buf_ptr := (others => '0');
        for i in VEC'range loop
            if (SEL(i) = '1') then
                req_buf_ptr := req_buf_ptr or VEC(i);
            end if;
        end loop;
        return req_buf_ptr;
    end function;
    ------------------------------------------------------------------------------
    -- 
    ------------------------------------------------------------------------------
    signal    i_req_addr            :  REQ_ADDR_VECTOR   (IN_NUM-1 downto 0);
    signal    i_req_size            :  REQ_SIZE_VECTOR   (IN_NUM-1 downto 0);
    signal    i_req_mode            :  REQ_MODE_VECTOR(   IN_NUM-1 downto 0);
    signal    i_req_buf_ptr         :  REQ_BUF_PTR_VECTOR(IN_NUM-1 downto 0);
    signal    i_req_first           :  std_logic_vector  (IN_NUM-1 downto 0);
    signal    i_req_last            :  std_logic_vector  (IN_NUM-1 downto 0);
    signal    i_req_valid           :  std_logic_vector  (IN_NUM-1 downto 0);
    signal    i_req_ready           :  std_logic_vector  (IN_NUM-1 downto 0);
    signal    i_flow_ready          :  std_logic_vector  (IN_NUM-1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    
begin
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    REQ: block
        constant  ARB_NULL          :  std_logic_vector  (IN_NUM-1 downto 0) := (others => '0');
        signal    arb_request       :  std_logic_vector  (IN_NUM-1 downto 0);
        signal    arb_grant         :  std_logic_vector  (IN_NUM-1 downto 0);
        signal    arb_valid         :  std_logic;
        signal    arb_shift         :  std_logic;
        type      STATE_TYPE        is (IDLE_STATE, SEL_STATE, REQ_STATE, ACK_STATE);
        signal    curr_state        :  STATE_TYPE;
        signal    curr_sel          :  std_logic_vector  (IN_NUM-1 downto 0);
        signal    curr_val          :  std_logic_vector  (IN_NUM-1 downto 0);
    begin
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        ARB: QUEUE_ARBITER                   -- 
            generic map (                    -- 
                MIN_NUM     => 0          ,  -- 
                MAX_NUM     => IN_NUM-1      -- 
            )                                -- 
            port map (                       -- 
                CLK         => CLK        ,  -- In  :
                RST         => RST        ,  -- In  :
                CLR         => CLR        ,  -- In  :
                REQUEST     => arb_request,  -- In  :
                GRANT       => arb_grant  ,  -- Out :
                REQUEST_O   => arb_valid  ,  -- Out :
                SHIFT       => arb_shift     -- In  :
            );                               --
        arb_request <= i_req_valid and i_flow_ready;
        arb_shift   <= '1' when ((ACK_VALID and curr_val) /= ARB_NULL) else '0';
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (CLK, RST) begin
            if (RST = '1') then
                    curr_state  <= IDLE_STATE;
                    curr_sel    <= (others => '0');
                    curr_val    <= (others => '0');
                    REQ_ADDR    <= (others => '0');
                    REQ_SIZE    <= (others => '0');
                    REQ_BUF_PTR <= (others => '0');
                    REQ_MODE    <= (others => '0');
                    REQ_FIRST   <= '0';
                    REQ_LAST    <= '0';
            elsif (CLK'event and CLK = '1') then
                if (CLR = '1') then
                    curr_state  <= IDLE_STATE;
                    curr_sel    <= (others => '0');
                    curr_val    <= (others => '0');
                    REQ_ADDR    <= (others => '0');
                    REQ_SIZE    <= (others => '0');
                    REQ_BUF_PTR <= (others => '0');
                    REQ_MODE    <= (others => '0');
                    REQ_FIRST   <= '0';
                    REQ_LAST    <= '0';
                else
                    case curr_state is
                        when IDLE_STATE =>
                            if (arb_valid = '1') then
                                curr_state <= SEL_STATE;
                                curr_sel   <= arb_grant;
                            else
                                curr_state <= IDLE_STATE;
                                curr_sel   <= (others => '0');
                            end if;
                            curr_val    <= (others => '0');
                        when SEL_STATE =>
                            curr_state  <= REQ_STATE;
                            curr_val    <= curr_sel;
                            REQ_ADDR    <= SELECT_REQ_ADDR(   curr_sel, i_req_addr   );
                            REQ_SIZE    <= SELECT_REQ_SIZE(   curr_sel, i_req_size   );
                            REQ_BUF_PTR <= SELECT_REQ_BUF_PTR(curr_sel, i_req_buf_ptr);
                            REQ_MODE    <= SELECT_REQ_MODE(   curr_sel, i_req_mode   );
                            REQ_FIRST   <= SELECT_REQ_FLAG(   curr_sel, i_req_first  );
                            REQ_LAST    <= SELECT_REQ_FLAG(   curr_sel, i_req_last   );
                        when REQ_STATE =>
                            if    (REQ_READY = '0') then
                                curr_state <= REQ_STATE;
                            elsif ((ACK_VALID and curr_val) /= ARB_NULL) then
                                curr_state <= IDLE_STATE;
                                curr_val   <= (others => '0');
                            else
                                curr_state <= ACK_STATE;
                            end if;
                        when ACK_STATE =>
                            if ((ACK_VALID and curr_val) /= ARB_NULL) then
                                curr_state <= IDLE_STATE;
                                curr_val   <= (others => '0');
                            else
                                curr_state <= REQ_STATE;
                            end if;
                    end case;
                end if;
            end if;
        end process;
        REQ_VALID   <= curr_val;
        FLOW_READY  <= '1' when (curr_state = REQ_STATE or curr_state = ACK_STATE) else '0';
        FLOW_PAUSE  <= '0' when (curr_state = REQ_STATE or curr_state = ACK_STATE) else '1';
        FLOW_STOP   <= '0';
        FLOW_LAST   <= '0';
        FLOW_SIZE   <= std_logic_vector(to_unsigned(2**MAX_XFER_SIZE, FLOW_SIZE'length));
        i_req_ready <= (others => '1');
    end block;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    CH: for channel in 0 to IN_NUM-1 generate
        ---------------------------------------------------------------------------
        -- レジスタアクセス用の信号群.
        ---------------------------------------------------------------------------
        signal    reg_load          :  std_logic_vector(REG_PARAM.BITS -1 downto 0);
        signal    reg_wbit          :  std_logic_vector(REG_PARAM.BITS -1 downto 0);
        signal    reg_rbit          :  std_logic_vector(REG_PARAM.BITS -1 downto 0);
        signal    buf_ren           :  std_logic;
        signal    buf_rptr          :  std_logic_vector(BUF_DEPTH      -1 downto 0);
        signal    buf_rdata         :  std_logic_vector(BUF_DATA_BITS  -1 downto 0);
        signal    buf_we            :  std_logic_vector(BUF_DATA_BITS/8-1 downto 0);
        signal    mrg_in_data       :  std_logic_vector(MRG_DATA_BITS  -1 downto 0);
        signal    mrg_in_last       :  std_logic;
        signal    mrg_in_valid      :  std_logic;
        signal    mrg_in_ready      :  std_logic;
        signal    mrg_in_eblk       :  std_logic;
        signal    i_end_of_blk      :  std_logic;
        signal    i_size_zero       :  std_logic;
        signal    o_open_valid      :  std_logic;
        signal    o_close_valid     :  std_logic;
        signal    o_end_of_blk      :  std_logic;
        signal    o_size_zero       :  std_logic;
        signal    o_reset           :  std_logic;
        signal    o_open            :  std_logic;
        signal    o_done            :  std_logic;
        type      STATE_TYPE        is (IDLE_STATE, MRG_READ_STATE, MRG_NONE_STATE, END_NONE_STATE);
        signal    curr_state        :  STATE_TYPE;
    begin
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        reg_load <= REG_L((channel+1)*REG_PARAM.BITS-1 downto channel*REG_PARAM.BITS);
        reg_wbit <= REG_D((channel+1)*REG_PARAM.BITS-1 downto channel*REG_PARAM.BITS);
        REG_Q((channel+1)*REG_PARAM.BITS-1 downto channel*REG_PARAM.BITS) <= reg_rbit;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        CTRL: PUMP_STREAM_INTAKE_CONTROLLER                      -- 
            generic map (                                        -- 
                I_CLK_RATE          => 1                       , --
                I_REQ_ADDR_VALID    => 1                       , --
                I_REQ_ADDR_BITS     => REQ_ADDR_BITS           , --
                I_REG_ADDR_BITS     => REG_PARAM.ADDR_BITS     , --
                I_REQ_SIZE_VALID    => 1                       , --
                I_REQ_SIZE_BITS     => REQ_SIZE_BITS           , --
                I_REG_SIZE_BITS     => REG_PARAM.SIZE_BITS     , --
                I_REG_MODE_BITS     => REG_PARAM.MODE_BITS     , --
                I_REG_STAT_BITS     => REG_PARAM.STAT_RESV_BITS, --
                I_USE_PUSH_BUF_SIZE => 0                       , --
                I_FIXED_FLOW_OPEN   => 0                       , --
                I_FIXED_POOL_OPEN   => 1                       , --
                O_CLK_RATE          => 1                       , --
                O_DATA_BITS         => MRG_DATA_BITS           , --
                BUF_DEPTH           => BUF_DEPTH               , --
                BUF_DATA_BITS       => BUF_DATA_BITS           , --
                I2O_OPEN_INFO_BITS  => 2                       , --
                I2O_CLOSE_INFO_BITS => 1                       , --
                O2I_OPEN_INFO_BITS  => 1                       , --
                O2I_CLOSE_INFO_BITS => 1                       , --
                I2O_DELAY_CYCLE     => 1                         --
            )                                                    -- 
            port map (                                           -- 
            -----------------------------------------------------------------------
            --Reset Signals.
            -----------------------------------------------------------------------
                RST                 => RST                     , --  In  :
            -----------------------------------------------------------------------
            -- Intake Clock and Clock Enable.
            -----------------------------------------------------------------------
                I_CLK               => CLK                     , --  In  :
                I_CLR               => CLR                     , --  In  :
                I_CKE               => '1'                     , --  In  :
            -----------------------------------------------------------------------
            -- Intake Control Register Interface.
            -----------------------------------------------------------------------
                I_ADDR_L            => reg_load(REG_PARAM.ADDR_HI      downto REG_PARAM.ADDR_LO     ), --  In  :
                I_ADDR_D            => reg_wbit(REG_PARAM.ADDR_HI      downto REG_PARAM.ADDR_LO     ), --  In  :
                I_ADDR_Q            => reg_rbit(REG_PARAM.ADDR_HI      downto REG_PARAM.ADDR_LO     ), --  Out :
                I_SIZE_L            => reg_load(REG_PARAM.SIZE_HI      downto REG_PARAM.SIZE_LO     ), --  In  :
                I_SIZE_D            => reg_wbit(REG_PARAM.SIZE_HI      downto REG_PARAM.SIZE_LO     ), --  In  :
                I_SIZE_Q            => reg_rbit(REG_PARAM.SIZE_HI      downto REG_PARAM.SIZE_LO     ), --  Out :
                I_MODE_L            => reg_load(REG_PARAM.MODE_HI      downto REG_PARAM.MODE_LO     ), --  In  :
                I_MODE_D            => reg_wbit(REG_PARAM.MODE_HI      downto REG_PARAM.MODE_LO     ), --  In  :
                I_MODE_Q            => reg_rbit(REG_PARAM.MODE_HI      downto REG_PARAM.MODE_LO     ), --  Out :
                I_STAT_L            => reg_load(REG_PARAM.STAT_RESV_HI downto REG_PARAM.STAT_RESV_LO), --  In  :
                I_STAT_D            => reg_wbit(REG_PARAM.STAT_RESV_HI downto REG_PARAM.STAT_RESV_LO), --  In  :
                I_STAT_Q            => reg_rbit(REG_PARAM.STAT_RESV_HI downto REG_PARAM.STAT_RESV_LO), --  Out :
                I_STAT_I            => I_STAT_RESV_NULL                    , --  In  :
                I_RESET_L           => reg_load(REG_PARAM.CTRL_RESET_POS)  , --  In  :
                I_RESET_D           => reg_wbit(REG_PARAM.CTRL_RESET_POS)  , --  In  :
                I_RESET_Q           => reg_rbit(REG_PARAM.CTRL_RESET_POS)  , --  Out :
                I_START_L           => reg_load(REG_PARAM.CTRL_START_POS)  , --  In  :
                I_START_D           => reg_wbit(REG_PARAM.CTRL_START_POS)  , --  In  :
                I_START_Q           => reg_rbit(REG_PARAM.CTRL_START_POS)  , --  Out :
                I_STOP_L            => reg_load(REG_PARAM.CTRL_STOP_POS )  , --  In  :
                I_STOP_D            => reg_wbit(REG_PARAM.CTRL_STOP_POS )  , --  In  :
                I_STOP_Q            => reg_rbit(REG_PARAM.CTRL_STOP_POS )  , --  Out :
                I_PAUSE_L           => reg_load(REG_PARAM.CTRL_PAUSE_POS)  , --  In  :
                I_PAUSE_D           => reg_wbit(REG_PARAM.CTRL_PAUSE_POS)  , --  In  :
                I_PAUSE_Q           => reg_rbit(REG_PARAM.CTRL_PAUSE_POS)  , --  Out :
                I_FIRST_L           => reg_load(REG_PARAM.CTRL_FIRST_POS)  , --  In  :
                I_FIRST_D           => reg_wbit(REG_PARAM.CTRL_FIRST_POS)  , --  In  :
                I_FIRST_Q           => reg_rbit(REG_PARAM.CTRL_FIRST_POS)  , --  Out :
                I_LAST_L            => reg_load(REG_PARAM.CTRL_LAST_POS )  , --  In  :
                I_LAST_D            => reg_wbit(REG_PARAM.CTRL_LAST_POS )  , --  In  :
                I_LAST_Q            => reg_rbit(REG_PARAM.CTRL_LAST_POS )  , --  Out :
                I_DONE_EN_L         => reg_load(REG_PARAM.CTRL_DONE_POS )  , --  In  :
                I_DONE_EN_D         => reg_wbit(REG_PARAM.CTRL_DONE_POS )  , --  In  :
                I_DONE_EN_Q         => reg_rbit(REG_PARAM.CTRL_DONE_POS )  , --  Out :
                I_DONE_ST_L         => reg_load(REG_PARAM.STAT_DONE_POS )  , --  In  :
                I_DONE_ST_D         => reg_wbit(REG_PARAM.STAT_DONE_POS )  , --  In  :
                I_DONE_ST_Q         => reg_rbit(REG_PARAM.STAT_DONE_POS )  , --  Out :
                I_ERR_ST_L          => reg_load(REG_PARAM.STAT_ERROR_POS)  , --  In  :
                I_ERR_ST_D          => reg_wbit(REG_PARAM.STAT_ERROR_POS)  , --  In  :
                I_ERR_ST_Q          => reg_rbit(REG_PARAM.STAT_ERROR_POS)  , --  Out :
                I_CLOSE_ST_L        => reg_load(REG_PARAM.STAT_CLOSE_POS)  , --  In  :
                I_CLOSE_ST_D        => reg_wbit(REG_PARAM.STAT_CLOSE_POS)  , --  In  :
                I_CLOSE_ST_Q        => reg_rbit(REG_PARAM.STAT_CLOSE_POS)  , --  Out :
            -----------------------------------------------------------------------
            -- Intake Configuration Signals.
            -----------------------------------------------------------------------
                I_ADDR_FIX          => '0'                     , --  In  :
                I_BUF_READY_LEVEL   => I_BUF_READY_LEVEL       , --  In  :
                I_FLOW_READY_LEVEL  => I_FLOW_READY_LEVEL      , --  In  :
            -----------------------------------------------------------------------
            -- Intake Transaction Command Request Signals.
            -----------------------------------------------------------------------
                I_REQ_VALID         => i_req_valid   (channel) , --  Out :
                I_REQ_ADDR          => i_req_addr    (channel) , --  Out :
                I_REQ_SIZE          => i_req_size    (channel) , --  Out :
                I_REQ_BUF_PTR       => i_req_buf_ptr (channel) , --  Out :
                I_REQ_FIRST         => i_req_first   (channel) , --  Out :
                I_REQ_LAST          => i_req_last    (channel) , --  Out :
                I_REQ_READY         => i_req_ready   (channel) , --  In  :
            -----------------------------------------------------------------------
            -- Intake Transaction Command Acknowledge Signals.
            -----------------------------------------------------------------------
                I_ACK_VALID         => ACK_VALID     (channel) , --  In  :
                I_ACK_SIZE          => ACK_SIZE                , --  In  :
                I_ACK_ERROR         => ACK_ERROR               , --  In  :
                I_ACK_NEXT          => ACK_NEXT                , --  In  :
                I_ACK_LAST          => ACK_LAST                , --  In  :
                I_ACK_STOP          => ACK_STOP                , --  In  :
                I_ACK_NONE          => ACK_NONE                , --  In  :
            -----------------------------------------------------------------------
            -- Intake Transfer Status Signals.
            -----------------------------------------------------------------------
                I_XFER_BUSY         => XFER_BUSY     (channel) , --  In  :
                I_XFER_DONE         => XFER_DONE     (channel) , --  In  :
                I_XFER_ERROR        => XFER_ERROR    (channel) , --  In  :
            -----------------------------------------------------------------------
            -- Intake Flow Control Signals.
            -----------------------------------------------------------------------
                I_FLOW_READY        => i_flow_ready  (channel) , --  Out :
                I_FLOW_PAUSE        => open                    , --  Out :
                I_FLOW_STOP         => open                    , --  Out :
                I_FLOW_LAST         => open                    , --  Out :
                I_FLOW_SIZE         => open                    , --  Out :
                I_PUSH_FIN_VALID    => PUSH_FIN_VALID(channel) , --  In  :
                I_PUSH_FIN_LAST     => PUSH_FIN_LAST           , --  In  :
                I_PUSH_FIN_ERROR    => PUSH_FIN_ERROR          , --  In  :
                I_PUSH_FIN_SIZE     => PUSH_FIN_SIZE           , --  In  :
                I_PUSH_BUF_RESET    => PUSH_BUF_RESET(channel) , --  In  :
                I_PUSH_BUF_VALID    => PUSH_BUF_VALID(channel) , --  In  :
                I_PUSH_BUF_LAST     => PUSH_BUF_LAST           , --  In  :
                I_PUSH_BUF_ERROR    => PUSH_BUF_ERROR          , --  In  :
                I_PUSH_BUF_SIZE     => PUSH_BUF_SIZE           , --  In  :
                I_PUSH_BUF_READY    => PUSH_BUF_READY(channel) , --  Out :
            -----------------------------------------------------------------------
            -- Intake Status.
            -----------------------------------------------------------------------
                I_OPEN              => I_OPEN        (channel) , --  Out :
                I_RUNNING           => I_RUNNING     (channel) , --  Out :
                I_DONE              => I_DONE        (channel) , --  Out :
                I_ERROR             => I_ERROR       (channel) , --  Out :
            -----------------------------------------------------------------------
            -- Intake Open/Close Infomation Interface
            -----------------------------------------------------------------------
                I_I2O_OPEN_INFO(0)  => i_size_zero             , --  In  :
                I_I2O_OPEN_INFO(1)  => i_end_of_blk            , --  In  :
                I_I2O_CLOSE_INFO    => "0"                     , --  In  :
                I_O2I_OPEN_INFO     => open                    , --  Out :
                I_O2I_OPEN_VALID    => open                    , --  Out :
                I_O2I_CLOSE_INFO    => open                    , --  Out :
                I_O2I_CLOSE_VALID   => open                    , --  Out :
                I_O2I_STOP_VALID    => open                    , --  Out :
            -----------------------------------------------------------------------
            -- Outlet Clock and Clock Enable.
            -----------------------------------------------------------------------
                O_CLK               => CLK                     , --  In  :
                O_CLR               => CLR                     , --  In  :
                O_CKE               => '1'                     , --  In  :
            -----------------------------------------------------------------------
            -- Outlet Stream Interface.
            -----------------------------------------------------------------------
                O_DATA              => mrg_in_data             , --  Out :
                O_STRB              => open                    , --  Out :
                O_LAST              => mrg_in_last             , --  Out :
                O_VALID             => mrg_in_valid            , --  Out :
                O_READY             => mrg_in_ready            , --  In  :
            -----------------------------------------------------------------------
            -- Outlet Status.
            -----------------------------------------------------------------------
                O_OPEN              => o_open                  , --  Out :
                O_RUNNING           => open                    , --  Out :
                O_DONE              => o_done                  , --  Out :
                O_ERROR             => open                    , --  Out :
            -----------------------------------------------------------------------
            -- Outlet Open/Close Infomation Interface
            -----------------------------------------------------------------------
                O_O2I_STOP_VALID    => '0'                     , --  In  :
                O_O2I_OPEN_INFO     => "0"                     , --  In  :
                O_O2I_OPEN_VALID    => o_open_valid            , --  In  :
                O_O2I_CLOSE_INFO    => "0"                     , --  In  :
                O_O2I_CLOSE_VALID   => o_close_valid           , --  In  :
                O_I2O_RESET         => o_reset                 , --  Out :
                O_I2O_STOP_VALID    => open                    , --  Out :
                O_I2O_OPEN_INFO(0)  => o_size_zero             , --  Out :
                O_I2O_OPEN_INFO(1)  => o_end_of_blk            , --  Out :
                O_I2O_OPEN_VALID    => o_open_valid            , --  Out :
                O_I2O_CLOSE_INFO    => open                    , --  Out :
                O_I2O_CLOSE_VALID   => o_close_valid           , --  Out :
            -----------------------------------------------------------------------
            -- Outlet Buffer Read Interface.
            -----------------------------------------------------------------------
                BUF_REN             => buf_ren                 , --  Out :
                BUF_PTR             => buf_rptr                , --  Out :
                BUF_DATA            => buf_rdata                 --  In  :
            );                                                   --
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (CLK, RST) begin
            if (RST = '1') then
                    i_end_of_blk <= '0';
            elsif (CLK'event and CLK = '1') then
                if (CLR = '1' or reg_rbit(REG_PARAM.CTRL_RESET_POS) = '1') then
                    i_end_of_blk <= '0';
                elsif (reg_load(REG_PARAM.CTRL_EBLK_POS) = '1') then
                    i_end_of_blk <= reg_wbit(REG_PARAM.CTRL_EBLK_POS);
                end if;
            end if;
        end process;
        reg_rbit(REG_PARAM.CTRL_EBLK_POS) <= i_end_of_blk;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        i_req_mode(channel) <= reg_rbit(REG_PARAM.MODE_HI downto REG_PARAM.MODE_LO);
        i_size_zero <= '1' when (unsigned(reg_rbit(REG_PARAM.SIZE_HI downto REG_PARAM.SIZE_LO)) = 0) else '0';
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (CLK, RST) begin
            if (RST = '1') then
                    curr_state  <= IDLE_STATE;
                    mrg_in_eblk <= '0';
            elsif (CLK'event and CLK = '1') then
                if (CLR = '1' or o_reset = '1') then
                    curr_state  <= IDLE_STATE;
                    mrg_in_eblk <= '0';
                else
                    case curr_state is
                        when IDLE_STATE =>
                            if    (o_open_valid = '1' and o_size_zero = '1') then
                                curr_state <= MRG_NONE_STATE;
                            elsif (o_open_valid = '1' and o_size_zero = '0') then
                                curr_state <= MRG_READ_STATE;
                            else
                                curr_state <= IDLE_STATE;
                            end if;
                            if (o_open_valid = '1') then
                                mrg_in_eblk <= o_end_of_blk;
                            end if;
                        when MRG_NONE_STATE =>
                            if (MRG_READY(channel) = '1') then
                                curr_state <= END_NONE_STATE;
                            else
                                curr_state <= MRG_NONE_STATE;
                            end if;
                        when END_NONE_STATE =>
                            if (o_open = '0') or
                               (o_open = '1' and o_done = '1') then
                                curr_state <= IDLE_STATE;
                            else
                                curr_state <= END_NONE_STATE;
                            end if;
                        when MRG_READ_STATE =>
                            if (o_open = '0') or
                               (o_open = '1' and o_done = '1') then
                                curr_state <= IDLE_STATE;
                            else
                                curr_state <= MRG_READ_STATE;
                            end if;
                        when others => 
                                curr_state <= IDLE_STATE;
                    end case;
                end if;
            end if;
        end process;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        MRG_DATA((channel+1)*MRG_DATA_BITS-1 downto channel*MRG_DATA_BITS) <= mrg_in_data;
        MRG_VALID(channel) <= '1' when (curr_state = MRG_NONE_STATE) or
                                       (curr_state = MRG_READ_STATE and mrg_in_valid = '1') else '0';
        MRG_LAST (channel) <= '1' when (curr_state = MRG_NONE_STATE) or
                                       (curr_state = MRG_READ_STATE and mrg_in_last  = '1') else '0';
        MRG_NONE (channel) <= '1' when (curr_state = MRG_NONE_STATE) else '0';
        MRG_EBLK (channel) <= mrg_in_eblk;
        mrg_in_ready       <= '1' when (curr_state = MRG_READ_STATE and MRG_READY(channel) = '1') else '0';
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        RAM: SDPRAM 
            generic map(
                DEPTH       => BUF_DEPTH+3         ,
                RWIDTH      => BUF_DATA_WIDTH      , --
                WWIDTH      => BUF_DATA_WIDTH      , --
                WEBIT       => BUF_DATA_WIDTH-3    , --
                ID          => channel               -- 
            )                                        -- 
            port map (                               -- 
                WCLK        => CLK                 , -- In  :
                WE          => buf_we              , -- In  :
                WADDR       => BUF_PTR (BUF_DEPTH-1 downto BUF_DATA_WIDTH-3), -- In  :
                WDATA       => BUF_DATA            , -- In  :
                RCLK        => CLK                 , -- In  :
                RADDR       => buf_rptr(BUF_DEPTH-1 downto BUF_DATA_WIDTH-3), -- In  :
                RDATA       => buf_rdata             -- Out :
            );
        buf_we <= BUF_BEN when (BUF_WEN(channel) = '1') else (others => '0');
    end generate;
end RTL;
