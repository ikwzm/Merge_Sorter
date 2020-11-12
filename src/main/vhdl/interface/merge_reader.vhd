-----------------------------------------------------------------------------------
--!     @file    merge_reader.vhd
--!     @brief   Merge Sorter Merge Reader Module :
--!     @version 0.7.0
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
entity  Merge_Reader is
    generic (
        WAYS            :  integer :=  8;
        WORDS           :  integer :=  1;
        WORD_BITS       :  integer := 64;
        REG_PARAM       :  Interface.Regs_Field_Type := Interface.Default_Regs_Param;
        REQ_ADDR_BITS   :  integer := 32;
        REQ_SIZE_BITS   :  integer := 32;
        BUF_DATA_BITS   :  integer := 64;
        BUF_DEPTH       :  integer := 13;
        MAX_XFER_SIZE   :  integer := 12;
        ARB_NODE_NUM    :  integer :=  4;
        ARB_PIPELINE    :  integer :=  0
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
        REG_L           :  in  std_logic_vector(WAYS*REG_PARAM.BITS -1 downto 0);
        REG_D           :  in  std_logic_vector(WAYS*REG_PARAM.BITS -1 downto 0);
        REG_Q           :  out std_logic_vector(WAYS*REG_PARAM.BITS -1 downto 0);
    -------------------------------------------------------------------------------
    -- Transaction Command Request Signals.
    -------------------------------------------------------------------------------
        REQ_VALID       :  out std_logic_vector(WAYS                -1 downto 0);
        REQ_ADDR        :  out std_logic_vector(REQ_ADDR_BITS       -1 downto 0);
        REQ_SIZE        :  out std_logic_vector(REQ_SIZE_BITS       -1 downto 0);
        REQ_BUF_PTR     :  out std_logic_vector(BUF_DEPTH           -1 downto 0);
        REQ_MODE        :  out std_logic_vector(REG_PARAM.MODE_BITS -1 downto 0);
        REQ_FIRST       :  out std_logic;
        REQ_LAST        :  out std_logic;
        REQ_NONE        :  out std_logic;
        REQ_READY       :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transaction Command Acknowledge Signals.
    -------------------------------------------------------------------------------
        ACK_VALID       :  in  std_logic_vector(WAYS                -1 downto 0);
        ACK_SIZE        :  in  std_logic_vector(BUF_DEPTH              downto 0);
        ACK_ERROR       :  in  std_logic := '0';
        ACK_NEXT        :  in  std_logic;
        ACK_LAST        :  in  std_logic;
        ACK_STOP        :  in  std_logic;
        ACK_NONE        :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transfer Status Signals.
    -------------------------------------------------------------------------------
        XFER_BUSY       :  in  std_logic_vector(WAYS                -1 downto 0);
        XFER_DONE       :  in  std_logic_vector(WAYS                -1 downto 0);
        XFER_ERROR      :  in  std_logic_vector(WAYS                -1 downto 0) := (others => '0');
    -------------------------------------------------------------------------------
    -- Intake Flow Control Signals.
    -------------------------------------------------------------------------------
        FLOW_READY      :  out std_logic;
        FLOW_PAUSE      :  out std_logic;
        FLOW_STOP       :  out std_logic;
        FLOW_LAST       :  out std_logic;
        FLOW_SIZE       :  out std_logic_vector(BUF_DEPTH              downto 0);
        PUSH_FIN_VALID  :  in  std_logic_vector(WAYS                -1 downto 0);
        PUSH_FIN_LAST   :  in  std_logic;
        PUSH_FIN_ERROR  :  in  std_logic := '0';
        PUSH_FIN_SIZE   :  in  std_logic_vector(BUF_DEPTH              downto 0);
        PUSH_BUF_RESET  :  in  std_logic_vector(WAYS                -1 downto 0) := (others => '0');
        PUSH_BUF_VALID  :  in  std_logic_vector(WAYS                -1 downto 0) := (others => '0');
        PUSH_BUF_LAST   :  in  std_logic;
        PUSH_BUF_ERROR  :  in  std_logic := '0';
        PUSH_BUF_SIZE   :  in  std_logic_vector(BUF_DEPTH              downto 0);
        PUSH_BUF_READY  :  out std_logic_vector(WAYS                -1 downto 0);
    -------------------------------------------------------------------------------
    -- Buffer Interface Signals.
    -------------------------------------------------------------------------------
        BUF_WEN         :  in  std_logic_vector(WAYS                -1 downto 0);
        BUF_BEN         :  in  std_logic_vector(BUF_DATA_BITS/8     -1 downto 0);
        BUF_DATA        :  in  std_logic_vector(BUF_DATA_BITS       -1 downto 0);
        BUF_PTR         :  in  std_logic_vector(BUF_DEPTH           -1 downto 0);
    -------------------------------------------------------------------------------
    -- Merge Outlet Signals.
    -------------------------------------------------------------------------------
        MRG_DATA        :  out std_logic_vector(WAYS*WORDS*WORD_BITS-1 downto 0);
        MRG_NONE        :  out std_logic_vector(WAYS*WORDS          -1 downto 0);
        MRG_EBLK        :  out std_logic_vector(WAYS                -1 downto 0);
        MRG_LAST        :  out std_logic_vector(WAYS                -1 downto 0);
        MRG_VALID       :  out std_logic_vector(WAYS                -1 downto 0);
        MRG_READY       :  in  std_logic_vector(WAYS                -1 downto 0);
        MRG_LEVEL       :  in  std_logic_vector(WAYS                -1 downto 0);
    -------------------------------------------------------------------------------
    -- Status Output.
    -------------------------------------------------------------------------------
        BUSY            :  out std_logic_vector(WAYS                -1 downto 0);
        DONE            :  out std_logic_vector(WAYS                -1 downto 0)
    );
