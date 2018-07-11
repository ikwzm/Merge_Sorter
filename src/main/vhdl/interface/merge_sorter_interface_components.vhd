-----------------------------------------------------------------------------------
--!     @file    merge_sorter_interface_components.vhd                           --
--!     @brief   Merge Sorter Interface Component Library Description Package    --
--!     @version 0.1.0                                                           --
--!     @date    2018/07/11                                                      --
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
use     Merge_Sorter.Merge_Sorter_Interface;
-----------------------------------------------------------------------------------
--! @brief Merge Sorter Interface Component Library Description Package          --
-----------------------------------------------------------------------------------
package Merge_Sorter_Interface_Components is
-----------------------------------------------------------------------------------
--! @brief Merge_Sorter_Merge_Reader                                             --
-----------------------------------------------------------------------------------
component Merge_Sorter_Merge_Reader
    generic (
        IN_NUM          :  integer :=  8;
        REG_PARAM       :  Merge_Sorter_Interface.Regs_Field_Type := Merge_Sorter_Interface.Default_Regs_Param;
        REQ_ADDR_BITS   :  integer := 32;
        REQ_SIZE_BITS   :  integer := 32;
        MRG_DATA_BITS   :  integer := 64;
        BUF_DATA_BITS   :  integer := 64;
        BUF_DEPTH       :  integer := 13;
        MAX_XFER_SIZE   :  integer := 12
    );
    port (
    -------------------------------------------------------------------------------
    -- Clock/Reset Signals.
    -------------------------------------------------------------------------------
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Register Interface
    -------------------------------------------------------------------------------
        REG_L           :  in  std_logic_vector(IN_NUM*REG_PARAM.BITS-1 downto 0);
        REG_D           :  in  std_logic_vector(IN_NUM*REG_PARAM.BITS-1 downto 0);
        REG_Q           :  out std_logic_vector(IN_NUM*REG_PARAM.BITS-1 downto 0);
    -------------------------------------------------------------------------------
    -- Transaction Command Request Signals.
    -------------------------------------------------------------------------------
        REQ_VALID       :  out std_logic_vector(IN_NUM               -1 downto 0);
        REQ_ADDR        :  out std_logic_vector(REQ_ADDR_BITS        -1 downto 0);
        REQ_SIZE        :  out std_logic_vector(REQ_SIZE_BITS        -1 downto 0);
        REQ_BUF_PTR     :  out std_logic_vector(BUF_DEPTH            -1 downto 0);
        REQ_MODE        :  out std_logic_vector(REG_PARAM.MODE_BITS  -1 downto 0);
        REQ_FIRST       :  out std_logic;
        REQ_LAST        :  out std_logic;
        REQ_READY       :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transaction Command Acknowledge Signals.
    -------------------------------------------------------------------------------
        ACK_VALID       :  in  std_logic_vector(IN_NUM               -1 downto 0);
        ACK_SIZE        :  in  std_logic_vector(BUF_DEPTH               downto 0);
        ACK_ERROR       :  in  std_logic := '0';
        ACK_NEXT        :  in  std_logic;
        ACK_LAST        :  in  std_logic;
        ACK_STOP        :  in  std_logic;
        ACK_NONE        :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transfer Status Signals.
    -------------------------------------------------------------------------------
        XFER_BUSY       :  in  std_logic_vector(IN_NUM               -1 downto 0);
        XFER_DONE       :  in  std_logic_vector(IN_NUM               -1 downto 0);
        XFER_ERROR      :  in  std_logic_vector(IN_NUM               -1 downto 0) := (others => '0');
    -------------------------------------------------------------------------------
    -- Intake Flow Control Signals.
    -------------------------------------------------------------------------------
        FLOW_READY      :  out std_logic;
        FLOW_PAUSE      :  out std_logic;
        FLOW_STOP       :  out std_logic;
        FLOW_LAST       :  out std_logic;
        FLOW_SIZE       :  out std_logic_vector(BUF_DEPTH               downto 0);
        PUSH_FIN_VALID  :  in  std_logic_vector(IN_NUM               -1 downto 0);
        PUSH_FIN_LAST   :  in  std_logic;
        PUSH_FIN_ERROR  :  in  std_logic := '0';
        PUSH_FIN_SIZE   :  in  std_logic_vector(BUF_DEPTH               downto 0);
        PUSH_BUF_RESET  :  in  std_logic_vector(IN_NUM               -1 downto 0) := (others => '0');
        PUSH_BUF_VALID  :  in  std_logic_vector(IN_NUM               -1 downto 0) := (others => '0');
        PUSH_BUF_LAST   :  in  std_logic;
        PUSH_BUF_ERROR  :  in  std_logic := '0';
        PUSH_BUF_SIZE   :  in  std_logic_vector(BUF_DEPTH               downto 0);
        PUSH_BUF_READY  :  out std_logic_vector(IN_NUM               -1 downto 0);
    -------------------------------------------------------------------------------
    -- Buffer Interface Signals.
    -------------------------------------------------------------------------------
        BUF_WEN         :  in  std_logic_vector(IN_NUM               -1 downto 0);
        BUF_BEN         :  in  std_logic_vector(BUF_DATA_BITS/8      -1 downto 0);
        BUF_DATA        :  in  std_logic_vector(BUF_DATA_BITS        -1 downto 0);
        BUF_PTR         :  in  std_logic_vector(BUF_DEPTH               downto 0);
    -------------------------------------------------------------------------------
    -- Merge Outlet Signals.
    -------------------------------------------------------------------------------
        MRG_DATA        :  out std_logic_vector(IN_NUM*MRG_DATA_BITS -1 downto 0);
        MRG_NONE        :  out std_logic_vector(IN_NUM               -1 downto 0);
        MRG_EBLK        :  out std_logic_vector(IN_NUM               -1 downto 0);
        MRG_LAST        :  out std_logic_vector(IN_NUM               -1 downto 0);
        MRG_VALID       :  out std_logic_vector(IN_NUM               -1 downto 0);
        MRG_READY       :  in  std_logic_vector(IN_NUM               -1 downto 0);
        MRG_LEVEL       :  in  std_logic_vector(IN_NUM               -1 downto 0);
    -------------------------------------------------------------------------------
    -- Intake Status Output.
    -------------------------------------------------------------------------------
        I_OPEN          :  out std_logic_vector(IN_NUM               -1 downto 0);
        I_RUNNING       :  out std_logic_vector(IN_NUM               -1 downto 0);
        I_DONE          :  out std_logic_vector(IN_NUM               -1 downto 0);
        I_ERROR         :  out std_logic_vector(IN_NUM               -1 downto 0);
    -------------------------------------------------------------------------------
    -- Outlet Status Output.
    -------------------------------------------------------------------------------
        O_OPEN          :  out std_logic_vector(IN_NUM               -1 downto 0);
        O_RUNNING       :  out std_logic_vector(IN_NUM               -1 downto 0);
        O_DONE          :  out std_logic_vector(IN_NUM               -1 downto 0);
        O_ERROR         :  out std_logic_vector(IN_NUM               -1 downto 0)
    );
