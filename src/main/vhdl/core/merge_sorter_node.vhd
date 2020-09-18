-----------------------------------------------------------------------------------
--!     @file    merge_sorter_node.vhd
--!     @brief   Merge Sorter Node Module :
--!     @version 0.5.0
--!     @date    2020/9/18
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
use     Merge_Sorter.Word;
entity  Merge_Sorter_Node is
    generic (
        WORD_PARAM  :  Word.Param_Type := Word.Default_Param;
        INFO_BITS   :  integer :=  1;
        SORT_ORDER  :  integer :=  0
    );
    port (
        CLK         :  in  std_logic;
        RST         :  in  std_logic;
        CLR         :  in  std_logic;
        A_WORD      :  in  std_logic_vector(WORD_PARAM.BITS-1 downto 0);
        A_INFO      :  in  std_logic_vector(INFO_BITS      -1 downto 0) := (others => '0');
        A_LAST      :  in  std_logic;
        A_VALID     :  in  std_logic;
        A_READY     :  out std_logic;
        B_WORD      :  in  std_logic_vector(WORD_PARAM.BITS-1 downto 0);
        B_INFO      :  in  std_logic_vector(INFO_BITS      -1 downto 0) := (others => '0');
        B_LAST      :  in  std_logic;
        B_VALID     :  in  std_logic;
        B_READY     :  out std_logic;
        O_WORD      :  out std_logic_vector(WORD_PARAM.BITS-1 downto 0);
        O_INFO      :  out std_logic_vector(INFO_BITS      -1 downto 0);
        O_LAST      :  out std_logic;
        O_VALID     :  out std_logic;
        O_READY     :  in  std_logic
    );
end Merge_Sorter_Node;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
library Merge_Sorter;
use     Merge_Sorter.Word;
use     Merge_Sorter.Core_Components.Word_Compare;
architecture RTL of Merge_Sorter_Node is
    type      STATE_TYPE        is (IDLE_STATE , COMP_STATE   ,
                                    A_SEL_STATE, A_FLUSH_STATE, 
                                    B_SEL_STATE, B_FLUSH_STATE
                                );
    signal    curr_state        :  STATE_TYPE;
    signal    next_state        :  STATE_TYPE;
    signal    temp_state        :  STATE_TYPE;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal    comp_valid        :  std_logic;
    signal    comp_ready        :  std_logic;
    signal    comp_sel_a        :  std_logic;
    signal    comp_sel_b        :  std_logic;
begin
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    COMP: Word_Compare                        --
        generic map(                          --
            WORD_PARAM  => WORD_PARAM       , -- 
            SORT_ORDER  => SORT_ORDER         -- 
        )                                     -- 
        port map (                            --
            CLK         => CLK              , -- In  :
            RST         => RST              , -- In  :
            CLR         => CLR              , -- In  :
            A_WORD      => A_WORD           , -- In  :
            B_WORD      => B_WORD           , -- In  :
            VALID       => comp_valid       , -- In  :
            READY       => comp_ready       , -- Out :
            SEL_A       => comp_sel_a       , -- Out :
            SEL_B       => comp_sel_b         -- Out :
        );                                    -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    comp_valid <= '1' when (curr_state = COMP_STATE and A_VALID = '1' and B_VALID = '1') else '0';
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    process (curr_state, comp_ready, comp_sel_b) begin
        case curr_state is
            when COMP_STATE =>
                if   (comp_ready = '1') then
                    if (comp_sel_b = '1') then
                        temp_state <= B_SEL_STATE;
                    else
                        temp_state <= A_SEL_STATE;
                    end if;
                else
                        temp_state <= COMP_STATE;
                end if;
            when others =>
                        temp_state <= curr_state;
        end case;
    end process;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    process (temp_state, A_VALID, A_LAST, B_VALID, B_LAST, O_READY) begin
        case temp_state is
            when A_SEL_STATE =>
                if    (O_READY = '1' and A_VALID = '1' and A_LAST = '1') then
                    next_state <= B_FLUSH_STATE;
                elsif (O_READY = '1' and A_VALID = '1' and A_LAST = '0') then
                    next_state <= COMP_STATE;
                else
                    next_state <= A_SEL_STATE;
                end if;
            when B_SEL_STATE =>
                if    (O_READY = '1' and B_VALID = '1' and B_LAST = '1') then
                    next_state <= A_FLUSH_STATE;
                elsif (O_READY = '1' and B_VALID = '1' and B_LAST = '0') then
                    next_state <= COMP_STATE;
                else
                    next_state <= B_SEL_STATE;
                end if;
            when A_FLUSH_STATE =>
                if    (O_READY = '1' and A_VALID = '1' and A_LAST = '1') then
                    next_state <= COMP_STATE;
                else
                    next_state <= A_FLUSH_STATE;
                end if;
            when B_FLUSH_STATE =>
                if    (O_READY = '1' and B_VALID = '1' and B_LAST = '1') then
                    next_state <= COMP_STATE;
                else
                    next_state <= B_FLUSH_STATE;
                end if;
            when COMP_STATE  =>
                    next_state <= COMP_STATE;
            when others =>
                    next_state <= COMP_STATE;
        end case;
    end process;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    process (CLK, RST) begin
        if (RST = '1') then
                curr_state <= IDLE_STATE;
        elsif (CLK'event and CLK = '1') then
            if (CLR = '1') then
                curr_state <= IDLE_STATE;
            else
                curr_state <= next_state;
            end if;
        end if;
    end process;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    A_READY <= '1' when (temp_state = A_SEL_STATE   and O_READY = '1') or
                        (temp_state = A_FLUSH_STATE and O_READY = '1') else '0';
    B_READY <= '1' when (temp_state = B_SEL_STATE   and O_READY = '1') or
                        (temp_state = B_FLUSH_STATE and O_READY = '1') else '0';
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    O_VALID <= '1' when (temp_state = A_SEL_STATE   and A_VALID = '1') or
                        (temp_state = A_FLUSH_STATE and A_VALID = '1') or
                        (temp_state = B_SEL_STATE   and B_VALID = '1') or
                        (temp_state = B_FLUSH_STATE and B_VALID = '1') else '0';
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    O_LAST  <= '1' when (temp_state = A_FLUSH_STATE and A_LAST  = '1') or
                        (temp_state = B_FLUSH_STATE and B_LAST  = '1') else '0';
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    O_WORD  <= B_WORD when (temp_state = B_SEL_STATE  ) or
                           (temp_state = B_FLUSH_STATE) else A_WORD;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    O_INFO  <= B_INFO when (temp_state = B_SEL_STATE  ) or
                           (temp_state = B_FLUSH_STATE) else A_INFO;
end RTL;
