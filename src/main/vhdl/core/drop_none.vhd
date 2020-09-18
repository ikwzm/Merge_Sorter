-----------------------------------------------------------------------------------
--!     @file    drop_none.vhd
--!     @brief   Merge Sorter Drop None Module :
--!     @version 0.3.0
--!     @date    2020/9/17
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
library Merge_Sorter;
use     Merge_Sorter.Word;
entity  Drop_None is
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
end Drop_None;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
library PipeWork;
use     PipeWork.Components.REDUCER;
architecture RTL of Drop_None is
    constant  DATA_WORD_LO_POS  :  integer := 0;
    constant  DATA_WORD_HI_POS  :  integer := DATA_WORD_LO_POS + WORD_PARAM.BITS - 1;
    constant  DATA_INFO_LO_POS  :  integer := DATA_WORD_HI_POS + 1;
    constant  DATA_INFO_HI_POS  :  integer := DATA_INFO_LO_POS + INFO_BITS - 1;
    constant  DATA_LO_POS       :  integer := DATA_WORD_LO_POS;
    constant  DATA_HI_POS       :  integer := DATA_INFO_HI_POS;
    constant  DATA_BITS         :  integer := DATA_HI_POS - DATA_LO_POS + 1;
    signal    i_strb            :  std_logic_vector(0 downto 0);
    signal    i_data            :  std_logic_vector(DATA_BITS-1 downto 0);
    signal    o_data            :  std_logic_vector(DATA_BITS-1 downto 0);
begin
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    Q: REDUCER                               -- 
        generic map (                        -- 
            WORD_BITS       => DATA_BITS,    --
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
            I_DATA          => i_data      , -- In  :
            I_STRB          => i_strb      , -- In  :
            I_DONE          => I_LAST      , -- In  :
            I_VAL           => I_VALID     , -- In  :
            I_RDY           => I_READY     , -- Out :
            O_DATA          => o_data      , -- Out :
            O_DONE          => O_LAST      , -- Out :
            O_VAL           => O_VALID     , -- Out :
            O_RDY           => O_READY       -- In  :
        );
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    i_strb <= "1" when (I_WORD(WORD_PARAM.ATRB_NONE_POS) = '0') else "0";
    i_data(DATA_WORD_HI_POS downto DATA_WORD_LO_POS) <= I_WORD;
    i_data(DATA_INFO_HI_POS downto DATA_INFO_LO_POS) <= I_INFO;
    O_WORD <= o_data(DATA_WORD_HI_POS downto DATA_WORD_LO_POS);
    O_INFO <= o_data(DATA_INFO_HI_POS downto DATA_INFO_LO_POS);
end RTL;
