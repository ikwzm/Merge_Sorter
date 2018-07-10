-----------------------------------------------------------------------------------
--!     @file    merge_sorter_single_way_tree_testbench.vhd
--!     @brief   Merge Sorter Single Way Tree Test Bench :
--!     @version 0.1.0
--!     @date    2018/6/15
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
entity  Merge_Sorter_Single_Way_Tree_Test_Bench is
    generic (
        NAME            :  STRING  := "TEST";
        SCENARIO_FILE   :  STRING  := "test.snr";
        I_NUM           :  integer :=  4;
        SORT_ORDER      :  integer :=  0;
        FINISH_ABORT    :  boolean := FALSE
    );
end     Merge_Sorter_Single_Way_Tree_Test_Bench;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     std.textio.all;
library Merge_Sorter;
use     Merge_Sorter.Merge_Sorter_Core;
library DUMMY_PLUG;
use     DUMMY_PLUG.AXI4_TYPES.all;
use     DUMMY_PLUG.AXI4_MODELS.AXI4_STREAM_MASTER_PLAYER;
use     DUMMY_PLUG.AXI4_MODELS.AXI4_STREAM_SLAVE_PLAYER;
use     DUMMY_PLUG.SYNC.all;
use     DUMMY_PLUG.UTIL.HEX_TO_STRING;
use     DUMMY_PLUG.CORE.MARCHAL;
use     DUMMY_PLUG.CORE.REPORT_STATUS_TYPE;
use     DUMMY_PLUG.CORE.REPORT_STATUS_VECTOR;
architecture Model of Merge_Sorter_Single_Way_Tree_Test_Bench is
    -------------------------------------------------------------------------------
    -- 各種定数
    -------------------------------------------------------------------------------
    constant   PERIOD       :  time    := 10 ns;
    constant   DELAY        :  time    :=  1 ns;
    constant   QUEUE_SIZE   :  integer :=  2;
    constant   WORD_PARAM   :  Merge_Sorter_Core.Word_Field_Type := Merge_Sorter_Core.New_Word_Field_Type(32);
    constant   DATA_BITS    :  integer := WORD_PARAM.DATA_BITS;
    constant   ATRB_BITS    :  integer := WORD_PARAM.ATRB_BITS;
    constant   INFO_BITS    :  integer :=  4;
    constant   USER_BITS    :  integer :=  ATRB_BITS + INFO_BITS;
    constant   USER_ATRB_LO :  integer :=  0;
    constant   USER_ATRB_HI :  integer :=  USER_ATRB_LO + ATRB_BITS - 1;
    constant   USER_INFO_LO :  integer :=  USER_ATRB_HI + 1;
    constant   USER_INFO_HI :  integer :=  USER_INFO_LO + INFO_BITS - 1;
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
                                   USER  => USER_BITS,
                                   DEST  => 4,
                                   DATA  => DATA_BITS
                               );
    type       I_DATA_VECTOR is array (integer range <>) of std_logic_vector(DATA_BITS-1 downto 0);
    type       I_USER_VECTOR is array (integer range <>) of std_logic_vector(USER_BITS-1 downto 0);
    signal     i_data       :  I_DATA_VECTOR   (I_NUM-1 downto 0);
    signal     i_user       :  I_USER_VECTOR   (I_NUM-1 downto 0);
    signal     i_last       :  std_logic_vector(I_NUM-1 downto 0);
    signal     i_valid      :  std_logic_vector(I_NUM-1 downto 0);
    signal     i_ready      :  std_logic_vector(I_NUM-1 downto 0);
    signal     i_word       :  std_logic_vector(I_NUM*WORD_PARAM.BITS-1 downto 0);
    signal     i_info       :  std_logic_vector(I_NUM*INFO_BITS      -1 downto 0);
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    constant   O_WIDTH      :  AXI4_STREAM_SIGNAL_WIDTH_TYPE := (
                                   ID    => 4,
                                   USER  => USER_BITS,
                                   DEST  => 4,
                                   DATA  => DATA_BITS
                               );
    signal     o_data       :  std_logic_vector(DATA_BITS-1 downto 0);
    signal     o_user       :  std_logic_vector(USER_BITS-1 downto 0);
    signal     o_last       :  std_logic;
    signal     o_valid      :  std_logic;
    signal     o_ready      :  std_logic;
    constant   o_keep       :  std_logic_vector(DATA_BITS/8 -1 downto 0) := (others => '1');
    constant   o_strb       :  std_logic_vector(DATA_BITS/8 -1 downto 0) := (others => '1');
    constant   o_id         :  std_logic_vector(O_WIDTH.ID  -1 downto 0) := (others => '0');
    constant   o_dest       :  std_logic_vector(O_WIDTH.DEST-1 downto 0) := (others => '0');
    signal     o_word       :  std_logic_vector(WORD_PARAM.BITS-1 downto 0);
    signal     o_info       :  std_logic_vector(INFO_BITS      -1 downto 0);
    -------------------------------------------------------------------------------
    -- GPIO(General Purpose Input/Output)
    -------------------------------------------------------------------------------
    signal     O_GPI        : std_logic_vector(GPI_WIDTH   -1 downto 0);
    signal     O_GPO        : std_logic_vector(GPO_WIDTH   -1 downto 0);
    -------------------------------------------------------------------------------
    -- 各種状態出力.
    -------------------------------------------------------------------------------
    signal     N_REPORT     : REPORT_STATUS_TYPE;
    signal     N_FINISH     : std_logic;
    signal     O_REPORT     : REPORT_STATUS_TYPE;
    signal     O_FINISH     : std_logic;
    signal     I_REPORT     : REPORT_STATUS_VECTOR(I_NUM-1 downto 0);
    signal     I_FINISH     : std_logic_vector    (I_NUM-1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component  Merge_Sorter_Single_Way_Tree
        generic (
            WORD_PARAM  :  Merge_Sorter_Core.Word_Field_Type := Merge_Sorter_Core.New_Word_Field_Type(8);
            I_NUM       :  integer :=  8;
            INFO_BITS   :  integer :=  3;
            SORT_ORDER  :  integer :=  0;
            QUEUE_SIZE  :  integer :=  2
        );
        port (
            CLK         :  in  std_logic;
            RST         :  in  std_logic;
            CLR         :  in  std_logic;
            I_WORD      :  in  std_logic_vector(I_NUM*WORD_PARAM.BITS-1 downto 0);
            I_INFO      :  in  std_logic_vector(I_NUM*INFO_BITS      -1 downto 0);
            I_LAST      :  in  std_logic_vector(I_NUM                -1 downto 0);
            I_VALID     :  in  std_logic_vector(I_NUM                -1 downto 0);
            I_READY     :  out std_logic_vector(I_NUM                -1 downto 0);
            O_WORD      :  out std_logic_vector(      WORD_PARAM.BITS-1 downto 0);
            O_INFO      :  out std_logic_vector(      INFO_BITS      -1 downto 0);
            O_LAST      :  out std_logic;
            O_VALID     :  out std_logic;
            O_READY     :  in  std_logic
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
    o_data                                   <= o_word(WORD_PARAM.DATA_HI downto WORD_PARAM.DATA_LO);
    o_user(USER_ATRB_HI downto USER_ATRB_LO) <= o_word(WORD_PARAM.ATRB_HI downto WORD_PARAM.ATRB_LO);
    o_user(USER_INFO_HI downto USER_INFO_LO) <= o_info;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    I_MASTER:  for i in 0 to I_NUM-1 generate        --
        constant  gpi  :  std_logic_vector(GPI_WIDTH-1 downto 0) := (others => '0');
        constant  name :  string(1 to 3) := string'("I") & HEX_TO_STRING(i,8);
        signal    word :  std_logic_vector(WORD_PARAM.BITS-1 downto 0);
    begin                                            -- 
        PLAYER: AXI4_STREAM_MASTER_PLAYER            -- 
            generic map (                            -- 
                SCENARIO_FILE   => SCENARIO_FILE   , --
                NAME            => name            , --
                OUTPUT_DELAY    => DELAY           , --
                SYNC_PLUG_NUM   => 3+i             , --
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
                TUSER           => i_user  (i)     , -- Out :
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
        word(WORD_PARAM.DATA_HI downto WORD_PARAM.DATA_LO)       <= i_data(i);
        word(WORD_PARAM.ATRB_HI downto WORD_PARAM.ATRB_LO)       <= i_user(i)(USER_ATRB_HI downto USER_ATRB_LO);
        i_word((i+1)*WORD_PARAM.BITS-1 downto i*WORD_PARAM.BITS) <= word;
        i_info((i+1)*INFO_BITS      -1 downto i*INFO_BITS      ) <= i_user(i)(USER_INFO_HI downto USER_INFO_LO);
    end generate;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    DUT: Merge_Sorter_Single_Way_Tree    -- 
        generic map (                    -- 
            WORD_PARAM  => WORD_PARAM  , -- 
            SORT_ORDER  => SORT_ORDER  , -- 
            QUEUE_SIZE  => QUEUE_SIZE  , -- 
            I_NUM       => I_NUM       , -- 
            INFO_BITS   => INFO_BITS     -- 
        )                                -- 
        port map (                       -- 
            CLK         => CLOCK       , -- In  :
            RST         => RESET       , -- In  :
            CLR         => CLEAR       , -- In  :
            I_WORD      => i_word      , -- In  :
            I_INFO      => i_info      , -- In  :
            I_LAST      => i_last      , -- In  :
            I_VALID     => i_valid     , -- In  :
            I_READY     => i_ready     , -- Out :
            O_WORD      => o_word      , -- Out :
            O_INFO      => o_info      , -- Out :
            O_LAST      => o_last      , -- Out :
            O_VALID     => o_valid     , -- Out :
            O_READY     => o_ready       -- In  :
        );                               -- 
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
        WRITE(L,T);                                                   WRITELINE(OUTPUT,L);
        WRITE(L,T & "ERROR REPORT " & NAME);                          WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Error    : ");WRITE(L,O_REPORT.error_count   );WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Mismatch : ");WRITE(L,O_REPORT.mismatch_count);WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Warning  : ");WRITE(L,O_REPORT.warning_count );WRITELINE(OUTPUT,L);
        WRITE(L,T);                                                   WRITELINE(OUTPUT,L);
        assert (O_REPORT.error_count    = 0)
            report "Simulation complete(error)."    severity FAILURE;
        assert (O_REPORT.mismatch_count = 0)
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
entity  Merge_Sorter_Single_Way_Tree_Test_Bench_X04_O0 is
    generic (
        NAME            :  STRING  := "TEST_X04_O0";
        SCENARIO_FILE   :  STRING  := "test_x04_o0.snr";
        FINISH_ABORT    :  boolean := FALSE
    );
end     Merge_Sorter_Single_Way_Tree_Test_Bench_X04_O0;
architecture Model of Merge_Sorter_Single_Way_Tree_Test_Bench_X04_O0 is
begin
    TEST: entity WORK.Merge_Sorter_Single_Way_Tree_Test_Bench
        generic map (
            NAME            => NAME,
            SCENARIO_FILE   => SCENARIO_FILE,
            I_NUM           => 4,
            SORT_ORDER      => 0,
            FINISH_ABORT    => FINISH_ABORT
        );
end Model;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  Merge_Sorter_Single_Way_Tree_Test_Bench_X02_O1 is
    generic (
        NAME            :  STRING  := "TEST_X02_O1";
        SCENARIO_FILE   :  STRING  := "test_x02_o1.snr";
        FINISH_ABORT    :  boolean := FALSE
    );
end     Merge_Sorter_Single_Way_Tree_Test_Bench_X02_O1;
architecture Model of Merge_Sorter_Single_Way_Tree_Test_Bench_X02_O1 is
begin
    TEST: entity WORK.Merge_Sorter_Single_Way_Tree_Test_Bench
        generic map (
            NAME            => NAME,
            SCENARIO_FILE   => SCENARIO_FILE,
            I_NUM           => 2,
            SORT_ORDER      => 1,
            FINISH_ABORT    => FINISH_ABORT
        );
end Model;