end Merge_Reader;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library Merge_Sorter;
use     Merge_Sorter.Interface;
library PIPEWORK;
use     PIPEWORK.PUMP_COMPONENTS.PUMP_STREAM_INTAKE_CONTROLLER;
use     PIPEWORK.COMPONENTS.QUEUE_TREE_ARBITER;
use     PIPEWORK.COMPONENTS.SDPRAM;
architecture RTL of Merge_Reader is
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
    constant  BUF_DATA_BYTES        :  integer := BUF_DATA_BITS/8;
    constant  BUF_BYTES             :  integer := 2**BUF_DEPTH;
    constant  MAX_XFER_BYTES        :  integer := 2**MAX_XFER_SIZE;
    ------------------------------------------------------------------------------
    -- 入力側のフロー制御用定数.
    ------------------------------------------------------------------------------
    constant  I_FLOW_READY_LEVEL    :  std_logic_vector(BUF_DEPTH downto 0)
                                    := std_logic_vector(to_unsigned(BUF_BYTES-MAX_XFER_BYTES  , BUF_DEPTH+1));
    constant  I_BUF_READY_LEVEL     :  std_logic_vector(BUF_DEPTH downto 0)
                                    := std_logic_vector(to_unsigned(BUF_BYTES-2*BUF_DATA_BYTES, BUF_DEPTH+1));
    constant  I_STAT_RESV_NULL      :  std_logic_vector(REG_PARAM.STAT_RESV_BITS-1 downto 0) := (others => '0');
    ------------------------------------------------------------------------------
    -- 
    ------------------------------------------------------------------------------
    type      REQ_ADDR_VECTOR       is array (integer range <>) of std_logic_vector(REQ_ADDR_BITS      -1 downto 0);
    type      REQ_SIZE_VECTOR       is array (integer range <>) of std_logic_vector(REQ_SIZE_BITS      -1 downto 0);
    type      REQ_MODE_VECTOR       is array (integer range <>) of std_logic_vector(REG_PARAM.MODE_BITS-1 downto 0);
    type      REQ_BUF_PTR_VECTOR    is array (integer range <>) of std_logic_vector(BUF_DEPTH          -1 downto 0);
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
        variable v_req_addr  :  std_logic_vector(REQ_ADDR_BITS-1 downto 0);
    begin
        v_req_addr := (others => '0');
        for i in VEC'range loop
            if (SEL(i) = '1') then
                v_req_addr := v_req_addr or VEC(i);
            end if;
        end loop;
        return v_req_addr;
    end function;
    ------------------------------------------------------------------------------
    -- 
    ------------------------------------------------------------------------------
    function  SELECT_REQ_SIZE(SEL: std_logic_vector; VEC: REQ_SIZE_VECTOR) return std_logic_vector is
        variable v_req_size  :  std_logic_vector(REQ_SIZE_BITS-1 downto 0);
    begin
        v_req_size := (others => '0');
        for i in VEC'range loop
            if (SEL(i) = '1') then
                v_req_size := v_req_size or VEC(i);
            end if;
        end loop;
        return v_req_size;
    end function;
    ------------------------------------------------------------------------------
    -- 
    ------------------------------------------------------------------------------
    function  SELECT_REQ_MODE(SEL: std_logic_vector; VEC: REQ_MODE_VECTOR) return std_logic_vector is
        variable v_req_mode  :  std_logic_vector(REG_PARAM.MODE_BITS-1 downto 0);
    begin
        v_req_mode := (others => '0');
        for i in VEC'range loop
            if (SEL(i) = '1') then
                v_req_mode := v_req_mode or VEC(i);
            end if;
        end loop;
        return v_req_mode;
    end function;
    ------------------------------------------------------------------------------
    -- 
    ------------------------------------------------------------------------------
    function  SELECT_REQ_BUF_PTR(SEL: std_logic_vector; VEC: REQ_BUF_PTR_VECTOR) return std_logic_vector is
        variable v_req_buf_ptr :  std_logic_vector(BUF_DEPTH-1 downto 0);
    begin
        v_req_buf_ptr := (others => '0');
        for i in VEC'range loop
            if (SEL(i) = '1') then
                v_req_buf_ptr := v_req_buf_ptr or VEC(i);
            end if;
        end loop;
        return v_req_buf_ptr;
    end function;
    ------------------------------------------------------------------------------
    -- 
    ------------------------------------------------------------------------------
    signal    i_req_addr            :  REQ_ADDR_VECTOR   (WAYS-1 downto 0);
    signal    i_req_size            :  REQ_SIZE_VECTOR   (WAYS-1 downto 0);
    signal    i_req_mode            :  REQ_MODE_VECTOR(   WAYS-1 downto 0);
    signal    i_req_buf_ptr         :  REQ_BUF_PTR_VECTOR(WAYS-1 downto 0);
    signal    i_req_first           :  std_logic_vector  (WAYS-1 downto 0);
    signal    i_req_last            :  std_logic_vector  (WAYS-1 downto 0);
    signal    i_req_none            :  std_logic_vector  (WAYS-1 downto 0);
    signal    i_req_valid           :  std_logic_vector  (WAYS-1 downto 0);
    signal    i_req_ready           :  std_logic_vector  (WAYS-1 downto 0);
    signal    i_flow_ready          :  std_logic_vector  (WAYS-1 downto 0);
    signal    i_flow_stop           :  std_logic_vector  (WAYS-1 downto 0);
