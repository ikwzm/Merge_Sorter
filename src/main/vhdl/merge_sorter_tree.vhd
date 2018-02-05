-----------------------------------------------------------------------------------
--!     @file    merge_sorter_tree.vhd
--!     @brief   Merge Sorter Tree Module :
--!     @version 0.0.4
--!     @date    2018/2/5
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
entity  Merge_Sorter_Tree is
    generic (
        I_NUM       :  integer :=  8;
        DATA_BITS   :  integer := 64;
        INFO_BITS   :  integer :=  1;
        SORT_ORDER  :  integer :=  0;
        COMP_HIGH   :  integer := 63;
        COMP_LOW    :  integer := 32;
        QUEUE_SIZE  :  integer :=  2
    );
    port (
        CLK         :  in  std_logic;
        RST         :  in  std_logic;
        CLR         :  in  std_logic;
        I_DATA      :  in  std_logic_vector(I_NUM*DATA_BITS-1 downto 0);
        I_INFO      :  in  std_logic_vector(I_NUM*INFO_BITS-1 downto 0);
        I_LAST      :  in  std_logic_vector(I_NUM          -1 downto 0);
        I_VALID     :  in  std_logic_vector(I_NUM          -1 downto 0);
        I_READY     :  out std_logic_vector(I_NUM          -1 downto 0);
        O_DATA      :  out std_logic_vector(      DATA_BITS-1 downto 0);
        O_INFO      :  out std_logic_vector(      INFO_BITS-1 downto 0);
        O_LAST      :  out std_logic;
        O_VALID     :  out std_logic;
        O_READY     :  in  std_logic
    );
