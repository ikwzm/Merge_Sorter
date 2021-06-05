-----------------------------------------------------------------------------------
--!     @file    argsort_vivado.vhd
--!     @brief   Merge Sorter ArgSort for Xilinx Vivado
--!     @version 1.0.0
--!     @date    2021/6/5
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
--
--      Copyright (C) 2021 Ichiro Kawazome
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
entity  ArgSort_Vivado is
    generic (
        MRG_WAYS            : --! @brief MERGE WAY SIZE :
                              integer :=  4;
        MRG_WORDS           : --! @brief MERGE WORD SIZE :
                              integer :=  1;
        WORD_BITS           : --! @brief SORT WORD BIT SIZE :
                              integer := 32;
        INDEX_BITS          : --! @brief INDEX BIT SIZE :
                              integer := 32;
        COMP_SIGN           : --! @brief COMPARE SIGN :
                              boolean := FALSE;
        SORT_ORDER          : --! @brief SORT ORDER :
                              integer :=  0;
        MRG_FIFO_SIZE       : --! @brief MERGE FIFO SIZE :
                              integer :=  16;
        STM_FEEDBACK        : --! @brief STREAM FEED BACK NUMBER :
                              integer :=  0;
        STM_IN_QUEUE_SIZE   : --! @brief STREAM IN QUEUE SIZE :
                              integer :=  0;
        CSR_AXI_ADDR_WIDTH  : --! @brief CSR I/F AXI ADDRRESS WIDTH :
                              integer := 12;
        CSR_AXI_DATA_WIDTH  : --! @brief CSR I/F AXI DATA WIDTH :
                              integer := 32;
        STM_AXI_ADDR_WIDTH  : --! @brief STREAM IN/OUT AXI ADDRESS WIDTH :
                              integer := 32;
        STM_AXI_DATA_WIDTH  : --! @brief STREAM IN/OUT AXI DATA WIDTH :
                              integer := 64;
        STM_AXI_ID_WIDTH    : --! @brief STREAM IN/OUT AXI ID WIDTH :
                              integer := 1;
        STM_AXI_USER_WIDTH  : --! @brief STREAM IN/OUT AXI ADDRESS USER WIDTH :
                              integer := 1;
        STM_AXI_ID_BASE     : --! @brief STREAM IN/OUT AXI ID BASE :
                              integer := 0;
        STM_RD_AXI_XFER_SIZE: --! @brief STREAM IN  AXI MAX XFER SIZE :
                              integer := 11;
        STM_RD_AXI_BUF_SIZE : --! @brief STREAM IN  AXI BUFFER SIZE :
                              integer := 0;
        STM_RD_AXI_QUEUE    : --! @brief STREAM IN  AXI QUEUE SIZE :
                              integer := 4;
        STM_RD_AXI_DATA_REGS: --! @brief STREAM IN  AXI DATA REGISTER :
                              integer := 2;
        STM_RD_AXI_ACK_REGS : --! @brief STREAM IN  AXI ACKNOWLEDGE REGISTER :
                              integer range 0 to 1 := 1;
        STM_WR_AXI_XFER_SIZE: --! @brief STREAM OUT AXI MAX XFER SIZE :
                              integer := 11;
        STM_WR_AXI_BUF_SIZE : --! @brief STREAM OUT AXI BUFFER SIZE :
                              integer := 0;
        STM_WR_AXI_QUEUE    : --! @brief STREAM OUT AXI QUEUE SIZE :
                              integer := 4;
        STM_WR_AXI_REQ_REGS : --! @brief STREAM OUT AXI REQUEST REGISTER :
                              integer range 0 to 1 := 1;
        STM_WR_AXI_ACK_REGS : --! @brief STREAM OUT AXI ACKNOWLEDGE REGISTER :
                              integer range 0 to 1 := 1;
        STM_WR_AXI_RESP_REGS: --! @brief STREAM OUT AXI RESPONSE REGISTER :
                              integer range 0 to 1 := 1;
        MRG_AXI_ADDR_WIDTH  : --! @brief MERGE IN/OUT AXI ADDRESS WIDTH :
                              integer := 32;
        MRG_AXI_DATA_WIDTH  : --! @brief MERGE IN/OUT AXI DATA WIDTH :
                              integer := 64;
        MRG_AXI_ID_WIDTH    : --! @brief MERGE IN/OUT AXI ID WIDTH :
                              integer := 1;
        MRG_AXI_USER_WIDTH  : --! @brief MERGE IN/OUT AXI ADDRESS USER WIDTH :
                              integer := 1;
        MRG_AXI_ID_BASE     : --! @brief MERGE IN/OUT AXI ID BASE :
                              integer := 0;
        MRG_RD_AXI_XFER_SIZE: --! @brief MERGE IN  AXI MAX XFER SIZE :
                              integer := 11;
        MRG_RD_AXI_BUF_SIZE : --! @brief MERGE IN  AXI BUFFER SIZE :
                              integer := 0;
        MRG_RD_AXI_QUEUE    : --! @brief MERGE IN  AXI QUEUE SIZE :
                              integer := 4;
        MRG_RD_AXI_DATA_REGS: --! @brief MERGE IN  AXI DATA REGISTER :
                              integer := 2;
        MRG_RD_AXI_ACK_REGS : --! @brief MERGE IN  AXI ACKNOWLEDGE REGISTER :
                              integer range 0 to 1 := 1;
        MRG_RD_ARB_NODE_NUM : --! @brief MERGE IN  ARBITER NODE SIZE :
                              integer := 4;
        MRG_RD_ARB_PIPELINE : --! @brief MERGE IN  ARBITER PIPELINE :
                              integer := 0;
        MRG_WR_AXI_XFER_SIZE: --! @brief MERGE OUT AXI MAX XFER SIZE :
                              integer := 11;
        MRG_WR_AXI_BUF_SIZE : --! @brief MERGE OUT AXI BUFFER SIZE :
                              integer := 0;
        MRG_WR_AXI_QUEUE    : --! @brief MERGE OUT AXI QUEUE SIZE :
                              integer := 4;
        MRG_WR_AXI_REQ_REGS : --! @brief MERGE OUT AXI REQUEST REGISTER :
                              integer range 0 to 1 := 1;
        MRG_WR_AXI_ACK_REGS : --! @brief MERGE OUT AXI ACKNOWLEDGE REGISTER :
                              integer range 0 to 1 := 1;
        MRG_WR_AXI_RESP_REGS: --! @brief MERGE OUT AXI RESPONSE REGISTER :
                              integer range 0 to 1 := 1;
        DEBUG_ENABLE        : --! @brief DEBUG ENABLE :
                              integer range 0 to 1 := 0
    );
    port(
    -------------------------------------------------------------------------------
    -- Clock / Reset Signals.
    -------------------------------------------------------------------------------
        ACLK                : in  std_logic;
        ARESETn             : in  std_logic;
    -------------------------------------------------------------------------------
    -- Control Status Register I/F AXI4 Read Address Channel Signals.
    -------------------------------------------------------------------------------
        CSR_AXI_ARADDR      : in  std_logic_vector(CSR_AXI_ADDR_WIDTH   -1 downto 0);
        CSR_AXI_ARVALID     : in  std_logic;
        CSR_AXI_ARREADY     : out std_logic;
    ------------------------------------------------------------------------------
    -- Control Status Register I/F AXI4 Read Data Channel Signals.
    ------------------------------------------------------------------------------
        CSR_AXI_RDATA       : out std_logic_vector(CSR_AXI_DATA_WIDTH   -1 downto 0);
        CSR_AXI_RRESP       : out std_logic_vector(1 downto 0);  
        CSR_AXI_RVALID      : out std_logic;
        CSR_AXI_RREADY      : in  std_logic;
    ------------------------------------------------------------------------------
    -- Control Status Register I/F AXI4 Write Address Channel Signals.
    ------------------------------------------------------------------------------
        CSR_AXI_AWADDR      : in  std_logic_vector(CSR_AXI_ADDR_WIDTH   -1 downto 0);
        CSR_AXI_AWVALID     : in  std_logic;
        CSR_AXI_AWREADY     : out std_logic;
    ------------------------------------------------------------------------------
    -- Control Status Register I/F AXI4 Write Data Channel Signals.
    ------------------------------------------------------------------------------
        CSR_AXI_WDATA       : in  std_logic_vector(CSR_AXI_DATA_WIDTH   -1 downto 0);
        CSR_AXI_WSTRB       : in  std_logic_vector(CSR_AXI_DATA_WIDTH/8 -1 downto 0);
        CSR_AXI_WVALID      : in  std_logic;
        CSR_AXI_WREADY      : out std_logic;
    ------------------------------------------------------------------------------
    -- Control Status Register I/F AXI4 Write Response Channel Signals.
    ------------------------------------------------------------------------------
        CSR_AXI_BRESP       : out std_logic_vector(1 downto 0);
        CSR_AXI_BVALID      : out std_logic;
        CSR_AXI_BREADY      : in  std_logic;
    -------------------------------------------------------------------------------
    -- STREAM IN/OUT AXI4 Read Address Channel Signals.
    -------------------------------------------------------------------------------
        STM_AXI_ARID        : out std_logic_vector(STM_AXI_ID_WIDTH    -1 downto 0);
        STM_AXI_ARADDR      : out std_logic_vector(STM_AXI_ADDR_WIDTH  -1 downto 0);
        STM_AXI_ARLEN       : out std_logic_vector(7 downto 0);
        STM_AXI_ARSIZE      : out std_logic_vector(2 downto 0);
        STM_AXI_ARBURST     : out std_logic_vector(1 downto 0);
        STM_AXI_ARLOCK      : out std_logic_vector(0 downto 0);
        STM_AXI_ARCACHE     : out std_logic_vector(3 downto 0);
        STM_AXI_ARPROT      : out std_logic_vector(2 downto 0);
        STM_AXI_ARQOS       : out std_logic_vector(3 downto 0);
        STM_AXI_ARREGION    : out std_logic_vector(3 downto 0);
        STM_AXI_ARUSER      : out std_logic_vector(STM_AXI_USER_WIDTH  -1 downto 0);
        STM_AXI_ARVALID     : out std_logic;
        STM_AXI_ARREADY     : in  std_logic;
    -------------------------------------------------------------------------------
    -- STREAM IN/OUT AXI4 Read Data Channel Signals.
    -------------------------------------------------------------------------------
        STM_AXI_RID         : in  std_logic_vector(STM_AXI_ID_WIDTH    -1 downto 0);
        STM_AXI_RDATA       : in  std_logic_vector(STM_AXI_DATA_WIDTH  -1 downto 0);
        STM_AXI_RRESP       : in  std_logic_vector(1 downto 0);
        STM_AXI_RLAST       : in  std_logic;
        STM_AXI_RVALID      : in  std_logic;
        STM_AXI_RREADY      : out std_logic;
    -------------------------------------------------------------------------------
    -- STREAM IN/OUT AXI4 Write Address Channel Signals.
    -------------------------------------------------------------------------------
        STM_AXI_AWID        : out std_logic_vector(STM_AXI_ID_WIDTH    -1 downto 0);
        STM_AXI_AWADDR      : out std_logic_vector(STM_AXI_ADDR_WIDTH  -1 downto 0);
        STM_AXI_AWLEN       : out std_logic_vector(7 downto 0);
        STM_AXI_AWSIZE      : out std_logic_vector(2 downto 0);
        STM_AXI_AWBURST     : out std_logic_vector(1 downto 0);
        STM_AXI_AWLOCK      : out std_logic_vector(0 downto 0);
        STM_AXI_AWCACHE     : out std_logic_vector(3 downto 0);
        STM_AXI_AWPROT      : out std_logic_vector(2 downto 0);
        STM_AXI_AWQOS       : out std_logic_vector(3 downto 0);
        STM_AXI_AWREGION    : out std_logic_vector(3 downto 0);
        STM_AXI_AWUSER      : out std_logic_vector(STM_AXI_USER_WIDTH  -1 downto 0);
        STM_AXI_AWVALID     : out std_logic;
        STM_AXI_AWREADY     : in  std_logic;
    -------------------------------------------------------------------------------
    -- STREAM IN/OUT AXI4 Write Data Channel Signals.
    -------------------------------------------------------------------------------
        STM_AXI_WID         : out std_logic_vector(STM_AXI_ID_WIDTH    -1 downto 0);
        STM_AXI_WDATA       : out std_logic_vector(STM_AXI_DATA_WIDTH  -1 downto 0);
        STM_AXI_WSTRB       : out std_logic_vector(STM_AXI_DATA_WIDTH/8-1 downto 0);
        STM_AXI_WLAST       : out std_logic;
        STM_AXI_WVALID      : out std_logic;
        STM_AXI_WREADY      : in  std_logic;
    -------------------------------------------------------------------------------
    -- STREAM IN/OUT AXI4 Write Response Channel Signals.
    -------------------------------------------------------------------------------
        STM_AXI_BID         : in  std_logic_vector(STM_AXI_ID_WIDTH    -1 downto 0);
        STM_AXI_BRESP       : in  std_logic_vector(1 downto 0);
        STM_AXI_BVALID      : in  std_logic;
        STM_AXI_BREADY      : out std_logic;
    -------------------------------------------------------------------------------
    -- MERGE IN/OUT AXI4 Read Address Channel Signals.
    -------------------------------------------------------------------------------
        MRG_AXI_ARID        : out std_logic_vector(MRG_AXI_ID_WIDTH    -1 downto 0);
        MRG_AXI_ARADDR      : out std_logic_vector(MRG_AXI_ADDR_WIDTH  -1 downto 0);
        MRG_AXI_ARLEN       : out std_logic_vector(7 downto 0);
        MRG_AXI_ARSIZE      : out std_logic_vector(2 downto 0);
        MRG_AXI_ARBURST     : out std_logic_vector(1 downto 0);
        MRG_AXI_ARLOCK      : out std_logic_vector(0 downto 0);
        MRG_AXI_ARCACHE     : out std_logic_vector(3 downto 0);
        MRG_AXI_ARPROT      : out std_logic_vector(2 downto 0);
        MRG_AXI_ARQOS       : out std_logic_vector(3 downto 0);
        MRG_AXI_ARREGION    : out std_logic_vector(3 downto 0);
        MRG_AXI_ARUSER      : out std_logic_vector(MRG_AXI_USER_WIDTH  -1 downto 0);
        MRG_AXI_ARVALID     : out std_logic;
        MRG_AXI_ARREADY     : in  std_logic;
    -------------------------------------------------------------------------------
    -- MERGE IN/OUT AXI4 Read Data Channel Signals.
    -------------------------------------------------------------------------------
        MRG_AXI_RID         : in  std_logic_vector(MRG_AXI_ID_WIDTH    -1 downto 0);
        MRG_AXI_RDATA       : in  std_logic_vector(MRG_AXI_DATA_WIDTH  -1 downto 0);
        MRG_AXI_RRESP       : in  std_logic_vector(1 downto 0);
        MRG_AXI_RLAST       : in  std_logic;
        MRG_AXI_RVALID      : in  std_logic;
        MRG_AXI_RREADY      : out std_logic;
    -------------------------------------------------------------------------------
    -- MERGE IN/OUT AXI4 Write Address Channel Signals.
    -------------------------------------------------------------------------------
        MRG_AXI_AWID        : out std_logic_vector(MRG_AXI_ID_WIDTH    -1 downto 0);
        MRG_AXI_AWADDR      : out std_logic_vector(MRG_AXI_ADDR_WIDTH  -1 downto 0);
        MRG_AXI_AWLEN       : out std_logic_vector(7 downto 0);
        MRG_AXI_AWSIZE      : out std_logic_vector(2 downto 0);
        MRG_AXI_AWBURST     : out std_logic_vector(1 downto 0);
        MRG_AXI_AWLOCK      : out std_logic_vector(0 downto 0);
        MRG_AXI_AWCACHE     : out std_logic_vector(3 downto 0);
        MRG_AXI_AWPROT      : out std_logic_vector(2 downto 0);
        MRG_AXI_AWQOS       : out std_logic_vector(3 downto 0);
        MRG_AXI_AWREGION    : out std_logic_vector(3 downto 0);
        MRG_AXI_AWUSER      : out std_logic_vector(MRG_AXI_USER_WIDTH  -1 downto 0);
        MRG_AXI_AWVALID     : out std_logic;
        MRG_AXI_AWREADY     : in  std_logic;
    -------------------------------------------------------------------------------
    -- MERGE IN/OUT AXI4 Write Data Channel Signals.
    -------------------------------------------------------------------------------
        MRG_AXI_WID         : out std_logic_vector(MRG_AXI_ID_WIDTH    -1 downto 0);
        MRG_AXI_WDATA       : out std_logic_vector(MRG_AXI_DATA_WIDTH  -1 downto 0);
        MRG_AXI_WSTRB       : out std_logic_vector(MRG_AXI_DATA_WIDTH/8-1 downto 0);
        MRG_AXI_WLAST       : out std_logic;
        MRG_AXI_WVALID      : out std_logic;
        MRG_AXI_WREADY      : in  std_logic;
    -------------------------------------------------------------------------------
    -- MERGE IN/OUT AXI4 Write Response Channel Signals.
    -------------------------------------------------------------------------------
        MRG_AXI_BID         : in  std_logic_vector(MRG_AXI_ID_WIDTH    -1 downto 0);
        MRG_AXI_BRESP       : in  std_logic_vector(1 downto 0);
        MRG_AXI_BVALID      : in  std_logic;
        MRG_AXI_BREADY      : out std_logic;
    -------------------------------------------------------------------------------
    -- Interrupt Request
    -------------------------------------------------------------------------------
        INTERRUPT           : out std_logic
    );