end component;
-----------------------------------------------------------------------------------
--! @brief Merge_Sorter_Merge_Writer                                             --
-----------------------------------------------------------------------------------
component Merge_Sorter_Merge_Writer
    generic (
        REG_PARAM       :  Merge_Sorter_Interface.Regs_Field_Type := Merge_Sorter_Interface.Default_Regs_Param;
        REQ_ADDR_BITS   :  integer := 32;
        REQ_SIZE_BITS   :  integer := 32;
        BUF_DATA_BITS   :  integer := 64;
        BUF_DEPTH       :  integer := 13;
        MAX_XFER_SIZE   :  integer := 12;
        MRG_NUM         :  integer :=  1;
        MRG_DATA_BITS   :  integer := 64
    );
    port (
    -------------------------------------------------------------------------------
    -- Clock/Reset Signals.
    -------------------------------------------------------------------------------
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Register Interface
    -------------------------------------------------------------------------------
        REG_L           :  in  std_logic_vector(REG_PARAM.BITS     -1 downto 0);
        REG_D           :  in  std_logic_vector(REG_PARAM.BITS     -1 downto 0);
        REG_Q           :  out std_logic_vector(REG_PARAM.BITS     -1 downto 0);
    -------------------------------------------------------------------------------
    -- Transaction Command Request Signals.
    -------------------------------------------------------------------------------
        REQ_VALID       :  out std_logic;
        REQ_ADDR        :  out std_logic_vector(REQ_ADDR_BITS      -1 downto 0);
        REQ_SIZE        :  out std_logic_vector(REQ_SIZE_BITS      -1 downto 0);
        REQ_BUF_PTR     :  out std_logic_vector(BUF_DEPTH          -1 downto 0);
        REQ_MODE        :  out std_logic_vector(REG_PARAM.MODE_BITS-1 downto 0);
        REQ_FIRST       :  out std_logic;
        REQ_LAST        :  out std_logic;
        REQ_READY       :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transaction Command Acknowledge Signals.
    -------------------------------------------------------------------------------
        ACK_VALID       :  in  std_logic;
        ACK_SIZE        :  in  std_logic_vector(BUF_DEPTH             downto 0);
        ACK_ERROR       :  in  std_logic := '0';
        ACK_NEXT        :  in  std_logic;
        ACK_LAST        :  in  std_logic;
        ACK_STOP        :  in  std_logic;
        ACK_NONE        :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transfer Status Signals.
    -------------------------------------------------------------------------------
        XFER_BUSY       :  in  std_logic;
        XFER_DONE       :  in  std_logic;
        XFER_ERROR      :  in  std_logic := '0';
    -------------------------------------------------------------------------------
    -- Intake Flow Control Signals.
    -------------------------------------------------------------------------------
        FLOW_READY      :  out std_logic;
        FLOW_PAUSE      :  out std_logic;
        FLOW_STOP       :  out std_logic;
        FLOW_LAST       :  out std_logic;
        FLOW_SIZE       :  out std_logic_vector(BUF_DEPTH             downto 0);
        PULL_FIN_VALID  :  in  std_logic;
        PULL_FIN_LAST   :  in  std_logic;
        PULL_FIN_ERROR  :  in  std_logic := '0';
        PULL_FIN_SIZE   :  in  std_logic_vector(BUF_DEPTH             downto 0);
        PULL_BUF_RESET  :  in  std_logic;
        PULL_BUF_VALID  :  in  std_logic;
        PULL_BUF_LAST   :  in  std_logic;
        PULL_BUF_ERROR  :  in  std_logic := '0';
        PULL_BUF_SIZE   :  in  std_logic_vector(BUF_DEPTH             downto 0);
        PULL_BUF_READY  :  out std_logic;
    -------------------------------------------------------------------------------
    -- Buffer Interface Signals.
    -------------------------------------------------------------------------------
        BUF_REN         :  in  std_logic_vector;
        BUF_DATA        :  out std_logic_vector(BUF_DATA_BITS      -1 downto 0);
        BUF_PTR         :  in  std_logic_vector(BUF_DEPTH          -1 downto 0);
    -------------------------------------------------------------------------------
    -- Merge Intake Signals.
    -------------------------------------------------------------------------------
        MRG_DATA        :  in  std_logic_vector(MRG_NUM*MRG_DATA_BITS  -1 downto 0);
        MRG_STRB        :  in  std_logic_vector(MRG_NUM*MRG_DATA_BITS/8-1 downto 0);
        MRG_LAST        :  in  std_logic;
        MRG_VALID       :  in  std_logic;
        MRG_READY       :  out std_logic;
    -------------------------------------------------------------------------------
    -- Outlet Status Output.
    -------------------------------------------------------------------------------
        O_OPEN          :  out std_logic;
        O_RUNNING       :  out std_logic;
        O_DONE          :  out std_logic;
        O_ERROR         :  out std_logic;
    -------------------------------------------------------------------------------
    -- Intake Status Output.
    -------------------------------------------------------------------------------
        I_OPEN          :  out std_logic;
        I_RUNNING       :  out std_logic;
        I_DONE          :  out std_logic;
        I_ERROR         :  out std_logic
    );
