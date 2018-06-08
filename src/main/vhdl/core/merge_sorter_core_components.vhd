-----------------------------------------------------------------------------------
--!     @file    merge_sorter_core_components.vhd                                --
--!     @brief   Merge Sorter Core Component Library Description Package         --
--!     @version 0.0.5                                                           --
--!     @date    2018/06/08                                                      --
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
-----------------------------------------------------------------------------------
--! @brief Merge Sorter Core Component Library Description Package               --
-----------------------------------------------------------------------------------
package Merge_Sorter_Core_Components is
-----------------------------------------------------------------------------------
--! @brief Merge_Sorter_Compare                                                  --
-----------------------------------------------------------------------------------
component Merge_Sorter_Compare
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
        A_PRIORITY  :  in  std_logic;
        A_POSTPOND  :  in  std_logic;
        B_DATA      :  in  std_logic_vector(DATA_BITS-1 downto 0);
        B_PRIORITY  :  in  std_logic;
        B_POSTPOND  :  in  std_logic;
        VALID       :  in  std_logic;
        READY       :  out std_logic;
        SEL_A       :  out std_logic;
        SEL_B       :  out std_logic
    );
end component;
-----------------------------------------------------------------------------------
--! @brief Merge_Sorter_Core                                                     --
-----------------------------------------------------------------------------------
component Merge_Sorter_Core
    generic (
        IN_NUM          :  integer :=    8;
        STM_ENABLE      :  boolean := TRUE;
        STM_IN_NUM      :  integer :=    1;
        STM_FEEDBACK    :  integer :=    1;
        MRG_ENABLE      :  boolean := TRUE;
        MRG_FIFO_SIZE   :  integer :=  128;
        MRG_LEVEL_SIZE  :  integer :=   64;
        SORT_ORDER      :  integer :=    0;
        DATA_BITS       :  integer :=   64;
        COMP_HIGH       :  integer :=   63;
        COMP_LOW        :  integer :=   32;
        ATRB_BITS       :  integer :=    4;
        ATRB_NONE_POS   :  integer :=    0;
        ATRB_PRIO_POS   :  integer :=    1;
        ATRB_POST_POS   :  integer :=    2;
        ATRB_DONE_POS   :  integer :=    3
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
        MRG_IN_DATA     :  in  std_logic_vector(    IN_NUM*DATA_BITS-1 downto 0);
        MRG_IN_ATRB     :  in  std_logic_vector(    IN_NUM*ATRB_BITS-1 downto 0);
        MRG_IN_LAST     :  in  std_logic_vector(    IN_NUM          -1 downto 0);
        MRG_IN_VALID    :  in  std_logic_vector(    IN_NUM          -1 downto 0);
        MRG_IN_READY    :  out std_logic_vector(    IN_NUM          -1 downto 0);
        MRG_IN_LEVEL    :  out std_logic_vector(    IN_NUM          -1 downto 0);
        MRG_OUT_DATA    :  out std_logic_vector(           DATA_BITS-1 downto 0);
        MRG_OUT_LAST    :  out std_logic;
        MRG_OUT_VALID   :  out std_logic;
        MRG_OUT_READY   :  in  std_logic
    );
