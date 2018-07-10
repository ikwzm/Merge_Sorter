-----------------------------------------------------------------------------------
--!     @file    merge_sorter_argsort_reader.vhd
--!     @brief   Merge Sorter ArgSort Reader Module :
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
entity  Merge_Sorter_ArgSort_Reader is
    generic (
        REG_PARAM       :  Merge_Sorter_Interface.Regs_Field_Type := Merge_Sorter_Interface.Default_Regs_Param;
        REQ_ADDR_BITS   :  integer := 32;
        REQ_SIZE_BITS   :  integer := 32;
        BUF_DATA_BITS   :  integer := 64;
        BUF_DEPTH       :  integer := 13;
        MAX_XFER_SIZE   :  integer := 12;
        STM_NUM         :  integer :=  1;
        STM_DATA_BITS   :  integer := 64;
        STM_INDEX_LO    :  integer :=  0;
        STM_INDEX_HI    :  integer := 31;
        STM_COMP_LO     :  integer := 32;
        STM_COMP_HI     :  integer := 63
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
        REG_L           :  in  std_logic_vector(REG_PARAM.BITS     -1 downto 0);
        REG_D           :  in  std_logic_vector(REG_PARAM.BITS     -1 downto 0);
        REG_Q           :  out std_logic_vector(REG_PARAM.BITS     -1 downto 0);
    -------------------------------------------------------------------------------
    -- Transaction Command Request Signals.
    -------------------------------------------------------------------------------
        REQ_VALID       :  out std_logic;
        REQ_ADDR        :  out std_logic_vector(REQ_ADDR_BITS      -1 downto 0);
        REQ_SIZE        :  out std_logic_vector(REQ_SIZE_BITS      -1 downto 0);
        REQ_BUF_PTR     :  out std_logic_vector(BUF_DEPTH          -1 downto 0);
        REQ_MODE        :  out std_logic_vector(REG_PARAM.MODE_BITS-1 downto 0);
        REQ_FIRST       :  out std_logic;
        REQ_LAST        :  out std_logic;
        REQ_READY       :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transaction Command Acknowledge Signals.
    -------------------------------------------------------------------------------
        ACK_VALID       :  in  std_logic;
        ACK_SIZE        :  in  std_logic_vector(BUF_DEPTH             downto 0);
        ACK_ERROR       :  in  std_logic := '0';
        ACK_NEXT        :  in  std_logic;
        ACK_LAST        :  in  std_logic;
        ACK_STOP        :  in  std_logic;
        ACK_NONE        :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transfer Status Signals.
    -------------------------------------------------------------------------------
        XFER_BUSY       :  in  std_logic;
        XFER_DONE       :  in  std_logic;
        XFER_ERROR      :  in  std_logic := '0';
    -------------------------------------------------------------------------------
    -- Intake Flow Control Signals.
    -------------------------------------------------------------------------------
        FLOW_READY      :  out std_logic;
        FLOW_PAUSE      :  out std_logic;
        FLOW_STOP       :  out std_logic;
        FLOW_LAST       :  out std_logic;
        FLOW_SIZE       :  out std_logic_vector(BUF_DEPTH             downto 0);
        PUSH_FIN_VALID  :  in  std_logic;
        PUSH_FIN_LAST   :  in  std_logic;
        PUSH_FIN_ERROR  :  in  std_logic := '0';
        PUSH_FIN_SIZE   :  in  std_logic_vector(BUF_DEPTH             downto 0);
        PUSH_BUF_RESET  :  in  std_logic;
        PUSH_BUF_VALID  :  in  std_logic;
        PUSH_BUF_LAST   :  in  std_logic;
        PUSH_BUF_ERROR  :  in  std_logic := '0';
        PUSH_BUF_SIZE   :  in  std_logic_vector(BUF_DEPTH             downto 0);
        PUSH_BUF_READY  :  out std_logic;
    -------------------------------------------------------------------------------
    -- Buffer Interface Signals.
    -------------------------------------------------------------------------------
        BUF_WEN         :  in  std_logic;
        BUF_BEN         :  in  std_logic_vector(BUF_DATA_BITS/8    -1 downto 0);
        BUF_DATA        :  in  std_logic_vector(BUF_DATA_BITS      -1 downto 0);
        BUF_PTR         :  in  std_logic_vector(BUF_DEPTH             downto 0);
    -------------------------------------------------------------------------------
    -- Merge Outlet Signals.
    -------------------------------------------------------------------------------
        STM_DATA        :  out std_logic_vector(STM_NUM*STM_DATA_BITS  -1 downto 0);
        STM_STRB        :  out std_logic_vector(STM_NUM*STM_DATA_BITS/8-1 downto 0);
        STM_LAST        :  out std_logic;
        STM_VALID       :  out std_logic;
        STM_READY       :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Intake Status Output.
    -------------------------------------------------------------------------------
        I_OPEN          :  out std_logic;
        I_RUNNING       :  out std_logic;
        I_DONE          :  out std_logic;
        I_ERROR         :  out std_logic;
        I_IRQ           :  out std_logic
    );
