-----------------------------------------------------------------------------------
--!     @file    merge_sorter_core_testbench.vhd
--!     @brief   Merge Sorter Core Test Bench :
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
entity  Merge_Sorter_Core_Test_Bench is
    generic (
        NAME            :  STRING  := "TEST";
        SCENARIO_FILE   :  STRING  := "test.snr";
        IN_NUM          :  integer := 4;
        STM_ENABLE      :  boolean := TRUE;
        STM_FEEDBACK    :  integer := 2;
        STM_IN_NUM      :  integer := 1;
        MRG_ENABLE      :  boolean := TRUE;
        MRG_FIFO_SIZE   :  integer := 64;
        SORT_ORDER      :  integer := 0;
        FINISH_ABORT    :  boolean := FALSE
    );
end     Merge_Sorter_Core_Test_Bench;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     std.textio.all;
library Merge_Sorter;
use     Merge_Sorter.Merge_Sorter_Core_Components.Merge_Sorter_Core;
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
    constant   USER_BITS    :  integer :=  4;
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
    signal     SYNC         : SYNC_SIG_VECTOR (SYNC_WIDTH-1 downto 0);
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    constant   MRG_I_WIDTH  :  AXI4_STREAM_SIGNAL_WIDTH_TYPE := (
                                   ID    => 4,
                                   USER  => USER_BITS,
                                   DEST  => 4,
                                   DATA  => DATA_BITS
                               );
    type       I_DATA_VECTOR is array (integer range <>) of std_logic_vector(DATA_BITS-1 downto 0);
    type       I_USER_VECTOR is array (integer range <>) of std_logic_vector(USER_BITS-1 downto 0);
    signal     mrg_i_data   :  I_DATA_VECTOR   (IN_NUM-1 downto 0);
    signal     mrg_i_user   :  I_USER_VECTOR   (IN_NUM-1 downto 0);
    signal     mrg_i_last   :  std_logic_vector(IN_NUM-1 downto 0);
    signal     mrg_i_valid  :  std_logic_vector(IN_NUM-1 downto 0);
    signal     mrg_i_ready  :  std_logic_vector(IN_NUM-1 downto 0);
    signal     mrg_i_word   :  std_logic_vector(IN_NUM*DATA_BITS-1 downto 0);
    signal     mrg_i_atrb   :  std_logic_vector(IN_NUM*USER_BITS-1 downto 0);
    signal     mrg_i_level  :  std_logic_vector(IN_NUM-1 downto 0);
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    constant   STM_I_WIDTH  :  AXI4_STREAM_SIGNAL_WIDTH_TYPE := (
                                   ID    => 4,
                                   USER  => USER_BITS,
                                   DEST  => 4,
                                   DATA  => STM_IN_NUM*DATA_BITS
                               );
    signal     stm_i_data   :  std_logic_vector(STM_I_WIDTH.DATA  -1 downto 0);
    signal     stm_i_ena    :  std_logic_vector(STM_IN_NUM        -1 downto 0);
    signal     stm_i_last   :  std_logic;
    signal     stm_i_valid  :  std_logic;
    signal     stm_i_ready  :  std_logic;
    signal     stm_i_keep   :  std_logic_vector(STM_I_WIDTH.DATA/8-1 downto 0) := (others => '1');
    signal     stm_i_strb   :  std_logic_vector(STM_I_WIDTH.DATA/8-1 downto 0) := (others => '1');
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    constant   STM_O_WIDTH  :  AXI4_STREAM_SIGNAL_WIDTH_TYPE := (
                                   ID    => 4,
                                   USER  => USER_BITS,
                                   DEST  => 4,
                                   DATA  => DATA_BITS
                               );
    signal     stm_o_data   :  std_logic_vector(    DATA_BITS   -1 downto 0);
    signal     stm_o_last   :  std_logic;
    signal     stm_o_valid  :  std_logic;
    signal     stm_o_ready  :  std_logic;
    constant   stm_o_keep   :  std_logic_vector(    DATA_BITS/8 -1 downto 0) := (others => '1');
    constant   stm_o_strb   :  std_logic_vector(    DATA_BITS/8 -1 downto 0) := (others => '1');
    constant   stm_o_id     :  std_logic_vector(STM_O_WIDTH.ID  -1 downto 0) := (others => '0');
    constant   stm_o_dest   :  std_logic_vector(STM_O_WIDTH.DEST-1 downto 0) := (others => '0');
    constant   stm_o_user   :  std_logic_vector(STM_O_WIDTH.USER-1 downto 0) := (others => '0');
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    constant   MRG_O_WIDTH  :  AXI4_STREAM_SIGNAL_WIDTH_TYPE := (
                                   ID    => 4,
                                   USER  => USER_BITS,
                                   DEST  => 4,
                                   DATA  => DATA_BITS
                               );
    signal     mrg_o_data   :  std_logic_vector(    DATA_BITS   -1 downto 0);
    signal     mrg_o_last   :  std_logic;
    signal     mrg_o_valid  :  std_logic;
    signal     mrg_o_ready  :  std_logic;
    constant   mrg_o_keep   :  std_logic_vector(    DATA_BITS/8 -1 downto 0) := (others => '1');
    constant   mrg_o_strb   :  std_logic_vector(    DATA_BITS/8 -1 downto 0) := (others => '1');
    constant   mrg_o_id     :  std_logic_vector(MRG_O_WIDTH.ID  -1 downto 0) := (others => '0');
    constant   mrg_o_dest   :  std_logic_vector(MRG_O_WIDTH.DEST-1 downto 0) := (others => '0');
    constant   mrg_o_user   :  std_logic_vector(MRG_O_WIDTH.USER-1 downto 0) := (others => '0');
    -------------------------------------------------------------------------------
    -- GPIO(General Purpose Input/Output)
    -------------------------------------------------------------------------------
    signal     STM_O_GPI    :  std_logic_vector(GPI_WIDTH   -1 downto 0);
    signal     STM_O_GPO    :  std_logic_vector(GPO_WIDTH   -1 downto 0);
    signal     STM_I_GPI    :  std_logic_vector(GPI_WIDTH   -1 downto 0);
    signal     STM_I_GPO    :  std_logic_vector(GPO_WIDTH   -1 downto 0);
    signal     MRG_O_GPI    :  std_logic_vector(GPI_WIDTH   -1 downto 0);
    signal     MRG_O_GPO    :  std_logic_vector(GPO_WIDTH   -1 downto 0);
    -------------------------------------------------------------------------------
    -- 各種状態出力.
    -------------------------------------------------------------------------------
    signal     N_REPORT     :  REPORT_STATUS_TYPE;
    signal     N_FINISH     :  std_logic;
    signal     STM_O_REPORT :  REPORT_STATUS_TYPE;
    signal     STM_O_FINISH :  std_logic;
    signal     STM_I_REPORT :  REPORT_STATUS_TYPE;
    signal     STM_I_FINISH :  std_logic;
    signal     MRG_O_REPORT :  REPORT_STATUS_TYPE;
    signal     MRG_O_FINISH :  std_logic;
    signal     MRG_I_REPORT :  REPORT_STATUS_VECTOR(IN_NUM-1 downto 0);
    signal     MRG_I_FINISH :  std_logic_vector    (IN_NUM-1 downto 0);
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
    STM_O: AXI4_STREAM_SLAVE_PLAYER              -- 
        generic map (                            -- 
            SCENARIO_FILE   => SCENARIO_FILE   , --
            NAME            => "STM_O"         , --
            OUTPUT_DELAY    => DELAY           , --
            SYNC_PLUG_NUM   => 2               , --
            WIDTH           => STM_O_WIDTH     , --
            SYNC_WIDTH      => SYNC_WIDTH      , --
            GPI_WIDTH       => GPI_WIDTH       , --
            GPO_WIDTH       => GPO_WIDTH       , --
            FINISH_ABORT    => FALSE             --
        )                                        -- 
        port map(                                -- 
            ACLK            => CLOCK           , -- In  :
            ARESETn         => ARESETn         , -- In  :
            TDATA           => stm_o_data      , -- In  :
            TSTRB           => stm_o_strb      , -- In  :
            TKEEP           => stm_o_keep      , -- In  :
            TUSER           => stm_o_user      , -- In  :
            TDEST           => stm_o_dest      , -- In  :
            TID             => stm_o_id        , -- In  :
            TLAST           => stm_o_last      , -- In  :
            TVALID          => stm_o_valid     , -- In  :
            TREADY          => stm_o_ready     , -- Out :
            SYNC            => SYNC            , -- I/O :
            GPI             => STM_O_GPI       , -- In  :
            GPO             => STM_O_GPO       , -- Out :
            REPORT_STATUS   => STM_O_REPORT    , -- Out :
            FINISH          => STM_O_FINISH      -- Out :
        );                                       --
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    MRG_O: AXI4_STREAM_SLAVE_PLAYER              -- 
        generic map (                            -- 
            SCENARIO_FILE   => SCENARIO_FILE   , --
            NAME            => "MRG_O"         , --
            OUTPUT_DELAY    => DELAY           , --
            SYNC_PLUG_NUM   => 3               , --
            WIDTH           => MRG_O_WIDTH     , --
            SYNC_WIDTH      => SYNC_WIDTH      , --
            GPI_WIDTH       => GPI_WIDTH       , --
            GPO_WIDTH       => GPO_WIDTH       , --
            FINISH_ABORT    => FALSE             --
        )                                        -- 
        port map(                                -- 
            ACLK            => CLOCK           , -- In  :
            ARESETn         => ARESETn         , -- In  :
            TDATA           => mrg_o_data      , -- In  :
            TSTRB           => mrg_o_strb      , -- In  :
            TKEEP           => mrg_o_keep      , -- In  :
            TUSER           => mrg_o_user      , -- In  :
            TDEST           => mrg_o_dest      , -- In  :
            TID             => mrg_o_id        , -- In  :
            TLAST           => mrg_o_last      , -- In  :
            TVALID          => mrg_o_valid     , -- In  :
            TREADY          => mrg_o_ready     , -- Out :
            SYNC            => SYNC            , -- I/O :
            GPI             => MRG_O_GPI       , -- In  :
            GPO             => MRG_O_GPO       , -- Out :
            REPORT_STATUS   => MRG_O_REPORT    , -- Out :
            FINISH          => MRG_O_FINISH      -- Out :
        );                                       --
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    STM_I: AXI4_STREAM_MASTER_PLAYER             -- 
        generic map (                            -- 
            SCENARIO_FILE   => SCENARIO_FILE   , --
            NAME            => "STM_I"         , --
            OUTPUT_DELAY    => DELAY           , --
            SYNC_PLUG_NUM   => 4               , --
            WIDTH           => STM_I_WIDTH     , --
            SYNC_WIDTH      => SYNC_WIDTH      , --
            GPI_WIDTH       => GPI_WIDTH       , --
            GPO_WIDTH       => GPO_WIDTH       , --
            FINISH_ABORT    => FALSE             --
        )                                        -- 
        port map (                               -- 
            ACLK            => CLOCK           , -- In  :
            ARESETn         => ARESETn         , -- In  :
            TDATA           => stm_i_data      , -- Out :
            TSTRB           => stm_i_strb      , -- Out :
            TKEEP           => stm_i_keep      , -- Out :
            TUSER           => open            , -- Out :
            TDEST           => open            , -- Out :
            TID             => open            , -- Out :
            TLAST           => stm_i_last      , -- Out :
            TVALID          => stm_i_valid     , -- Out :
            TREADY          => stm_i_ready     , -- In  :
            SYNC            => SYNC            , -- I/O :
            GPI             => STM_I_GPI       , -- In  :
            GPO             => STM_I_GPO       , -- Out :
            REPORT_STATUS   => STM_I_REPORT    , -- Out :
            FINISH          => STM_I_FINISH      -- Out :
        );                                       --
    process(stm_i_strb) begin
        for i in stm_i_ena'range loop
            stm_i_ena(i) <= stm_i_strb(i*(DATA_BITS/8));
        end loop;
    end process;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    I_MASTER:  for i in 0 to IN_NUM-1 generate        --
        signal    gpi  : std_logic_vector(GPI_WIDTH-1 downto 0);
        constant  name : string(1 to 7) := string'("MRG_I") & HEX_TO_STRING(i,8);
    begin                                            -- 
        PLAYER: AXI4_STREAM_MASTER_PLAYER            -- 
            generic map (                            -- 
                SCENARIO_FILE   => SCENARIO_FILE   , --
                NAME            => name            , --
                OUTPUT_DELAY    => DELAY           , --
                SYNC_PLUG_NUM   => 5+i             , --
                WIDTH           => MRG_I_WIDTH     , --
                SYNC_WIDTH      => SYNC_WIDTH      , --
                GPI_WIDTH       => GPI_WIDTH       , --
                GPO_WIDTH       => GPO_WIDTH       , --
                FINISH_ABORT    => FALSE             --
            )                                        -- 
            port map (                               -- 
                ACLK            => CLOCK           , -- In  :
                ARESETn         => ARESETn         , -- In  :
                TDATA           => mrg_i_data  (i) , -- Out :
                TSTRB           => open            , -- Out :
                TKEEP           => open            , -- Out :
                TUSER           => mrg_i_user  (i) , -- Out :
                TDEST           => open            , -- Out :
                TID             => open            , -- Out :
                TLAST           => mrg_i_last  (i) , -- Out :
                TVALID          => mrg_i_valid (i) , -- Out :
                TREADY          => mrg_i_ready (i) , -- In  :
                SYNC            => SYNC            , -- I/O :
                GPI             => gpi             , -- In  :
                GPO             => open            , -- Out :
                REPORT_STATUS   => MRG_I_REPORT(i) , -- Out :
                FINISH          => MRG_I_FINISH(i)   -- Out :
            );                                       -- 
        mrg_i_word((i+1)*DATA_BITS-1 downto i*DATA_BITS) <= mrg_i_data(i);
        mrg_i_atrb((i+1)*USER_BITS-1 downto i*USER_BITS) <= mrg_i_user(i);
        gpi(0)                 <= mrg_i_level(i);
        gpi(gpi'high downto 1) <= (gpi'high downto 1 => '0');
    end generate;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    DUT: Merge_Sorter_Core                       -- 
        generic map (                            -- 
            SORT_ORDER      => SORT_ORDER      , -- 
            IN_NUM          => IN_NUM          , --
            STM_ENABLE      => STM_ENABLE      , --
            STM_IN_NUM      => STM_IN_NUM      , -- 
            STM_FEEDBACK    => STM_FEEDBACK    , -- 
            MRG_ENABLE      => MRG_ENABLE      , --
            MRG_FIFO_SIZE   => MRG_FIFO_SIZE   , --
            MRG_LEVEL_SIZE  => MRG_FIFO_SIZE/2 , --
            DATA_BITS       => DATA_BITS       , --
            COMP_HIGH       => COMP_HIGH       , -- 
            COMP_LOW        => COMP_LOW          -- 
        )                                        -- 
        port map (                               -- 
            CLK             => CLOCK           , -- In  :
            RST             => RESET           , -- In  :
            CLR             => CLEAR           , -- In  :
            STM_REQ_VALID   => STM_O_GPO(0)    , -- In  :
            STM_REQ_READY   => STM_O_GPI(0)    , -- Out :
            STM_RES_VALID   => STM_O_GPI(1)    , -- Out :
            STM_RES_READY   => STM_O_GPO(1)    , -- In  :
            STM_IN_DATA     => stm_i_data      , -- In  :
            STM_IN_STRB     => stm_i_ena       , -- In  :
            STM_IN_LAST     => stm_i_last      , -- In  :
            STM_IN_VALID    => stm_i_valid     , -- In  :
            STM_IN_READY    => stm_i_ready     , -- Out :
            STM_OUT_DATA    => stm_o_data      , -- Out :
            STM_OUT_LAST    => stm_o_last      , -- Out :
            STM_OUT_VALID   => stm_o_valid     , -- Out :
            STM_OUT_READY   => stm_o_ready     , -- In  :
            MRG_REQ_VALID   => MRG_O_GPO(0)    , -- In  :
            MRG_REQ_READY   => MRG_O_GPI(0)    , -- Out :
            MRG_RES_VALID   => MRG_O_GPI(1)    , -- Out :
            MRG_RES_READY   => MRG_O_GPO(1)    , -- In  :
            MRG_IN_DATA     => mrg_i_word      , -- In  :
            MRG_IN_ATRB     => mrg_i_atrb      , -- In  :
            MRG_IN_LAST     => mrg_i_last      , -- In  :
            MRG_IN_VALID    => mrg_i_valid     , -- In  :
            MRG_IN_READY    => mrg_i_ready     , -- Out :
            MRG_IN_LEVEL    => mrg_i_level     , -- Out :
            MRG_OUT_DATA    => mrg_o_data      , -- Out :
            MRG_OUT_LAST    => mrg_o_last      , -- Out :
            MRG_OUT_VALID   => mrg_o_valid     , -- Out :
            MRG_OUT_READY   => mrg_o_ready       -- In  :
        );                                       --
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    process begin
        loop
            CLOCK  <= '0'; wait for PERIOD / 2;
            CLOCK  <= '1'; wait for PERIOD / 2;
            exit when(N_FINISH = '1');
        end loop;
        CLOCK  <= '0';
        wait;
    end process;

    ARESETn <= '1' when (RESET = '0') else '0';
    process
        variable L   : LINE;
        constant T   : STRING(1 to 7) := "  ***  ";
    begin
        wait until (N_FINISH'event and N_FINISH = '1');
        wait for DELAY;
        WRITE(L,T);                                                       WRITELINE(OUTPUT,L);
        WRITE(L,T & "ERROR REPORT " & NAME);                              WRITELINE(OUTPUT,L);
        WRITE(L,T);                                                       WRITELINE(OUTPUT,L);
        WRITE(L,T & "[STREAM]"     );                                     WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Error    : ");WRITE(L,STM_O_REPORT.error_count   );WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Mismatch : ");WRITE(L,STM_O_REPORT.mismatch_count);WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Warning  : ");WRITE(L,STM_O_REPORT.warning_count );WRITELINE(OUTPUT,L);
        WRITE(L,T & "[MERGE]"      );                                     WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Error    : ");WRITE(L,MRG_O_REPORT.error_count   );WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Mismatch : ");WRITE(L,MRG_O_REPORT.mismatch_count);WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Warning  : ");WRITE(L,MRG_O_REPORT.warning_count );WRITELINE(OUTPUT,L);
        WRITE(L,T);                                                       WRITELINE(OUTPUT,L);
        assert (STM_O_REPORT.error_count    = 0) and
               (MRG_O_REPORT.error_count    = 0) 
            report "Simulation complete(error)."    severity FAILURE;
        assert (STM_O_REPORT.mismatch_count = 0) and
               (MRG_O_REPORT.mismatch_count = 0)
            report "Simulation complete(mismatch)." severity FAILURE;
        if (FINISH_ABORT) then
            assert FALSE report "Simulation complete(success)."  severity FAILURE;
        else
            assert FALSE report "Simulation complete(success)."  severity NOTE;
        end if;
        wait;
    end process;
