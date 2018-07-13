-----------------------------------------------------------------------------------
--!     @file    core_components.vhd                                             --
--!     @brief   Merge Sorter Core Component Library Description Package         --
--!     @version 0.1.0                                                           --
--!     @date    2018/07/14                                                      --
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>                     --
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--                                                                               --
--      Copyright (C) 2018 Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>           --
--      All rights reserved.                                                     --
--                                                                               --
--      Redistribution and use in source and binary forms, with or without       --
--      modification, are permitted provided that the following conditions       --
--      are met:                                                                 --
--                                                                               --
--        1. Redistributions of source code must retain the above copyright      --
--           notice, this list of conditions and the following disclaimer.       --
--                                                                               --
--        2. Redistributions in binary form must reproduce the above copyright   --
--           notice, this list of conditions and the following disclaimer in     --
--           the documentation and/or other materials provided with the          --
--           distribution.                                                       --
--                                                                               --
--      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS      --
--      "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT        --
--      LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR    --
--      A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT    --
--      OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,    --
--      SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT         --
--      LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,    --
--      DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY    --
--      THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT      --
--      (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE    --
--      OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.     --
--                                                                               --
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
library Merge_Sorter;
use     Merge_Sorter.Word;
-----------------------------------------------------------------------------------
--! @brief Merge Sorter Core Component Library Description Package               --
-----------------------------------------------------------------------------------
package Core_Components is
-----------------------------------------------------------------------------------
--! @brief Merge_Sorter_Core                                                     --
-----------------------------------------------------------------------------------
component Merge_Sorter_Core
    generic (
        MRG_IN_ENABLE   :  boolean := TRUE;
        MRG_IN_NUM      :  integer :=    8;
        MRG_FIFO_SIZE   :  integer :=  128;
        MRG_LEVEL_SIZE  :  integer :=   64;
        STM_IN_ENABLE   :  boolean := TRUE;
        STM_IN_NUM      :  integer :=    1;
        STM_FEEDBACK    :  integer :=    1;
        SORT_ORDER      :  integer :=    0;
        DATA_BITS       :  integer :=   64;
        COMP_HIGH       :  integer :=   63;
        COMP_LOW        :  integer :=    0;
        COMP_SIGN       :  boolean := FALSE
    );
    port (
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
        STM_REQ_VALID   :  in  std_logic;
        STM_REQ_READY   :  out std_logic;
        STM_RES_VALID   :  out std_logic;
        STM_RES_READY   :  in  std_logic;
        STM_IN_DATA     :  in  std_logic_vector(STM_IN_NUM*DATA_BITS-1 downto 0);
        STM_IN_STRB     :  in  std_logic_vector(STM_IN_NUM          -1 downto 0);
        STM_IN_LAST     :  in  std_logic;
        STM_IN_VALID    :  in  std_logic;
        STM_IN_READY    :  out std_logic;
        STM_OUT_DATA    :  out std_logic_vector(           DATA_BITS-1 downto 0);
        STM_OUT_LAST    :  out std_logic;
        STM_OUT_VALID   :  out std_logic;
        STM_OUT_READY   :  in  std_logic;
        MRG_REQ_VALID   :  in  std_logic;
        MRG_REQ_READY   :  out std_logic;
        MRG_RES_VALID   :  out std_logic;
        MRG_RES_READY   :  in  std_logic;
        MRG_IN_DATA     :  in  std_logic_vector(MRG_IN_NUM*DATA_BITS-1 downto 0);
        MRG_IN_NONE     :  in  std_logic_vector(MRG_IN_NUM          -1 downto 0);
        MRG_IN_EBLK     :  in  std_logic_vector(MRG_IN_NUM          -1 downto 0);
        MRG_IN_LAST     :  in  std_logic_vector(MRG_IN_NUM          -1 downto 0);
        MRG_IN_VALID    :  in  std_logic_vector(MRG_IN_NUM          -1 downto 0);
        MRG_IN_READY    :  out std_logic_vector(MRG_IN_NUM          -1 downto 0);
        MRG_IN_LEVEL    :  out std_logic_vector(MRG_IN_NUM          -1 downto 0);
        MRG_OUT_DATA    :  out std_logic_vector(           DATA_BITS-1 downto 0);
        MRG_OUT_LAST    :  out std_logic;
        MRG_OUT_VALID   :  out std_logic;
        MRG_OUT_READY   :  in  std_logic
    );
end component;
-----------------------------------------------------------------------------------
--! @brief Core_Intake_Fifo                                                      --
-----------------------------------------------------------------------------------
component Core_Intake_Fifo
    generic (
        WORD_PARAM      :  Word.Param_Type := Word.New_Param(DATA_BITS => 8);
        FBK_IN_ENABLE   :  boolean := TRUE;
        MRG_IN_ENABLE   :  boolean := TRUE;
        SIZE_BITS       :  integer :=    6;
        FIFO_SIZE       :  integer :=   64;
        LEVEL_SIZE      :  integer :=   32;
        INFO_BITS       :  integer :=    8;
        INFO_EBLK_POS   :  integer :=    0;
        INFO_FBK_POS    :  integer :=    1;
        INFO_FBK_NUM_LO :  integer :=    2;
        INFO_FBK_NUM_HI :  integer :=    7
    );
    port (
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
        FBK_REQ         :  in  std_logic := '0';
        FBK_ACK         :  out std_logic;
        FBK_DONE        :  out std_logic;
        FBK_OUT_START   :  in  std_logic := '0';
        FBK_OUT_SIZE    :  in  std_logic_vector(SIZE_BITS      -1 downto 0);
        FBK_OUT_LAST    :  in  std_logic := '0';
        FBK_IN_WORD     :  in  std_logic_vector(WORD_PARAM.BITS-1 downto 0);
        FBK_IN_LAST     :  in  std_logic;
        FBK_IN_VALID    :  in  std_logic := '0';
        FBK_IN_READY    :  out std_logic;
        MRG_REQ         :  in  std_logic := '0';
        MRG_ACK         :  out std_logic;
        MRG_IN_WORD     :  in  std_logic_vector(WORD_PARAM.BITS-1 downto 0);
        MRG_IN_EBLK     :  in  std_logic;
        MRG_IN_LAST     :  in  std_logic;
        MRG_IN_VALID    :  in  std_logic := '0';
        MRG_IN_READY    :  out std_logic;
        MRG_IN_LEVEL    :  out std_logic;
        OUTLET_WORD     :  out std_logic_vector(WORD_PARAM.BITS-1 downto 0);
        OUTLET_INFO     :  out std_logic_vector(INFO_BITS      -1 downto 0);
        OUTLET_LAST     :  out std_logic;
        OUTLET_VALID    :  out std_logic;
        OUTLET_READY    :  in  std_logic
    );
end component;
-----------------------------------------------------------------------------------
--! @brief Core_Stream_Intake                                                    --
-----------------------------------------------------------------------------------
component Core_Stream_Intake
    generic (
        WORD_PARAM      :  Word.Param_Type := Word.Default_Param;
        O_NUM           :  integer :=  8;
        I_NUM           :  integer :=  1;
        FEEDBACK        :  integer :=  1;
        O_NUM_BITS      :  integer :=  3;
        SIZE_BITS       :  integer :=  6;
        INFO_BITS       :  integer :=  8;
        INFO_EBLK_POS   :  integer :=  0;
        INFO_FBK_POS    :  integer :=  1;
        INFO_FBK_NUM_LO :  integer :=  2;
        INFO_FBK_NUM_HI :  integer :=  7
    );
    port (
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
        START           :  in  std_logic;
        BUSY            :  out std_logic;
        DONE            :  out std_logic;
        FBK_OUT_START   :  out std_logic;
        FBK_OUT_SIZE    :  out std_logic_vector(SIZE_BITS                 -1 downto 0);
        FBK_OUT_LAST    :  out std_logic;
        I_DATA          :  in  std_logic_vector(I_NUM*WORD_PARAM.DATA_BITS-1 downto 0);
        I_STRB          :  in  std_logic_vector(I_NUM                     -1 downto 0);
        I_LAST          :  in  std_logic;
        I_VALID         :  in  std_logic;
        I_READY         :  out std_logic;
        O_WORD          :  out std_logic_vector(O_NUM*WORD_PARAM.BITS     -1 downto 0);
        O_INFO          :  out std_logic_vector(O_NUM*INFO_BITS           -1 downto 0);
        O_LAST          :  out std_logic_vector(O_NUM                     -1 downto 0);
        O_VALID         :  out std_logic_vector(O_NUM                     -1 downto 0);
        O_READY         :  in  std_logic_vector(O_NUM                     -1 downto 0)
    );
end component;
-----------------------------------------------------------------------------------
--! @brief Word_Compare                                                          --
-----------------------------------------------------------------------------------
component Word_Compare
    generic (
        WORD_PARAM  :  Word.Param_Type := Word.Default_Param;
        SORT_ORDER  :  integer :=  0
    );
    port (
        CLK         :  in  std_logic;
        RST         :  in  std_logic;
        CLR         :  in  std_logic;
        A_WORD      :  in  std_logic_vector(WORD_PARAM.BITS-1 downto 0);
        B_WORD      :  in  std_logic_vector(WORD_PARAM.BITS-1 downto 0);
        VALID       :  in  std_logic;
        READY       :  out std_logic;
        SEL_A       :  out std_logic;
        SEL_B       :  out std_logic
    );
end component;
-----------------------------------------------------------------------------------
--! @brief Word_Queue                                                            --
-----------------------------------------------------------------------------------
component Word_Queue
    generic (
        WORD_PARAM  :  Word.Param_Type := Word.Default_Param;
        INFO_BITS   :  integer :=  1;
        QUEUE_SIZE  :  integer :=  2
    );
    port (
        CLK         :  in  std_logic;
        RST         :  in  std_logic;
        CLR         :  in  std_logic;
        I_WORD      :  in  std_logic_vector(WORD_PARAM.BITS-1 downto 0);
        I_INFO      :  in  std_logic_vector(INFO_BITS      -1 downto 0);
        I_LAST      :  in  std_logic;
        I_VALID     :  in  std_logic;
        I_READY     :  out std_logic;
        O_WORD      :  out std_logic_vector(WORD_PARAM.BITS-1 downto 0);
        O_INFO      :  out std_logic_vector(INFO_BITS      -1 downto 0);
        O_LAST      :  out std_logic;
        O_VALID     :  out std_logic;
        O_READY     :  in  std_logic
    );
end component;
-----------------------------------------------------------------------------------
--! @brief Drop_None                                                             --
-----------------------------------------------------------------------------------
component Drop_None
    generic (
        WORD_PARAM  :  Word.Param_Type := Word.Default_Param;
        INFO_BITS   :  integer :=  1
    );
    port (
        CLK         :  in  std_logic;
        RST         :  in  std_logic;
        CLR         :  in  std_logic;
        I_WORD      :  in  std_logic_vector(WORD_PARAM.BITS-1 downto 0);
        I_INFO      :  in  std_logic_vector(INFO_BITS      -1 downto 0) := (others => '0');
        I_LAST      :  in  std_logic;
        I_VALID     :  in  std_logic;
        I_READY     :  out std_logic;
        O_WORD      :  out std_logic_vector(WORD_PARAM.BITS-1 downto 0);
        O_INFO      :  out std_logic_vector(INFO_BITS      -1 downto 0);
        O_LAST      :  out std_logic;
        O_VALID     :  out std_logic;
        O_READY     :  in  std_logic
    );
end component;
end Core_Components;