end component;
-----------------------------------------------------------------------------------
--! @brief Merge_Sorter_ArgSort_Reader                                           --
-----------------------------------------------------------------------------------
component Merge_Sorter_ArgSort_Reader
    generic (
        REG_PARAM       :  Merge_Sorter_Interface.Regs_Field_Type := Merge_Sorter_Interface.Default_Regs_Param;
        REQ_ADDR_BITS   :  integer := 32;
        REQ_SIZE_BITS   :  integer := 32;
        BUF_DATA_BITS   :  integer := 64;
        BUF_DEPTH       :  integer := 13;
        MAX_XFER_SIZE   :  integer := 12;
        STM_NUM         :  integer :=  1;
        STM_DATA_BITS   :  integer := 64;
        STM_INDEX_LO    :  integer :=  0;
        STM_INDEX_HI    :  integer := 31;
        STM_COMP_LO     :  integer := 32;
        STM_COMP_HI     :  integer := 63
    );
    port (
    -------------------------------------------------------------------------------
    -- Clock/Reset Signals.
    -------------------------------------------------------------------------------
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Register Interface
    -------------------------------------------------------------------------------
        REG_L           :  in  std_logic_vector(REG_PARAM.BITS     -1 downto 0);
        REG_D           :  in  std_logic_vector(REG_PARAM.BITS     -1 downto 0);
        REG_Q           :  out std_logic_vector(REG_PARAM.BITS     -1 downto 0);
    -------------------------------------------------------------------------------
    -- Transaction Command Request Signals.
    -------------------------------------------------------------------------------
        REQ_VALID       :  out std_logic;
        REQ_ADDR        :  out std_logic_vector(REQ_ADDR_BITS      -1 downto 0);
        REQ_SIZE        :  out std_logic_vector(REQ_SIZE_BITS      -1 downto 0);
        REQ_BUF_PTR     :  out std_logic_vector(BUF_DEPTH          -1 downto 0);
        REQ_MODE        :  out std_logic_vector(REG_PARAM.MODE_BITS-1 downto 0);
        REQ_FIRST       :  out std_logic;
        REQ_LAST        :  out std_logic;
        REQ_READY       :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transaction Command Acknowledge Signals.
    -------------------------------------------------------------------------------
        ACK_VALID       :  in  std_logic;
        ACK_SIZE        :  in  std_logic_vector(BUF_DEPTH             downto 0);
        ACK_ERROR       :  in  std_logic := '0';
        ACK_NEXT        :  in  std_logic;
        ACK_LAST        :  in  std_logic;
        ACK_STOP        :  in  std_logic;
        ACK_NONE        :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transfer Status Signals.
    -------------------------------------------------------------------------------
        XFER_BUSY       :  in  std_logic;
        XFER_DONE       :  in  std_logic;
        XFER_ERROR      :  in  std_logic := '0';
    -------------------------------------------------------------------------------
    -- Intake Flow Control Signals.
    -------------------------------------------------------------------------------
        FLOW_READY      :  out std_logic;
        FLOW_PAUSE      :  out std_logic;
        FLOW_STOP       :  out std_logic;
        FLOW_LAST       :  out std_logic;
        FLOW_SIZE       :  out std_logic_vector(BUF_DEPTH             downto 0);
        PUSH_FIN_VALID  :  in  std_logic;
        PUSH_FIN_LAST   :  in  std_logic;
        PUSH_FIN_ERROR  :  in  std_logic := '0';
        PUSH_FIN_SIZE   :  in  std_logic_vector(BUF_DEPTH             downto 0);
        PUSH_BUF_RESET  :  in  std_logic;
        PUSH_BUF_VALID  :  in  std_logic;
        PUSH_BUF_LAST   :  in  std_logic;
        PUSH_BUF_ERROR  :  in  std_logic := '0';
        PUSH_BUF_SIZE   :  in  std_logic_vector(BUF_DEPTH             downto 0);
        PUSH_BUF_READY  :  out std_logic;
    -------------------------------------------------------------------------------
    -- Buffer Interface Signals.
    -------------------------------------------------------------------------------
        BUF_WEN         :  in  std_logic;
        BUF_BEN         :  in  std_logic_vector(BUF_DATA_BITS/8    -1 downto 0);
        BUF_DATA        :  in  std_logic_vector(BUF_DATA_BITS      -1 downto 0);
        BUF_PTR         :  in  std_logic_vector(BUF_DEPTH             downto 0);
    -------------------------------------------------------------------------------
    -- Stream Outlet Signals.
    -------------------------------------------------------------------------------
        STM_DATA        :  out std_logic_vector(STM_NUM*STM_DATA_BITS  -1 downto 0);
        STM_STRB        :  out std_logic_vector(STM_NUM*STM_DATA_BITS/8-1 downto 0);
        STM_LAST        :  out std_logic;
        STM_VALID       :  out std_logic;
        STM_READY       :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Intake Status Output.
    -------------------------------------------------------------------------------
        I_OPEN          :  out std_logic;
        I_RUNNING       :  out std_logic;
        I_DONE          :  out std_logic;
        I_ERROR         :  out std_logic;
    -------------------------------------------------------------------------------
    -- Outlet Status Output.
    -------------------------------------------------------------------------------
        O_OPEN          :  out std_logic;
        O_RUNNING       :  out std_logic;
        O_DONE          :  out std_logic;
        O_ERROR         :  out std_logic
    );
