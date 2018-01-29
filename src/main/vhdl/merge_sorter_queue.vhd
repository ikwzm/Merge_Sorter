-----------------------------------------------------------------------------------
--!     @file    merge_sorter_queue.vhd
--!     @brief   Merge Sorter Queue Module :
--!     @version 0.0.1
--!     @date    2018/1/28
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
entity  Merge_Sorter_Queue is
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
end Merge_Sorter_Queue;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
library PipeWork;
use     PipeWork.Components.QUEUE_REGISTER;
architecture RTL of Merge_Sorter_Queue is
    constant  WORD_DATA_LO_POS  :  integer := 0;
    constant  WORD_DATA_HI_POS  :  integer := WORD_DATA_LO_POS + DATA_BITS - 1;
    constant  WORD_INFO_LO_POS  :  integer := WORD_DATA_HI_POS + 1;
    constant  WORD_INFO_HI_POS  :  integer := WORD_INFO_LO_POS + INFO_BITS - 1;
    constant  WORD_LAST_POS     :  integer := WORD_INFO_HI_POS + 1;
    constant  WORD_LO_POS       :  integer := WORD_DATA_LO_POS;
    constant  WORD_HI_POS       :  integer := WORD_LAST_POS;
    constant  WORD_BITS         :  integer := WORD_HI_POS - WORD_LO_POS + 1;
    signal    i_word            :  std_logic_vector(WORD_HI_POS downto WORD_LO_POS);
    signal    q_word            :  std_logic_vector(WORD_HI_POS downto WORD_LO_POS);
    signal    q_valid           :  std_logic_vector(QUEUE_SIZE  downto           0);
begin
    Q: QUEUE_REGISTER                    -- 
        generic map (                    -- 
            QUEUE_SIZE  => QUEUE_SIZE  , -- 
            DATA_BITS   => WORD_BITS     --
        )                                -- 
        port map (                       -- 
            CLK         => CLK         , -- In  :
            RST         => RST         , -- In  :
            CLR         => CLR         , -- In  :
            I_DATA      => i_word      , -- In  :
            I_VAL       => I_VALID     , -- In  :
            I_RDY       => I_READY     , -- Out :
            O_DATA      => open        , -- Out :
            O_VAL       => open        , -- Out :
            Q_DATA      => q_word      , -- Out :
            Q_VAL       => q_valid     , -- Out :
            Q_RDY       => O_READY       -- In  :
        );
    i_word(WORD_DATA_HI_POS downto WORD_DATA_LO_POS) <= I_DATA;
    i_word(WORD_INFO_HI_POS downto WORD_INFO_LO_POS) <= I_INFO;
    i_word(WORD_LAST_POS                           ) <= I_LAST;
    O_DATA <= q_word(WORD_DATA_HI_POS downto WORD_DATA_LO_POS);
    O_INFO <= q_word(WORD_INFO_HI_POS downto WORD_INFO_LO_POS);
    O_LAST <= q_word(WORD_LAST_POS);
    O_VALID<= q_valid(0);
end RTL;