end Model;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  Merge_Sorter_Core_Test_Bench_X04_M1_S1_F2 is
    generic (
        NAME            :  STRING  := "TEST_X04_M1_S1_F2";
        SCENARIO_FILE   :  STRING  := "test_x04_m1_s1_f2.snr";
        FINISH_ABORT    :  boolean := FALSE
    );
end     Merge_Sorter_Core_Test_Bench_X04_M1_S1_F2;
architecture Model of Merge_Sorter_Core_Test_Bench_X04_M1_S1_F2 is
begin
    TEST: entity  WORK.Merge_Sorter_Core_Test_Bench
        generic map (
            NAME            => NAME,
            SCENARIO_FILE   => SCENARIO_FILE,
            IN_NUM          => 4,
            STM_ENABLE      => TRUE,
            STM_FEEDBACK    => 2,
            STM_IN_NUM      => 1,
            MRG_ENABLE      => TRUE,
            MRG_FIFO_SIZE   => 64,
            SORT_ORDER      => 0,
            FINISH_ABORT    => FINISH_ABORT
        );
end Model;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  Merge_Sorter_Core_Test_Bench_X04_M1_S0_F0 is
    generic (
        NAME            :  STRING  := "TEST_X04_M1_S0_F0";
        SCENARIO_FILE   :  STRING  := "test_x04_m1_s0_f0.snr";
        FINISH_ABORT    :  boolean := FALSE
    );