end component;
-----------------------------------------------------------------------------------
--! @brief Merge_Sorter_ArgSort_Writer                                           --
-----------------------------------------------------------------------------------
component Merge_Sorter_ArgSort_Writer
    generic (
        REG_PARAM       :  Merge_Sorter_Interface.Regs_Field_Type := Merge_Sorter_Interface.Default_Regs_Param;
        REQ_ADDR_BITS   :  integer := 32;
        REQ_SIZE_BITS   :  integer := 32;
        BUF_DATA_BITS   :  integer := 64;
        BUF_DEPTH       :  integer := 13;
        MAX_XFER_SIZE   :  integer := 12;
        STM_NUM         :  integer :=  1;
        STM_DATA_BITS   :  integer := 64;
        STM_INDEX_LO    :  integer :=  0;
        STM_INDEX_HI    :  integer := 31;
        STM_COMP_LO     :  integer := 32;
        STM_COMP_HI     :  integer := 63
    );
    port (
    -------------------------------------------------------------------------------
    -- Clock/Reset Signals.
    -------------------------------------------------------------------------------
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Register Interface
    -------------------------------------------------------------------------------
        REG_L           :  in  std_logic_vector(REG_PARAM.BITS     -1 downto 0);
        REG_D           :  in  std_logic_vector(REG_PARAM.BITS     -1 downto 0);
        REG_Q           :  out std_logic_vector(REG_PARAM.BITS     -1 downto 0);
    -------------------------------------------------------------------------------
    -- Transaction Command Request Signals.
    -------------------------------------------------------------------------------
        REQ_VALID       :  out std_logic;
        REQ_ADDR        :  out std_logic_vector(REQ_ADDR_BITS      -1 downto 0);
        REQ_SIZE        :  out std_logic_vector(REQ_SIZE_BITS      -1 downto 0);
        REQ_BUF_PTR     :  out std_logic_vector(BUF_DEPTH          -1 downto 0);
        REQ_MODE        :  out std_logic_vector(REG_PARAM.MODE_BITS-1 downto 0);
        REQ_FIRST       :  out std_logic;
        REQ_LAST        :  out std_logic;
        REQ_READY       :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transaction Command Acknowledge Signals.
    -------------------------------------------------------------------------------
        ACK_VALID       :  in  std_logic;
        ACK_SIZE        :  in  std_logic_vector(BUF_DEPTH             downto 0);
        ACK_ERROR       :  in  std_logic := '0';
        ACK_NEXT        :  in  std_logic;
        ACK_LAST        :  in  std_logic;
        ACK_STOP        :  in  std_logic;
        ACK_NONE        :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Transfer Status Signals.
    -------------------------------------------------------------------------------
        XFER_BUSY       :  in  std_logic;
        XFER_DONE       :  in  std_logic;
        XFER_ERROR      :  in  std_logic := '0';
    -------------------------------------------------------------------------------
    -- Intake Flow Control Signals.
    -------------------------------------------------------------------------------
        FLOW_READY      :  out std_logic;
        FLOW_PAUSE      :  out std_logic;
        FLOW_STOP       :  out std_logic;
        FLOW_LAST       :  out std_logic;
        FLOW_SIZE       :  out std_logic_vector(BUF_DEPTH             downto 0);
        PULL_FIN_VALID  :  in  std_logic;
        PULL_FIN_LAST   :  in  std_logic;
        PULL_FIN_ERROR  :  in  std_logic := '0';
        PULL_FIN_SIZE   :  in  std_logic_vector(BUF_DEPTH             downto 0);
        PULL_BUF_RESET  :  in  std_logic;
        PULL_BUF_VALID  :  in  std_logic;
        PULL_BUF_LAST   :  in  std_logic;
        PULL_BUF_ERROR  :  in  std_logic := '0';
        PULL_BUF_SIZE   :  in  std_logic_vector(BUF_DEPTH             downto 0);
        PULL_BUF_READY  :  out std_logic;
    -------------------------------------------------------------------------------
    -- Buffer Interface Signals.
    -------------------------------------------------------------------------------
        BUF_REN         :  in  std_logic_vector;
        BUF_DATA        :  out std_logic_vector(BUF_DATA_BITS      -1 downto 0);
        BUF_PTR         :  in  std_logic_vector(BUF_DEPTH          -1 downto 0);
    -------------------------------------------------------------------------------
    -- Merge Outlet Signals.
    -------------------------------------------------------------------------------
        STM_DATA        :  in  std_logic_vector(STM_NUM*STM_DATA_BITS  -1 downto 0);
        STM_STRB        :  in  std_logic_vector(STM_NUM*STM_DATA_BITS/8-1 downto 0);
        STM_LAST        :  in  std_logic;
        STM_VALID       :  in  std_logic;
        STM_READY       :  out std_logic;
    -------------------------------------------------------------------------------
    -- Outlet Status Output.
    -------------------------------------------------------------------------------
        O_OPEN          :  out std_logic;
        O_RUNNING       :  out std_logic;
        O_DONE          :  out std_logic;
        O_ERROR         :  out std_logic;
    -------------------------------------------------------------------------------
    -- Intake Status Output.
    -------------------------------------------------------------------------------
        I_OPEN          :  out std_logic;
        I_RUNNING       :  out std_logic;
        I_DONE          :  out std_logic;
        I_ERROR         :  out std_logic
    );
