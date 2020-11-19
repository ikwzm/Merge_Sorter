-----------------------------------------------------------------------------------
--!     @file    interface.vhd
--!     @brief   Merge Sorter Interface Package :
--!     @version 0.9.1
--!     @date    2020/11/19
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
package Interface is

    -------------------------------------------------------------------------------
    -- Interface Register Field Type
    -------------------------------------------------------------------------------
    type      Regs_Field_Type  is record
                  BITS              :  integer;
                  BASE_ADDR         :  integer;
                  REGS_LO           :  integer;
                  REGS_HI           :  integer;
                  ADDR_BASE_ADDR    :  integer;
                  ADDR_BITS         :  integer;
                  ADDR_LO           :  integer;
                  ADDR_HI           :  integer;
                  SIZE_BASE_ADDR    :  integer;
                  SIZE_BITS         :  integer;
                  SIZE_LO           :  integer;
                  SIZE_HI           :  integer;
                  MODE_BASE_ADDR    :  integer;
                  MODE_BITS         :  integer;
                  MODE_HI           :  integer;
                  MODE_LO           :  integer;
                  MODE_SAFETY_POS   :  integer;
                  MODE_SPECUL_POS   :  integer;
                  MODE_AID_LO       :  integer;
                  MODE_AID_HI       :  integer;
                  MODE_AUSER_HI     :  integer;
                  MODE_AUSER_LO     :  integer;
                  MODE_APROT_HI     :  integer;
                  MODE_APROT_LO     :  integer;
                  MODE_CACHE_HI     :  integer;
                  MODE_CACHE_LO     :  integer;
                  MODE_CLOSE_POS    :  integer;
                  MODE_ERROR_POS    :  integer;
                  MODE_DONE_POS     :  integer;
                  STAT_BASE_ADDR    :  integer;
                  STAT_BITS         :  integer;
                  STAT_LO           :  integer;
                  STAT_HI           :  integer;
                  STAT_RESV_BITS    :  integer;
                  STAT_RESV_HI      :  integer;
                  STAT_RESV_LO      :  integer;
                  STAT_CLOSE_POS    :  integer;
                  STAT_ERROR_POS    :  integer;
                  STAT_DONE_POS     :  integer;
                  CTRL_BASE_ADDR    :  integer;
                  CTRL_BITS         :  integer;
                  CTRL_LO           :  integer;
                  CTRL_HI           :  integer;
                  CTRL_RESET_POS    :  integer;
                  CTRL_PAUSE_POS    :  integer;
                  CTRL_STOP_POS     :  integer;
                  CTRL_START_POS    :  integer;
                  CTRL_EBLK_POS     :  integer;
                  CTRL_DONE_POS     :  integer;
                  CTRL_FIRST_POS    :  integer;
                  CTRL_LAST_POS     :  integer;
    end record;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function  New_Regs_Field_Type return Regs_Field_Type;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    constant  Default_Regs_Param : Regs_Field_Type := New_Regs_Field_Type;
    
