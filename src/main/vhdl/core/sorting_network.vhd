-----------------------------------------------------------------------------------
--!     @file    sorting_network.vhd
--!     @brief   Sorting Network Package :
--!     @version 0.7.0
--!     @date    2020/10/30
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
--
--      Copyright (C) 2020 Ichiro Kawazome
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
library Merge_Sorter;
use     Merge_Sorter.Word;
package Sorting_Network is
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    constant  Max_Network_Size      :  integer := 256;
    constant  Max_Stage_Size        :  integer := 256;
    constant  Max_Stage_Queue_Size  :  integer := 2;
    constant  Stage_Queue_Ctrl_Bits :  integer := Max_Stage_Queue_Size+1;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    type      Comparator_Type       is record
                  STEP              :  integer;  -- Connect Network
                  ORDER             :  integer;  -- SORT ORDER (0=Ascending,1:Descending)
    end record;
    constant  Comparator_Null       :  Comparator_Type := (
                  STEP              => 0,
                  ORDER             => 0
              );
    type      Comparator_Vector     is array (integer range <>) of Comparator_Type;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    type      Stage_Type            is record
                  Comparator_List   :  Comparator_Vector(0 to Max_Network_Size-1);
                  Queue_Size        :  integer range 0 to Max_Stage_Queue_Size;
    end record;
    constant  Stage_Null            :  Stage_Type := (
                  Comparator_List   => (others => Comparator_Null),
                  Queue_Size        => 0
              );
    type      Stage_Vector          is array (integer range <>) of Stage_Type;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    type      Param_Type            is record
                  Stage_List        :  Stage_Vector( 1 to Max_Stage_Size);
                  Stage_Size        :  integer range 0 to Max_Stage_Size;
                  Stage_Lo          :  integer range 0 to Max_Stage_Size;
                  Stage_Hi          :  integer range 0 to Max_Stage_Size;
                  Stage_Ctrl_Lo     :  integer range 0 to Max_Stage_Size*Stage_Queue_Ctrl_Bits;
                  Stage_Ctrl_Hi     :  integer range 0 to Max_Stage_Size*Stage_Queue_Ctrl_Bits;
                  Size              :  integer range 0 to Max_Network_Size;
                  Lo                :  integer range 0 to Max_Network_Size-1;
                  Hi                :  integer range 0 to Max_Network_Size-1;
    end record;
    constant  Param_Null            :  Param_Type := (
                  Stage_List        => (others => Stage_Null),
                  Stage_Size        => 0,
                  Stage_Lo          => 0,
                  Stage_Hi          => 0,
                  Stage_Ctrl_Lo     => 0,
                  Stage_Ctrl_Hi     => 0,
                  Size              => 0,
                  Lo                => 0,
                  Hi                => 0
              );
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    procedure  Add_Comparator(
        variable  NETWORK     :  inout Param_Type;
                  STAGE       :  in    integer;
                  LO          :  in    integer;
                  HI          :  in    integer;
                  ORDER       :  in    integer
    );
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    procedure  Add_Queue_Params(
        variable  NETWORK     :  inout Param_Type;
                  QUEUE_SIZE  :  in    integer
    );
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function   New_Bitonic_Sorter_Network(LO,HI,ORDER,QUEUE:integer) return Param_Type;
    function   New_Bitonic_Merger_Network(LO,HI,ORDER,QUEUE:integer) return Param_Type;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function   New_OddEven_Sorter_Network(LO,HI,ORDER,QUEUE:integer) return Param_Type;
    function   New_OddEven_Merger_Network(LO,HI,ORDER,QUEUE:integer) return Param_Type;