end component;
-----------------------------------------------------------------------------------
--! @brief Merge_Sorter_Core_Fifo                                                --
-----------------------------------------------------------------------------------
component Merge_Sorter_Core_Fifo
    generic (
        FBK_ENABLE      :  boolean := TRUE;
        MRG_ENABLE      :  boolean := TRUE;
        SIZE_BITS       :  integer :=    6;
        FIFO_SIZE       :  integer :=   64;
        LEVEL_SIZE      :  integer :=   32;
        DATA_BITS       :  integer :=   64;
        INFO_BITS       :  integer :=    8;
        INFO_NONE_POS   :  integer :=    0;
        INFO_DONE_POS   :  integer :=    1;
        INFO_PRIO_POS   :  integer :=    2;
        INFO_POST_POS   :  integer :=    3;
        INFO_FBK_POS    :  integer :=    4;
        INFO_FBK_NUM_LO :  integer :=    5;
        INFO_FBK_NUM_HI :  integer :=    9;
        ATRB_BITS       :  integer :=    4;
        ATRB_NONE_POS   :  integer :=    0;
        ATRB_PRIO_POS   :  integer :=    1;
        ATRB_POST_POS   :  integer :=    2;
        ATRB_DONE_POS   :  integer :=    3
    );
    port (
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
        FBK_REQ         :  in  std_logic := '0';
        FBK_ACK         :  out std_logic;
        FBK_DONE        :  out std_logic;
        FBK_OUT_START   :  in  std_logic := '0';
        FBK_OUT_SIZE    :  in  std_logic_vector(SIZE_BITS-1 downto 0);
        FBK_OUT_LAST    :  in  std_logic := '0';
        FBK_IN_DATA     :  in  std_logic_vector(DATA_BITS-1 downto 0);
        FBK_IN_ATRB     :  in  std_logic_vector(ATRB_BITS-1 downto 0) := (others => '0');
        FBK_IN_LAST     :  in  std_logic;
        FBK_IN_VALID    :  in  std_logic := '0';
        FBK_IN_READY    :  out std_logic;
        MRG_REQ         :  in  std_logic := '0';
        MRG_ACK         :  out std_logic;
        MRG_IN_DATA     :  in  std_logic_vector(DATA_BITS-1 downto 0);
        MRG_IN_ATRB     :  in  std_logic_vector(ATRB_BITS-1 downto 0) := (others => '0');
        MRG_IN_LAST     :  in  std_logic;
        MRG_IN_VALID    :  in  std_logic := '0';
        MRG_IN_READY    :  out std_logic;
        MRG_IN_LEVEL    :  out std_logic;
        OUTLET_DATA     :  out std_logic_vector(DATA_BITS-1 downto 0);
        OUTLET_INFO     :  out std_logic_vector(INFO_BITS-1 downto 0);
        OUTLET_LAST     :  out std_logic;
        OUTLET_VALID    :  out std_logic;
        OUTLET_READY    :  in  std_logic
    );
end component;
-----------------------------------------------------------------------------------
--! @brief Merge_Sorter_Core_Stream_Intake                                       --
-----------------------------------------------------------------------------------
component Merge_Sorter_Core_Stream_Intake
    generic (
        O_NUM           :  integer :=  8;
        I_NUM           :  integer :=  1;
        FEEDBACK        :  integer :=  1;
        O_NUM_BITS      :  integer :=  3;
        SIZE_BITS       :  integer :=  6;
        DATA_BITS       :  integer := 64;
        INFO_BITS       :  integer :=  8;
        INFO_NONE_POS   :  integer :=  0;
        INFO_PRIO_POS   :  integer :=  1;
        INFO_POST_POS   :  integer :=  2;
        INFO_DONE_POS   :  integer :=  3;
        INFO_FBK_POS    :  integer :=  4;
        INFO_FBK_NUM_LO :  integer :=  5;
        INFO_FBK_NUM_HI :  integer :=  9
    );
    port (
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
        START           :  in  std_logic;
        BUSY            :  out std_logic;
        DONE            :  out std_logic;
        FBK_OUT_START   :  out std_logic;
        FBK_OUT_SIZE    :  out std_logic_vector(      SIZE_BITS-1 downto 0);
        FBK_OUT_LAST    :  out std_logic;
        I_DATA          :  in  std_logic_vector(I_NUM*DATA_BITS-1 downto 0);
        I_STRB          :  in  std_logic_vector(I_NUM          -1 downto 0);
        I_LAST          :  in  std_logic;
        I_VALID         :  in  std_logic;
        I_READY         :  out std_logic;
        O_DATA          :  out std_logic_vector(O_NUM*DATA_BITS-1 downto 0);
        O_INFO          :  out std_logic_vector(O_NUM*INFO_BITS-1 downto 0);
        O_LAST          :  out std_logic_vector(O_NUM          -1 downto 0);
        O_VALID         :  out std_logic_vector(O_NUM          -1 downto 0);
        O_READY         :  in  std_logic_vector(O_NUM          -1 downto 0)
    );
end component;
-----------------------------------------------------------------------------------
--! @brief Merge_Sorter_Drop_None                                                --
-----------------------------------------------------------------------------------
component Merge_Sorter_Drop_None
    generic (
        DATA_BITS   :  integer := 64;
        INFO_BITS   :  integer :=  1
    );
    port (
        CLK         :  in  std_logic;
        RST         :  in  std_logic;
        CLR         :  in  std_logic;
        I_DATA      :  in  std_logic_vector(DATA_BITS-1 downto 0);
        I_INFO      :  in  std_logic_vector(INFO_BITS-1 downto 0);
        I_LAST      :  in  std_logic;
        I_VALID     :  in  std_logic;
        I_READY     :  out std_logic;
        O_DATA      :  out std_logic_vector(DATA_BITS-1 downto 0);
        O_INFO      :  out std_logic_vector(INFO_BITS-1 downto 0);
        O_LAST      :  out std_logic;
        O_VALID     :  out std_logic;
        O_READY     :  in  std_logic
    );