end ArgSort_Vivado;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library Merge_Sorter;
use     Merge_Sorter.Core_Components.Merge_Sorter_Core;
use     Merge_Sorter.ArgSort_AXI_Components.ArgSort_AXI_Interface;
library PIPEWORK;
use     PIPEWORK.AXI4_TYPES.all;
use     PIPEWORK.AXI4_COMPONENTS.AXI4_REGISTER_INTERFACE;
use     PIPEWORK.COMPONENTS.REGISTER_ACCESS_ADAPTER;
architecture RTL of ArgSort_Vivado is
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function  MAX(A,B:integer) return integer is
    begin
        if (A > B) then return A;
        else            return B;
        end if;
    end function;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    constant  MRG_WORD_INDEX_LO :  integer := 0;
    constant  MRG_WORD_INDEX_HI :  integer := MRG_WORD_INDEX_LO + INDEX_BITS - 1;
    constant  MRG_WORD_COMP_LO  :  integer := MRG_WORD_INDEX_HI + 1;
    constant  MRG_WORD_COMP_HI  :  integer := MRG_WORD_COMP_LO  + WORD_BITS  - 1;
    constant  MRG_WORD_BITS     :  integer := MRG_WORD_COMP_HI  - MRG_WORD_INDEX_LO + 1;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    constant  STM_RD_XFER_SIZE  :  integer := AXI4_MAX_XFER_SIZE(STM_AXI_DATA_WIDTH, STM_RD_AXI_XFER_SIZE);
    constant  STM_RD_BUF_DEPTH  :  integer := MAX(STM_RD_XFER_SIZE+1, STM_RD_AXI_BUF_SIZE);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    constant  STM_WR_XFER_SIZE  :  integer := AXI4_MAX_XFER_SIZE(STM_AXI_DATA_WIDTH, STM_WR_AXI_XFER_SIZE);
    constant  STM_WR_BUF_DEPTH  :  integer := MAX(STM_WR_XFER_SIZE+1, STM_WR_AXI_BUF_SIZE);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    constant  MRG_RD_XFER_SIZE  :  integer := AXI4_MAX_XFER_SIZE(MRG_AXI_DATA_WIDTH, MRG_RD_AXI_XFER_SIZE);
    constant  MRG_RD_BUF_DEPTH  :  integer := MAX(MRG_RD_XFER_SIZE+1, MRG_RD_AXI_BUF_SIZE);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    constant  MRG_WR_XFER_SIZE  :  integer := AXI4_MAX_XFER_SIZE(MRG_AXI_DATA_WIDTH, MRG_WR_AXI_XFER_SIZE);
    constant  MRG_WR_BUF_DEPTH  :  integer := MAX(MRG_WR_XFER_SIZE+1, MRG_WR_AXI_BUF_SIZE);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal    RESET             :  std_logic;
    constant  CLEAR             :  std_logic := '0';
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    constant  RW_ADDR_BITS      :  integer := 64;
    constant  RW_SIZE_BITS      :  integer := 32;
    constant  RW_MODE_BITS      :  integer := 16;
    constant  SORT_COUNT_BITS   :  integer := 16;
    -------------------------------------------------------------------------------
    -- Vivado-HLS Method Interface
    -------------------------------------------------------------------------------
    signal    ap_start          :  std_logic;
    signal    ap_busy           :  std_logic;
    signal    ap_done           :  std_logic;
    signal    ap_ready          :  std_logic;
    signal    ap_idle           :  std_logic;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    signal    sort_start        :  std_logic;
    signal    sort_busy         :  std_logic;
    signal    sort_done         :  std_logic;
    signal    sort_size_load    :  std_logic_vector(RW_SIZE_BITS     -1 downto 0);
    signal    sort_size_wbit    :  std_logic_vector(RW_SIZE_BITS     -1 downto 0);
    signal    sort_size_data    :  std_logic_vector(RW_SIZE_BITS     -1 downto 0);
    signal    sort_count_load   :  std_logic_vector(SORT_COUNT_BITS  -1 downto 0);
    signal    sort_count_wbit   :  std_logic_vector(SORT_COUNT_BITS  -1 downto 0);
    signal    sort_count_regs   :  std_logic_vector(SORT_COUNT_BITS  -1 downto 0);
    -------------------------------------------------------------------------------
    -- CTRL_REGS    : Control signals
    -------------------------------------------------------------------------------
    -- 0x00 : bit 0  - ap_start (Read/Write/COH)
    --        bit 1  - ap_done (Read/COR)
    --        bit 2  - ap_idle (Read)
    --        bit 3  - ap_ready (Read)
    --        bit 7  - auto_restart (Read/Write)
    --        others - reserved
    -------------------------------------------------------------------------------
    constant  CTRL_REGS_ADDR    :  integer := 16#00#;
    constant  CTRL_REGS_BITS    :  integer := 32;
    constant  CTRL_REGS_LO      :  integer := 8*CTRL_REGS_ADDR;
    constant  CTRL_REGS_HI      :  integer := 8*CTRL_REGS_ADDR + CTRL_REGS_BITS - 1;
    constant  CTRL_START_POS    :  integer :=  0;
    constant  CTRL_DONE_POS     :  integer :=  1;
    constant  CTRL_IDLE_POS     :  integer :=  2;
    constant  CTRL_READY_POS    :  integer :=  3;
    constant  CTRL_RESV_LO      :  integer :=  4;
    constant  CTRL_RESV_HI      :  integer := CTRL_REGS_BITS - 1;
    signal    ctrl_load         :  std_logic_vector(CTRL_REGS_BITS   -1 downto 0);
    signal    ctrl_read         :  std_logic_vector(CTRL_REGS_BITS   -1 downto 0);
    signal    ctrl_wbit         :  std_logic_vector(CTRL_REGS_BITS   -1 downto 0);
    signal    ctrl_regs         :  std_logic_vector(CTRL_REGS_BITS   -1 downto 0);
    signal    ctrl_start        :  std_logic;
    signal    ctrl_done         :  std_logic;
    type      CTRL_STETE_TYPE   is (IDLE_STATE,
                                    SORT_STATE,
                                    MISC_STATE,
                                    GET_DEBUG_STATE,
                                    GET_MODE_STATE,
                                    SET_MODE_STATE);
    signal    ctrl_state        :  CTRL_STETE_TYPE;
    -------------------------------------------------------------------------------
    -- GIRQ_ENA_REGS: Global Interrupt Enable Register
    -------------------------------------------------------------------------------
    -- 0x04 : bit 0  - Global Interrupt Enable (Read/Write)
    --        others - reserved
    -------------------------------------------------------------------------------
    constant  GIER_REGS_ADDR    :  integer := 16#04#;
    constant  GIER_REGS_BITS    :  integer := 32;
    constant  GIER_REGS_LO      :  integer := 8*GIER_REGS_ADDR;
    constant  GIER_REGS_HI      :  integer := 8*GIER_REGS_ADDR + GIER_REGS_BITS - 1;
    constant  GIER_ENABLE_POS   :  integer :=  0;
    constant  GIER_RESV_LO      :  integer :=  1;
    constant  GIER_RESV_HI      :  integer := GIER_REGS_BITS - 1;
    signal    gier_load         :  std_logic_vector(GIER_REGS_BITS   -1 downto 0);
    signal    gier_wbit         :  std_logic_vector(GIER_REGS_BITS   -1 downto 0);
    signal    gier_regs         :  std_logic_vector(GIER_REGS_BITS   -1 downto 0);
    -------------------------------------------------------------------------------
    -- IRQ_ENA_REGS : IP Interrupt Enable Register (Read/Write)
    -------------------------------------------------------------------------------
    -- 0x08 : bit 0  - Channel 0 (ap_done)
    --        bit 1  - Channel 1 (ap_ready)
    --        others - reserved
    -------------------------------------------------------------------------------
    constant  IRQ_ENA_REGS_ADDR :  integer := 16#08#;
    constant  IRQ_ENA_REGS_BITS :  integer := 32;
    constant  IRQ_ENA_REGS_LO   :  integer := 8*IRQ_ENA_REGS_ADDR;
    constant  IRQ_ENA_REGS_HI   :  integer := 8*IRQ_ENA_REGS_ADDR + IRQ_ENA_REGS_BITS - 1;
    constant  IRQ_ENA_DONE_POS  :  integer :=  0;
    constant  IRQ_ENA_READY_POS :  integer :=  1;
    constant  IRQ_ENA_RESV_LO   :  integer :=  2;
    constant  IRQ_ENA_RESV_HI   :  integer := IRQ_ENA_REGS_BITS - 1;
    signal    irq_ena_load      :  std_logic_vector(IRQ_ENA_REGS_BITS-1 downto 0);
    signal    irq_ena_wbit      :  std_logic_vector(IRQ_ENA_REGS_BITS-1 downto 0);
    signal    irq_ena_regs      :  std_logic_vector(IRQ_ENA_REGS_BITS-1 downto 0);
    -------------------------------------------------------------------------------
    -- IRQ_STA_REGS : IP Interrupt Status Register (Read/TOW)
    -------------------------------------------------------------------------------
    -- 0x0c : bit 0  - Channel 0 (ap_done)
    --        bit 1  - Channel 1 (ap_ready)
    --        others - reserved
    -------------------------------------------------------------------------------
    constant  IRQ_STA_REGS_ADDR :  integer := 16#0C#;
    constant  IRQ_STA_REGS_BITS :  integer := 32;
    constant  IRQ_STA_REGS_LO   :  integer := 8*IRQ_STA_REGS_ADDR;
    constant  IRQ_STA_REGS_HI   :  integer := 8*IRQ_STA_REGS_ADDR + IRQ_STA_REGS_BITS - 1;
    constant  IRQ_STA_DONE_POS  :  integer :=  0;
    constant  IRQ_STA_READY_POS :  integer :=  1;
    constant  IRQ_STA_RESV_LO   :  integer :=  2;
    constant  IRQ_STA_RESV_HI   :  integer := IRQ_STA_REGS_BITS - 1;
    signal    irq_sta_load      :  std_logic_vector(IRQ_STA_REGS_BITS-1 downto 0);
    signal    irq_sta_wbit      :  std_logic_vector(IRQ_STA_REGS_BITS-1 downto 0);
    signal    irq_sta_regs      :  std_logic_vector(IRQ_STA_REGS_BITS-1 downto 0);
    ------------------------------------------------------------------------------
    -- COMMAND_REGS : Command Register
    -------------------------------------------------------------------------------
    constant  COMMAND_REGS_ADDR :  integer := 16#10#;
    constant  COMMAND_REGS_BITS :  integer := 32;
    constant  COMMAND_REGS_LO   :  integer := 8*COMMAND_REGS_ADDR;
    constant  COMMAND_REGS_HI   :  integer := 8*COMMAND_REGS_ADDR + COMMAND_REGS_BITS - 1;
    constant  COMMAND_TYPE_HI   :  integer := 31;
    constant  COMMAND_TYPE_LO   :  integer := 28;
    constant  COMMAND_MODE_HI   :  integer := 27;
    constant  COMMAND_MODE_LO   :  integer := 24;
    constant  COMMAND_ARG2_HI   :  integer := 23;
    constant  COMMAND_ARG2_LO   :  integer := 16;
    constant  COMMAND_ARG1_HI   :  integer := 15;
    constant  COMMAND_ARG1_LO   :  integer :=  8;
    constant  COMMAND_ARG0_HI   :  integer :=  7;
    constant  COMMAND_ARG0_LO   :  integer :=  0;
    constant  COMMAND_SORT_TYPE :  integer :=  0;
    constant  COMMAND_GET_DEBUG :  integer :=  1;
    constant  COMMAND_SET_MODE  :  integer :=  2;
    constant  COMMAND_GET_MODE  :  integer :=  3;
    signal    command_load      :  std_logic_vector(COMMAND_REGS_BITS-1 downto 0);
    signal    command_wbit      :  std_logic_vector(COMMAND_REGS_BITS-1 downto 0);
    signal    command_regs      :  std_logic_vector(COMMAND_REGS_BITS-1 downto 0);
    signal    command_mode      :  std_logic_vector(COMMAND_MODE_HI downto COMMAND_MODE_LO);
    signal    command_type      :  std_logic_vector(COMMAND_TYPE_HI downto COMMAND_TYPE_LO);
    signal    get_debug_start   :  std_logic;
    signal    get_mode_start    :  std_logic;
    signal    set_mode_start    :  std_logic;
    signal    set_t0_mode       :  boolean;
    signal    set_t1_mode       :  boolean;
    signal    set_rd_mode       :  boolean;
    signal    set_wr_mode       :  boolean;
    constant  set_mode_load     :  std_logic_vector(RW_MODE_BITS-1 downto 0) := (others => '1');
    signal    set_mode_wbit     :  std_logic_vector(RW_MODE_BITS-1 downto 0);
    ------------------------------------------------------------------------------
    -- RESV_REGS    : Reserved Register
    -------------------------------------------------------------------------------
    constant  RESV_REGS_ADDR    :  integer := 16#14#;
    constant  RESV_REGS_BITS    :  integer := 32;
    constant  RESV_REGS_LO      :  integer := 8*RESV_REGS_ADDR;
    constant  RESV_REGS_HI      :  integer := 8*RESV_REGS_ADDR    + RESV_REGS_BITS    - 1;
    constant  resv_regs         :  std_logic_vector(RESV_REGS_BITS-1 downto 0) := (others => '0');
    -------------------------------------------------------------------------------
    -- SIZE_REGS    : Size Register
    -------------------------------------------------------------------------------
    constant  SIZE_REGS_ADDR    :  integer := 16#18#;
    constant  SIZE_REGS_BITS    :  integer := 64;
    constant  SIZE_REGS_LO      :  integer := 8*SIZE_REGS_ADDR;
    constant  SIZE_REGS_HI      :  integer := 8*SIZE_REGS_ADDR    + SIZE_REGS_BITS    - 1;
    constant  SIZE_SIZE_LO      :  integer := 0;
    constant  SIZE_SIZE_HI      :  integer := RW_SIZE_BITS  - 1;
    constant  SIZE_RESV_LO      :  integer := RW_SIZE_BITS;
    constant  SIZE_RESV_HI      :  integer := SIZE_REGS_BITS - 1;
    signal    size_load         :  std_logic_vector(SIZE_REGS_BITS   -1 downto 0);
    signal    size_wbit         :  std_logic_vector(SIZE_REGS_BITS   -1 downto 0);
    signal    size_regs         :  std_logic_vector(SIZE_REGS_BITS   -1 downto 0);
    ------------------------------------------------------------------------------
    -- T0_ADDR_REGS : Tempolary Buffer[0] Address Register
    -------------------------------------------------------------------------------
    constant  T0_ADDR_REGS_ADDR :  integer := 16#20#;
    constant  T0_ADDR_REGS_BITS :  integer := RW_ADDR_BITS;
    constant  T0_ADDR_REGS_LO   :  integer := 8*T0_ADDR_REGS_ADDR;
    constant  T0_ADDR_REGS_HI   :  integer := 8*T0_ADDR_REGS_ADDR + T0_ADDR_REGS_BITS - 1;
    signal    t0_addr_load      :  std_logic_vector(RW_ADDR_BITS     -1 downto 0);
    signal    t0_addr_wbit      :  std_logic_vector(RW_ADDR_BITS     -1 downto 0);
    signal    t0_addr_regs      :  std_logic_vector(RW_ADDR_BITS     -1 downto 0);
    -------------------------------------------------------------------------------
    -- T1_ADDR_REGS : Tempolary Buffer[1] Address Register
    -------------------------------------------------------------------------------
    constant  T1_ADDR_REGS_ADDR :  integer := 16#28#;
    constant  T1_ADDR_REGS_BITS :  integer := RW_ADDR_BITS;
    constant  T1_ADDR_REGS_LO   :  integer := 8*T1_ADDR_REGS_ADDR;
    constant  T1_ADDR_REGS_HI   :  integer := 8*T1_ADDR_REGS_ADDR + T1_ADDR_REGS_BITS - 1;
    signal    t1_addr_load      :  std_logic_vector(RW_ADDR_BITS     -1 downto 0);
    signal    t1_addr_wbit      :  std_logic_vector(RW_ADDR_BITS     -1 downto 0);
    signal    t1_addr_regs      :  std_logic_vector(RW_ADDR_BITS     -1 downto 0);
    -------------------------------------------------------------------------------
    -- T0_MODE_REGS : Tempolary Buffer[0] Mode Register
    -------------------------------------------------------------------------------
    constant  T0_MODE_REGS_ADDR :  integer := 16#30#;
    constant  T0_MODE_REGS_BITS :  integer := RW_MODE_BITS;
    constant  T0_MODE_REGS_LO   :  integer := 8*T0_MODE_REGS_ADDR;
    constant  T0_MODE_REGS_HI   :  integer := 8*T0_MODE_REGS_ADDR + T0_MODE_REGS_BITS - 1;
    signal    t0_mode_load      :  std_logic_vector(RW_MODE_BITS     -1 downto 0);
    signal    t0_mode_wbit      :  std_logic_vector(RW_MODE_BITS     -1 downto 0);
    signal    t0_mode_regs      :  std_logic_vector(RW_MODE_BITS     -1 downto 0);
    -------------------------------------------------------------------------------
    -- T1_MODE_REGS : Tempolary Buffer[1] Mode Register
    -------------------------------------------------------------------------------
    constant  T1_MODE_REGS_ADDR :  integer := 16#32#;
    constant  T1_MODE_REGS_BITS :  integer := RW_MODE_BITS;
    constant  T1_MODE_REGS_LO   :  integer := 8*T1_MODE_REGS_ADDR;
    constant  T1_MODE_REGS_HI   :  integer := 8*T1_MODE_REGS_ADDR + T1_MODE_REGS_BITS - 1;
    signal    t1_mode_load      :  std_logic_vector(RW_MODE_BITS     -1 downto 0);
    signal    t1_mode_wbit      :  std_logic_vector(RW_MODE_BITS     -1 downto 0);
    signal    t1_mode_regs      :  std_logic_vector(RW_MODE_BITS     -1 downto 0);
    -------------------------------------------------------------------------------
    -- RD_MODE_REGS : Stream Reader Mode Register
    -------------------------------------------------------------------------------
    constant  RD_MODE_REGS_ADDR :  integer := 16#34#;
    constant  RD_MODE_REGS_BITS :  integer := RW_MODE_BITS;
    constant  RD_MODE_REGS_LO   :  integer := 8*RD_MODE_REGS_ADDR;
    constant  RD_MODE_REGS_HI   :  integer := 8*RD_MODE_REGS_ADDR + RD_MODE_REGS_BITS - 1;
    signal    rd_mode_load      :  std_logic_vector(RW_MODE_BITS     -1 downto 0);
    signal    rd_mode_wbit      :  std_logic_vector(RW_MODE_BITS     -1 downto 0);
    signal    rd_mode_regs      :  std_logic_vector(RW_MODE_BITS     -1 downto 0);
    -------------------------------------------------------------------------------
    -- WR_MODE_REGS : Stream Writer Mode Register
    -------------------------------------------------------------------------------
    constant  WR_MODE_REGS_ADDR :  integer := 16#36#;
    constant  WR_MODE_REGS_BITS :  integer := RW_MODE_BITS;
    constant  WR_MODE_REGS_LO   :  integer := 8*WR_MODE_REGS_ADDR;
    constant  WR_MODE_REGS_HI   :  integer := 8*WR_MODE_REGS_ADDR + WR_MODE_REGS_BITS - 1;
    signal    wr_mode_load      :  std_logic_vector(RW_MODE_BITS     -1 downto 0);
    signal    wr_mode_wbit      :  std_logic_vector(RW_MODE_BITS     -1 downto 0);
    signal    wr_mode_regs      :  std_logic_vector(RW_MODE_BITS     -1 downto 0);
    -------------------------------------------------------------------------------
    -- RESULT_REGS : Result Register
    -------------------------------------------------------------------------------
    constant  RESULT_REGS_ADDR  :  integer := 16#38#;
    constant  RESULT_REGS_BITS  :  integer := 64;
    constant  RESULT_REGS_LO    :  integer := 8*RESULT_REGS_ADDR;
    constant  RESULT_REGS_HI    :  integer := 8*RESULT_REGS_ADDR  + RESULT_REGS_BITS  - 1;
    signal    result_regs       :  std_logic_vector(RESULT_REGS_BITS -1 downto 0);
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    function  to_unsigned(I: boolean; LEN: integer) return unsigned is
    begin
        if (I = TRUE) then return to_unsigned(1, LEN);
        else               return to_unsigned(0, LEN);
        end if;
    end function;
    -------------------------------------------------------------------------------
    -- VERSION_REGS
    -------------------------------------------------------------------------------
    constant  VERSION_REGS_BITS :  integer := 64;
    constant  VERSION_MAJOR     :  integer range 0 to 15 := 1;
    constant  VERSION_MINOR     :  integer range 0 to 15 := 0;
    constant  VERSION_REGS_DATA :  std_logic_vector(VERSION_REGS_BITS-1 downto 0)
                                := std_logic_vector(to_unsigned(VERSION_MAJOR, 4)) &
                                   std_logic_vector(to_unsigned(VERSION_MINOR, 4)) &
                                   std_logic_vector(to_unsigned(MRG_WAYS     ,10)) &
                                   std_logic_vector(to_unsigned(MRG_WORDS    ,10)) &
                                   std_logic_vector(to_unsigned(STM_FEEDBACK , 4)) &
                                   std_logic_vector(to_unsigned(WORD_BITS    ,12)) &
                                   std_logic_vector(to_unsigned(INDEX_BITS   ,12)) &
                                   std_logic_vector(to_unsigned(SORT_ORDER   , 1)) &
                                   std_logic_vector(to_unsigned(COMP_SIGN    , 1)) &
                                   std_logic_vector(to_unsigned(DEBUG_ENABLE , 1)) &
                                   std_logic_vector(to_unsigned(0            , 5));
    -------------------------------------------------------------------------------
    -- DEBUG_REGS
    -------------------------------------------------------------------------------
    constant  DEBUG_BITS        :  integer := 64;
    constant  DEBUG_SIZE        :  integer :=  8;
    constant  DEBUG_COUNT_BITS  :  integer := 32;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    signal    debug_mode        :  std_logic_vector(3 downto 0);
    signal    debug_data        :  std_logic_vector(DEBUG_SIZE*DEBUG_BITS-1 downto 0);
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    signal    stm_req_valid     :  std_logic;
    signal    stm_req_ready     :  std_logic;
    signal    stm_res_valid     :  std_logic;
    signal    stm_res_ready     :  std_logic;
    signal    stm_in_data       :  std_logic_vector(MRG_WORDS*MRG_WORD_BITS-1 downto 0);
    signal    stm_in_strb       :  std_logic_vector(MRG_WORDS              -1 downto 0);
    signal    stm_in_last       :  std_logic;
    signal    stm_in_valid      :  std_logic;
    signal    stm_in_ready      :  std_logic;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    signal    mrg_req_valid     :  std_logic;
    signal    mrg_req_ready     :  std_logic;
    signal    mrg_res_valid     :  std_logic;
    signal    mrg_res_ready     :  std_logic;
    signal    mrg_in_data       :  std_logic_vector(MRG_WAYS*MRG_WORDS*MRG_WORD_BITS-1 downto 0);
    signal    mrg_in_none       :  std_logic_vector(MRG_WAYS*MRG_WORDS              -1 downto 0);
    signal    mrg_in_eblk       :  std_logic_vector(MRG_WAYS-1 downto 0);
    signal    mrg_in_level      :  std_logic_vector(MRG_WAYS-1 downto 0);
    signal    mrg_in_last       :  std_logic_vector(MRG_WAYS-1 downto 0);
    signal    mrg_in_valid      :  std_logic_vector(MRG_WAYS-1 downto 0);
    signal    mrg_in_ready      :  std_logic_vector(MRG_WAYS-1 downto 0);
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    signal    merged_data       :  std_logic_vector(MRG_WORDS*MRG_WORD_BITS-1 downto 0);
    signal    merged_strb       :  std_logic_vector(MRG_WORDS              -1 downto 0);
    signal    merged_last       :  std_logic;
    signal    merged_valid      :  std_logic;
    signal    merged_ready      :  std_logic;