end Sorting_Network;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
package body Sorting_Network is
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    procedure Add_Comparator(
        variable  NETWORK     :  inout Param_Type;
                  STAGE       :  in    integer;
                  LO          :  in    integer;
                  HI          :  in    integer;
                  ORDER       :  in    integer
    ) is
    begin
        assert (HI - LO > 0)
            report "Add_Comparator error" severity ERROR;
        assert ((NETWORK.Stage_List(STAGE).Comparator_List(LO).STEP = 0) or
                ((NETWORK.Stage_List(STAGE).Comparator_List(LO).STEP  = HI-LO) and
                 (NETWORK.Stage_List(STAGE).Comparator_List(LO).ORDER = ORDER)))
            report "Add_Comparator error" severity ERROR;
        assert ((NETWORK.Stage_List(STAGE).Comparator_List(HI).STEP = 0) or
                ((NETWORK.Stage_List(STAGE).Comparator_List(HI).STEP  = LO-HI) and
                 (NETWORK.Stage_List(STAGE).Comparator_List(HI).ORDER = ORDER)))
            report "Add_Comparator error" severity ERROR;
        NETWORK.Stage_List(STAGE).Comparator_List(LO).STEP  := HI-LO;
        NETWORK.Stage_List(STAGE).Comparator_List(LO).ORDER := ORDER;
        NETWORK.Stage_List(STAGE).Comparator_List(HI).STEP  := LO-HI;
        NETWORK.Stage_List(STAGE).Comparator_List(HI).ORDER := ORDER;
    end procedure;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    procedure  Add_Queue_Params(
        variable  NETWORK     :  inout Param_Type;
                  QUEUE_SIZE  :  in    integer
    ) is
    begin
        NETWORK.Stage_Ctrl_Lo := NETWORK.Stage_Lo*Stage_Queue_Ctrl_Bits;
        NETWORK.Stage_Ctrl_Hi := NETWORK.Stage_Hi*Stage_Queue_Ctrl_Bits;
        for stage in NETWORK.Stage_Lo to NETWORK.Stage_Hi loop
            NETWORK.Stage_List(stage).Queue_Size := QUEUE_SIZE;
        end loop;
    end procedure;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    procedure bitonic_merge(
        variable  NETWORK     :  inout Param_Type;
                  START_STAGE :  in    integer;
                  LO          :  in    integer;
                  HI          :  in    integer;
                  ORDER       :  in    integer
    ) is
        variable  dist        :        integer;
        variable  index       :        integer;
    begin
        if (HI - LO > 0) then
            dist   := (HI-LO+1)/2;
            index  := LO;
            while (index+dist <= HI) loop
                Add_Comparator(NETWORK, START_STAGE, index, index+dist, ORDER);
                index := index + 1;
            end loop;
            if (START_STAGE > NETWORK.Stage_Hi) then
                NETWORK.Stage_Hi   := START_STAGE;
                NETWORK.Stage_Size := NETWORK.Stage_Hi - NETWORK.Stage_Lo + 1;
            end if;
            bitonic_merge(NETWORK, START_STAGE + 1, LO     , LO+dist-1, ORDER);
            bitonic_merge(NETWORK, START_STAGE + 1, LO+dist, HI       , ORDER);
        end if;
    end procedure;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    procedure bitonic_sort(
        variable  NETWORK     :  inout Param_Type;
                  START_STAGE :  in    integer;
                  LO          :  in    integer;
                  HI          :  in    integer;
                  ORDER       :  in    integer
    ) is
        variable  dist        :        integer;
    begin
        if (HI - LO > 0) then
            dist := (HI-LO+1)/2;
            bitonic_sort (NETWORK, START_STAGE         , LO        , LO + dist-1, 0    );
            bitonic_sort (NETWORK, START_STAGE         , LO + dist , HI         , 1    );
            bitonic_merge(NETWORK, NETWORK.Stage_Hi + 1, LO        , HI         , ORDER);
        end if;
    end procedure;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function   New_Bitonic_Sorter_Network(LO,HI,ORDER,QUEUE:integer) return Param_Type
    is
        variable network :  Param_Type;
    begin
        network          := Param_Null;
        network.Size     := HI - LO + 1;
        network.Lo       := LO;
        network.Hi       := HI;
        network.Stage_Lo := 1;
        bitonic_sort(network, network.Stage_Lo, network.Lo, network.Hi, ORDER);
        Add_Queue_Params(network, QUEUE);
        return network;
    end function;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function   New_Bitonic_Merger_Network(LO,HI,ORDER,QUEUE:integer) return Param_Type
    is
        variable network :  Param_Type;
    begin
        network          := Param_Null;
        network.Size     := HI - LO + 1;
        network.Lo       := LO;
        network.Hi       := HI;
        network.Stage_Lo := 1;
        bitonic_merge(network, network.Stage_Lo, network.Lo, network.Hi, ORDER);
        Add_Queue_Params(network, QUEUE);
        return network;
    end function;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    procedure oddeven_merge(
        variable  NETWORK     :  inout Param_Type;
                  START_STAGE :  in    integer;
                  LO          :  in    integer;
                  HI          :  in    integer;
                  R           :  in    integer;
                  ORDER       :  in    integer
    ) is
        variable  step        :        integer;
        variable  index       :        integer;
    begin
        step := R * 2;
        if (HI - LO > step) then
            oddeven_merge(NETWORK, START_STAGE + 1, LO    , HI, step, ORDER);
            oddeven_merge(NETWORK, START_STAGE + 1, LO + r, HI, step, ORDER);
            index  := LO + R;
            while (index <= HI - R) loop
                Add_Comparator(NETWORK, START_STAGE, index, index + R, ORDER);
                index := index + step;
            end loop;
        else
            Add_Comparator(NETWORK, START_STAGE, LO, LO + R, ORDER);
        end if;
        if (START_STAGE > NETWORK.Stage_Hi) then
            NETWORK.Stage_Hi   := START_STAGE;
            NETWORK.Stage_Size := NETWORK.Stage_Hi - NETWORK.Stage_Lo + 1;
        end if;
    end procedure;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    procedure oddeven_sort(
        variable  NETWORK     :  inout Param_Type;
                  START_STAGE :  in    integer;
                  LO          :  in    integer;
                  HI          :  in    integer;
                  ORDER       :  in    integer
    ) is
        variable  mid         :        integer;
    begin
        if (HI - LO > 0) then
            mid := LO + ((HI - LO) / 2);
            oddeven_merge(NETWORK, START_STAGE         , LO   , HI , 1, ORDER);
            oddeven_sort (NETWORK, NETWORK.Stage_HI + 1, LO   , mid,    ORDER);
            oddeven_sort (NETWORK, NETWORK.Stage_HI + 1, mid+1, HI ,    ORDER);
        end if;
    end procedure;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    procedure reverse_network_stage_list(
        variable  NETWORK     :  inout Param_Type
    ) is
        variable  stage_list  :        Stage_Vector(NETWORK.Stage_LO to NETWORK.Stage_HI);
    begin
        stage_list(NETWORK.Stage_LO to NETWORK.Stage_HI) := NETWORK.Stage_List(NETWORK.Stage_LO to NETWORK.Stage_HI);
        for i in 0 to NETWORK.Stage_Size-1 loop
            NETWORK.Stage_List(NETWORK.Stage_Lo+i) := stage_list(NETWORK.Stage_Hi-i);
        end loop;
    end procedure;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function   New_OddEven_Sorter_Network(LO,HI,ORDER,QUEUE:integer) return Param_Type
    is
        variable network :  Param_Type;
    begin
        network          := Param_Null;
        network.Size     := HI - LO + 1;
        network.Lo       := LO;
        network.Hi       := HI;
        network.Stage_Lo := 1;
        oddeven_sort(network, network.Stage_Lo, network.Lo, network.Hi, ORDER);
        reverse_network_stage_list(network);
        Add_Queue_Params(network, QUEUE);
        return network;
    end function;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function   New_OddEven_Merger_Network(LO,HI,ORDER,QUEUE:integer) return Param_Type
    is
        variable network :  Param_Type;
    begin
        network          := Param_Null;
        network.Size     := HI - LO + 1;
        network.Lo       := LO;
        network.Hi       := HI;
        network.Stage_Lo := 1;
        oddeven_merge(network, network.Stage_Lo, network.Lo, network.Hi, 1, ORDER);
        reverse_network_stage_list(network);
        Add_Queue_Params(network, QUEUE);
        return network;
    end function;
end Sorting_Network;
