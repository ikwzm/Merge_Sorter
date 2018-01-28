-----------------------------------------------------------------------------------
--!     @file    merge_sorter_tree.vhd
--!     @brief   Merge Sorter Tree Module :
--!     @version 0.0.1
--!     @date    2018/1/28
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
        QUEUE_SIZE  :  integer :=  2;
        TREE_DEPTH  :  integer :=  1;
        DATA_BITS   :  integer := 64;
        COMP_HIGH   :  integer := 63;
        COMP_LOW    :  integer := 32;
        INFO_BITS   :  integer :=  1
    );
    port (
        CLK         :  in  std_logic;
        RST         :  in  std_logic;
        CLR         :  in  std_logic;
        I_DATA      :  in  std_logic_vector((2**TREE_DEPTH)*DATA_BITS-1 downto 0);
        I_INFO      :  in  std_logic_vector((2**TREE_DEPTH)*INFO_BITS-1 downto 0);
        I_LAST      :  in  std_logic_vector((2**TREE_DEPTH)          -1 downto 0);
        I_VALID     :  in  std_logic_vector((2**TREE_DEPTH)          -1 downto 0);
        I_READY     :  out std_logic_vector((2**TREE_DEPTH)          -1 downto 0);
        O_DATA      :  out std_logic_vector(                DATA_BITS-1 downto 0);
        O_INFO      :  out std_logic_vector(                INFO_BITS-1 downto 0);
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
    type      DATA_ARRAY    is array (integer range <>, integer range <>) of std_logic_vector(DATA_BITS-1 downto 0);
    type      INFO_ARRAY    is array (integer range <>, integer range <>) of std_logic_vector(INFO_BITS-1 downto 0);
    type      LAST_ARRAY    is array (integer range <>, integer range <>) of std_logic;
    type      VALID_ARRAY   is array (integer range <>, integer range <>) of std_logic;
    type      READY_ARRAY   is array (integer range <>, integer range <>) of std_logic;
    signal    node_data     :  DATA_ARRAY (0 to TREE_DEPTH, 0 to (2**TREE_DEPTH)-1);
    signal    node_info     :  INFO_ARRAY (0 to TREE_DEPTH, 0 to (2**TREE_DEPTH)-1);
    signal    node_last     :  LAST_ARRAY (0 to TREE_DEPTH, 0 to (2**TREE_DEPTH)-1);
    signal    node_valid    :  VALID_ARRAY(0 to TREE_DEPTH, 0 to (2**TREE_DEPTH)-1);
    signal    node_ready    :  READY_ARRAY(0 to TREE_DEPTH, 0 to (2**TREE_DEPTH)-1);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component Merge_Sorter_Node
        generic (
            QUEUE_SIZE      :  integer :=  2;
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
begin
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    INTAKE: for i in 0 to (2**TREE_DEPTH)-1 generate           -- 
        QUEUE: Merge_Sorter_Queue                              -- 
            generic map (                                      -- 
                QUEUE_SIZE  => QUEUE_SIZE                    , -- 
                DATA_BITS   => DATA_BITS                     , --
                INFO_BITS   => INFO_BITS                       -- 
            )                                                  -- 
            port map (                                         -- 
                CLK         => CLK                           , -- In  :
                RST         => RST                           , -- In  :
                CLR         => CLR                           , -- In  :
                I_DATA      => I_DATA((i+1)*DATA_BITS-1 downto i*DATA_BITS) , -- In  :
                I_INFO      => I_INFO((i+1)*INFO_BITS-1 downto i*INFO_BITS) , -- In  :
                I_LAST      => I_LAST(i)                     , -- In  :
                I_VALID     => I_VALID(i)                    , -- In  :
                I_READY     => I_READY(i)                    , -- Out :
                O_DATA      => node_data (TREE_DEPTH, i)     , -- Out :
                O_INFO      => node_info (TREE_DEPTH, i)     , -- Out :
                O_LAST      => node_last (TREE_DEPTH, i)     , -- Out :
                O_VALID     => node_valid(TREE_DEPTH, i)     , -- Out :
                O_READY     => node_ready(TREE_DEPTH, i)       -- In  :
            );                                                 -- 
    end generate;                                              -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    TREE: for depth in TREE_DEPTH-1 downto 0 generate          -- 
        GEN: for i in 0 to (2**depth)-1 generate               -- 
            NODE: Merge_Sorter_Node                            -- 
               generic map(                                    -- 
                    QUEUE_SIZE  => QUEUE_SIZE                , -- 
                    DATA_BITS   => DATA_BITS                 , -- 
                    COMP_HIGH   => COMP_HIGH                 , -- 
                    COMP_LOW    => COMP_LOW                  , --
                    INFO_BITS   => INFO_BITS                   -- 
                )                                              -- 
                port map (                                     -- 
                    CLK         => CLK                       , -- In  :
                    RST         => RST                       , -- In  :
                    CLR         => CLR                       , -- In  :
                    A_DATA      => node_data (depth+1, 2*i+0), -- In  :
                    A_INFO      => node_info (depth+1, 2*i+0), -- In  :
                    A_LAST      => node_last (depth+1, 2*i+0), -- In  :
                    A_VALID     => node_valid(depth+1, 2*i+0), -- In  :
                    A_READY     => node_ready(depth+1, 2*i+0), -- Out :
                    B_DATA      => node_data (depth+1, 2*i+1), -- In  :
                    B_INFO      => node_info (depth+1, 2*i+1), -- In  :
                    B_LAST      => node_last (depth+1, 2*i+1), -- In  :
                    B_VALID     => node_valid(depth+1, 2*i+1), -- In  :
                    B_READY     => node_ready(depth+1, 2*i+1), -- Out :
                    O_DATA      => node_data (depth  ,   i  ), -- Out :
                    O_INFO      => node_info (depth  ,   i  ), -- Out :
                    O_LAST      => node_last (depth  ,   i  ), -- Out :
                    O_VALID     => node_valid(depth  ,   i  ), -- Out :
                    O_READY     => node_ready(depth  ,   i  )  -- In  :
                );                                             -- 
        end generate;                                          -- 
    end generate;                                              -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    O_DATA  <= node_data (0,0);
    O_INFO  <= node_info (0,0);
    O_LAST  <= node_last (0,0);
    O_VALID <= node_valid(0,0);
    node_ready(0,0) <= O_READY;
end RTL;
