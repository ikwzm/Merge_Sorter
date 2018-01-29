-----------------------------------------------------------------------------------
--!     @file    merge_sorter_compare.vhd
--!     @brief   Merge Sorter Compare Module :
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
entity  Merge_Sorter_Compare is
    generic (
        SORT_ORDER  :  integer :=  0;
        DATA_BITS   :  integer := 64;
        COMP_HIGH   :  integer := 63;
        COMP_LOW    :  integer := 32
    );
    port (
        CLK         :  in  std_logic;
        RST         :  in  std_logic;
        CLR         :  in  std_logic;
        A_DATA      :  in  std_logic_vector(DATA_BITS-1 downto 0);
        A_NONE      :  in  std_logic;
        B_DATA      :  in  std_logic_vector(DATA_BITS-1 downto 0);
        B_NONE      :  in  std_logic;
        VALID       :  in  std_logic;
        READY       :  out std_logic;
        SEL_A       :  out std_logic;
        SEL_B       :  out std_logic
    );
end Merge_Sorter_Compare;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
architecture RTL of Merge_Sorter_Compare is
begin
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    process(VALID, A_NONE, A_DATA, B_NONE, B_DATA) 
        variable comp_a  :  unsigned(COMP_HIGH-COMP_LOW downto 0);
        variable comp_b  :  unsigned(COMP_HIGH-COMP_LOW downto 0);
        variable a_gt_b  :  boolean;
    begin
        if (VALID = '1') then
            comp_a := unsigned(A_DATA(COMP_HIGH downto COMP_LOW));
            comp_b := unsigned(B_DATA(COMP_HIGH downto COMP_LOW));
            a_gt_b := (comp_a > comp_b);
            if    (A_NONE = '1' and B_NONE = '1') then
                SEL_A <= '1';
                SEL_B <= '0';
            elsif (A_NONE = '0' and B_NONE = '1') then
                SEL_A <= '1';
                SEL_B <= '0';
            elsif (A_NONE = '1' and B_NONE = '0') then
                SEL_A <= '0';
                SEL_B <= '1';
            elsif (SORT_ORDER  = 0 and a_gt_b = TRUE ) or
                  (SORT_ORDER /= 0 and a_gt_b = FALSE) then
                SEL_A <= '1';
                SEL_B <= '0';
            else
                SEL_A <= '0';
                SEL_B <= '1';
            end if;
                READY <= '1';
        else
                READY <= '0';
                SEL_A <= '0';
                SEL_B <= '0';
        end if;
    end process;
end RTL;