end     Merge_Sorter_Core_Test_Bench_X04_M1_S0_F0;
architecture Model of Merge_Sorter_Core_Test_Bench_X04_M1_S0_F0 is
begin
    TEST: entity  WORK.Merge_Sorter_Core_Test_Bench
        generic map (
            NAME            => NAME,
            SCENARIO_FILE   => SCENARIO_FILE,
            IN_NUM          => 4,
            STM_ENABLE      => FALSE,
            STM_FEEDBACK    => 0,
            STM_IN_NUM      => 1,
            MRG_ENABLE      => TRUE,
            MRG_FIFO_SIZE   => 64,
            SORT_ORDER      => 0,
            FINISH_ABORT    => FINISH_ABORT
        );
end Model;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  Merge_Sorter_Core_Test_Bench_X04_M0_S1_F0 is
    generic (
        NAME            :  STRING  := "TEST_X04_M0_S1_F0";
        SCENARIO_FILE   :  STRING  := "test_x04_m0_s1_f0.snr";
        FINISH_ABORT    :  boolean := FALSE
    );
end     Merge_Sorter_Core_Test_Bench_X04_M0_S1_F0;
architecture Model of Merge_Sorter_Core_Test_Bench_X04_M0_S1_F0 is
begin
    TEST: entity  WORK.Merge_Sorter_Core_Test_Bench
        generic map (
            NAME            => NAME,
            SCENARIO_FILE   => SCENARIO_FILE,
            IN_NUM          => 4,
            STM_ENABLE      => TRUE,
            STM_FEEDBACK    => 0,
            STM_IN_NUM      => 1,
            MRG_ENABLE      => FALSE,
            MRG_FIFO_SIZE   => 64,
            SORT_ORDER      => 0,
            FINISH_ABORT    => FINISH_ABORT
        );