end Merge_Sorter_Tree;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
architecture RTL of Merge_Sorter_Tree is
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component Merge_Sorter_Node
        generic (
            SORT_ORDER      :  integer :=  0;
            DATA_BITS       :  integer := 64;
            COMP_HIGH       :  integer := 63;
            COMP_LOW        :  integer := 32;
            INFO_BITS       :  integer :=  1
        );
        port (
            CLK             :  in  std_logic;
            RST             :  in  std_logic;
            CLR             :  in  std_logic;
            A_DATA          :  in  std_logic_vector(DATA_BITS-1 downto 0);
            A_INFO          :  in  std_logic_vector(INFO_BITS-1 downto 0);
            A_LAST          :  in  std_logic;
            A_VALID         :  in  std_logic;
            A_READY         :  out std_logic;
            B_DATA          :  in  std_logic_vector(DATA_BITS-1 downto 0);
            B_INFO          :  in  std_logic_vector(INFO_BITS-1 downto 0);
            B_LAST          :  in  std_logic;
            B_VALID         :  in  std_logic;
            B_READY         :  out std_logic;
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
    component Merge_Sorter_Tree
        generic (
            I_NUM           :  integer :=  8;
            DATA_BITS       :  integer := 64;
            INFO_BITS       :  integer :=  1;
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
    signal    q_data        :  std_logic_vector(DATA_BITS-1 downto 0);
    signal    q_info        :  std_logic_vector(INFO_BITS-1 downto 0);
    signal    q_last        :  std_logic;
    signal    q_valid       :  std_logic;
    signal    q_ready       :  std_logic;
begin
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    NONE: if (I_NUM = 1) generate
        q_data     <= I_DATA;
        q_info     <= I_INFO;
        q_last     <= I_LAST (0);
        q_valid    <= I_VALID(0);
        I_READY(0) <= q_ready;
    end generate;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    TREE: if (I_NUM > 1) generate
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        constant  A_I_NUM   :  integer := I_NUM / 2;
        constant  A_FLAG_LO :  integer := 0;
        constant  A_FLAG_HI :  integer := A_I_NUM - 1;
        constant  A_DATA_LO :  integer := 0;
        constant  A_DATA_HI :  integer := A_I_NUM*DATA_BITS - 1;
        constant  A_INFO_LO :  integer := 0;
        constant  A_INFO_HI :  integer := A_I_NUM*INFO_BITS - 1;
        signal    a_data    :  std_logic_vector(DATA_BITS-1 downto 0);
        signal    a_info    :  std_logic_vector(INFO_BITS-1 downto 0);
        signal    a_last    :  std_logic;
        signal    a_valid   :  std_logic;
        signal    a_ready   :  std_logic;
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        constant  B_I_NUM   :  integer := I_NUM - A_I_NUM;
        constant  B_FLAG_LO :  integer := A_FLAG_HI + 1;
        constant  B_FLAG_HI :  integer := I_NUM     - 1;
        constant  B_DATA_LO :  integer := A_DATA_HI + 1;
        constant  B_DATA_HI :  integer := I_NUM*DATA_BITS - 1;
        constant  B_INFO_LO :  integer := A_INFO_HI + 1;
        constant  B_INFO_HI :  integer := I_NUM*INFO_BITS - 1;
        signal    b_data    :  std_logic_vector(DATA_BITS-1 downto 0);
        signal    b_info    :  std_logic_vector(INFO_BITS-1 downto 0);
        signal    b_last    :  std_logic;
        signal    b_valid   :  std_logic;
        signal    b_ready   :  std_logic;
    begin
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        A: Merge_Sorter_Tree                                        -- 
            generic map (                                           -- 
                I_NUM       => A_I_NUM                            , --
                DATA_BITS   => DATA_BITS                          , --
                INFO_BITS   => INFO_BITS                          , --
                SORT_ORDER  => SORT_ORDER                         , -- 
                COMP_HIGH   => COMP_HIGH                          , --
                COMP_LOW    => COMP_LOW                           , --
                QUEUE_SIZE  => QUEUE_SIZE                           --
            )                                                       -- 
            port map (                                              -- 
                CLK         => CLK                                , -- In  :
                RST         => RST                                , -- In  :
                CLR         => CLR                                , -- In  :
                I_DATA      => I_DATA (A_DATA_HI downto A_DATA_LO), -- In  :
                I_INFO      => I_INFO (A_INFO_HI downto A_INFO_LO), -- In  :
                I_LAST      => I_LAST (A_FLAG_HI downto A_FLAG_LO), -- In  :
                I_VALID     => I_VALID(A_FLAG_HI downto A_FLAG_LO), -- In  :
                I_READY     => I_READY(A_FLAG_HI downto A_FLAG_LO), -- Out :
                O_DATA      => a_data                             , -- Out :
                O_INFO      => a_info                             , -- Out :
                O_LAST      => a_last                             , -- Out :
                O_VALID     => a_valid                            , -- Out :
                O_READY     => a_ready                              -- In  :
            );                                                      -- 
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        B: Merge_Sorter_Tree                                        -- 
            generic map (                                           -- 
                I_NUM       => B_I_NUM                            , --
                DATA_BITS   => DATA_BITS                          , --
                INFO_BITS   => INFO_BITS                          , --
                SORT_ORDER  => SORT_ORDER                         , -- 
                COMP_HIGH   => COMP_HIGH                          , --
                COMP_LOW    => COMP_LOW                           , --
                QUEUE_SIZE  => QUEUE_SIZE                           --
            )                                                       -- 
            port map (                                              -- 
                CLK         => CLK                                , -- In  :
                RST         => RST                                , -- In  :
                CLR         => CLR                                , -- In  :
                I_DATA      => I_DATA (B_DATA_HI downto B_DATA_LO), -- In  :
                I_INFO      => I_INFO (B_INFO_HI downto B_INFO_LO), -- In  :
                I_LAST      => I_LAST (B_FLAG_HI downto B_FLAG_LO), -- In  :
                I_VALID     => I_VALID(B_FLAG_HI downto B_FLAG_LO), -- In  :
                I_READY     => I_READY(B_FLAG_HI downto B_FLAG_LO), -- Out :
                O_DATA      => b_data                             , -- Out :
                O_INFO      => b_info                             , -- Out :
                O_LAST      => b_last                             , -- Out :
                O_VALID     => b_valid                            , -- Out :
                O_READY     => b_ready                              -- In  :
            );                                                      -- 
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        NODE: Merge_Sorter_Node              -- 
           generic map(                      -- 
                SORT_ORDER  => SORT_ORDER  , -- 
                DATA_BITS   => DATA_BITS   , -- 
                COMP_HIGH   => COMP_HIGH   , -- 
                COMP_LOW    => COMP_LOW    , --
                INFO_BITS   => INFO_BITS     -- 
            )                                -- 
            port map (                       -- 
                CLK         => CLK         , -- In  :
                RST         => RST         , -- In  :
                CLR         => CLR         , -- In  :
                A_DATA      => a_data      , -- In  :
                A_INFO      => a_info      , -- In  :
                A_LAST      => a_last      , -- In  :
                A_VALID     => a_valid     , -- In  :
                A_READY     => a_ready     , -- Out :
                B_DATA      => b_data      , -- In  :
                B_INFO      => b_info      , -- In  :
                B_LAST      => b_last      , -- In  :
                B_VALID     => b_valid     , -- In  :
                B_READY     => b_ready     , -- Out :
                O_DATA      => q_data      , -- Out :
                O_INFO      => q_info      , -- Out :
                O_LAST      => q_last      , -- Out :
                O_VALID     => q_valid     , -- Out :
                O_READY     => q_ready       -- In  :
            );                               -- 
    end generate;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    OUTLET: block                            -- 
    begin                                    -- 
        QUEUE: Merge_Sorter_Queue            -- 
            generic map (                    -- 
                QUEUE_SIZE  => QUEUE_SIZE  , -- 
                DATA_BITS   => DATA_BITS   , -- 
                INFO_BITS   => INFO_BITS     -- 
            )                                -- 
            port map (                       -- 
                CLK         => CLK         , -- In  :
                RST         => RST         , -- In  :
                CLR         => CLR         , -- In  :
                I_DATA      => q_data      , -- In  :
                I_INFO      => q_info      , -- In  :
                I_LAST      => q_last      , -- In  :
                I_VALID     => q_valid     , -- In  :
                I_READY     => q_ready     , -- Out :
                O_DATA      => O_DATA      , -- Out :
                O_INFO      => O_INFO      , -- Out :
                O_LAST      => O_LAST      , -- Out :
                O_VALID     => O_VALID     , -- Out :
                O_READY     => O_READY       -- In  :
           );                                --
    end block;
end RTL;