begin
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    RESET <= '1' when (ARESETn = '0') else '0';
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    REGS: block
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        constant  CSR_AXI_ID_WIDTH  :  integer := 4;
        constant  CSR_AXI_ARID      :  std_logic_vector(CSR_AXI_ID_WIDTH-1 downto 0) := (others => '0');
        constant  CSR_AXI_AWID      :  std_logic_vector(CSR_AXI_ID_WIDTH-1 downto 0) := (others => '0');
        signal    CSR_AXI_RID       :  std_logic_vector(CSR_AXI_ID_WIDTH-1 downto 0);
        signal    CSR_AXI_BID       :  std_logic_vector(CSR_AXI_ID_WIDTH-1 downto 0);
        constant  CSR_AXI_ARLEN     :  std_logic_vector(7 downto 0) := (others => '0');
        constant  CSR_AXI_ARSIZE    :  std_logic_vector(2 downto 0) := "010";
        constant  CSR_AXI_ARBURST   :  std_logic_vector(1 downto 0) := "01";
        signal    CSR_AXI_RLAST     :  std_logic;
        constant  CSR_AXI_AWLEN     :  std_logic_vector(7 downto 0) := (others => '0');
        constant  CSR_AXI_AWSIZE    :  std_logic_vector(2 downto 0) := "010";
        constant  CSR_AXI_AWBURST   :  std_logic_vector(1 downto 0) := "01";
        constant  CSR_AXI_WLAST     :  std_logic := '1';
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        constant  REGS_ADDR_WIDTH   :  integer := 6;  -- 0x00 - 0x3F
        constant  REGS_DATA_WIDTH   :  integer := CSR_AXI_DATA_WIDTH;
        constant  REGS_DATA_BITS    :  integer := (2**REGS_ADDR_WIDTH)*8;
        signal    regs_load         :  std_logic_vector(REGS_DATA_BITS   -1 downto 0);
        signal    regs_read         :  std_logic_vector(REGS_DATA_BITS   -1 downto 0);
        signal    regs_wbit         :  std_logic_vector(REGS_DATA_BITS   -1 downto 0);
        signal    regs_rbit         :  std_logic_vector(REGS_DATA_BITS   -1 downto 0);
        signal    regs_req          :  std_logic;
        signal    regs_write        :  std_logic;
        signal    regs_ack          :  std_logic;
        signal    regs_err          :  std_logic;
        signal    regs_addr         :  std_logic_vector(REGS_ADDR_WIDTH  -1 downto 0);
        signal    regs_ben          :  std_logic_vector(REGS_DATA_WIDTH/8-1 downto 0);
        signal    regs_wdata        :  std_logic_vector(REGS_DATA_WIDTH  -1 downto 0);
        signal    regs_rdata        :  std_logic_vector(REGS_DATA_WIDTH  -1 downto 0);
    begin
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        AXI4: AXI4_REGISTER_INTERFACE                  --
            generic map (                              --
                AXI4_LITE       => 1                 , -- 
                AXI4_ADDR_WIDTH => CSR_AXI_ADDR_WIDTH, --
                AXI4_DATA_WIDTH => CSR_AXI_DATA_WIDTH, --
                AXI4_ID_WIDTH   => CSR_AXI_ID_WIDTH  , --
                REGS_ADDR_WIDTH => REGS_ADDR_WIDTH   , --
                REGS_DATA_WIDTH => REGS_DATA_WIDTH     --
            )                                          -- 
            port map (                                 -- 
            -----------------------------------------------------------------------
            -- Clock and Reset Signals.
            -----------------------------------------------------------------------
                CLK             => ACLK              , -- In  :
                RST             => RESET             , -- In  :
                CLR             => CLEAR             , -- In  :
            -----------------------------------------------------------------------
            -- AXI4 Read Address Channel Signals.
            -----------------------------------------------------------------------
                ARID            => CSR_AXI_ARID      , -- In  :
                ARADDR          => CSR_AXI_ARADDR    , -- In  :
                ARLEN           => CSR_AXI_ARLEN     , -- In  :
                ARSIZE          => CSR_AXI_ARSIZE    , -- In  :
                ARBURST         => CSR_AXI_ARBURST   , -- In  :
                ARVALID         => CSR_AXI_ARVALID   , -- In  :
                ARREADY         => CSR_AXI_ARREADY   , -- Out :
            -----------------------------------------------------------------------
            -- AXI4 Read Data Channel Signals.
            -----------------------------------------------------------------------
                RID             => CSR_AXI_RID       , -- Out :
                RDATA           => CSR_AXI_RDATA     , -- Out :
                RRESP           => CSR_AXI_RRESP     , -- Out :
                RLAST           => CSR_AXI_RLAST     , -- Out :
                RVALID          => CSR_AXI_RVALID    , -- Out :
                RREADY          => CSR_AXI_RREADY    , -- In  :
            -----------------------------------------------------------------------
            -- AXI4 Write Address Channel Signals.
            -----------------------------------------------------------------------
                AWID            => CSR_AXI_AWID      , -- In  :
                AWADDR          => CSR_AXI_AWADDR    , -- In  :
                AWLEN           => CSR_AXI_AWLEN     , -- In  :
                AWSIZE          => CSR_AXI_AWSIZE    , -- In  :
                AWBURST         => CSR_AXI_AWBURST   , -- In  :
                AWVALID         => CSR_AXI_AWVALID   , -- In  :
                AWREADY         => CSR_AXI_AWREADY   , -- Out :
            -----------------------------------------------------------------------
            -- AXI4 Write Data Channel Signals.
            -----------------------------------------------------------------------
                WDATA           => CSR_AXI_WDATA     , -- In  :
                WSTRB           => CSR_AXI_WSTRB     , -- In  :
                WLAST           => CSR_AXI_WLAST     , -- In  :
                WVALID          => CSR_AXI_WVALID    , -- In  :
                WREADY          => CSR_AXI_WREADY    , -- Out :
            -----------------------------------------------------------------------
            -- AXI4 Write Response Channel Signals.
            -----------------------------------------------------------------------
                BID             => CSR_AXI_BID       , -- Out :
                BRESP           => CSR_AXI_BRESP     , -- Out :
                BVALID          => CSR_AXI_BVALID    , -- Out :
                BREADY          => CSR_AXI_BREADY    , -- In  :
            -----------------------------------------------------------------------
            -- Register Interface.
            -----------------------------------------------------------------------
                REGS_REQ        => regs_req          , -- Out :
                REGS_WRITE      => regs_write        , -- Out :
                REGS_ACK        => regs_ack          , -- In  :
                REGS_ERR        => regs_err          , -- In  :
                REGS_ADDR       => regs_addr         , -- Out :
                REGS_BEN        => regs_ben          , -- Out :
                REGS_WDATA      => regs_wdata        , -- Out :
                REGS_RDATA      => regs_rdata          -- In  :
            );
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        DEC: REGISTER_ACCESS_ADAPTER                   -- 
            generic map (                              -- 
                ADDR_WIDTH      => REGS_ADDR_WIDTH   , -- 
                DATA_WIDTH      => REGS_DATA_WIDTH   , -- 
                WBIT_MIN        => regs_wbit'low     , -- 
                WBIT_MAX        => regs_wbit'high    , -- 
                RBIT_MIN        => regs_rbit'low     , -- 
                RBIT_MAX        => regs_rbit'high    , -- 
                I_CLK_RATE      => 1                 , -- 
                O_CLK_RATE      => 1                 , -- 
                O_CLK_REGS      => 0                   -- 
            )                                          -- 
            port map (                                 -- 
                RST             => RESET             , -- In  :
                I_CLK           => ACLK              , -- In  :
                I_CLR           => CLEAR             , -- In  :
                I_CKE           => '1'               , -- In  :
                I_REQ           => regs_req          , -- In  :
                I_SEL           => '1'               , -- In  :
                I_WRITE         => regs_write        , -- In  :
                I_ADDR          => regs_addr         , -- In  :
                I_BEN           => regs_ben          , -- In  :
                I_WDATA         => regs_wdata        , -- In  :
                I_RDATA         => regs_rdata        , -- Out :
                I_ACK           => regs_ack          , -- Out :
                I_ERR           => regs_err          , -- Out :
                O_CLK           => ACLK              , -- In  :
                O_CLR           => CLEAR             , -- In  :
                O_CKE           => '1'               , -- In  :
                O_WDATA         => regs_wbit         , -- Out :
                O_WLOAD         => regs_load         , -- Out :
                O_RDATA         => regs_rbit         , -- In  :
                O_RENAB         => regs_read           -- Out :
            );                                         -- 
        ---------------------------------------------------------------------------
        -- ctrl_regs
        ---------------------------------------------------------------------------
        ctrl_load <= regs_load(CTRL_REGS_HI downto  CTRL_REGS_LO);
        ctrl_wbit <= regs_wbit(CTRL_REGS_HI downto  CTRL_REGS_LO);
        ctrl_read <= regs_read(CTRL_REGS_HI downto  CTRL_REGS_LO);
        regs_rbit(CTRL_REGS_HI downto  CTRL_REGS_LO) <= ctrl_regs;

        ctrl_regs(CTRL_START_POS) <= ap_start;
        ctrl_regs(CTRL_DONE_POS ) <= ctrl_done;
        ctrl_regs(CTRL_IDLE_POS ) <= ap_idle;
        ctrl_regs(CTRL_READY_POS) <= ap_ready;
        ctrl_regs(CTRL_RESV_HI downto CTRL_RESV_LO) <= (CTRL_RESV_HI downto CTRL_RESV_LO => '0');

        ctrl_start      <= '1' when (ctrl_state = IDLE_STATE         and
                                     ctrl_load(CTRL_START_POS) = '1' and
                                     ctrl_wbit(CTRL_START_POS) = '1') else '0';
        sort_start      <= '1' when (ctrl_start = '1' and
                                     to_01(unsigned(command_type)) = COMMAND_SORT_TYPE) else '0';
        get_debug_start <= '1' when (ctrl_start = '1' and
                                     to_01(unsigned(command_type)) = COMMAND_GET_DEBUG) else '0';
        get_mode_start  <= '1' when (ctrl_start = '1' and
                                     to_01(unsigned(command_type)) = COMMAND_GET_MODE ) else '0';
        set_mode_start  <= '1' when (ctrl_start = '1' and
                                     to_01(unsigned(command_type)) = COMMAND_SET_MODE ) else '0';
        process(ACLK, RESET)
            variable debug_regs   :  std_logic_vector(DEBUG_BITS  -1 downto 0);
            variable mode_regs    :  std_logic_vector(RW_MODE_BITS-1 downto 0);
        begin
            if (RESET = '1') then
                    ctrl_state  <= IDLE_STATE;
                    ctrl_done   <= '0';
                    result_regs <= (others => '0');
            elsif (ACLK'event and ACLK = '1') then
                if (CLEAR = '1') then
                    ctrl_state  <= IDLE_STATE;
                    ctrl_done   <= '0';
                    result_regs <= (others => '0');
                else
                    case ctrl_state is
                        when IDLE_STATE =>
                            if (ctrl_start = '1') then
                                if    (sort_start  = '1') then
                                    ctrl_state <= SORT_STATE;
                                elsif (get_debug_start = '1') then
                                    ctrl_state <= GET_DEBUG_STATE;
                                elsif (set_mode_start  = '1') then
                                    ctrl_state <= SET_MODE_STATE;
                                elsif (get_mode_start  = '1') then
                                    ctrl_state <= GET_MODE_STATE;
                                else
                                    ctrl_state <= MISC_STATE;
                                end if;
                            else
                                    ctrl_state <= IDLE_STATE;
                            end if;
                        when SORT_STATE =>
                            if (sort_done = '1') then
                                ctrl_state  <= IDLE_STATE;
                            else
                                ctrl_state  <= SORT_STATE;
                            end if;
                            result_regs <= std_logic_vector(resize(unsigned(sort_count_regs), RESULT_REGS_BITS));
                        when GET_DEBUG_STATE =>
                            ctrl_state  <= IDLE_STATE;
                            debug_regs  := (others => '0');
                            for i in 0 to DEBUG_SIZE loop
                                if (i = to_integer(unsigned(command_mode)) and i < DEBUG_SIZE) then
                                    debug_regs := debug_regs or
                                                  debug_data(DEBUG_BITS*(i+1)-1 downto DEBUG_BITS*i);
                                end if;
                            end loop;
                            result_regs <= debug_regs;
                        when SET_MODE_STATE =>
                            ctrl_state  <= GET_MODE_STATE;
                        when GET_MODE_STATE =>
                            ctrl_state  <= IDLE_STATE;
                            case to_integer(unsigned(command_mode)) is
                                when 0      => mode_regs := t0_mode_regs;
                                when 1      => mode_regs := t1_mode_regs;
                                when 2      => mode_regs := rd_mode_regs;
                                when 3      => mode_regs := wr_mode_regs;
                                when others => mode_regs := (others => '0');
                            end case;
                            result_regs <= std_logic_vector(resize(unsigned(mode_regs), RESULT_REGS_BITS));
                        when MISC_STATE =>
                            ctrl_state  <= IDLE_STATE;
                            result_regs <= VERSION_REGS_DATA;
                        when others =>
                            ctrl_state  <= IDLE_STATE;
                    end case;
                    if (ap_done = '1') then
                        ctrl_done <= '1';
                    elsif (ctrl_read(CTRL_DONE_POS) = '1') then
                        ctrl_done <= '0';
                    end if;
                end if;
            end if;
        end process;
        ap_done  <= '1' when (ctrl_state  = SORT_STATE and sort_done = '1') or
                             (ctrl_state  = GET_DEBUG_STATE) or
                             (ctrl_state  = GET_MODE_STATE ) or
                             (ctrl_state  = MISC_STATE     ) else '0';
        ap_busy  <= '1' when (ctrl_state /= IDLE_STATE ) else '0';
        ap_start <= '1' when (ap_busy = '1' or ctrl_start = '1') else '0';
        ap_idle  <= '1' when (ap_busy = '0') else '0';
        ap_ready <= '1' when (ap_done = '1') else '0';
        ---------------------------------------------------------------------------
        -- irq_ena_regs
        ---------------------------------------------------------------------------
        irq_ena_load <= regs_load(IRQ_ENA_REGS_HI downto IRQ_ENA_REGS_LO);
        irq_ena_wbit <= regs_wbit(IRQ_ENA_REGS_HI downto IRQ_ENA_REGS_LO);
        regs_rbit(IRQ_ENA_REGS_HI downto IRQ_ENA_REGS_LO) <= irq_ena_regs;
        process(ACLK, RESET) begin
            if (RESET = '1') then
                    irq_ena_regs <= (others => '0');
            elsif (ACLK'event and ACLK = '1') then
                if (CLEAR = '1') then
                    irq_ena_regs <= (others => '0');
                else
                    if (irq_ena_load(IRQ_ENA_DONE_POS ) = '1') then
                        irq_ena_regs(IRQ_ENA_DONE_POS ) <= irq_ena_wbit(IRQ_ENA_DONE_POS );
                    end if;
                    if (irq_ena_load(IRQ_ENA_READY_POS) = '1') then
                        irq_ena_regs(IRQ_ENA_READY_POS) <= irq_ena_wbit(IRQ_ENA_READY_POS);
                    end if;
                end if;
            end if;
        end process;
        ---------------------------------------------------------------------------
        -- irq_sta_regs
        ---------------------------------------------------------------------------
        irq_sta_load <= regs_load(IRQ_STA_REGS_HI downto IRQ_STA_REGS_LO);
        irq_sta_wbit <= regs_wbit(IRQ_STA_REGS_HI downto IRQ_STA_REGS_LO);
        regs_rbit(IRQ_STA_REGS_HI downto IRQ_STA_REGS_LO) <= irq_sta_regs;
        process(ACLK, RESET) begin
            if (RESET = '1') then
                    irq_sta_regs <= (others => '0');
            elsif (ACLK'event and ACLK = '1') then
                if (CLEAR = '1') then
                    irq_sta_regs <= (others => '0');
                else
                    if    (irq_ena_regs(IRQ_ENA_DONE_POS ) = '1' and ap_done  = '1') then
                        irq_sta_regs(IRQ_STA_DONE_POS ) <= '1';
                    elsif (irq_sta_load(IRQ_STA_DONE_POS ) = '1') then
                        irq_sta_regs(IRQ_STA_DONE_POS ) <= irq_sta_regs(IRQ_STA_DONE_POS ) xor
                                                           irq_sta_wbit(IRQ_STA_DONE_POS );
                    end if;
                    if    (irq_ena_regs(IRQ_ENA_READY_POS) = '1' and ap_ready = '1') then
                        irq_sta_regs(IRQ_STA_READY_POS) <= '1';
                    elsif (irq_sta_load(IRQ_STA_READY_POS) = '1') then
                        irq_sta_regs(IRQ_STA_READY_POS) <= irq_sta_regs(IRQ_STA_READY_POS) xor
                                                           irq_sta_wbit(IRQ_STA_READY_POS);
                    end if;
                end if;
            end if;
        end process;
        ---------------------------------------------------------------------------
        -- command_regs
        ---------------------------------------------------------------------------
        command_load <= regs_load(COMMAND_REGS_HI downto COMMAND_REGS_LO);
        command_wbit <= regs_wbit(COMMAND_REGS_HI downto COMMAND_REGS_LO);
        regs_rbit(COMMAND_REGS_HI downto COMMAND_REGS_LO) <= command_regs;
        command_type  <= command_regs(COMMAND_TYPE_HI downto COMMAND_TYPE_LO);
        command_mode  <= command_regs(COMMAND_MODE_HI downto COMMAND_MODE_LO);
        set_t0_mode   <= (ctrl_state = SET_MODE_STATE and to_integer(to_01(unsigned(command_mode))) = 0);
        set_t1_mode   <= (ctrl_state = SET_MODE_STATE and to_integer(to_01(unsigned(command_mode))) = 1);
        set_rd_mode   <= (ctrl_state = SET_MODE_STATE and to_integer(to_01(unsigned(command_mode))) = 2);
        set_wr_mode   <= (ctrl_state = SET_MODE_STATE and to_integer(to_01(unsigned(command_mode))) = 3);
        set_mode_wbit <= command_regs(COMMAND_ARG1_HI downto COMMAND_ARG0_LO);
        ---------------------------------------------------------------------------
        -- resv_regs
        ---------------------------------------------------------------------------
        regs_rbit(RESV_REGS_HI downto RESV_REGS_LO) <= resv_regs;
        ---------------------------------------------------------------------------
        -- size_regs
        ---------------------------------------------------------------------------
        size_load    <= regs_load(SIZE_REGS_HI downto SIZE_REGS_LO);
        size_wbit    <= regs_wbit(SIZE_REGS_HI downto SIZE_REGS_LO);
        regs_rbit(SIZE_REGS_HI downto SIZE_REGS_LO) <= size_regs;
        ---------------------------------------------------------------------------
        -- t0_addr_regs
        ---------------------------------------------------------------------------
        t0_addr_load <= regs_load(T0_ADDR_REGS_HI downto T0_ADDR_REGS_LO);
        t0_addr_wbit <= regs_wbit(T0_ADDR_REGS_HI downto T0_ADDR_REGS_LO);
        regs_rbit(T0_ADDR_REGS_HI downto T0_ADDR_REGS_LO) <= t0_addr_regs;
        ---------------------------------------------------------------------------
        -- t1_addr_regs
        ---------------------------------------------------------------------------
        t1_addr_load <= regs_load(T1_ADDR_REGS_HI downto T1_ADDR_REGS_LO);
        t1_addr_wbit <= regs_wbit(T1_ADDR_REGS_HI downto T1_ADDR_REGS_LO);
        regs_rbit(T1_ADDR_REGS_HI downto T1_ADDR_REGS_LO) <= t1_addr_regs;
        ---------------------------------------------------------------------------
        -- t0_mode_regs
        ---------------------------------------------------------------------------
        t0_mode_load <= set_mode_load when (set_t0_mode) else
                        regs_load(T0_MODE_REGS_HI downto T0_MODE_REGS_LO);
        t0_mode_wbit <= set_mode_wbit when (set_t0_mode) else
                        regs_wbit(T0_MODE_REGS_HI downto T0_MODE_REGS_LO);
        regs_rbit(T0_MODE_REGS_HI downto T0_MODE_REGS_LO) <= t0_mode_regs;
        ---------------------------------------------------------------------------
        -- t1_mode_regs
        ---------------------------------------------------------------------------
        t1_mode_load <= set_mode_load when (set_t1_mode) else
                        regs_load(T1_MODE_REGS_HI downto T1_MODE_REGS_LO);
        t1_mode_wbit <= set_mode_wbit when (set_t1_mode) else
                        regs_wbit(T1_MODE_REGS_HI downto T1_MODE_REGS_LO);
        regs_rbit(T1_MODE_REGS_HI downto T1_MODE_REGS_LO) <= t1_mode_regs;
        ---------------------------------------------------------------------------
        -- rd_mode_regs
        ---------------------------------------------------------------------------
        rd_mode_load <= set_mode_load when (set_rd_mode) else
                        regs_load(RD_MODE_REGS_HI downto RD_MODE_REGS_LO);
        rd_mode_wbit <= set_mode_wbit when (set_rd_mode) else
                        regs_wbit(RD_MODE_REGS_HI downto RD_MODE_REGS_LO);
        regs_rbit(RD_MODE_REGS_HI downto RD_MODE_REGS_LO) <= rd_mode_regs;
        ---------------------------------------------------------------------------
        -- wr_mode_regs
        ---------------------------------------------------------------------------
        wr_mode_load <= set_mode_load when (set_wr_mode) else
                        regs_load(WR_MODE_REGS_HI downto WR_MODE_REGS_LO);
        wr_mode_wbit <= set_mode_wbit when (set_wr_mode) else
                        regs_wbit(WR_MODE_REGS_HI downto WR_MODE_REGS_LO);
        regs_rbit(WR_MODE_REGS_HI downto WR_MODE_REGS_LO) <= wr_mode_regs;
        ---------------------------------------------------------------------------
        -- sort_size
        ---------------------------------------------------------------------------
        sort_size_load <= size_load(SIZE_SIZE_HI downto SIZE_SIZE_LO);
        sort_size_wbit <= size_wbit(SIZE_SIZE_HI downto SIZE_SIZE_LO);
        size_regs <= std_logic_vector(resize(to_01(unsigned(sort_size_data)), SIZE_REGS_BITS));
        ---------------------------------------------------------------------------
        -- sort_count_load/sort_count_wbit
        ---------------------------------------------------------------------------
        sort_count_load <= (others => '1') when (sort_start = '1') else (others => '0');
        sort_count_wbit <= (others => '0');
        ---------------------------------------------------------------------------
        -- result_regs
        ---------------------------------------------------------------------------
        regs_rbit(RESULT_REGS_HI downto RESULT_REGS_LO) <= result_regs;
        ---------------------------------------------------------------------------
        -- debug_mode
        ---------------------------------------------------------------------------
        debug_mode <= command_mode;
        ---------------------------------------------------------------------------
        -- gier_regs / INTERRUPT
        ---------------------------------------------------------------------------
        gier_load <= regs_load(GIER_REGS_HI downto GIER_REGS_LO);
        gier_wbit <= regs_wbit(GIER_REGS_HI downto GIER_REGS_LO);
        regs_rbit(GIER_REGS_HI downto GIER_REGS_LO) <= gier_regs;
        process(ACLK, RESET) begin
            if (RESET = '1') then
                    gier_regs <= (others => '0');
                    INTERRUPT <= '0';
            elsif (ACLK'event and ACLK = '1') then
                if (CLEAR = '1') then
                    gier_regs <= (others => '0');
                    INTERRUPT <= '0';
                else
                    if (gier_load(GIER_ENABLE_POS) = '1') then
                        gier_regs(GIER_ENABLE_POS) <= gier_wbit(GIER_ENABLE_POS);
                    end if;
                    if (gier_regs(GIER_ENABLE_POS) = '1') and
                        (irq_sta_regs(IRQ_STA_DONE_POS ) = '1' or
                         irq_sta_regs(IRQ_STA_READY_POS) = '1') then
                        INTERRUPT <= '1';
                    else
                        INTERRUPT <= '0';
                    end if;
                end if;
            end if;
        end process;
    end block;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    ARGSORT_IF:  ArgSort_AXI_Interface                   -- 
        generic map (                                    -- 
            WAYS                => MRG_WAYS            , --   
            WORDS               => MRG_WORDS           , --   
            WORD_BITS           => MRG_WORD_BITS       , --   
            WORD_INDEX_LO       => MRG_WORD_INDEX_LO   , --   
            WORD_INDEX_HI       => MRG_WORD_INDEX_HI   , --   
            WORD_COMP_LO        => MRG_WORD_COMP_LO    , --   
            WORD_COMP_HI        => MRG_WORD_COMP_HI    , --   
            MRG_AXI_ID_BASE     => MRG_AXI_ID_BASE     , -- 
            MRG_AXI_ID_WIDTH    => MRG_AXI_ID_WIDTH    , --   
            MRG_AXI_AUSER_WIDTH => MRG_AXI_USER_WIDTH  , --   
            MRG_AXI_WUSER_WIDTH => 1                   , --   
            MRG_AXI_BUSER_WIDTH => 1                   , --   
            MRG_AXI_ADDR_WIDTH  => MRG_AXI_ADDR_WIDTH  , --   
            MRG_AXI_DATA_WIDTH  => MRG_AXI_DATA_WIDTH  , --   
            MRG_RD_AXI_XFER_SIZE=> MRG_RD_XFER_SIZE    , --   
            MRG_RD_AXI_BUF_DEPTH=> MRG_RD_BUF_DEPTH    , --   
            MRG_RD_AXI_QUEUE    => MRG_RD_AXI_QUEUE    , --
            MRG_RD_AXI_DATA_REGS=> MRG_RD_AXI_DATA_REGS, --
            MRG_RD_AXI_ACK_REGS => MRG_RD_AXI_ACK_REGS , -- 
            MRG_RD_ARB_NODE_NUM => MRG_RD_ARB_NODE_NUM , --   
            MRG_RD_ARB_PIPELINE => MRG_RD_ARB_PIPELINE , --   
            MRG_WR_AXI_XFER_SIZE=> MRG_WR_XFER_SIZE    , --   
            MRG_WR_AXI_BUF_DEPTH=> MRG_WR_BUF_DEPTH    , --   
            MRG_WR_AXI_QUEUE    => MRG_WR_AXI_QUEUE    , -- 
            MRG_WR_AXI_REQ_REGS => MRG_WR_AXI_REQ_REGS , -- 
            MRG_WR_AXI_ACK_REGS => MRG_WR_AXI_ACK_REGS , -- 
            MRG_WR_AXI_RESP_REGS=> MRG_WR_AXI_RESP_REGS, -- 
            STM_AXI_ID_BASE     => STM_AXI_ID_BASE     , --   
            STM_AXI_ID_WIDTH    => STM_AXI_ID_WIDTH    , --   
            STM_AXI_AUSER_WIDTH => STM_AXI_USER_WIDTH  , --   
            STM_AXI_WUSER_WIDTH => 1                   , --   
            STM_AXI_BUSER_WIDTH => 1                   , --   
            STM_AXI_ADDR_WIDTH  => STM_AXI_ADDR_WIDTH  , --   
            STM_AXI_DATA_WIDTH  => STM_AXI_DATA_WIDTH  , --   
            STM_RD_AXI_XFER_SIZE=> STM_RD_XFER_SIZE    , --   
            STM_RD_AXI_BUF_DEPTH=> STM_RD_BUF_DEPTH    , --
            STM_RD_AXI_QUEUE    => STM_RD_AXI_QUEUE    , --
            STM_RD_AXI_DATA_REGS=> STM_RD_AXI_DATA_REGS, --
            STM_RD_AXI_ACK_REGS => STM_RD_AXI_ACK_REGS , --
            STM_WR_AXI_XFER_SIZE=> STM_WR_XFER_SIZE    , --   
            STM_WR_AXI_BUF_DEPTH=> STM_WR_BUF_DEPTH    , --   
            STM_WR_AXI_QUEUE    => STM_WR_AXI_QUEUE    , --
            STM_WR_AXI_REQ_REGS => STM_WR_AXI_REQ_REGS , --
            STM_WR_AXI_ACK_REGS => STM_WR_AXI_ACK_REGS , --
            STM_WR_AXI_RESP_REGS=> STM_WR_AXI_RESP_REGS, -- 
            STM_FEEDBACK        => STM_FEEDBACK        , --
            STM_RD_ADDR_VALID   => FALSE               , --
            STM_WR_ADDR_VALID   => FALSE               , --
            REG_RW_ADDR_BITS    => RW_ADDR_BITS        , --   
            REG_RW_MODE_BITS    => RW_MODE_BITS        , --   
            REG_SIZE_BITS       => RW_SIZE_BITS        , --   
            REG_MODE_BITS       => COMMAND_REGS_BITS   , --   
            REG_COUNT_BITS      => SORT_COUNT_BITS     , --   
            DEBUG_ENABLE        => DEBUG_ENABLE        , --   
            DEBUG_SIZE          => DEBUG_SIZE          , --
            DEBUG_BITS          => DEBUG_BITS          , --
            DEBUG_COUNT_BITS    => DEBUG_COUNT_BITS      --
        )                                                -- 
        port map (                                       -- 
        ---------------------------------------------------------------------------
        -- Clock/Reset Signals.
        ---------------------------------------------------------------------------
            CLK                 => ACLK                , -- In  :
            RST                 => RESET               , -- In  :
            CLR                 => CLEAR               , -- In  :
        ---------------------------------------------------------------------------
        -- Register Interface
        ---------------------------------------------------------------------------
            REG_T0_ADDR_L       => t0_addr_load        , -- In  :
            REG_T0_ADDR_D       => t0_addr_wbit        , -- In  :
            REG_T0_ADDR_Q       => t0_addr_regs        , -- Out :
            REG_T1_ADDR_L       => t1_addr_load        , -- In  :
            REG_T1_ADDR_D       => t1_addr_wbit        , -- In  :
            REG_T1_ADDR_Q       => t1_addr_regs        , -- Out :
            REG_T0_MODE_L       => t0_mode_load        , -- In  :
            REG_T0_MODE_D       => t0_mode_wbit        , -- In  :
            REG_T0_MODE_Q       => t0_mode_regs        , -- Out :
            REG_T1_MODE_L       => t1_mode_load        , -- In  :
            REG_T1_MODE_D       => t1_mode_wbit        , -- In  :
            REG_T1_MODE_Q       => t1_mode_regs        , -- Out :
            REG_RD_MODE_L       => rd_mode_load        , -- In  :
            REG_RD_MODE_D       => rd_mode_wbit        , -- In  :
            REG_RD_MODE_Q       => rd_mode_regs        , -- Out :
            REG_WR_MODE_L       => wr_mode_load        , -- In  :
            REG_WR_MODE_D       => wr_mode_wbit        , -- In  :
            REG_WR_MODE_Q       => wr_mode_regs        , -- Out :
            REG_SIZE_L          => sort_size_load      , -- In  :
            REG_SIZE_D          => sort_size_wbit      , -- In  :
            REG_SIZE_Q          => sort_size_data      , -- Out :
            REG_START_L         => sort_start          , -- In  :
            REG_START_D         => '1'                 , -- In  :
            REG_START_Q         => sort_busy           , -- Out :
            REG_DONE_EN_L       => sort_start          , -- In  :
            REG_DONE_EN_D       => '1'                 , -- In  :
            REG_DONE_EN_Q       => open                , -- Out :
            REG_DONE_ST_L       => sort_done           , -- In  :
            REG_DONE_ST_D       => '0'                 , -- In  :
            REG_DONE_ST_Q       => sort_done           , -- Out :
            REG_MODE_L          => command_load        , -- In  :
            REG_MODE_D          => command_wbit        , -- In  :
            REG_MODE_Q          => command_regs        , -- Out :
            REG_COUNT_L         => sort_count_load     , -- In  :
            REG_COUNT_D         => sort_count_wbit     , -- In  :
            REG_COUNT_Q         => sort_count_regs     , -- Out :
        ---------------------------------------------------------------------------
        -- Stream AXI Master Read Address Channel Signals.
        ---------------------------------------------------------------------------
            STM_AXI_ARID        => STM_AXI_ARID        , -- Out :
            STM_AXI_ARADDR      => STM_AXI_ARADDR      , -- Out :
            STM_AXI_ARLEN       => STM_AXI_ARLEN       , -- Out :
            STM_AXI_ARSIZE      => STM_AXI_ARSIZE      , -- Out :
            STM_AXI_ARBURST     => STM_AXI_ARBURST     , -- Out :
            STM_AXI_ARLOCK      => STM_AXI_ARLOCK      , -- Out :
            STM_AXI_ARCACHE     => STM_AXI_ARCACHE     , -- Out :
            STM_AXI_ARPROT      => STM_AXI_ARPROT      , -- Out :
            STM_AXI_ARQOS       => STM_AXI_ARQOS       , -- Out :
            STM_AXI_ARREGION    => STM_AXI_ARREGION    , -- Out :
            STM_AXI_ARUSER      => STM_AXI_ARUSER      , -- Out :
            STM_AXI_ARVALID     => STM_AXI_ARVALID     , -- Out :
            STM_AXI_ARREADY     => STM_AXI_ARREADY     , -- In  :
        ---------------------------------------------------------------------------
        -- Stream AXI Master Read Data Channel Signals.
        ---------------------------------------------------------------------------
            STM_AXI_RID         => STM_AXI_RID         , -- In  :
            STM_AXI_RDATA       => STM_AXI_RDATA       , -- In  :
            STM_AXI_RRESP       => STM_AXI_RRESP       , -- In  :
            STM_AXI_RLAST       => STM_AXI_RLAST       , -- In  :
            STM_AXI_RVALID      => STM_AXI_RVALID      , -- In  :
            STM_AXI_RREADY      => STM_AXI_RREADY      , -- Out :
        ---------------------------------------------------------------------------
        -- Stream AXI Master Writer Address Channel Signals.
        ---------------------------------------------------------------------------
            STM_AXI_AWID        => STM_AXI_AWID        , -- Out :
            STM_AXI_AWADDR      => STM_AXI_AWADDR      , -- Out :
            STM_AXI_AWLEN       => STM_AXI_AWLEN       , -- Out :
            STM_AXI_AWSIZE      => STM_AXI_AWSIZE      , -- Out :
            STM_AXI_AWBURST     => STM_AXI_AWBURST     , -- Out :
            STM_AXI_AWLOCK      => STM_AXI_AWLOCK      , -- Out :
            STM_AXI_AWCACHE     => STM_AXI_AWCACHE     , -- Out :
            STM_AXI_AWPROT      => STM_AXI_AWPROT      , -- Out :
            STM_AXI_AWQOS       => STM_AXI_AWQOS       , -- Out :
            STM_AXI_AWREGION    => STM_AXI_AWREGION    , -- Out :
            STM_AXI_AWUSER      => STM_AXI_AWUSER      , -- Out :
            STM_AXI_AWVALID     => STM_AXI_AWVALID     , -- Out :
            STM_AXI_AWREADY     => STM_AXI_AWREADY     , -- In  :
        ---------------------------------------------------------------------------
        -- Stream AXI Master Write Data Channel Signals.
        ---------------------------------------------------------------------------
            STM_AXI_WID         => STM_AXI_WID         , -- Out :
            STM_AXI_WDATA       => STM_AXI_WDATA       , -- Out :
            STM_AXI_WSTRB       => STM_AXI_WSTRB       , -- Out :
            STM_AXI_WUSER       => open                , -- Out :
            STM_AXI_WLAST       => STM_AXI_WLAST       , -- Out :
            STM_AXI_WVALID      => STM_AXI_WVALID      , -- Out :
            STM_AXI_WREADY      => STM_AXI_WREADY      , -- In  :
        ---------------------------------------------------------------------------
        -- Stream AXI Write Response Channel Signals.
        ---------------------------------------------------------------------------
            STM_AXI_BID         => STM_AXI_BID         , -- In  :
            STM_AXI_BRESP       => STM_AXI_BRESP       , -- In  :
            STM_AXI_BUSER       => "0"                 , -- In  :
            STM_AXI_BVALID      => STM_AXI_BVALID      , -- In  :
            STM_AXI_BREADY      => STM_AXI_BREADY      , -- Out :
        ---------------------------------------------------------------------------
        -- Stream Reader Outlet Signals.
        ---------------------------------------------------------------------------
            STM_RD_DATA         => stm_in_data         , -- Out :
            STM_RD_STRB         => stm_in_strb         , -- Out :
            STM_RD_LAST         => stm_in_last         , -- Out :
            STM_RD_VALID        => stm_in_valid        , -- Out :
            STM_RD_READY        => stm_in_ready        , -- In  :
        ---------------------------------------------------------------------------
        -- Merge AXI Master Read Address Channel Signals.
        ---------------------------------------------------------------------------
            MRG_AXI_ARID        => MRG_AXI_ARID        , -- Out :
            MRG_AXI_ARADDR      => MRG_AXI_ARADDR      , -- Out :
            MRG_AXI_ARLEN       => MRG_AXI_ARLEN       , -- Out :
            MRG_AXI_ARSIZE      => MRG_AXI_ARSIZE      , -- Out :
            MRG_AXI_ARBURST     => MRG_AXI_ARBURST     , -- Out :
            MRG_AXI_ARLOCK      => MRG_AXI_ARLOCK      , -- Out :
            MRG_AXI_ARCACHE     => MRG_AXI_ARCACHE     , -- Out :
            MRG_AXI_ARPROT      => MRG_AXI_ARPROT      , -- Out :
            MRG_AXI_ARQOS       => MRG_AXI_ARQOS       , -- Out :
            MRG_AXI_ARREGION    => MRG_AXI_ARREGION    , -- Out :
            MRG_AXI_ARUSER      => MRG_AXI_ARUSER      , -- Out :
            MRG_AXI_ARVALID     => MRG_AXI_ARVALID     , -- Out :
            MRG_AXI_ARREADY     => MRG_AXI_ARREADY     , -- In  :
        ---------------------------------------------------------------------------
        -- Merge AXI Master Read Data Channel Signals.
        ---------------------------------------------------------------------------
            MRG_AXI_RID         => MRG_AXI_RID         , -- In  :
            MRG_AXI_RDATA       => MRG_AXI_RDATA       , -- In  :
            MRG_AXI_RRESP       => MRG_AXI_RRESP       , -- In  :
            MRG_AXI_RLAST       => MRG_AXI_RLAST       , -- In  :
            MRG_AXI_RVALID      => MRG_AXI_RVALID      , -- In  :
            MRG_AXI_RREADY      => MRG_AXI_RREADY      , -- Out :
        ---------------------------------------------------------------------------
        -- Merge AXI Master Writer Address Channel Signals.
        ---------------------------------------------------------------------------
            MRG_AXI_AWID        => MRG_AXI_AWID        , -- Out :
            MRG_AXI_AWADDR      => MRG_AXI_AWADDR      , -- Out :
            MRG_AXI_AWLEN       => MRG_AXI_AWLEN       , -- Out :
            MRG_AXI_AWSIZE      => MRG_AXI_AWSIZE      , -- Out :
            MRG_AXI_AWBURST     => MRG_AXI_AWBURST     , -- Out :
            MRG_AXI_AWLOCK      => MRG_AXI_AWLOCK      , -- Out :
            MRG_AXI_AWCACHE     => MRG_AXI_AWCACHE     , -- Out :
            MRG_AXI_AWPROT      => MRG_AXI_AWPROT      , -- Out :
            MRG_AXI_AWQOS       => MRG_AXI_AWQOS       , -- Out :
            MRG_AXI_AWREGION    => MRG_AXI_AWREGION    , -- Out :
            MRG_AXI_AWUSER      => MRG_AXI_AWUSER      , -- Out :
            MRG_AXI_AWVALID     => MRG_AXI_AWVALID     , -- Out :
            MRG_AXI_AWREADY     => MRG_AXI_AWREADY     , -- In  :
        ---------------------------------------------------------------------------
        -- Merge AXI Master Write Data Channel Signals.
        ---------------------------------------------------------------------------
            MRG_AXI_WID         => MRG_AXI_WID         , -- Out :
            MRG_AXI_WDATA       => MRG_AXI_WDATA       , -- Out :
            MRG_AXI_WSTRB       => MRG_AXI_WSTRB       , -- Out :
            MRG_AXI_WUSER       => open                , -- Out :
            MRG_AXI_WLAST       => MRG_AXI_WLAST       , -- Out :
            MRG_AXI_WVALID      => MRG_AXI_WVALID      , -- Out :
            MRG_AXI_WREADY      => MRG_AXI_WREADY      , -- In  :
        ---------------------------------------------------------------------------
        -- Merge AXI Write Response Channel Signals.
        ---------------------------------------------------------------------------
            MRG_AXI_BID         => MRG_AXI_BID         , -- In  :
            MRG_AXI_BRESP       => MRG_AXI_BRESP       , -- In  :
            MRG_AXI_BUSER       => "0"                 , -- In  :
            MRG_AXI_BVALID      => MRG_AXI_BVALID      , -- In  :
            MRG_AXI_BREADY      => MRG_AXI_BREADY      , -- Out :
        ---------------------------------------------------------------------------
        -- Merge Reader Outlet Signals.
        ---------------------------------------------------------------------------
            MRG_RD_DATA         => mrg_in_data         , -- Out :
            MRG_RD_NONE         => mrg_in_none         , -- Out :
            MRG_RD_EBLK         => mrg_in_eblk         , -- Out :
            MRG_RD_LAST         => mrg_in_last         , -- Out :
            MRG_RD_VALID        => mrg_in_valid        , -- Out :
            MRG_RD_READY        => mrg_in_ready        , -- In  :
            MRG_RD_LEVEL        => mrg_in_level        , -- In  :
        ---------------------------------------------------------------------------
        -- Merge Sorter Core Control Interface Signals.
        ---------------------------------------------------------------------------
            STM_REQ_VALID       => stm_req_valid       , -- Out :
            STM_REQ_READY       => stm_req_ready       , -- In  :
            STM_RES_VALID       => stm_res_valid       , -- In  :
            STM_RES_READY       => stm_res_ready       , -- Out :
            MRG_REQ_VALID       => mrg_req_valid       , -- Out :
            MRG_REQ_READY       => mrg_req_ready       , -- In  :
            MRG_RES_VALID       => mrg_res_valid       , -- In  :
            MRG_RES_READY       => mrg_res_ready       , -- Out :
        ---------------------------------------------------------------------------
        -- Merge Result Intake Signals.
        ---------------------------------------------------------------------------
            MERGED_DATA         => merged_data         , -- In  :
            MERGED_STRB         => merged_strb         , -- In  :
            MERGED_LAST         => merged_last         , -- In  :
            MERGED_VALID        => merged_valid        , -- In  :
            MERGED_READY        => merged_ready        , -- Out :
        ---------------------------------------------------------------------------
        -- Debug Interface
        ---------------------------------------------------------------------------
            DEBUG_MODE          => debug_mode          , -- In  :
            DEBUG_DATA          => debug_data            -- Out :
    );
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    CORE: Merge_Sorter_Core                              -- 
        generic map (                                    -- 
            MRG_IN_ENABLE       => TRUE               ,  -- 
            MRG_WAYS            => MRG_WAYS           ,  --
            MRG_WORDS           => MRG_WORDS          ,  --
            MRG_FIFO_SIZE       => MRG_FIFO_SIZE      ,  --  
            MRG_LEVEL_SIZE      => 0                  ,  --  
            STM_IN_ENABLE       => TRUE               ,  --
            STM_IN_QUEUE        => STM_IN_QUEUE_SIZE  ,  --
            STM_WORDS           => MRG_WORDS          ,  --  
            STM_FEEDBACK        => STM_FEEDBACK       ,  --  
            SORT_ORDER          => SORT_ORDER         ,  --  
            DATA_BITS           => MRG_WORD_BITS      ,  --  
            COMP_HIGH           => MRG_WORD_COMP_HI   ,  --  
            COMP_LOW            => MRG_WORD_COMP_LO   ,  --  
            COMP_SIGN           => COMP_SIGN             --  
        )                                                -- 
        port map (                                       -- 
            CLK                 => ACLK               ,  -- In  :
            RST                 => RESET              ,  -- In  :
            CLR                 => CLEAR              ,  -- In  :
            STM_REQ_VALID       => stm_req_valid      ,  -- In  :
            STM_REQ_READY       => stm_req_ready      ,  -- Out :
            STM_RES_VALID       => stm_res_valid      ,  -- Out :
            STM_RES_READY       => stm_res_ready      ,  -- In  :
            STM_IN_DATA         => stm_in_data        ,  -- In  :
            STM_IN_STRB         => stm_in_strb        ,  -- In  :
            STM_IN_LAST         => stm_in_last        ,  -- In  :
            STM_IN_VALID        => stm_in_valid       ,  -- In  :
            STM_IN_READY        => stm_in_ready       ,  -- Out :
            MRG_REQ_VALID       => mrg_req_valid      ,  -- In  :
            MRG_REQ_READY       => mrg_req_ready      ,  -- Out :
            MRG_RES_VALID       => mrg_res_valid      ,  -- Out :
            MRG_RES_READY       => mrg_res_ready      ,  -- In  :
            MRG_IN_DATA         => mrg_in_data        ,  -- In  :
            MRG_IN_NONE         => mrg_in_none        ,  -- In  :
            MRG_IN_EBLK         => mrg_in_eblk        ,  -- In  :
            MRG_IN_LAST         => mrg_in_last        ,  -- In  :
            MRG_IN_VALID        => mrg_in_valid       ,  -- In  :
            MRG_IN_READY        => mrg_in_ready       ,  -- Out :
            MRG_IN_LEVEL        => open               ,  -- Out :
            OUT_DATA            => merged_data        ,  -- Out :
            OUT_STRB            => merged_strb        ,  -- Out :
            OUT_LAST            => merged_last        ,  -- Out :
            OUT_VALID           => merged_valid       ,  -- Out :
            OUT_READY           => merged_ready          -- In  :
        );
end RTL;