end Merge_Sorter_ArgSort_Reader;
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library Merge_Sorter;
use     Merge_Sorter.Merge_Sorter_Interface;
library PIPEWORK;
use     PIPEWORK.PUMP_COMPONENTS.PUMP_STREAM_INTAKE_CONTROLLER;
use     PIPEWORK.COMPONENTS.SDPRAM;
architecture RTL of Merge_Sorter_ArgSort_Reader is
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
    constant  STM_COMP_BITS         :  integer := STM_COMP_HI  - STM_COMP_LO  + 1;
    constant  STM_INDEX_BITS        :  integer := STM_INDEX_HI - STM_INDEX_LO + 1;
    ------------------------------------------------------------------------------
    -- 
    ------------------------------------------------------------------------------
    constant  BUF_DATA_WIDTH        :  integer := CALC_DATA_WIDTH(BUF_DATA_BITS);
    ------------------------------------------------------------------------------
    -- 
    ------------------------------------------------------------------------------
    signal    reg_load              :  std_logic_vector(REG_PARAM.BITS -1 downto 0);
    signal    reg_wbit              :  std_logic_vector(REG_PARAM.BITS -1 downto 0);
    signal    reg_rbit              :  std_logic_vector(REG_PARAM.BITS -1 downto 0);
    ------------------------------------------------------------------------------
    -- 
    ------------------------------------------------------------------------------
    signal    buf_ren               :  std_logic;
    signal    buf_rptr              :  std_logic_vector(BUF_DEPTH      -1 downto 0);
    signal    buf_rdata             :  std_logic_vector(BUF_DATA_BITS  -1 downto 0);
    signal    buf_we                :  std_logic_vector(BUF_DATA_BITS/8-1 downto 0);
    ------------------------------------------------------------------------------
    -- 
    ------------------------------------------------------------------------------
    signal    comp_data             :  std_logic_vector(STM_NUM*STM_COMP_BITS  -1 downto 0);
    signal    comp_strb             :  std_logic_vector(STM_NUM*STM_COMP_BITS/8-1 downto 0);
    signal    comp_last             :  std_logic;
    signal    comp_valid            :  std_logic;
    signal    comp_ready            :  std_logic;
    ------------------------------------------------------------------------------
    -- 
    ------------------------------------------------------------------------------
    signal    o_reset               :  std_logic;
    signal    o_open_valid          :  std_logic;
    signal    o_close_valid         :  std_logic;
