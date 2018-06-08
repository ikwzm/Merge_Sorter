-----------------------------------------------------------------------------------
--!     @file    merge_sorter_drop_none.vhd
--!     @brief   Merge Sorter Drop None Module :
--!     @version 0.0.8
--!     @date    2018/6/8
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
entity  Merge_Sorter_Drop_None is
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
end Merge_Sorter_Drop_None;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
library PipeWork;
use     PipeWork.Components.REDUCER;
architecture RTL of Merge_Sorter_Drop_None is
    constant  WORD_DATA_LO_POS  :  integer := 0;
    constant  WORD_DATA_HI_POS  :  integer := WORD_DATA_LO_POS + DATA_BITS - 1;
    constant  WORD_INFO_LO_POS  :  integer := WORD_DATA_HI_POS + 1;
    constant  WORD_INFO_HI_POS  :  integer := WORD_INFO_LO_POS + INFO_BITS - 1;
    constant  WORD_LO_POS       :  integer := WORD_DATA_LO_POS;
    constant  WORD_HI_POS       :  integer := WORD_INFO_HI_POS;
    constant  WORD_BITS         :  integer := WORD_HI_POS - WORD_LO_POS + 1;
    signal    i_strb            :  std_logic_vector(0 downto 0);
    signal    i_word            :  std_logic_vector(WORD_BITS-1 downto 0);
    signal    o_word            :  std_logic_vector(WORD_BITS-1 downto 0);
begin
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    Q: REDUCER                               -- 
        generic map (                        -- 
            WORD_BITS       => WORD_BITS,    --
            STRB_BITS       => 1,            -- 
            I_WIDTH         => 1,            -- 
            O_WIDTH         => 1,            -- 
            QUEUE_SIZE      => 3,            -- 3word分のキューを用意
            VALID_MIN       => 0,            -- 
            VALID_MAX       => 0,            -- 
            O_VAL_SIZE      => 2,            -- 2word分貯めてからO_VALIDをアサート
            O_SHIFT_MIN     => 1,            -- 
            O_SHIFT_MAX     => 1,            -- 
            I_JUSTIFIED     => 1,            -- 
            FLUSH_ENABLE    => 0             -- 
        )                                    -- 
        port map (                           -- 
            CLK             => CLK         , -- In  :
            RST             => RST         , -- In  :
            CLR             => CLR         , -- In  :
            I_DATA          => i_word      , -- In  :
            I_STRB          => i_strb      , -- In  :
            I_DONE          => I_LAST      , -- In  :
            I_VAL           => I_VALID     , -- In  :
            I_RDY           => I_READY     , -- Out :
            O_DATA          => o_word      , -- Out :
            O_DONE          => O_LAST      , -- Out :
            O_VAL           => O_VALID     , -- Out :
            O_RDY           => O_READY       -- In  :
        );
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    i_strb <= "1" when (I_INFO(0) = '0') else "0";
    i_word(WORD_DATA_HI_POS downto WORD_DATA_LO_POS) <= I_DATA;
    i_word(WORD_INFO_HI_POS downto WORD_INFO_LO_POS) <= I_INFO;
    O_DATA <= o_word(WORD_DATA_HI_POS downto WORD_DATA_LO_POS);
    O_INFO <= o_word(WORD_INFO_HI_POS downto WORD_INFO_LO_POS);
end RTL;

        
