-----------------------------------------------------------------------------------
--!     @file    asymmetric_sorter_network_print.vhd
--!     @brief   Batcher's Odd-Even Merge Sorter Network Print :
--!     @version 1.6.2
--!     @date    2026/1/2
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
--
--      Copyright (C) 2025-2026 Ichiro Kawazome
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
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     std.textio.all;
library Merge_Sorter;
use     Merge_Sorter.Sorting_Network;
use     Merge_Sorter.Asymmetric_MergeSort_Network;
library Dummy_Plug;
use     Dummy_Plug.UTIL.INTEGER_TO_STRING;
use     WORK.Sorting_Network_Printer.all;
entity  Asymmetric_Sort_Network_Print is
    generic (
        WORDS           :  integer :=  4;
        SORT_ORDER      :  integer :=  0
    );
end     Asymmetric_Sort_Network_Print;
architecture Model of Asymmetric_Sort_Network_Print is
    constant network   :  Sorting_Network.Param_Type :=
                          Asymmetric_MergeSort_Network.New_Network(0, WORDS-1, SORT_ORDER);
begin
    process
    begin
        Print_Sorting_Network(network);
        wait;
    end process;
end Model;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  Asymmetric_Sort_Network_x4_Print is
end     Asymmetric_Sort_Network_x4_Print;
architecture Model of Asymmetric_Sort_Network_x4_Print is
begin
    DUT: entity work.Asymmetric_Sort_Network_Print generic map(WORDS => 4);
end Model;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  Asymmetric_Sort_Network_x5_Print is
end     Asymmetric_Sort_Network_x5_Print;
architecture Model of Asymmetric_Sort_Network_x5_Print is
begin
    DUT: entity work.Asymmetric_Sort_Network_Print generic map(WORDS => 5);
end Model;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  Asymmetric_Sort_Network_x6_Print is
end     Asymmetric_Sort_Network_x6_Print;
architecture Model of Asymmetric_Sort_Network_x6_Print is
begin
    DUT: entity work.Asymmetric_Sort_Network_Print generic map(WORDS => 6);
end Model;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  Asymmetric_Sort_Network_x7_Print is
end     Asymmetric_Sort_Network_x7_Print;
architecture Model of Asymmetric_Sort_Network_x7_Print is
begin
    DUT: entity work.Asymmetric_Sort_Network_Print generic map(WORDS => 7);
end Model;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  Asymmetric_Sort_Network_x8_Print is
end     Asymmetric_Sort_Network_x8_Print;
architecture Model of Asymmetric_Sort_Network_x8_Print is
begin
    DUT: entity work.Asymmetric_Sort_Network_Print generic map(WORDS => 8);
end Model;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  Asymmetric_Sort_Network_x9_Print is
end     Asymmetric_Sort_Network_x9_Print;
architecture Model of Asymmetric_Sort_Network_x9_Print is
begin
    DUT: entity work.Asymmetric_Sort_Network_Print generic map(WORDS => 9);
end Model;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  Asymmetric_Sort_Network_x10_Print is
end     Asymmetric_Sort_Network_x10_Print;
architecture Model of Asymmetric_Sort_Network_x10_Print is
begin
    DUT: entity work.Asymmetric_Sort_Network_Print generic map(WORDS => 10);
end Model;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  Asymmetric_Sort_Network_x11_Print is
end     Asymmetric_Sort_Network_x11_Print;
architecture Model of Asymmetric_Sort_Network_x11_Print is
begin
    DUT: entity work.Asymmetric_Sort_Network_Print generic map(WORDS => 11);
end Model;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  Asymmetric_Sort_Network_x12_Print is
end     Asymmetric_Sort_Network_x12_Print;
architecture Model of Asymmetric_Sort_Network_x12_Print is
begin
    DUT: entity work.Asymmetric_Sort_Network_Print generic map(WORDS => 12);
end Model;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  Asymmetric_Sort_Network_x13_Print is
end     Asymmetric_Sort_Network_x13_Print;
architecture Model of Asymmetric_Sort_Network_x13_Print is
begin
    DUT: entity work.Asymmetric_Sort_Network_Print generic map(WORDS => 13);
end Model;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  Asymmetric_Sort_Network_x14_Print is
end     Asymmetric_Sort_Network_x14_Print;
architecture Model of Asymmetric_Sort_Network_x14_Print is
begin
    DUT: entity work.Asymmetric_Sort_Network_Print generic map(WORDS => 14);
end Model;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  Asymmetric_Sort_Network_x15_Print is
end     Asymmetric_Sort_Network_x15_Print;
architecture Model of Asymmetric_Sort_Network_x15_Print is
begin
    DUT: entity work.Asymmetric_Sort_Network_Print generic map(WORDS => 15);
end Model;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  Asymmetric_Sort_Network_x16_Print is
end     Asymmetric_Sort_Network_x16_Print;
architecture Model of Asymmetric_Sort_Network_x16_Print is
begin
    DUT: entity work.Asymmetric_Sort_Network_Print generic map(WORDS => 16);
end Model;
