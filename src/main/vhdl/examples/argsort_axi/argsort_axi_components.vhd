-----------------------------------------------------------------------------------
--!     @file    argsort_axi_components.vhd                                      --
--!     @brief   ArgSorter Component Library Description Package                 --
--!     @version 0.5.0                                                           --
--!     @date    2020/10/05                                                      --
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>                     --
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--                                                                               --
--      Copyright (C) 2020 Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>           --
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
--! @brief ArgSorter Component Library Description Package                       --
-----------------------------------------------------------------------------------
package ArgSort_AXI_Components is
-----------------------------------------------------------------------------------
--! @brief ArgSort_AXI                                                           --
-----------------------------------------------------------------------------------
component ArgSort_AXI
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
                              integer :=  0;
        STM_FEEDBACK        : --! @brief STREAM FEED BACK NUMBER :
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
        STM_AXI_ID          : --! @brief STREAM IN/OUT AXI ID :
                              integer := 0;
        STM_AXI_PROT        : --! @brief STREAM IN/OUT AXI PROT :
                              integer := 1;
        STM_AXI_CACHE       : --! @brief STREAM IN/OUT AXI REGION :
                              integer := 15;
        STM_AXI_AUSER       : --! @brief STREAM IN/OUT AXI ADDRESS USER VALUE:
                              integer := 0;
        STM_AXI_REQ_QUEUE   : --! @brief STREAM IN/OUT AXI REQUEST QUEUE SIZE :
                              integer := 4;
        STM_AXI_XFER_SIZE   : --! @brief STREAM IN/OUT AXI MAX XFER SIZE :
                              integer := 12;
        MRG_AXI_ADDR_WIDTH  : --! @brief MERGE IN/OUT AXI ADDRESS WIDTH :
                              integer := 32;
        MRG_AXI_DATA_WIDTH  : --! @brief MERGE IN/OUT AXI DATA WIDTH :
                              integer := 64;
        MRG_AXI_ID_WIDTH    : --! @brief MERGE IN/OUT AXI ID WIDTH :
                              integer := 1;
        MRG_AXI_USER_WIDTH  : --! @brief MERGE IN/OUT AXI ADDRESS USER WIDTH :
                              integer := 1;
        MRG_AXI_ID          : --! @brief MERGE IN/OUT AXI ID :
                              integer := 0;
        MRG_AXI_PROT        : --! @brief MERGE IN/OUT AXI PROT :
                              integer := 1;
        MRG_AXI_CACHE       : --! @brief MERGE IN/OUT AXI REGION :
                              integer := 15;
        MRG_AXI_AUSER       : --! @brief MERGE IN/OUT AXI ADDRESS USER VALUE:
                              integer := 0;
        MRG_AXI_REQ_QUEUE   : --! @brief MERGE IN/OUT AXI REQUEST QUEUE SIZE :
                              integer := 4;
        MRG_AXI_XFER_SIZE   : --! @brief MERGE IN/OUT AXI MAX XFER SIZE :
                              integer := 12
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
end component;
-----------------------------------------------------------------------------------
--! @brief ArgSort_AXI_Interface                                                 --
-----------------------------------------------------------------------------------
component ArgSort_AXI_Interface
    generic (
        WAYS                :  integer :=    8;
        WORDS               :  integer :=    1;
        WORD_BITS           :  integer :=   64;
        WORD_INDEX_LO       :  integer :=    0;
        WORD_INDEX_HI       :  integer :=   31;
        WORD_COMP_LO        :  integer :=   32;
        WORD_COMP_HI        :  integer :=   63;
        MRG_AXI_ID          :  integer :=    1;
        MRG_AXI_ID_WIDTH    :  integer :=    8;
        MRG_AXI_AUSER_WIDTH :  integer :=    4;
        MRG_AXI_WUSER_WIDTH :  integer :=    4;
        MRG_AXI_BUSER_WIDTH :  integer :=    4;
        MRG_AXI_ADDR_WIDTH  :  integer :=   32;
        MRG_AXI_DATA_WIDTH  :  integer :=   64;
        MRG_AXI_XFER_SIZE   :  integer :=   12;
        STM_AXI_ID          :  integer :=    1;
        STM_AXI_ID_WIDTH    :  integer :=    8;
        STM_AXI_AUSER_WIDTH :  integer :=    4;
        STM_AXI_WUSER_WIDTH :  integer :=    4;
        STM_AXI_BUSER_WIDTH :  integer :=    4;
        STM_AXI_ADDR_WIDTH  :  integer :=   32;
        STM_AXI_DATA_WIDTH  :  integer :=   64;
        STM_AXI_XFER_SIZE   :  integer :=   12;
        STM_FEEDBACK        :  integer :=    1;
        REG_RW_ADDR_BITS    :  integer :=   64;
        REG_RW_MODE_BITS    :  integer :=   32;
        REG_SIZE_BITS       :  integer :=   32;
        REG_MODE_BITS       :  integer :=   16;
        REG_STAT_BITS       :  integer :=    6
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
        REG_RD_ADDR_L       :  in  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_RD_ADDR_D       :  in  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_RD_ADDR_Q       :  out std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_WR_ADDR_L       :  in  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_WR_ADDR_D       :  in  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_WR_ADDR_Q       :  out std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_T0_ADDR_L       :  in  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_T0_ADDR_D       :  in  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_T0_ADDR_Q       :  out std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_T1_ADDR_L       :  in  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_T1_ADDR_D       :  in  std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_T1_ADDR_Q       :  out std_logic_vector(REG_RW_ADDR_BITS-1 downto 0);
        REG_RD_MODE_L       :  in  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_RD_MODE_D       :  in  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_RD_MODE_Q       :  out std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_WR_MODE_L       :  in  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_WR_MODE_D       :  in  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_WR_MODE_Q       :  out std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_T0_MODE_L       :  in  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_T0_MODE_D       :  in  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_T0_MODE_Q       :  out std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_T1_MODE_L       :  in  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_T1_MODE_D       :  in  std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_T1_MODE_Q       :  out std_logic_vector(REG_RW_MODE_BITS-1 downto 0);
        REG_SIZE_L          :  in  std_logic_vector(REG_SIZE_BITS   -1 downto 0);
        REG_SIZE_D          :  in  std_logic_vector(REG_SIZE_BITS   -1 downto 0);
        REG_SIZE_Q          :  out std_logic_vector(REG_SIZE_BITS   -1 downto 0);
        REG_START_L         :  in  std_logic := '0';
        REG_START_D         :  in  std_logic := '0';
        REG_START_Q         :  out std_logic;
        REG_RESET_L         :  in  std_logic := '0';
        REG_RESET_D         :  in  std_logic := '0';
        REG_RESET_Q         :  out std_logic;
        REG_DONE_EN_L       :  in  std_logic := '0';
        REG_DONE_EN_D       :  in  std_logic := '0';
        REG_DONE_EN_Q       :  out std_logic;
        REG_DONE_ST_L       :  in  std_logic := '0';
        REG_DONE_ST_D       :  in  std_logic := '0';
        REG_DONE_ST_Q       :  out std_logic;
        REG_ERR_ST_L        :  in  std_logic := '0';
        REG_ERR_ST_D        :  in  std_logic := '0';
        REG_ERR_ST_Q        :  out std_logic;
        REG_MODE_L          :  in  std_logic_vector(REG_MODE_BITS   -1 downto 0) := (others => '0');
        REG_MODE_D          :  in  std_logic_vector(REG_MODE_BITS   -1 downto 0) := (others => '0');
        REG_MODE_Q          :  out std_logic_vector(REG_MODE_BITS   -1 downto 0);
        REG_STAT_L          :  in  std_logic_vector(REG_STAT_BITS   -1 downto 0) := (others => '0');
        REG_STAT_D          :  in  std_logic_vector(REG_STAT_BITS   -1 downto 0) := (others => '0');
        REG_STAT_Q          :  out std_logic_vector(REG_STAT_BITS   -1 downto 0);
        REG_STAT_I          :  in  std_logic_vector(REG_STAT_BITS   -1 downto 0) := (others => '0');
    -------------------------------------------------------------------------------
    -- Stream AXI Master Read Address Channel Signals.
    -------------------------------------------------------------------------------
        STM_AXI_ARID        :  out std_logic_vector(STM_AXI_ID_WIDTH    -1 downto 0);
        STM_AXI_ARADDR      :  out std_logic_vector(STM_AXI_ADDR_WIDTH  -1 downto 0);
        STM_AXI_ARLEN       :  out std_logic_vector(7 downto 0);
        STM_AXI_ARSIZE      :  out std_logic_vector(2 downto 0);
        STM_AXI_ARBURST     :  out std_logic_vector(1 downto 0);
        STM_AXI_ARLOCK      :  out std_logic_vector(0 downto 0);
        STM_AXI_ARCACHE     :  out std_logic_vector(3 downto 0);
        STM_AXI_ARPROT      :  out std_logic_vector(2 downto 0);
        STM_AXI_ARQOS       :  out std_logic_vector(3 downto 0);
        STM_AXI_ARREGION    :  out std_logic_vector(3 downto 0);
        STM_AXI_ARUSER      :  out std_logic_vector(STM_AXI_AUSER_WIDTH -1 downto 0);
        STM_AXI_ARVALID     :  out std_logic;
        STM_AXI_ARREADY     :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Stream AXI Master Read Data Channel Signals.
    -------------------------------------------------------------------------------
        STM_AXI_RID         :  in  std_logic_vector(STM_AXI_ID_WIDTH    -1 downto 0);
        STM_AXI_RDATA       :  in  std_logic_vector(STM_AXI_DATA_WIDTH  -1 downto 0);
        STM_AXI_RRESP       :  in  std_logic_vector(1 downto 0);
        STM_AXI_RLAST       :  in  std_logic;
        STM_AXI_RVALID      :  in  std_logic;
        STM_AXI_RREADY      :  out std_logic;
    -------------------------------------------------------------------------------
    -- Stream AXI Master Writer Address Channel Signals.
    -------------------------------------------------------------------------------
        STM_AXI_AWID        :  out std_logic_vector(STM_AXI_ID_WIDTH    -1 downto 0);
        STM_AXI_AWADDR      :  out std_logic_vector(STM_AXI_ADDR_WIDTH  -1 downto 0);
        STM_AXI_AWLEN       :  out std_logic_vector(7 downto 0);
        STM_AXI_AWSIZE      :  out std_logic_vector(2 downto 0);
        STM_AXI_AWBURST     :  out std_logic_vector(1 downto 0);
        STM_AXI_AWLOCK      :  out std_logic_vector(0 downto 0);
        STM_AXI_AWCACHE     :  out std_logic_vector(3 downto 0);
        STM_AXI_AWPROT      :  out std_logic_vector(2 downto 0);
        STM_AXI_AWQOS       :  out std_logic_vector(3 downto 0);
        STM_AXI_AWREGION    :  out std_logic_vector(3 downto 0);
        STM_AXI_AWUSER      :  out std_logic_vector(STM_AXI_AUSER_WIDTH -1 downto 0);
        STM_AXI_AWVALID     :  out std_logic;
        STM_AXI_AWREADY     :  in  std_logic;
    ------------------------------------------------------------------------------
    -- Stream AXI Master Write Data Channel Signals.
    ------------------------------------------------------------------------------
        STM_AXI_WID         :  out std_logic_vector(STM_AXI_ID_WIDTH    -1 downto 0);
        STM_AXI_WDATA       :  out std_logic_vector(STM_AXI_DATA_WIDTH  -1 downto 0);
        STM_AXI_WSTRB       :  out std_logic_vector(STM_AXI_DATA_WIDTH/8-1 downto 0);
        STM_AXI_WUSER       :  out std_logic_vector(STM_AXI_WUSER_WIDTH -1 downto 0);
        STM_AXI_WLAST       :  out std_logic;
        STM_AXI_WVALID      :  out std_logic;
        STM_AXI_WREADY      :  in  std_logic;
    ------------------------------------------------------------------------------
    -- Stream AXI Write Response Channel Signals.
    ------------------------------------------------------------------------------
        STM_AXI_BID         :  in  std_logic_vector(STM_AXI_ID_WIDTH    -1 downto 0);
        STM_AXI_BRESP       :  in  std_logic_vector(1 downto 0);
        STM_AXI_BUSER       :  in  std_logic_vector(STM_AXI_BUSER_WIDTH -1 downto 0);
        STM_AXI_BVALID      :  in  std_logic;
        STM_AXI_BREADY      :  out std_logic;
    -------------------------------------------------------------------------------
    -- Stream Reader Outlet Signals.
    -------------------------------------------------------------------------------
        STM_RD_DATA         :  out std_logic_vector(WORDS*WORD_BITS     -1 downto 0);
        STM_RD_STRB         :  out std_logic_vector(WORDS               -1 downto 0);
        STM_RD_LAST         :  out std_logic;
        STM_RD_VALID        :  out std_logic;
        STM_RD_READY        :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Merge AXI Master Read Address Channel Signals.
    -------------------------------------------------------------------------------
        MRG_AXI_ARID        :  out std_logic_vector(MRG_AXI_ID_WIDTH    -1 downto 0);
        MRG_AXI_ARADDR      :  out std_logic_vector(MRG_AXI_ADDR_WIDTH  -1 downto 0);
        MRG_AXI_ARLEN       :  out std_logic_vector(7 downto 0);
        MRG_AXI_ARSIZE      :  out std_logic_vector(2 downto 0);
        MRG_AXI_ARBURST     :  out std_logic_vector(1 downto 0);
        MRG_AXI_ARLOCK      :  out std_logic_vector(0 downto 0);
        MRG_AXI_ARCACHE     :  out std_logic_vector(3 downto 0);
        MRG_AXI_ARPROT      :  out std_logic_vector(2 downto 0);
        MRG_AXI_ARQOS       :  out std_logic_vector(3 downto 0);
        MRG_AXI_ARREGION    :  out std_logic_vector(3 downto 0);
        MRG_AXI_ARUSER      :  out std_logic_vector(MRG_AXI_AUSER_WIDTH -1 downto 0);
        MRG_AXI_ARVALID     :  out std_logic;
        MRG_AXI_ARREADY     :  in  std_logic;
    -------------------------------------------------------------------------------
    -- Merge AXI Master Read Data Channel Signals.
    -------------------------------------------------------------------------------
        MRG_AXI_RID         :  in  std_logic_vector(MRG_AXI_ID_WIDTH    -1 downto 0);
        MRG_AXI_RDATA       :  in  std_logic_vector(MRG_AXI_DATA_WIDTH  -1 downto 0);
        MRG_AXI_RRESP       :  in  std_logic_vector(1 downto 0);
        MRG_AXI_RLAST       :  in  std_logic;
        MRG_AXI_RVALID      :  in  std_logic;
        MRG_AXI_RREADY      :  out std_logic;
    -------------------------------------------------------------------------------
    -- Merge AXI Master Writer Address Channel Signals.
    -------------------------------------------------------------------------------
        MRG_AXI_AWID        :  out std_logic_vector(MRG_AXI_ID_WIDTH    -1 downto 0);
        MRG_AXI_AWADDR      :  out std_logic_vector(MRG_AXI_ADDR_WIDTH  -1 downto 0);
        MRG_AXI_AWLEN       :  out std_logic_vector(7 downto 0);
        MRG_AXI_AWSIZE      :  out std_logic_vector(2 downto 0);
        MRG_AXI_AWBURST     :  out std_logic_vector(1 downto 0);
        MRG_AXI_AWLOCK      :  out std_logic_vector(0 downto 0);
        MRG_AXI_AWCACHE     :  out std_logic_vector(3 downto 0);
        MRG_AXI_AWPROT      :  out std_logic_vector(2 downto 0);
        MRG_AXI_AWQOS       :  out std_logic_vector(3 downto 0);
        MRG_AXI_AWREGION    :  out std_logic_vector(3 downto 0);
        MRG_AXI_AWUSER      :  out std_logic_vector(MRG_AXI_AUSER_WIDTH -1 downto 0);
        MRG_AXI_AWVALID     :  out std_logic;
        MRG_AXI_AWREADY     :  in  std_logic;
    ------------------------------------------------------------------------------
    -- Merge AXI Master Write Data Channel Signals.
    ------------------------------------------------------------------------------
        MRG_AXI_WID         :  out std_logic_vector(MRG_AXI_ID_WIDTH    -1 downto 0);
        MRG_AXI_WDATA       :  out std_logic_vector(MRG_AXI_DATA_WIDTH  -1 downto 0);
        MRG_AXI_WSTRB       :  out std_logic_vector(MRG_AXI_DATA_WIDTH/8-1 downto 0);
        MRG_AXI_WUSER       :  out std_logic_vector(MRG_AXI_WUSER_WIDTH -1 downto 0);
        MRG_AXI_WLAST       :  out std_logic;
        MRG_AXI_WVALID      :  out std_logic;
        MRG_AXI_WREADY      :  in  std_logic;
    ------------------------------------------------------------------------------
    -- Merge AXI Write Response Channel Signals.
    ------------------------------------------------------------------------------
        MRG_AXI_BID         :  in  std_logic_vector(MRG_AXI_ID_WIDTH    -1 downto 0);
        MRG_AXI_BRESP       :  in  std_logic_vector(1 downto 0);
        MRG_AXI_BUSER       :  in  std_logic_vector(MRG_AXI_BUSER_WIDTH -1 downto 0);
        MRG_AXI_BVALID      :  in  std_logic;
        MRG_AXI_BREADY      :  out std_logic;
    -------------------------------------------------------------------------------
    -- Merge Reader Outlet Signals.
    -------------------------------------------------------------------------------
        MRG_RD_DATA         :  out std_logic_vector(WAYS*WORDS*WORD_BITS-1 downto 0);
        MRG_RD_NONE         :  out std_logic_vector(WAYS*WORDS          -1 downto 0);
        MRG_RD_EBLK         :  out std_logic_vector(WAYS*WORDS          -1 downto 0);
        MRG_RD_LAST         :  out std_logic_vector(WAYS                -1 downto 0);
        MRG_RD_VALID        :  out std_logic_vector(WAYS                -1 downto 0);
        MRG_RD_READY        :  in  std_logic_vector(WAYS                -1 downto 0);
        MRG_RD_LEVEL        :  in  std_logic_vector(WAYS                -1 downto 0);
    -------------------------------------------------------------------------------
    -- Merge Result Intake Signals.
    -------------------------------------------------------------------------------
        MERGED_DATA         :  in  std_logic_vector(WORDS*WORD_BITS     -1 downto 0);
        MERGED_STRB         :  in  std_logic_vector(WORDS               -1 downto 0);
        MERGED_LAST         :  in  std_logic;
        MERGED_VALID        :  in  std_logic;
        MERGED_READY        :  out std_logic;
    -------------------------------------------------------------------------------
    -- Merge Sorter Core Control Interface Signals.
    -------------------------------------------------------------------------------
        STM_REQ_VALID       :  out std_logic;
        STM_REQ_READY       :  in  std_logic;
        STM_RES_VALID       :  in  std_logic;
        STM_RES_READY       :  out std_logic;
        MRG_REQ_VALID       :  out std_logic;
        MRG_REQ_READY       :  in  std_logic;
        MRG_RES_VALID       :  in  std_logic;
        MRG_RES_READY       :  out std_logic
    );
end component;
end ArgSort_AXI_Components;