end component;
-----------------------------------------------------------------------------------
--! @brief Merge_Sorter_Interface_Controller                                     --
-----------------------------------------------------------------------------------
component Merge_Sorter_Interface_Controller
    generic (
        MRG_RD_NUM          :  integer :=    8;
        STM_FEEDBACK        :  integer :=    1;
        STM_RD_DATA_BITS    :  integer :=   32;
        STM_WR_DATA_BITS    :  integer :=   32;
        MRG_RW_DATA_BITS    :  integer :=   64;
        REG_ADDR_BITS       :  integer :=   64;
        REG_SIZE_BITS       :  integer :=   32;
        REG_MODE_BITS       :  integer :=   32;
        MRG_RD_REG_PARAM    :  Merge_Sorter_Interface.Regs_Field_Type := Merge_Sorter_Interface.Default_Regs_Param;
        MRG_WR_REG_PARAM    :  Merge_Sorter_Interface.Regs_Field_Type := Merge_Sorter_Interface.Default_Regs_Param;
        STM_RD_REG_PARAM    :  Merge_Sorter_Interface.Regs_Field_Type := Merge_Sorter_Interface.Default_Regs_Param;
        STM_WR_REG_PARAM    :  Merge_Sorter_Interface.Regs_Field_Type := Merge_Sorter_Interface.Default_Regs_Param
    );
    port (
    -------------------------------------------------------------------------------
    -- Clock/Reset Signals.
    -------------------------------------------------------------------------------
        CLK                 :  in  std_logic;
        RST                 :  in  std_logic;
        CLR                 :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Register Interface
    -------------------------------------------------------------------------------
        REG_RD_ADDR_L       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_RD_ADDR_D       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_RD_ADDR_Q       :  out std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_WR_ADDR_L       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_WR_ADDR_D       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_WR_ADDR_Q       :  out std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_T0_ADDR_L       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_T0_ADDR_D       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_T0_ADDR_Q       :  out std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_T1_ADDR_L       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_T1_ADDR_D       :  in  std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_T1_ADDR_Q       :  out std_logic_vector(REG_ADDR_BITS-1 downto 0);
        REG_SIZE_L          :  in  std_logic_vector(REG_SIZE_BITS-1 downto 0);
        REG_SIZE_D          :  in  std_logic_vector(REG_SIZE_BITS-1 downto 0);
        REG_SIZE_Q          :  out std_logic_vector(REG_SIZE_BITS-1 downto 0);
        REG_RD_MODE_L       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_RD_MODE_D       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_RD_MODE_Q       :  out std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_WR_MODE_L       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_WR_MODE_D       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_WR_MODE_Q       :  out std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_T0_MODE_L       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_T0_MODE_D       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_T0_MODE_Q       :  out std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_T1_MODE_L       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_T1_MODE_D       :  in  std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_T1_MODE_Q       :  out std_logic_vector(REG_MODE_BITS-1 downto 0);
        REG_START_L         :  in  std_logic;
        REG_START_D         :  in  std_logic;
        REG_START_Q         :  out std_logic;
        REG_RESET_L         :  in  std_logic;
        REG_RESET_D         :  in  std_logic;
        REG_RESET_Q         :  out std_logic;
    -------------------------------------------------------------------------------
    -- Merge Sorter Core Control Interface
    -------------------------------------------------------------------------------
        STM_REQ_VALID       :  out std_logic;
        STM_REQ_READY       :  in  std_logic;
        STM_RES_VALID       :  in  std_logic;
        STM_RES_READY       :  out std_logic;
        MRG_REQ_VALID       :  out std_logic;
        MRG_REQ_READY       :  in  std_logic;
        MRG_RES_VALID       :  in  std_logic;
        MRG_RES_READY       :  out std_logic;
    -------------------------------------------------------------------------------
    -- Stream Reader Control Register Interface
    -------------------------------------------------------------------------------
        STM_RD_REG_L        :  out std_logic_vector(           STM_RD_REG_PARAM.BITS-1 downto 0);
        STM_RD_REG_D        :  out std_logic_vector(           STM_RD_REG_PARAM.BITS-1 downto 0);
        STM_RD_REG_Q        :  in  std_logic_vector(           STM_RD_REG_PARAM.BITS-1 downto 0);
        STM_RD_BUSY         :  in  std_logic;
        STM_RD_DONE         :  in  std_logic;
        STM_RD_ERROR        :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Stream Writer Control Register Interface
    -------------------------------------------------------------------------------
        STM_WR_REG_L        :  out std_logic_vector(           STM_WR_REG_PARAM.BITS-1 downto 0);
        STM_WR_REG_D        :  out std_logic_vector(           STM_WR_REG_PARAM.BITS-1 downto 0);
        STM_WR_REG_Q        :  in  std_logic_vector(           STM_WR_REG_PARAM.BITS-1 downto 0);
        STM_WR_BUSY         :  in  std_logic;
        STM_WR_DONE         :  in  std_logic;
        STM_WR_ERROR        :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Merge Reader Control Register Interface
    -------------------------------------------------------------------------------
        MRG_RD_REG_L        :  out std_logic_vector(MRG_RD_NUM*MRG_RD_REG_PARAM.BITS-1 downto 0);
        MRG_RD_REG_D        :  out std_logic_vector(MRG_RD_NUM*MRG_RD_REG_PARAM.BITS-1 downto 0);
        MRG_RD_REG_Q        :  in  std_logic_vector(MRG_RD_NUM*MRG_RD_REG_PARAM.BITS-1 downto 0);
        MRG_RD_BUSY         :  in  std_logic_vector(MRG_RD_NUM                      -1 downto 0);
        MRG_RD_DONE         :  in  std_logic_vector(MRG_RD_NUM                      -1 downto 0);
        MRG_RD_ERROR        :  in  std_logic_vector(MRG_RD_NUM                      -1 downto 0);
    -------------------------------------------------------------------------------
    -- Merge Writer Control Register Interface
    -------------------------------------------------------------------------------
        MRG_WR_REG_L        :  out std_logic_vector(           MRG_WR_REG_PARAM.BITS-1 downto 0);
        MRG_WR_REG_D        :  out std_logic_vector(           MRG_WR_REG_PARAM.BITS-1 downto 0);
        MRG_WR_REG_Q        :  in  std_logic_vector(           MRG_WR_REG_PARAM.BITS-1 downto 0);
        MRG_WR_BUSY         :  in  std_logic;
        MRG_WR_DONE         :  in  std_logic;
        MRG_WR_ERROR        :  in  std_logic
    );
end component;
end Merge_Sorter_Interface_Components;
