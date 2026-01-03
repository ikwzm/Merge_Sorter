-----------------------------------------------------------------------------------
--!     @file    sorting_network_printer.vhd
--!     @brief   Sorting Network Printer Package :
--!     @version 1.6.2
--!     @date    2026/1/2
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
--
--      Copyright (C) 2026 Ichiro Kawazome
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
use     ieee.numeric_std.all;
use     std.textio.all;
library Merge_Sorter;
use     Merge_Sorter.Sorting_Network;
library Dummy_Plug;
use     Dummy_Plug.UTIL.INTEGER_TO_STRING;
package Sorting_Network_Printer is
    procedure Print_Sorting_Network(network: in Sorting_Network.Param_Type);
end Sorting_Network_Printer;
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     std.textio.all;
library Merge_Sorter;
use     Merge_Sorter.Sorting_Network;
package body Sorting_Network_Printer is
    procedure Print_Sorting_Network(network: in Sorting_Network.Param_Type) is
        variable text_line :  LINE;
        variable op        :  Sorting_Network.Operator_Type;
        variable tag       :  STRING(1 to 4);
    begin
        WRITE(text_line, Sorting_Network.To_String(network));
        WRITELINE(OUTPUT, text_line);
        for stage in network.Stage_Lo to network.Stage_Hi loop
            tag := string'("- - ");
            for net in network.Lo to network.Hi loop
                op := network.Stage_List(stage).Operator_List(net);
                if (Sorting_Network.Operator_Is_Comp(op) and op.STEP > 0) or
                   (Sorting_Network.Operator_Is_Pass(op) and op.STEP > 0) then
                    WRITE(text_line, 
                              tag &
                              string'("[""") &
                              Sorting_Network.To_String(op.op) &
                              string'(""",") &
                              INTEGER_TO_STRING(net) &
                              string'(",") &
                              INTEGER_TO_STRING(net+op.STEP) &
                              string'("]")
                    );
                    WRITELINE(OUTPUT, text_line);
                    tag := string'("  - ");
                end if;
            end loop;
        end loop;
    end procedure;
end Sorting_Network_Printer;
