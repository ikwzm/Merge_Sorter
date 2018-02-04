-----------------------------------------------------------------------------------
--!     @file    merge_sorter_core.vhd
--!     @brief   Merge Sorter Core Module :
--!     @version 0.0.3
--!     @date    2018/2/4
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
        SORT_ORDER  :  integer :=  0;
        FEEDBACK    :  integer :=  1;
        WORDS       :  integer :=  8;
        I_ENABLE    :  integer :=  1;
        I_WORDS     :  integer :=  8;
        DATA_BITS   :  integer := 64;
        COMP_HIGH   :  integer := 63;
        COMP_LOW    :  integer := 32
    );
    port (
        CLK         :  in  std_logic;
        RST         :  in  std_logic;
        CLR         :  in  std_logic;
        I_DATA      :  in  std_logic_vector(I_WORDS*DATA_BITS-1 downto 0);
        I_DONE      :  in  std_logic_vector(I_WORDS          -1 downto 0);
        I_NONE      :  in  std_logic_vector(I_WORDS          -1 downto 0);
        I_LAST      :  in  std_logic_vector(I_WORDS          -1 downto 0);
        I_VALID     :  in  std_logic_vector(I_WORDS          -1 downto 0);
        I_READY     :  out std_logic_vector(I_WORDS          -1 downto 0);
        O_DATA      :  out std_logic_vector(        DATA_BITS-1 downto 0);
        O_LAST      :  out std_logic;
        O_VALID     :  out std_logic;
        O_READY     :  in  std_logic
    );
