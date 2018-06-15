-----------------------------------------------------------------------------------
--!     @file    merge_sorter_core.vhd
--!     @brief   Merge Sorter Core Package :
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
use     ieee.numeric_std.all;
package Merge_Sorter_Core is
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    constant  ATRB_NONE_POS         :  integer := 0;
    constant  ATRB_PRIORITY_POS     :  integer := 1;
    constant  ATRB_POSTPEND_POS     :  integer := 2;
    constant  ATRB_BITS             :  integer := 3;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    type      Word_Field_Type       is record
                  BITS              :  integer;
                  DATA_BITS         :  integer;
                  DATA_LO           :  integer;
                  DATA_HI           :  integer;
                  DATA_COMPARE_LO   :  integer;
                  DATA_COMPARE_HI   :  integer;
                  ATRB_BITS         :  integer;
                  ATRB_LO           :  integer;
                  ATRB_HI           :  integer;
                  ATRB_NONE_POS     :  integer;
                  ATRB_PRIORITY_POS :  integer;
                  ATRB_POSTPEND_POS :  integer;
                  INFO_BITS         :  integer;
                  INFO_LO           :  integer;
                  INFO_HI           :  integer;
    end record;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function  New_Word_Field_Type(
                  DATA_BITS        :  integer;
                  COMP_LO          :  integer;
                  COMP_HI          :  integer;
                  INFO_BITS        :  integer
              )   return              Word_Field_Type;
    function  New_Word_Field_Type(
                  DATA_BITS        :  integer;
                  COMP_LO          :  integer;
                  COMP_HI          :  integer
              )   return              Word_Field_Type;
    function  New_Word_Field_Type(
                  DATA_BITS        :  integer;
                  INFO_BITS        :  integer
              )   return              Word_Field_Type;
    function  New_Word_Field_Type(
                  DATA_BITS        :  integer
              )   return              Word_Field_Type;
        
end Merge_Sorter_Core;

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
package body Merge_Sorter_Core is
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function  New_Word_Field_Type(
                  DATA_BITS        :  integer;
                  COMP_LO          :  integer;
                  COMP_HI          :  integer;
                  INFO_BITS        :  integer
              )   return              Word_Field_Type
    is
        variable  pos              :  integer;
        variable  field            :  Word_Field_Type;
    begin
        pos := 0;

        field.DATA_BITS            := DATA_BITS;
        field.DATA_LO              := pos;
        field.DATA_HI              := pos + DATA_BITS-1;
        field.DATA_COMPARE_LO      := COMP_LO;
        field.DATA_COMPARE_HI      := COMP_HI;
        pos := pos + DATA_BITS;
        
        field.ATRB_BITS            := ATRB_BITS;
        field.ATRB_LO              := pos;
        field.ATRB_HI              := pos + ATRB_BITS-1;
        field.ATRB_NONE_POS        := pos + ATRB_NONE_POS;
        field.ATRB_PRIORITY_POS    := pos + ATRB_PRIORITY_POS;
        field.ATRB_POSTPEND_POS    := pos + ATRB_POSTPEND_POS;
        pos := pos + ATRB_BITS;

        if INFO_BITS > 0 then
            field.INFO_BITS        := INFO_BITS;
            field.INFO_LO          := pos;
            field.INFO_HI          := pos + INFO_BITS-1;
            pos := pos + INFO_BITS;
        else
            field.INFO_BITS        := 0;
            field.INFO_LO          := pos;
            field.INFO_HI          := pos;
        end if;

        field.bits := pos;

        return field;
    end New_Word_Field_Type;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function  New_Word_Field_Type(
                  DATA_BITS        :  integer;
                  COMP_LO          :  integer;
                  COMP_HI          :  integer
              )   return              Word_Field_Type
    is
    begin
        return New_Word_Field_Type(
                  DATA_BITS        => DATA_BITS,
                  COMP_LO          => COMP_LO  ,
                  COMP_HI          => COMP_HI  ,
                  INFO_BITS        => 0
               );
    end New_Word_Field_Type;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function  New_Word_Field_Type(
                  DATA_BITS        :  integer;
                  INFO_BITS        :  integer
              )   return              Word_Field_Type
    is
    begin
        return New_Word_Field_Type(
                  DATA_BITS        => DATA_BITS  ,
                  COMP_LO          => 0          ,
                  COMP_HI          => DATA_BITS-1,
                  INFO_BITS        => INFO_BITS
               );
    end New_Word_Field_Type;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function  New_Word_Field_Type(
                  DATA_BITS        :  integer
              )   return              Word_Field_Type
    is
    begin
        return New_Word_Field_Type(
                  DATA_BITS        => DATA_BITS  ,
                  COMP_LO          => 0          ,
                  COMP_HI          => DATA_BITS-1,
                  INFO_BITS        => 0
               );
    end New_Word_Field_Type;
end Merge_Sorter_Core;