begin
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    REQ: block
        constant  ARB_NULL          :  std_logic_vector  (WAYS-1 downto 0) := (others => '0');
        signal    arb_request       :  std_logic_vector  (0 to WAYS-1);
        signal    arb_grant         :  std_logic_vector  (0 to WAYS-1);
        signal    arb_valid         :  std_logic;
        signal    arb_shift         :  std_logic;
        type      STATE_TYPE        is (IDLE_STATE, REQ_STATE, ACK_STATE);
        signal    curr_state        :  STATE_TYPE;
        signal    arb_sel           :  std_logic_vector  (WAYS-1 downto 0);
        signal    curr_val          :  std_logic_vector  (WAYS-1 downto 0);
        function  REVERSE_VECTOR(A: in std_logic_vector) return std_logic_vector is
            variable  reserved_a :  std_logic_vector(A'reverse_range);
        begin
            for i in reserved_a'range loop
                reserved_a(i) := A(i);
            end loop;
            return reserved_a;
        end function;
    begin
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        ARB: QUEUE_TREE_ARBITER                  -- 
            generic map (                        -- 
                MIN_NUM     => 0              ,  -- 
                MAX_NUM     => WAYS-1         , -- 
                NODE_NUM    => ARB_NODE_NUM   ,  --
                PIPELINE    => ARB_PIPELINE      -- 
            )                                    -- 
            port map (                           -- 
                CLK         => CLK            ,  -- In  :
                RST         => RST            ,  -- In  :
                CLR         => CLR            ,  -- In  :
                REQUEST     => arb_request    ,  -- In  :
                GRANT       => arb_grant      ,  -- Out :
                VALID       => arb_valid      ,  -- Out :
                SHIFT       => arb_shift         -- In  :
            );                                   --
        arb_request <= REVERSE_VECTOR(i_req_valid);
        arb_sel     <= REVERSE_VECTOR(arb_grant);
        arb_shift   <= '1' when ((ACK_VALID and curr_val) /= ARB_NULL) else '0';
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (CLK, RST) begin
            if (RST = '1') then
                    curr_state  <= IDLE_STATE;
                    curr_val    <= (others => '0');
                    REQ_ADDR    <= (others => '0');
                    REQ_SIZE    <= (others => '0');
                    REQ_BUF_PTR <= (others => '0');
                    REQ_MODE    <= (others => '0');
                    REQ_FIRST   <= '0';
                    REQ_LAST    <= '0';
                    REQ_NONE    <= '0';
                    FLOW_STOP   <= '0';
            elsif (CLK'event and CLK = '1') then
                if (CLR = '1') then
                    curr_state  <= IDLE_STATE;
                    curr_val    <= (others => '0');
                    REQ_ADDR    <= (others => '0');
                    REQ_SIZE    <= (others => '0');
                    REQ_BUF_PTR <= (others => '0');
                    REQ_MODE    <= (others => '0');
                    REQ_FIRST   <= '0';
                    REQ_LAST    <= '0';
                    REQ_NONE    <= '0';
                    FLOW_STOP   <= '0';
                else
                    case curr_state is
                        when IDLE_STATE =>
                            if (arb_valid = '1') then
                                curr_state <= REQ_STATE;
                                curr_val   <= arb_sel;
                            else
                                curr_state <= IDLE_STATE;
                                curr_val   <= (others => '0');
                            end if;
                            REQ_ADDR    <= SELECT_REQ_ADDR(   arb_sel, i_req_addr   );
                            REQ_SIZE    <= SELECT_REQ_SIZE(   arb_sel, i_req_size   );
                            REQ_BUF_PTR <= SELECT_REQ_BUF_PTR(arb_sel, i_req_buf_ptr);
                            REQ_MODE    <= SELECT_REQ_MODE(   arb_sel, i_req_mode   );
                            REQ_FIRST   <= SELECT_REQ_FLAG(   arb_sel, i_req_first  );
                            REQ_LAST    <= SELECT_REQ_FLAG(   arb_sel, i_req_last   );
                            REQ_NONE    <= SELECT_REQ_FLAG(   arb_sel, i_req_none   );
                            FLOW_STOP   <= SELECT_REQ_FLAG(   arb_sel, i_flow_stop  );
                        when REQ_STATE =>
                            if    (REQ_READY = '0') then
                                curr_state <= REQ_STATE;
                            elsif (arb_shift = '1') then
                                curr_state <= IDLE_STATE;
                                curr_val   <= (others => '0');
                                FLOW_STOP  <= '0';
                            else
                                curr_state <= ACK_STATE;
                            end if;
                        when ACK_STATE =>
                            if (arb_shift = '1') then
                                curr_state <= IDLE_STATE;
                                curr_val   <= (others => '0');
                                FLOW_STOP  <= '0';
                            else
                                curr_state <= ACK_STATE;
                            end if;
                        when others => 
                                curr_state <= IDLE_STATE;
                                curr_val   <= (others => '0');
                                FLOW_STOP  <= '0';
                    end case;
                end if;
            end if;
        end process;
        REQ_VALID   <= curr_val;
        FLOW_READY  <= '1';
        FLOW_PAUSE  <= '0';
        FLOW_LAST   <= '0';
        FLOW_SIZE   <= std_logic_vector(to_unsigned(MAX_XFER_BYTES, FLOW_SIZE'length));
        i_req_ready <= (others => '1');
    end block;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    CH: for channel in 0 to WAYS-1 generate
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
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        signal    c_req_valid       :  std_logic;
        signal    c_req_ready       :  std_logic;
        signal    c_ack_valid       :  std_logic;
        signal    c_ack_size        :  std_logic_vector(BUF_DEPTH         downto 0);
        signal    c_ack_error       :  std_logic;
        signal    c_ack_next        :  std_logic;
        signal    c_ack_last        :  std_logic;
        signal    c_ack_stop        :  std_logic;
        signal    c_ack_none        :  std_logic;
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        signal    mrg_in_data       :  std_logic_vector(WORDS*WORD_BITS  -1 downto 0);
        signal    mrg_in_strb       :  std_logic_vector(WORDS*WORD_BITS/8-1 downto 0);
        signal    mrg_in_none       :  std_logic_vector(WORDS            -1 downto 0);
        signal    mrg_in_last       :  std_logic;
        signal    mrg_in_valid      :  std_logic;
        signal    mrg_in_ready      :  std_logic;
        signal    mrg_in_eblk       :  std_logic;
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        signal    i_open            :  std_logic;
        signal    i_end_of_blk      :  std_logic;
        signal    o_open_valid      :  std_logic;
        signal    o_close_valid     :  std_logic;
        signal    o_end_of_blk      :  std_logic;
        signal    o_reset           :  std_logic;
        signal    o_stop            :  std_logic;
        signal    o_error           :  std_logic;
        signal    o_open            :  std_logic;
        signal    o_done            :  std_logic;
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
                O_DATA_BITS         => WORD_BITS*WORDS         , --
                O_WORD_BITS         => WORD_BITS               , --
                BUF_DEPTH           => BUF_DEPTH               , --
                BUF_DATA_BITS       => BUF_DATA_BITS           , --
                I2O_OPEN_INFO_BITS  => 1                       , --
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
                I_REQ_VALID         => c_req_valid             , --  Out :
                I_REQ_ADDR          => i_req_addr    (channel) , --  Out :
                I_REQ_SIZE          => i_req_size    (channel) , --  Out :
                I_REQ_BUF_PTR       => i_req_buf_ptr (channel) , --  Out :
                I_REQ_FIRST         => i_req_first   (channel) , --  Out :
                I_REQ_LAST          => i_req_last    (channel) , --  Out :
                I_REQ_NONE          => i_req_none    (channel) , --  Out :
                I_REQ_READY         => c_req_ready             , --  In  :
            -----------------------------------------------------------------------
            -- Intake Transaction Command Acknowledge Signals.
            -----------------------------------------------------------------------
                I_ACK_VALID         => c_ack_valid             , --  In  :
                I_ACK_SIZE          => c_ack_size              , --  In  :
                I_ACK_ERROR         => c_ack_error             , --  In  :
                I_ACK_NEXT          => c_ack_next              , --  In  :
                I_ACK_LAST          => c_ack_last              , --  In  :
                I_ACK_STOP          => c_ack_stop              , --  In  :
                I_ACK_NONE          => c_ack_none              , --  In  :
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
                I_FLOW_STOP         => i_flow_stop   (channel) , --  Out :
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
                I_OPEN              => i_open                  , --  Out :
                I_TRAN_BUSY         => open                    , --  Out :
                I_TRAN_DONE         => open                    , --  Out :
                I_TRAN_ERROR        => open                    , --  Out :
            -----------------------------------------------------------------------
            -- Intake Open/Close Infomation Interface
            -----------------------------------------------------------------------
                I_I2O_OPEN_INFO(0)  => i_end_of_blk            , --  In  :
                I_I2O_CLOSE_INFO    => "0"                     , --  In  :
                I_O2I_OPEN_INFO     => open                    , --  Out :
                I_O2I_OPEN_VALID    => open                    , --  Out :
                I_O2I_CLOSE_INFO    => open                    , --  Out :
                I_O2I_CLOSE_VALID   => open                    , --  Out :
                I_O2I_STOP          => open                    , --  Out :
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
                O_STRB              => mrg_in_strb             , --  Out :
                O_LAST              => mrg_in_last             , --  Out :
                O_VALID             => mrg_in_valid            , --  Out :
                O_READY             => mrg_in_ready            , --  In  :
            -----------------------------------------------------------------------
            -- Outlet Status.
            -----------------------------------------------------------------------
                O_OPEN              => o_open                  , --  Out :
                O_DONE              => o_done                  , --  Out :
            -----------------------------------------------------------------------
            -- Outlet Open/Close Infomation Interface
            -----------------------------------------------------------------------
                O_O2I_STOP          => '0'                     , --  In  :
                O_O2I_OPEN_INFO     => "0"                     , --  In  :
                O_O2I_OPEN_VALID    => o_open_valid            , --  In  :
                O_O2I_CLOSE_INFO    => "0"                     , --  In  :
                O_O2I_CLOSE_VALID   => o_close_valid           , --  In  :
                O_I2O_RESET         => o_reset                 , --  Out :
                O_I2O_ERROR         => o_error                 , --  Out :
                O_I2O_STOP          => o_stop                  , --  Out :
                O_I2O_OPEN_INFO(0)  => o_end_of_blk            , --  Out :
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
        REQ: block
            type      STATE_TYPE    is (IDLE_STATE    ,
                                        I_REQ_STATE   ,
                                        NONE_ACK_STATE);
            signal    curr_state    :  STATE_TYPE;
            signal    req_last      :  std_logic;
        begin
            process (CLK, RST) begin
                if (RST = '1') then
                        curr_state  <= IDLE_STATE;
                        req_last    <= '0';
                elsif (CLK'event and CLK = '1') then
                    if (CLR = '1' or o_reset = '1') then
                        curr_state  <= IDLE_STATE;
                        req_last    <= '0';
                    else
                        case curr_state is
                            when IDLE_STATE =>
                                if    (c_req_valid = '1' and i_req_none  (channel) = '1') then
                                    curr_state <= NONE_ACK_STATE;
                                elsif (c_req_valid = '1' and i_flow_ready(channel) = '1') or
                                      (c_req_valid = '1' and i_flow_stop (channel) = '1') then
                                    curr_state <= I_REQ_STATE;
                                else
                                    curr_state <= IDLE_STATE;
                                end if;
                                req_last <= i_req_last(channel);
                            when I_REQ_STATE =>
                                if    (ACK_VALID(channel) = '1') then
                                    curr_state <= IDLE_STATE;
                                else
                                    curr_state <= I_REQ_STATE;
                                end if;
                            when NONE_ACK_STATE =>
                                    curr_state <= IDLE_STATE;
                            when others =>
                                    curr_state <= IDLE_STATE;
                        end case;
                    end if;
                end if;
            end process;
            -----------------------------------------------------------------------
            --
            -----------------------------------------------------------------------
            i_req_valid(channel) <= '1' when (curr_state = I_REQ_STATE) else '0';
            c_req_ready          <= '1';
            -----------------------------------------------------------------------
            --
            -----------------------------------------------------------------------
            c_ack_valid <= ACK_VALID (channel) when (curr_state = I_REQ_STATE   ) else
                           '1'                 when (curr_state = NONE_ACK_STATE) else '0';
            c_ack_size  <= ACK_SIZE            when (curr_state = I_REQ_STATE   ) else (others => '0');
            c_ack_error <= ACK_ERROR           when (curr_state = I_REQ_STATE   ) else '0';
            c_ack_next  <= ACK_NEXT            when (curr_state = I_REQ_STATE   ) else
                           '1'                 when (curr_state = NONE_ACK_STATE and req_last = '0') else '0';
            c_ack_last  <= ACK_LAST            when (curr_state = I_REQ_STATE   ) else
                           '1'                 when (curr_state = NONE_ACK_STATE and req_last = '1') else '0';
            c_ack_stop  <= ACK_STOP            when (curr_state = I_REQ_STATE   ) else '0';
            c_ack_none  <= ACK_NONE            when (curr_state = I_REQ_STATE   ) else
                           '1'                 when (curr_state = NONE_ACK_STATE) else '0';
        end block;
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
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        MRG: block
            type      STATE_TYPE    is (IDLE_STATE    ,
                                        MRG_READ_STATE,
                                        MRG_NONE_STATE,
                                        CHK_NONE_STATE,
                                        END_NONE_STATE);
            signal    curr_state    :  STATE_TYPE;
            signal    o_none        :  std_logic;
        begin 
            process (CLK, RST) begin
                if (RST = '1') then
                        curr_state  <= IDLE_STATE;
                        o_none      <= '0';
                        mrg_in_eblk <= '0';
                elsif (CLK'event and CLK = '1') then
                    if (CLR = '1' or o_reset = '1') then
                        curr_state  <= IDLE_STATE;
                        o_none      <= '0';
                        mrg_in_eblk <= '0';
                    else
                        case curr_state is
                            when IDLE_STATE =>
                                if (o_open_valid = '1') then
                                    curr_state <= MRG_READ_STATE;
                                else
                                    curr_state <= IDLE_STATE;
                                end if;
                                if (o_open_valid = '1') then
                                    mrg_in_eblk <= o_end_of_blk;
                                end if;
                                o_none <= '1';
                            when MRG_READ_STATE =>
                                if (o_open = '0') or
                                   (o_open = '1' and o_done = '1') then
                                    curr_state <= CHK_NONE_STATE;
                                else
                                    curr_state <= MRG_READ_STATE;
                                end if;
                                if (mrg_in_valid = '1' and mrg_in_ready = '1') then
                                    o_none <= '0';
                                end if;
                            when CHK_NONE_STATE =>
                                if (o_none = '0') then
                                    curr_state <= IDLE_STATE;
                                else
                                    curr_state <= MRG_NONE_STATE;
                                end if;
                            when MRG_NONE_STATE =>
                                if (MRG_READY(channel) = '1') then
                                    curr_state <= END_NONE_STATE;
                                else
                                    curr_state <= MRG_NONE_STATE;
                                end if;
                            when END_NONE_STATE =>
                                    curr_state <= IDLE_STATE;
                            when others => 
                                    curr_state <= IDLE_STATE;
                        end case;
                    end if;
                end if;
            end process;
            -----------------------------------------------------------------------
            --
            -----------------------------------------------------------------------
            BUSY(channel) <= '1' when ((curr_state = IDLE_STATE     and i_open = '1') or
                                       (curr_state = MRG_READ_STATE                 ) or
                                       (curr_state = CHK_NONE_STATE                 ) or
                                       (curr_state = MRG_NONE_STATE                 ) or
                                       (curr_state = END_NONE_STATE                 )) else '0';
            DONE(channel) <= '1' when ((curr_state = CHK_NONE_STATE and o_none = '0') or
                                       (curr_state = END_NONE_STATE                 )) else '0';
            -----------------------------------------------------------------------
            --
            -----------------------------------------------------------------------
            process (curr_state, mrg_in_strb) begin
                for i in mrg_in_none'range loop
                    if (curr_state = MRG_NONE_STATE) or
                       (mrg_in_strb(i*(WORD_BITS/8)) = '0') then
                        mrg_in_none(i) <= '1';
                    else
                        mrg_in_none(i) <= '0';
                    end if;
                end loop;
            end process;
            -----------------------------------------------------------------------
            --
            -----------------------------------------------------------------------
            MRG_DATA((channel+1)*(WORDS*WORD_BITS)-1 downto channel*(WORDS*WORD_BITS)) <= mrg_in_data;
            MRG_NONE((channel+1)*(WORDS          )-1 downto channel*(WORDS          )) <= mrg_in_none;
            MRG_VALID(channel) <= '1' when (curr_state = MRG_NONE_STATE) or
                                           (curr_state = MRG_READ_STATE and mrg_in_valid = '1') else '0';
            MRG_LAST (channel) <= '1' when (curr_state = MRG_NONE_STATE) or
                                           (curr_state = MRG_READ_STATE and mrg_in_last  = '1') else '0';
            MRG_EBLK (channel) <= mrg_in_eblk;
            mrg_in_ready       <= '1' when (curr_state = MRG_READ_STATE and MRG_READY(channel) = '1') else '0';
        end block;
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