end Merge_Sorter_Core;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
architecture RTL of Merge_Sorter_Core is
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component Merge_Sorter_Tree
        generic (
            SORT_ORDER      :  integer :=  0;
            QUEUE_SIZE      :  integer :=  2;
            I_WORDS         :  integer :=  8;
            DATA_BITS       :  integer := 64;
            COMP_HIGH       :  integer := 63;
            COMP_LOW        :  integer := 32;
            INFO_BITS       :  integer :=  2
        );
        port (
            CLK             :  in  std_logic;
            RST             :  in  std_logic;
            CLR             :  in  std_logic;
            I_DATA          :  in  std_logic_vector(I_WORDS*DATA_BITS-1 downto 0);
            I_INFO          :  in  std_logic_vector(I_WORDS*INFO_BITS-1 downto 0);
            I_LAST          :  in  std_logic_vector(I_WORDS          -1 downto 0);
            I_VALID         :  in  std_logic_vector(I_WORDS          -1 downto 0);
            I_READY         :  out std_logic_vector(I_WORDS          -1 downto 0);
            O_DATA          :  out std_logic_vector(        DATA_BITS-1 downto 0);
            O_INFO          :  out std_logic_vector(        INFO_BITS-1 downto 0);
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
    function  CALC_WORD_PTR_BITS(WORDS:integer) return integer is
        variable value : integer;
    begin
        value := 0;
        while (2**value < WORDS) loop
            value := value + 1;
        end loop;
        return value;
    end function;
    constant  WORD_PTR_BITS     : integer := CALC_WORD_PTR_BITS(WORDS);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    constant  INFO_NONE_POS     :  integer := 0;
    constant  INFO_DONE_POS     :  integer := 1;
    constant  INFO_FEEDBACK_POS :  integer := 2;
    constant  INFO_WORD_PTR_LO  :  integer := 3;
    constant  INFO_WORD_PTR_HI  :  integer := INFO_WORD_PTR_LO + WORD_PTR_BITS - 1;
    constant  INFO_BITS         :  integer := INFO_WORD_PTR_HI + 1;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    type      WORD_DATA_VECTOR  is array (integer range <>) of std_logic_vector(DATA_BITS-1 downto 0);
    type      WORD_INFO_VECTOR  is array (integer range <>) of std_logic_vector(INFO_BITS-1 downto 0);
    signal    intake_word_data  :  WORD_DATA_VECTOR(WORDS-1 downto 0);
    signal    intake_word_info  :  WORD_INFO_VECTOR(WORDS-1 downto 0);
    signal    intake_word_last  :  std_logic_vector(WORDS-1 downto 0);
    signal    intake_word_valid :  std_logic_vector(WORDS-1 downto 0);
    signal    intake_word_ready :  std_logic_vector(WORDS-1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal    sorted_word_data  :  std_logic_vector(DATA_BITS-1 downto 0);
    signal    sorted_word_info  :  std_logic_vector(INFO_BITS-1 downto 0);
    signal    sorted_word_last  :  std_logic;
    signal    sorted_word_valid :  std_logic;
    signal    sorted_word_ready :  std_logic;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal    feedback_data     :  std_logic_vector(DATA_BITS-1 downto 0);
    signal    feedback_none     :  std_logic;
    signal    feedback_last     :  std_logic;
    signal    feedback_valid    :  std_logic_vector(WORDS-1 downto 0);
    signal    feedback_ready    :  std_logic_vector(WORDS-1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal    outlet_valid      :  std_logic;
    signal    outlet_ready      :  std_logic;
begin
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    SORT: block
        signal    i_word_data   :  std_logic_vector(WORDS*DATA_BITS-1 downto 0);
        signal    i_word_info   :  std_logic_vector(WORDS*INFO_BITS-1 downto 0);
    begin
        INTAKE: for i in 0 to WORDS-1 generate
            i_word_data((i+1)*DATA_BITS-1 downto i*DATA_BITS) <= intake_word_data(i);
            i_word_info((i+1)*INFO_BITS-1 downto i*INFO_BITS) <= intake_word_info(i);
        end generate;
        TREE: Merge_Sorter_Tree                          -- 
            generic map (                                -- 
                SORT_ORDER      => SORT_ORDER          , -- 
                QUEUE_SIZE      => 2                   , -- 
                I_WORDS         => WORDS               , -- 
                DATA_BITS       => DATA_BITS           , -- 
                COMP_HIGH       => COMP_HIGH           , -- 
                COMP_LOW        => COMP_LOW            , -- 
                INFO_BITS       => INFO_BITS             -- 
            )                                            -- 
            port map (                                   -- 
                CLK             => CLK                 , -- In  :
                RST             => RST                 , -- In  :
                CLR             => CLR                 , -- In  :
                I_DATA          => i_word_data         , -- In  :
                I_INFO          => i_word_info         , -- In  :
                I_LAST          => intake_word_last    , -- In  :
                I_VALID         => intake_word_valid   , -- In  :
                I_READY         => intake_word_ready   , -- Out :
                O_DATA          => sorted_word_data    , -- Out :
                O_INFO          => sorted_word_info    , -- Out :
                O_LAST          => sorted_word_last    , -- Out :
                O_VALID         => sorted_word_valid   , -- Out :
                O_READY         => sorted_word_ready     -- In  :
            );                                           -- 
    end block;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    FEEDBACK_ON: if (FEEDBACK > 0) generate
        constant  INFO_MASK_LO      :  integer := 1;
        constant  INFO_MASK_HI      :  integer := WORDS + INFO_MASK_LO - 1;
        signal    queue_i_info      :  std_logic_vector(INFO_MASK_HI downto 0);
        signal    queue_i_mask      :  std_logic_vector(WORDS-1      downto 0);
        signal    queue_i_valid     :  std_logic;
        signal    queue_i_ready     :  std_logic;
        signal    queue_o_info      :  std_logic_vector(INFO_MASK_HI downto 0);
        signal    queue_o_mask      :  std_logic_vector(WORDS-1      downto 0);
        signal    queue_o_valid     :  std_logic;
        signal    queue_o_ready     :  std_logic;
    begin
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        process (sorted_word_info)
            variable word_ptr      :  unsigned(WORD_PTR_BITS-1 downto 0);
        begin
            word_ptr := to_01(unsigned(sorted_word_info(INFO_WORD_PTR_HI downto INFO_WORD_PTR_LO)), '0');
            for i in i_mask'range loop
                if (i = word_ptr) then
                    queue_i_mask(i) <= '1';
                else
                    queue_i_mask(i) <= '0';
                end if;
            end loop;
        end process;
        sorted_word_ready <= '1' when (sorted_word_info(INFO_FEEDBACK_POS) = '0' and outlet_ready      = '1') or
                                      (sorted_word_info(INFO_FEEDBACK_POS) = '1' and queue_i_ready     = '1') else '0';
        outlet_valid      <= '1' when (sorted_word_info(INFO_FEEDBACK_POS) = '0' and sorted_word_valid = '1') else '0';
        queue_i_valid     <= '1' when (sorted_word_info(INFO_FEEDBACK_POS) = '1' and sorted_word_valid = '1') else '0';
        queue_i_info(INFO_MASK_HI downto INFO_MASK_LO) <= queue_i_mask;
        queue_i_info(INFO_NONE_POS                   ) <= sorted_word_info(INFO_NONE_POS);
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
        queue_o_mask   <= queue_o_info(INFO_MASK_HI downto INFO_MASK_LO);
        feedback_none  <= queue_o_info(INFO_NONE_POS);
        feedback_valid <= queue_o_mask when (queue_o_valid = '1') else (others => '0');
        queue_o_ready  <= or_reduce(queue_o_mask and feedback_ready);
    end generate;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    FEEDBACK_OFF: if (FEEDBACK = 0) generate
        outlet_valid      <= sorted_word_valid;
        sorted_word_ready <= outlet_ready;
        feedback_data     <= (others => '0');
        feedback_valid    <= (others => '0');
        feedback_last     <= '0';
        feedback_none     <= '0';
    end generate;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    OUTLET: block
        signal    i_none        :  std_logic;
        signal    i_last        :  std_logic;
    begin
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        i_none <= sorted_word_info(INFO_NONE_POS);
        i_last <= '1' when (sorted_word_last                = '1') and
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
                I_DATA          => sorted_word_data    , -- In  :
                I_INFO(0)       => i_none              , -- In  :
                I_LAST          => i_last              , -- In  :
                I_VALID         => outlet_valid        , -- In  :
                I_READY         => outlet_ready        , -- Out :
                O_DATA          => O_DATA              , -- Out :
                O_INFO(0)       => open                , -- Out :
                O_LAST          => O_LAST              , -- Out :
                O_VALID         => O_VALID             , -- Out :
                O_READY         => O_READY               -- In  :
            );                                           -- 
    end block;
end RTL;