begin 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    reg_load <= REG_L;
    reg_wbit <= REG_D;
    REG_Q <= reg_rbit;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
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
            O_DATA_BITS         => STM_NUM*STM_COMP_BITS   , --
            BUF_DEPTH           => BUF_DEPTH               , --
            BUF_DATA_BITS       => BUF_DATA_BITS           , --
            I2O_OPEN_INFO_BITS  => 1                       , --
            I2O_CLOSE_INFO_BITS => 1                       , --
            O2I_OPEN_INFO_BITS  => 1                       , --
            O2I_CLOSE_INFO_BITS => 1                       , --
            I2O_DELAY_CYCLE     => 1                         --
        )                                                    -- 
        port map (                                           -- 
        ---------------------------------------------------------------------------
        -- Reset Signals.
        ---------------------------------------------------------------------------
            RST                 => RST                     , --  In  :
        ---------------------------------------------------------------------------
        -- Intake Clock and Clock Enable.
        ---------------------------------------------------------------------------
            I_CLK               => CLK                     , --  In  :
            I_CLR               => CLR                     , --  In  :
            I_CKE               => '1'                     , --  In  :
        ---------------------------------------------------------------------------
        -- Intake Control Register Interface.
        ---------------------------------------------------------------------------
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
        ---------------------------------------------------------------------------
        -- Intake Configuration Signals.
        ---------------------------------------------------------------------------
            I_ADDR_FIX          => '0'                     , --  In  :
            I_BUF_READY_LEVEL   => I_BUF_READY_LEVEL       , --  In  :
            I_FLOW_READY_LEVEL  => I_FLOW_READY_LEVEL      , --  In  :
        ---------------------------------------------------------------------------
        -- Intake Transaction Command Request Signals.
        ---------------------------------------------------------------------------
            I_REQ_VALID         => REQ_VALID               , --  Out :
            I_REQ_ADDR          => REQ_ADDR                , --  Out :
            I_REQ_SIZE          => REQ_SIZE                , --  Out :
            I_REQ_BUF_PTR       => REQ_BUF_PTR             , --  Out :
            I_REQ_FIRST         => REQ_FIRST               , --  Out :
            I_REQ_LAST          => REQ_LAST                , --  Out :
            I_REQ_READY         => REQ_READY               , --  In  :
        ---------------------------------------------------------------------------
        -- Intake Transaction Command Acknowledge Signals.
        ---------------------------------------------------------------------------
            I_ACK_VALID         => ACK_VALID               , --  In  :
            I_ACK_SIZE          => ACK_SIZE                , --  In  :
            I_ACK_ERROR         => ACK_ERROR               , --  In  :
            I_ACK_NEXT          => ACK_NEXT                , --  In  :
            I_ACK_LAST          => ACK_LAST                , --  In  :
            I_ACK_STOP          => ACK_STOP                , --  In  :
            I_ACK_NONE          => ACK_NONE                , --  In  :
        ---------------------------------------------------------------------------
        -- Intake Transfer Status Signals.
        ---------------------------------------------------------------------------
            I_XFER_BUSY         => XFER_BUSY               , --  In  :
            I_XFER_DONE         => XFER_DONE               , --  In  :
            I_XFER_ERROR        => XFER_ERROR              , --  In  :
        ---------------------------------------------------------------------------
        -- Intake Flow Control Signals.
        ---------------------------------------------------------------------------
            I_FLOW_READY        => FLOW_READY              , --  Out :
            I_FLOW_PAUSE        => FLOW_PAUSE              , --  Out :
            I_FLOW_STOP         => FLOW_STOP               , --  Out :
            I_FLOW_LAST         => FLOW_LAST               , --  Out :
            I_FLOW_SIZE         => FLOW_SIZE               , --  Out :
            I_PUSH_FIN_VALID    => PUSH_FIN_VALID          , --  In  :
            I_PUSH_FIN_LAST     => PUSH_FIN_LAST           , --  In  :
            I_PUSH_FIN_ERROR    => PUSH_FIN_ERROR          , --  In  :
            I_PUSH_FIN_SIZE     => PUSH_FIN_SIZE           , --  In  :
            I_PUSH_BUF_RESET    => PUSH_BUF_RESET          , --  In  :
            I_PUSH_BUF_VALID    => PUSH_BUF_VALID          , --  In  :
            I_PUSH_BUF_LAST     => PUSH_BUF_LAST           , --  In  :
            I_PUSH_BUF_ERROR    => PUSH_BUF_ERROR          , --  In  :
            I_PUSH_BUF_SIZE     => PUSH_BUF_SIZE           , --  In  :
            I_PUSH_BUF_READY    => PUSH_BUF_READY          , --  Out :
        ---------------------------------------------------------------------------
        -- Intake Status.
        ---------------------------------------------------------------------------
            I_OPEN              => I_OPEN                  , --  Out :
            I_RUNNING           => I_RUNNING               , --  Out :
            I_DONE              => I_DONE                  , --  Out :
            I_ERROR             => I_ERROR                 , --  Out :
        ---------------------------------------------------------------------------
        -- Intake Open/Close Infomation Interface
        ---------------------------------------------------------------------------
            I_I2O_OPEN_INFO     => "0"                     , --  In  :
            I_I2O_CLOSE_INFO    => "0"                     , --  In  :
            I_O2I_OPEN_INFO     => open                    , --  Out :
            I_O2I_OPEN_VALID    => open                    , --  Out :
            I_O2I_CLOSE_INFO    => open                    , --  Out :
            I_O2I_CLOSE_VALID   => open                    , --  Out :
            I_O2I_STOP_VALID    => open                    , --  Out :
        ---------------------------------------------------------------------------
        -- Outlet Clock and Clock Enable.
        ---------------------------------------------------------------------------
            O_CLK               => CLK                     , --  In  :
            O_CLR               => CLR                     , --  In  :
            O_CKE               => '1'                     , --  In  :
        ---------------------------------------------------------------------------
        -- Outlet Stream Interface.
        ---------------------------------------------------------------------------
            O_DATA              => comp_data               , --  Out :
            O_STRB              => comp_strb               , --  Out :
            O_LAST              => comp_last               , --  Out :
            O_VALID             => comp_valid              , --  Out :
            O_READY             => comp_ready              , --  In  :
        ---------------------------------------------------------------------------
        -- Outlet Status.
        ---------------------------------------------------------------------------
            O_OPEN              => open                    , --  Out :
            O_RUNNING           => open                    , --  Out :
            O_DONE              => open                    , --  Out :
            O_ERROR             => open                    , --  Out :
        ---------------------------------------------------------------------------
        -- Outlet Open/Close Infomation Interface
        ---------------------------------------------------------------------------
            O_O2I_STOP_VALID    => '0'                     , --  In  :
            O_O2I_OPEN_INFO     => "0"                     , --  In  :
            O_O2I_OPEN_VALID    => o_open_valid            , --  In  :
            O_O2I_CLOSE_INFO    => "0"                     , --  In  :
            O_O2I_CLOSE_VALID   => o_close_valid           , --  In  :
            O_I2O_RESET         => o_reset                 , --  Out :
            O_I2O_STOP_VALID    => open                    , --  Out :
            O_I2O_OPEN_INFO     => open                    , --  Out :
            O_I2O_OPEN_VALID    => o_open_valid            , --  Out :
            O_I2O_CLOSE_INFO    => open                    , --  Out :
            O_I2O_CLOSE_VALID   => o_close_valid           , --  Out :
        ---------------------------------------------------------------------------
        -- Outlet Buffer Read Interface.
        ---------------------------------------------------------------------------
            BUF_REN             => buf_ren                 , --  Out :
            BUF_PTR             => buf_rptr                , --  Out :
            BUF_DATA            => buf_rdata                 --  In  :
        );                                                   --
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    RAM: SDPRAM 
        generic map(
            DEPTH       => BUF_DEPTH+3         ,
            RWIDTH      => BUF_DATA_WIDTH      , --
            WWIDTH      => BUF_DATA_WIDTH      , --
            WEBIT       => BUF_DATA_WIDTH-3    , --
            ID          => 0                     -- 
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
    buf_we <= BUF_BEN when (BUF_WEN = '1') else (others => '0');
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    STM_OUT: for i in 0 to STM_NUM-1 generate
        constant  STM_STRB_BITS  :  integer := STM_DATA_BITS/8;
        constant  STM_STRB_ALL_1 :  std_logic_vector(STM_STRB_BITS-1 downto 0) := (others => '1');
        constant  STM_STRB_ALL_0 :  std_logic_vector(STM_STRB_BITS-1 downto 0) := (others => '0');
        signal    o_strb         :  std_logic_vector(STM_STRB_BITS-1 downto 0);
        signal    o_data         :  std_logic_vector(STM_DATA_BITS-1 downto 0);
        signal    index          :  unsigned(STM_INDEX_BITS-1 downto 0);
    begin
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (CLK, RST) begin
            if (RST = '1') then
                    index <= to_unsigned(i, index'length);
            elsif (CLK'event and CLK = '1') then
                if    (CLR = '1' or o_reset = '1' or o_open_valid = '1') then
                    index <= to_unsigned(i, index'length);
                elsif (comp_valid = '1' and comp_ready = '1') then
                    index <= index + STM_NUM;
                end if;
            end if;
        end process;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        o_strb <= STM_STRB_ALL_1 when (comp_strb(i*(STM_COMP_BITS/8)) = '1') else STM_STRB_ALL_0;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        o_data(STM_COMP_HI  downto STM_COMP_LO ) <= comp_data((i+1)*STM_COMP_BITS-1 downto i*STM_COMP_BITS);
        o_data(STM_INDEX_HI downto STM_INDEX_LO) <= std_logic_vector(index);
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        STM_DATA((i+1)*STM_DATA_BITS-1 downto i*STM_DATA_BITS) <= o_data;
        STM_STRB((i+1)*STM_STRB_BITS-1 downto i*STM_STRB_BITS) <= o_strb;
    end generate;
    STM_LAST   <= comp_last;
    STM_VALID  <= comp_valid;
    comp_ready <= STM_READY;
end RTL;