end Interface;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
package body Interface is
    -------------------------------------------------------------------------------
    --           31            24              16               8               0
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x00 |                       Address[31:00]                          |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x04 |                       Address[63:31]                          |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x08 |                          Size[31:00]                          |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x0C | Control[7:0]  |  Status[7:0]  |          Mode[15:00]          |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -------------------------------------------------------------------------------

    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function  New_Regs_Field_Type return Regs_Field_Type is
        variable  regs_field  :  Regs_Field_Type;
    begin
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        regs_field.BASE_ADDR      := 16#00#;
        regs_field.REGS_LO        := 0;
        regs_field.REGS_HI        := 127;
        regs_field.BITS           := 128;
        ---------------------------------------------------------------------------
        -- Address Register
        ---------------------------------------------------------------------------
        -- Address     = 転送開始アドレス.
        ---------------------------------------------------------------------------
        regs_field.ADDR_BASE_ADDR := regs_field.BASE_ADDR + 16#00#;
        regs_field.ADDR_BITS      := 64;
        regs_field.ADDR_LO        := 8*regs_field.ADDR_BASE_ADDR;
        regs_field.ADDR_HI        := 8*regs_field.ADDR_BASE_ADDR + regs_field.ADDR_BITS - 1;
        ---------------------------------------------------------------------------
        -- Size Register
        ---------------------------------------------------------------------------
        -- Size[31:00] = 転送サイズ.
        ---------------------------------------------------------------------------
        regs_field.SIZE_BASE_ADDR := regs_field.BASE_ADDR + 16#08#;
        regs_field.SIZE_BITS      := 32;
        regs_field.SIZE_LO        := 8*regs_field.SIZE_BASE_ADDR;
        regs_field.SIZE_HI        := 8*regs_field.SIZE_BASE_ADDR + regs_field.SIZE_BITS - 1;
        ---------------------------------------------------------------------------
        -- Mode Register
        ---------------------------------------------------------------------------
        -- Mode[15]    = 1:AXI4 Master I/F をセイフティモードで動かす.
        -- Mode[14]    = 1:AXI4 Master I/F を投機モードで動かす.
        -- Mode[13]    = AXI4 Master I/F の AXID[0] の値を指定する.
        -- Mode[11]    = AXI4 Master I/F の ARUSER[0] の値を指定する.
        -- Mode[10:08] = AXI4 Master I/F の APORT[2:0] の値を指定する.
        -- Mode[07:04] = AXI4 Master I/F の ACHACHE[3:0]を指定する.
        -- Mode[03]    = 予約.
        -- Mode[02]    = 1:クローズ時(Status[2]='1')に割り込みを発生する.
        -- Mode[01]    = 1:エラー発生時(Status[1]='1')に割り込みを発生する.
        -- Mode[00]    = 1:転送終了時(Status[0]='1')に割り込みを発生する.
        -------------------------------------------------------------------------------
        regs_field.MODE_BASE_ADDR := regs_field.BASE_ADDR + 16#0C#;
        regs_field.MODE_BITS      := 16;
        regs_field.MODE_HI        := 8*regs_field.MODE_BASE_ADDR + 15;
        regs_field.MODE_LO        := 8*regs_field.MODE_BASE_ADDR +  0;
        regs_field.MODE_SAFETY_POS:= 8*regs_field.MODE_BASE_ADDR + 15;
        regs_field.MODE_SPECUL_POS:= 8*regs_field.MODE_BASE_ADDR + 14;
        regs_field.MODE_AID_HI    := 8*regs_field.MODE_BASE_ADDR + 13;
        regs_field.MODE_AID_LO    := 8*regs_field.MODE_BASE_ADDR + 13;
        regs_field.MODE_AUSER_HI  := 8*regs_field.MODE_BASE_ADDR + 11;
        regs_field.MODE_AUSER_LO  := 8*regs_field.MODE_BASE_ADDR + 11;
        regs_field.MODE_APROT_HI  := 8*regs_field.MODE_BASE_ADDR + 10;
        regs_field.MODE_APROT_LO  := 8*regs_field.MODE_BASE_ADDR +  8;
        regs_field.MODE_CACHE_HI  := 8*regs_field.MODE_BASE_ADDR +  7;
        regs_field.MODE_CACHE_LO  := 8*regs_field.MODE_BASE_ADDR +  4;
        regs_field.MODE_CLOSE_POS := 8*regs_field.MODE_BASE_ADDR +  2;
        regs_field.MODE_ERROR_POS := 8*regs_field.MODE_BASE_ADDR +  1;
        regs_field.MODE_DONE_POS  := 8*regs_field.MODE_BASE_ADDR +  0;
        ---------------------------------------------------------------------------
        -- Status Register
        ---------------------------------------------------------------------------
        -- Status[7:3] = 予約.
        -- Status[2]   = クローズ時にセットされる
        -- Status[1]   = エラー発生時にセットされる.
        -- Status[0]   = 転送終了時かつ Control[2]='1' にセットされる.
        ---------------------------------------------------------------------------
        regs_field.STAT_BASE_ADDR := regs_field.BASE_ADDR + 16#0E#;
        regs_field.STAT_BITS      := 8;
        regs_field.STAT_HI        := 8*regs_field.STAT_BASE_ADDR +  7;
        regs_field.STAT_LO        := 8*regs_field.STAT_BASE_ADDR +  0;
        regs_field.STAT_RESV_HI   := 8*regs_field.STAT_BASE_ADDR +  7;
        regs_field.STAT_RESV_LO   := 8*regs_field.STAT_BASE_ADDR +  3;
        regs_field.STAT_CLOSE_POS := 8*regs_field.STAT_BASE_ADDR +  2;
        regs_field.STAT_ERROR_POS := 8*regs_field.STAT_BASE_ADDR +  1;
        regs_field.STAT_DONE_POS  := 8*regs_field.STAT_BASE_ADDR +  0;
        regs_field.STAT_RESV_BITS := regs_field.STAT_RESV_HI - regs_field.STAT_RESV_LO + 1;
        ---------------------------------------------------------------------------
        -- Control Register
        ---------------------------------------------------------------------------
        -- Control[7]  = 1:モジュールをリセットする. 0:リセットを解除する.
        -- Control[6]  = 1:転送を一時中断する.       0:転送を再開する.
        -- Control[5]  = 1:転送を中止する.           0:意味無し.
        -- Control[4]  = 1:転送を開始する.           0:意味無し.
        -- Control[3]  = 1:最後のブロックであることを指定する.
        -- Control[2]  = 1:転送終了時にStatus[0]がセットされる.
        -- Control[1]  = 1:連続したトランザクションの開始を指定する.
        -- Control[0]  = 1:連続したトランザクションの終了を指定する.
        ---------------------------------------------------------------------------
        regs_field.CTRL_BASE_ADDR  := regs_field.BASE_ADDR + 16#0F#;
        regs_field.CTRL_BITS       := 8;
        regs_field.CTRL_HI         := 8*regs_field.CTRL_BASE_ADDR +  7;
        regs_field.CTRL_LO         := 8*regs_field.CTRL_BASE_ADDR +  0;
        regs_field.CTRL_RESET_POS  := 8*regs_field.CTRL_BASE_ADDR +  7;
        regs_field.CTRL_PAUSE_POS  := 8*regs_field.CTRL_BASE_ADDR +  6;
        regs_field.CTRL_STOP_POS   := 8*regs_field.CTRL_BASE_ADDR +  5;
        regs_field.CTRL_START_POS  := 8*regs_field.CTRL_BASE_ADDR +  4;
        regs_field.CTRL_EBLK_POS   := 8*regs_field.CTRL_BASE_ADDR +  3;
        regs_field.CTRL_DONE_POS   := 8*regs_field.CTRL_BASE_ADDR +  2;
        regs_field.CTRL_FIRST_POS  := 8*regs_field.CTRL_BASE_ADDR +  1;
        regs_field.CTRL_LAST_POS   := 8*regs_field.CTRL_BASE_ADDR +  0;

        return regs_field;
    end New_Regs_Field_Type;

end Interface;
