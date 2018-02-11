-----------------------------------------------------------------------------------
--!     @file    merge_sorter_core_testbench.vhd
--!     @brief   Merge Sorter Core Test Bench :
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
entity  Merge_Sorter_Core_Test_Bench is
    generic (
        NAME            :  STRING  := "TEST";
        SCENARIO_FILE   :  STRING  := "test.snr";
        I_NUM           :  integer := 4;
        STM_ENABLE      :  integer := 1;
        STM_FEEDBACK    :  integer := 1;
        STM_I_WORDS     :  integer := 1;
        MRG_ENABLE      :  integer := 1;
        MRG_FIFO_SIZE   :  integer := 64;
        SORT_ORDER      :  integer := 0
    );
end     Merge_Sorter_Core_Test_Bench;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     std.textio.all;
library Merge_Sorter;
library DUMMY_PLUG;
use     DUMMY_PLUG.AXI4_TYPES.all;
use     DUMMY_PLUG.AXI4_MODELS.AXI4_STREAM_MASTER_PLAYER;
use     DUMMY_PLUG.AXI4_MODELS.AXI4_STREAM_SLAVE_PLAYER;
use     DUMMY_PLUG.SYNC.all;
use     DUMMY_PLUG.UTIL.HEX_TO_STRING;
use     DUMMY_PLUG.CORE.MARCHAL;
use     DUMMY_PLUG.CORE.REPORT_STATUS_TYPE;
use     DUMMY_PLUG.CORE.REPORT_STATUS_VECTOR;
architecture Model of Merge_Sorter_Core_Test_Bench is
    -------------------------------------------------------------------------------
    -- 各種定数
    -------------------------------------------------------------------------------
    constant   PERIOD       :  time    := 10 ns;
    constant   DELAY        :  time    :=  1 ns;
    constant   QUEUE_SIZE   :  integer :=  2;
    constant   DATA_BITS    :  integer := 32;
    constant   COMP_HIGH    :  integer := 31;
    constant   COMP_LOW     :  integer :=  0;
    constant   INFO_BITS    :  integer :=  2;
    constant   SYNC_WIDTH   :  integer :=  2;
    constant   GPO_WIDTH    :  integer :=  8;
    constant   GPI_WIDTH    :  integer :=  GPO_WIDTH;
    -------------------------------------------------------------------------------
    -- グローバルシグナル.
    -------------------------------------------------------------------------------
    signal     CLOCK        :  std_logic;
    signal     ARESETn      :  std_logic;
    signal     RESET        :  std_logic;
    constant   CLEAR        :  std_logic := '0';
    -------------------------------------------------------------------------------
    -- シンクロ用信号
    -------------------------------------------------------------------------------
    signal     SYNC         : SYNC_SIG_VECTOR (SYNC_WIDTH     -1 downto 0);
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    constant   I_WIDTH      :  AXI4_STREAM_SIGNAL_WIDTH_TYPE := (
                                   ID    => 4,
                                   USER  => INFO_BITS,
                                   DEST  => 4,
                                   DATA  => DATA_BITS
                               );
    type       I_DATA_VECTOR is array (integer range <>) of std_logic_vector(DATA_BITS-1 downto 0);
    type       I_INFO_VECTOR is array (integer range <>) of std_logic_vector(INFO_BITS-1 downto 0);
    signal     i_data       :  I_DATA_VECTOR   (I_NUM-1 downto 0);
    signal     i_info       :  I_INFO_VECTOR   (I_NUM-1 downto 0);
    signal     i_last       :  std_logic_vector(I_NUM-1 downto 0);
    signal     i_valid      :  std_logic_vector(I_NUM-1 downto 0);
    signal     i_ready      :  std_logic_vector(I_NUM-1 downto 0);
    signal     i_flat_data  :  std_logic_vector(I_NUM*DATA_BITS-1 downto 0);
    signal     i_none       :  std_logic_vector(I_NUM          -1 downto 0);
    signal     i_done       :  std_logic_vector(I_NUM          -1 downto 0);
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    constant   S_WIDTH      :  AXI4_STREAM_SIGNAL_WIDTH_TYPE := (
                                   ID    => 4,
                                   USER  => INFO_BITS,
                                   DEST  => 4,
                                   DATA  => STM_I_WORDS*DATA_BITS
                               );
    signal     s_data       :  std_logic_vector(S_WIDTH.DATA  -1 downto 0);
    signal     s_word_strb  :  std_logic_vector(STM_I_WORDS   -1 downto 0);
    signal     s_last       :  std_logic;
    signal     s_valid      :  std_logic;
    signal     s_ready      :  std_logic;
    signal     s_keep       :  std_logic_vector(S_WIDTH.DATA/8-1 downto 0) := (others => '1');
    signal     s_strb       :  std_logic_vector(S_WIDTH.DATA/8-1 downto 0) := (others => '1');
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    constant   O_WIDTH      :  AXI4_STREAM_SIGNAL_WIDTH_TYPE := (
                                   ID    => 4,
                                   USER  => INFO_BITS,
                                   DEST  => 4,
                                   DATA  => DATA_BITS
                               );
    signal     o_data       :  std_logic_vector(DATA_BITS   -1 downto 0);
    signal     o_last       :  std_logic;
    signal     o_valid      :  std_logic;
    signal     o_ready      :  std_logic;
    constant   o_keep       :  std_logic_vector(DATA_BITS/8 -1 downto 0) := (others => '1');
    constant   o_strb       :  std_logic_vector(DATA_BITS/8 -1 downto 0) := (others => '1');
    constant   o_id         :  std_logic_vector(O_WIDTH.ID  -1 downto 0) := (others => '0');
    constant   o_dest       :  std_logic_vector(O_WIDTH.DEST-1 downto 0) := (others => '0');
    constant   o_user       :  std_logic_vector(O_WIDTH.USER-1 downto 0) := (others => '0');
    -------------------------------------------------------------------------------
    -- GPIO(General Purpose Input/Output)
    -------------------------------------------------------------------------------
    signal     O_GPI        :  std_logic_vector(GPI_WIDTH   -1 downto 0);
    signal     O_GPO        :  std_logic_vector(GPO_WIDTH   -1 downto 0);
    signal     S_GPI        :  std_logic_vector(GPI_WIDTH   -1 downto 0);
    signal     S_GPO        :  std_logic_vector(GPO_WIDTH   -1 downto 0);
    -------------------------------------------------------------------------------
    -- 各種状態出力.
    -------------------------------------------------------------------------------
    signal     N_REPORT     :  REPORT_STATUS_TYPE;
    signal     N_FINISH     :  std_logic;
    signal     O_REPORT     :  REPORT_STATUS_TYPE;
    signal     O_FINISH     :  std_logic;
    signal     S_REPORT     :  REPORT_STATUS_TYPE;
    signal     S_FINISH     :  std_logic;
    signal     I_REPORT     :  REPORT_STATUS_VECTOR(I_NUM-1 downto 0);
    signal     I_FINISH     :  std_logic_vector    (I_NUM-1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component  Merge_Sorter_Core 
        generic (
            SORT_ORDER      :  integer :=  0;
            I_NUM           :  integer :=  8;
            STM_ENABLE      :  integer :=  1;
            STM_I_WORDS     :  integer :=  1;
            STM_FEEDBACK    :  integer :=  1;
            MRG_ENABLE      :  integer :=  1;
            MRG_FIFO_SIZE   :  integer := 64;
            DATA_BITS       :  integer := 64;
            COMP_HIGH       :  integer := 63;
            COMP_LOW        :  integer := 32
        );
        port (
            CLK             :  in  std_logic;
            RST             :  in  std_logic;
            CLR             :  in  std_logic;
            STM_REQ_VALID   :  in  std_logic;
            STM_REQ_READY   :  out std_logic;
            STM_RES_VALID   :  out std_logic;
            STM_RES_READY   :  in  std_logic;
            STM_IN_DATA     :  in  std_logic_vector(STM_I_WORDS*DATA_BITS-1 downto 0);
            STM_IN_STRB     :  in  std_logic_vector(STM_I_WORDS          -1 downto 0);
            STM_IN_LAST     :  in  std_logic;
            STM_IN_VALID    :  in  std_logic;
            STM_IN_READY    :  out std_logic;
            MRG_REQ_VALID   :  in  std_logic;
            MRG_REQ_READY   :  out std_logic;
            MRG_RES_VALID   :  out std_logic;
            MRG_RES_READY   :  in  std_logic;
            MRG_IN_DATA     :  in  std_logic_vector(I_NUM*DATA_BITS-1 downto 0);
            MRG_IN_NONE     :  in  std_logic_vector(I_NUM          -1 downto 0);
            MRG_IN_DONE     :  in  std_logic_vector(I_NUM          -1 downto 0);
            MRG_IN_LAST     :  in  std_logic_vector(I_NUM          -1 downto 0);
            MRG_IN_VALID    :  in  std_logic_vector(I_NUM          -1 downto 0);
            MRG_IN_READY    :  out std_logic_vector(I_NUM          -1 downto 0);
            OUTLET_DATA     :  out std_logic_vector(      DATA_BITS-1 downto 0);
            OUTLET_LAST     :  out std_logic;
            OUTLET_VALID    :  out std_logic;
            OUTLET_READY    :  in  std_logic
        );
    end component;
begin
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    N: MARCHAL                                   -- 
        generic map(                             -- 
            SCENARIO_FILE   => SCENARIO_FILE,    -- 
            NAME            => "MARCHAL",        -- 
            SYNC_PLUG_NUM   => 1,                -- 
            SYNC_WIDTH      => SYNC_WIDTH,       -- 
            FINISH_ABORT    => FALSE             -- 
        )                                        -- 
        port map(                                -- 
            CLK             => CLOCK           , -- In  :
            RESET           => RESET           , -- Out :
            SYNC(0)         => SYNC(0)         , -- I/O :
            SYNC(1)         => SYNC(1)         , -- I/O :
            REPORT_STATUS   => N_REPORT        , -- Out :
            FINISH          => N_FINISH          -- Out :
        );                                       -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    O: AXI4_STREAM_SLAVE_PLAYER                  -- 
        generic map (                            -- 
            SCENARIO_FILE   => SCENARIO_FILE   , --
            NAME            => "O"             , --
            OUTPUT_DELAY    => DELAY           , --
            SYNC_PLUG_NUM   => 2               , --
            WIDTH           => O_WIDTH         , --
            SYNC_WIDTH      => SYNC_WIDTH      , --
            GPI_WIDTH       => GPI_WIDTH       , --
            GPO_WIDTH       => GPO_WIDTH       , --
            FINISH_ABORT    => FALSE             --
        )                                        -- 
        port map(                                -- 
            ACLK            => CLOCK           , -- In  :
            ARESETn         => ARESETn         , -- In  :
            TDATA           => o_data          , -- In  :
            TSTRB           => o_strb          , -- In  :
            TKEEP           => o_keep          , -- In  :
            TUSER           => o_user          , -- In  :
            TDEST           => o_dest          , -- In  :
            TID             => o_id            , -- In  :
            TLAST           => o_last          , -- In  :
            TVALID          => o_valid         , -- In  :
            TREADY          => o_ready         , -- Out :
            SYNC            => SYNC            , -- I/O :
            GPI             => O_GPI           , -- In  :
            GPO             => O_GPO           , -- Out :
            REPORT_STATUS   => O_REPORT        , -- Out :
            FINISH          => O_FINISH          -- Out :
        );                                       --
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    S: AXI4_STREAM_MASTER_PLAYER                 -- 
        generic map (                            -- 
            SCENARIO_FILE   => SCENARIO_FILE   , --
            NAME            => "S"             , --
            OUTPUT_DELAY    => DELAY           , --
            SYNC_PLUG_NUM   => 3               , --
            WIDTH           => S_WIDTH         , --
            SYNC_WIDTH      => SYNC_WIDTH      , --
            GPI_WIDTH       => GPI_WIDTH       , --
            GPO_WIDTH       => GPO_WIDTH       , --
            FINISH_ABORT    => FALSE             --
        )                                        -- 
        port map (                               -- 
            ACLK            => CLOCK           , -- In  :
            ARESETn         => ARESETn         , -- In  :
            TDATA           => s_data          , -- Out :
            TSTRB           => s_strb          , -- Out :
            TKEEP           => s_keep          , -- Out :
            TUSER           => open            , -- Out :
            TDEST           => open            , -- Out :
            TID             => open            , -- Out :
            TLAST           => s_last          , -- Out :
            TVALID          => s_valid         , -- Out :
            TREADY          => s_ready         , -- In  :
            SYNC            => SYNC            , -- I/O :
            GPI             => S_GPI           , -- In  :
            GPO             => S_GPO           , -- Out :
            REPORT_STATUS   => S_REPORT        , -- Out :
            FINISH          => S_FINISH          -- Out :
        );                                       --
    process(s_strb) begin
        for i in s_word_strb'range loop
            s_word_strb(i) <= s_strb(i*(DATA_BITS/8));
        end loop;
    end process;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    I_MASTER:  for i in 0 to I_NUM-1 generate        --
        constant  gpi  : std_logic_vector(GPI_WIDTH-1 downto 0) := (others => '0');
        constant  name : string(1 to 3) := string'("I") & HEX_TO_STRING(i,8);
    begin                                            -- 
        PLAYER: AXI4_STREAM_MASTER_PLAYER            -- 
            generic map (                            -- 
                SCENARIO_FILE   => SCENARIO_FILE   , --
                NAME            => name            , --
                OUTPUT_DELAY    => DELAY           , --
                SYNC_PLUG_NUM   => 4+i             , --
                WIDTH           => I_WIDTH         , --
                SYNC_WIDTH      => SYNC_WIDTH      , --
                GPI_WIDTH       => GPI_WIDTH       , --
                GPO_WIDTH       => GPO_WIDTH       , --
                FINISH_ABORT    => FALSE             --
            )                                        -- 
            port map (                               -- 
                ACLK            => CLOCK           , -- In  :
                ARESETn         => ARESETn         , -- In  :
                TDATA           => i_data  (i)     , -- Out :
                TSTRB           => open            , -- Out :
                TKEEP           => open            , -- Out :
                TUSER           => i_info  (i)     , -- Out :
                TDEST           => open            , -- Out :
                TID             => open            , -- Out :
                TLAST           => i_last  (i)     , -- Out :
                TVALID          => i_valid (i)     , -- Out :
                TREADY          => i_ready (i)     , -- In  :
                SYNC            => SYNC            , -- I/O :
                GPI             => gpi             , -- In  :
                GPO             => open            , -- Out :
                REPORT_STATUS   => I_REPORT(i)     , -- Out :
                FINISH          => I_FINISH(i)       -- Out :
            );                                       -- 
        i_flat_data((i+1)*DATA_BITS-1 downto i*DATA_BITS) <= i_data(i);
        i_none(i) <= i_info(i)(0);
        i_done(i) <= i_info(i)(1);
    end generate;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    DUT: Merge_Sorter_Core               -- 
        generic map (                    -- 
            SORT_ORDER      => SORT_ORDER      , -- 
            I_NUM           => I_NUM           , --
            STM_ENABLE      => STM_ENABLE      , --
            STM_I_WORDS     => STM_I_WORDS     , -- 
            STM_FEEDBACK    => STM_FEEDBACK    , -- 
            MRG_ENABLE      => MRG_ENABLE      , --
            MRG_FIFO_SIZE   => MRG_FIFO_SIZE   , --
            DATA_BITS       => DATA_BITS       , --
            COMP_HIGH       => COMP_HIGH       , -- 
            COMP_LOW        => COMP_LOW          -- 
        )                                        -- 
        port map (                               -- 
            CLK             => CLOCK           , -- In  :
            RST             => RESET           , -- In  :
            CLR             => CLEAR           , -- In  :
            STM_REQ_VALID   => S_GPO(0)        , -- In  :
            STM_REQ_READY   => S_GPI(0)        , -- Out :
            STM_RES_VALID   => S_GPO(1)        , -- Out :
            STM_RES_READY   => S_GPI(1)        , -- In  :
            STM_IN_DATA     => s_data          , -- In  :
            STM_IN_STRB     => s_word_strb     , -- In  :
            STM_IN_LAST     => s_last          , -- In  :
            STM_IN_VALID    => s_valid         , -- In  :
            STM_IN_READY    => s_ready         , -- Out :
            MRG_REQ_VALID   => S_GPO(2)        , -- In  :
            MRG_REQ_READY   => S_GPI(2)        , -- Out :
            MRG_RES_VALID   => S_GPO(3)        , -- Out :
            MRG_RES_READY   => S_GPI(3)        , -- In  :
            MRG_IN_DATA     => i_flat_data     , -- In  :
            MRG_IN_NONE     => i_none          , -- In  :
            MRG_IN_DONE     => i_done          , -- In  :
            MRG_IN_LAST     => i_last          , -- In  :
            MRG_IN_VALID    => i_valid         , -- In  :
            MRG_IN_READY    => i_ready         , -- Out :
            OUTLET_DATA     => o_data          , -- Out :
            OUTLET_LAST     => o_last          , -- Out :
            OUTLET_VALID    => o_valid         , -- Out :
            OUTLET_READY    => o_ready           -- In  :
        );                                       --
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    process begin
        CLOCK <= '0';
        wait for PERIOD / 2;
        CLOCK <= '1';
        wait for PERIOD / 2;
    end process;

    ARESETn <= '1' when (RESET = '0') else '0';
    process
        variable L   : LINE;
        constant T   : STRING(1 to 7) := "  ***  ";
    begin
        wait until (N_FINISH'event and N_FINISH = '1');
        wait for DELAY;
        WRITE(L,T);                                                   WRITELINE(OUTPUT,L);
        WRITE(L,T & "ERROR REPORT " & NAME);                          WRITELINE(OUTPUT,L);
        WRITE(L,T);                                                   WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Error    : ");WRITE(L,O_REPORT.error_count   );WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Mismatch : ");WRITE(L,O_REPORT.mismatch_count);WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Warning  : ");WRITE(L,O_REPORT.warning_count );WRITELINE(OUTPUT,L);
        WRITE(L,T);                                                   WRITELINE(OUTPUT,L);
        assert FALSE report "Simulation complete." severity FAILURE;
        wait;
    end process;
end Model;