end Model;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  Merge_Sorter_Core_Test_Bench_X04_M0_S1_F1 is
    generic (
        NAME            :  STRING  := "TEST_X04_M0_S1_F1";
        SCENARIO_FILE   :  STRING  := "test_x04_m0_s1_f1.snr";
        FINISH_ABORT    :  boolean := FALSE
    );
end     Merge_Sorter_Core_Test_Bench_X04_M0_S1_F1;
architecture Model of Merge_Sorter_Core_Test_Bench_X04_M0_S1_F1 is
begin
    TEST: entity  WORK.Merge_Sorter_Core_Test_Bench
        generic map (
            NAME            => NAME,
            SCENARIO_FILE   => SCENARIO_FILE,
            IN_NUM          => 4,
            STM_ENABLE      => TRUE,
            STM_FEEDBACK    => 1,
            STM_IN_NUM      => 1,
            MRG_ENABLE      => FALSE,
            MRG_FIFO_SIZE   => 64,
            SORT_ORDER      => 0,
            FINISH_ABORT    => FINISH_ABORT
        );
end Model;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  Merge_Sorter_Core_Test_Bench_X04_M0_S1_F2 is
    generic (
        NAME            :  STRING  := "TEST_X04_M0_S1_F2";
        SCENARIO_FILE   :  STRING  := "test_x04_m0_s1_f2.snr";
        FINISH_ABORT    :  boolean := FALSE
    );
end     Merge_Sorter_Core_Test_Bench_X04_M0_S1_F2;
architecture Model of Merge_Sorter_Core_Test_Bench_X04_M0_S1_F2 is
begin
    TEST: entity  WORK.Merge_Sorter_Core_Test_Bench
        generic map (
            NAME            => NAME,
            SCENARIO_FILE   => SCENARIO_FILE,
            IN_NUM          => 4,
            STM_ENABLE      => TRUE,
            STM_FEEDBACK    => 2,
            STM_IN_NUM      => 1,
            MRG_ENABLE      => FALSE,
            MRG_FIFO_SIZE   => 64,
            SORT_ORDER      => 0,
            FINISH_ABORT    => FINISH_ABORT
        );
end Model;