end component;
-----------------------------------------------------------------------------------
--! @brief Merge_Sorter_Queue                                                    --
-----------------------------------------------------------------------------------
component Merge_Sorter_Queue
    generic (
        QUEUE_SIZE  :  integer :=  2;
        DATA_BITS   :  integer := 64;
        INFO_BITS   :  integer :=  1
    );
    port (
        CLK         :  in  std_logic;
        RST         :  in  std_logic;
        CLR         :  in  std_logic;
        I_DATA      :  in  std_logic_vector(DATA_BITS-1 downto 0);
        I_INFO      :  in  std_logic_vector(INFO_BITS-1 downto 0);
        I_LAST      :  in  std_logic;
        I_VALID     :  in  std_logic;
        I_READY     :  out std_logic;
        O_DATA      :  out std_logic_vector(DATA_BITS-1 downto 0);
        O_INFO      :  out std_logic_vector(INFO_BITS-1 downto 0);
        O_LAST      :  out std_logic;
        O_VALID     :  out std_logic;
        O_READY     :  in  std_logic
    );
end component;
-----------------------------------------------------------------------------------
--! @brief Merge_Sorter_Simple_Cell                                              --
-----------------------------------------------------------------------------------
component Merge_Sorter_Simple_Cell
    generic (
        SORT_ORDER  :  integer :=  0;
        DATA_BITS   :  integer := 64;
        COMP_HIGH   :  integer := 63;
        COMP_LOW    :  integer := 32;
        INFO_BITS   :  integer :=  3
    );
    port (
        CLK         :  in  std_logic;
        RST         :  in  std_logic;
        CLR         :  in  std_logic;
        A_DATA      :  in  std_logic_vector(DATA_BITS-1 downto 0);
        A_INFO      :  in  std_logic_vector(INFO_BITS-1 downto 0);
        A_LAST      :  in  std_logic;
        A_VALID     :  in  std_logic;
        A_READY     :  out std_logic;
        B_DATA      :  in  std_logic_vector(DATA_BITS-1 downto 0);
        B_INFO      :  in  std_logic_vector(INFO_BITS-1 downto 0);
        B_LAST      :  in  std_logic;
        B_VALID     :  in  std_logic;
        B_READY     :  out std_logic;
        O_DATA      :  out std_logic_vector(DATA_BITS-1 downto 0);
        O_INFO      :  out std_logic_vector(INFO_BITS-1 downto 0);
        O_LAST      :  out std_logic;
        O_VALID     :  out std_logic;
        O_READY     :  in  std_logic
    );
end component;
-----------------------------------------------------------------------------------
--! @brief Merge_Sorter_Simple_Tree                                              --
-----------------------------------------------------------------------------------
component Merge_Sorter_Simple_Tree
    generic (
        I_NUM       :  integer :=  8;
        DATA_BITS   :  integer := 64;
        INFO_BITS   :  integer :=  3;
        SORT_ORDER  :  integer :=  0;
        COMP_HIGH   :  integer := 63;
        COMP_LOW    :  integer := 32;
        QUEUE_SIZE  :  integer :=  2
    );
    port (
        CLK         :  in  std_logic;
        RST         :  in  std_logic;
        CLR         :  in  std_logic;
        I_DATA      :  in  std_logic_vector(I_NUM*DATA_BITS-1 downto 0);
        I_INFO      :  in  std_logic_vector(I_NUM*INFO_BITS-1 downto 0);
        I_LAST      :  in  std_logic_vector(I_NUM          -1 downto 0);
        I_VALID     :  in  std_logic_vector(I_NUM          -1 downto 0);
        I_READY     :  out std_logic_vector(I_NUM          -1 downto 0);
        O_DATA      :  out std_logic_vector(      DATA_BITS-1 downto 0);
        O_INFO      :  out std_logic_vector(      INFO_BITS-1 downto 0);
        O_LAST      :  out std_logic;
        O_VALID     :  out std_logic;
        O_READY     :  in  std_logic
    );
end component;
end Merge_Sorter_Core_Components;