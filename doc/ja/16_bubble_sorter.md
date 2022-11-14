
# VHDL で書くソーティングネットワーク(バブルソート)



## はじめに


筆者はかつて「VHDL で書くマージソーター」という題で幾つか記事を書きました。マージソーターを実装するに当たり、ソーティングネットワークを VHDL で書く必要がありました。これらの詳細は以下の記事を参照してください。


* [「VHDL で書くマージソーター(はじめに)」]
* [「VHDL で書くソーティングネットワーク(コアパッケージ)」]
* [「VHDL で書くソーティングネットワーク(バイトニックマージソート)」]
* [「VHDL で書くソーティングネットワーク(バッチャー奇偶マージソート)」]



この記事は、上の記事の続編で、[「VHDL で書くソーティングネットワーク(コアパッケージ)」]を使ってバブルソート回路を構成する方法を紹介します。




## バブルソートとは


バブルソート(bubble sort) は、隣り合う要素の大小を比較しながら整列させるソートアルゴリズムです。アルゴリズムが比較的単純で実装も容易ですが、最悪計算量がO(n\*\*2)と遅いため、一般にはマージソートなどより最悪時間計算量の小さな方法が利用されます。(出典:[https://wikipedia.org/wiki/Bubble_sort])。



以下に Python で記述したバブルソートの実装例を示します。(出典:[『Pythonで学ぶアルゴリズム　第17弾：並べ替え（バブルソート）』@Qiita](https://qiita.com/Yuya-Shimizu/items/99349001f0fccc0d8d41) )。


```Python:bubble_sort.py
def bubble_sort(data):
    for i in range(len(data)):
        for j in range(len(data) - i -1):
            if data[j] > data[j+1]: 
                data[j], data[j+1] = data[j+1], data[j] 
    return data
```




これをそのままソーティングネットワークにすると次のようになります。


![Fig.1 バブルソートのソーティングネットワーク例(最適化前)](image/16_bubble_sorter_1.jpg "Fig.1 バブルソートのソーティングネットワーク例(最適化前)")

Fig.1 バブルソートのソーティングネットワーク例(最適化前)

<br />



ただし、このままだとステージ数がコンパレーターの数と同じ数になってしまいす。ここでステージとは、ソーティングネットワークを並列処理可能な単位で分割したものです。

具体的には、要素数n としてステージ数は (n×(n-1)÷2) となり、O(n\*\*2)で増加します。そこで次の図のように並列処理できるステージをまとめてしまいます。この最適化によって、ステージ数は (n-1)+(n-2) になります。


![Fig.2 バブルソートのソーティングネットワーク例(最適化後)](image/16_bubble_sorter_2.jpg "Fig.2 バブルソートのソーティングネットワーク例(最適化後)")

Fig.2 バブルソートのソーティングネットワーク例(最適化後)

<br />


## バブルソートの VHDL 記述



### ソーティングネットワークの VHDL 記述



#### New_Network 関数


New_Network 関数は、バブルソートのソーティングネットワークに対応した Sorting_Network.Param_Type([「VHDL で書くソーティングネットワーク(コアパッケージ)」]参照)を生成します。 New_Network 関数は Bubble_Sort_Network パッケージにて定義しています。


```VHDL:src/main/vhdl/core/bubble_sort_network.vhd
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library Merge_Sorter;
use     Merge_Sorter.Sorting_Network;
package Bubble_Sort_Network is
    function   New_Network(
                  LO          :  integer;
                  HI          :  integer;
                  ORDER       :  integer
    )             return         Sorting_Network.Param_Type;
    function   New_Network(
                  LO          :  integer;
                  HI          :  integer;
                  ORDER       :  integer;
                  QUEUE       :  Sorting_Network.Queue_Param_Type
    )             return         Sorting_Network.Param_Type;
end Bubble_Sort_Network;

```





```VHDL:src/main/vhdl/core/bubble_sort_network.vhd
package body Bubble_Sort_Network is
    -- (前略) --
    function   New_Network(
                  LO          :  integer;
                  HI          :  integer;
                  ORDER       :  integer
    )             return         Sorting_Network.Param_Type
    is
        variable  network     :  Sorting_Network.Param_Type;
    begin
        network := Sorting_Network.New_Network(LO,HI,ORDER);
        bubble_sort(network, network.Stage_Lo, network.Lo, network.Hi);
        return network;
    end function;
    function   New_Network(
                  LO          :  integer;
                  HI          :  integer;
                  ORDER       :  integer;
                  QUEUE       :  Sorting_Network.Queue_Param_Type
    )             return         Sorting_Network.Param_Type
    is
        variable  network     :  Sorting_Network.Param_Type;
    begin
        network := New_Network(LO,HI,ORDER);
        Sorting_Network.Set_Queue_Param(network, QUEUE);
        return network;
    end function;
end Bubble_Sort_Network;
```





#### bubble_sort 関数


Bubble_Sort_Netowork パッケージボディに定義されたbubble_sort 関数は、前述の Python による実装でしめした bubble_sort に対応します。bubble_sort 関数を再帰的に呼び出しています。


```VHDL:src/main/vhdl/core/bubble_sort_network.vhd
package body Bubble_Sort_Network is
    -- (前略) --
    procedure bubble_sort(
        variable  NETWORK     :  inout Sorting_Network.Param_Type;
                  START_STAGE :  in    integer;
                  LO          :  in    integer;
                  HI          :  in    integer
    ) is
        variable  comp_stage  :        integer;
    begin
        if (HI - LO > 0) then
            comp_stage := START_STAGE;
            for net in HI-1 downto LO loop
                Sorting_Network.Add_Comparator(NETWORK, comp_stage, net, net+1, TRUE);
                if (NETWORK.Stage_Hi <  comp_stage) then
                    NETWORK.Stage_Hi := comp_stage;
                end if;
                comp_stage := comp_stage + 1;
            end loop;
            NETWORK.Stage_Size := NETWORK.Stage_Hi - NETWORK.Stage_Lo + 1;
            bubble_sort(NETWORK, START_STAGE + 2, LO + 1, HI);
        end if;
    end procedure;
    -- (後略) --
end Bubble_Sort_Network;
```





### バブルソートの VHDL 記述例


[「VHDL で書くソーティングネットワーク(コアパッケージ)」]で説明した Sorting_Network_Core に、前述で説明した New_Network関数で生成したソーティングネットワーク構成を示す定数を渡してバブルソート回路を構成した例を示します。


#### Entity 



```VHDL:src/main/vhdl/examples/bubble_sorter/bubble_sorter.vhd
library ieee;
use     ieee.std_logic_1164.all;
entity  Bubble_Sorter is
    generic (
        WORDS           :  integer :=  4;
        DATA_BITS       :  integer := 32;
        COMP_HIGH       :  integer := 32;
        COMP_LOW        :  integer :=  0;
        COMP_SIGN       :  boolean := FALSE;
        SORT_ORDER      :  integer :=  0;
        ATRB_BITS       :  integer :=  4;
        INFO_BITS       :  integer :=  1;
        QUEUE_SIZE      :  integer :=  0
    );
    port (
        CLK             :  in  std_logic;
        RST             :  in  std_logic;
        CLR             :  in  std_logic;
        I_DATA          :  in  std_logic_vector(WORDS*DATA_BITS-1 downto 0);
        I_ATRB          :  in  std_logic_vector(WORDS*ATRB_BITS-1 downto 0) := (others => '0');
        I_INFO          :  in  std_logic_vector(      INFO_BITS-1 downto 0) := (others => '0');
        I_VALID         :  in  std_logic;
        I_READY         :  out std_logic;
        O_DATA          :  out std_logic_vector(WORDS*DATA_BITS-1 downto 0);
        O_ATRB          :  out std_logic_vector(WORDS*ATRB_BITS-1 downto 0);
        O_INFO          :  out std_logic_vector(      INFO_BITS-1 downto 0);
        O_VALID         :  out std_logic;
        O_READY         :  in  std_logic;
        BUSY            :  out std_logic
    );
end Bubble_Sorter;

```



#### Architecture


[「VHDL で書くマージソーター(ワードの定義)」]で説明したパラメータを WORD_PARAM 定数に設定します。


```VHDL:src/main/vhdl/examples/bubble_sorter/bubble_sorter.vhd
library ieee;
use     ieee.std_logic_1164.all;
library Merge_Sorter;
use     Merge_Sorter.Word;
use     Merge_Sorter.Sorting_Network;
use     Merge_Sorter.Bubble_Sort_Network;
use     Merge_Sorter.Core_Components.Sorting_Network_Core;
architecture RTL of Bubble_Sorter is
    constant  WORD_PARAM    :  Word.Param_Type := Word.New_Param(DATA_BITS, COMP_LOW, COMP_HIGH, COMP_SIGN);
    signal    i_word        :  std_logic_vector(WORDS*WORD_PARAM.BITS-1 downto 0);
    signal    o_word        :  std_logic_vector(WORDS*WORD_PARAM.BITS-1 downto 0);
begin
```




入力された I_DATA と I_ATRB を前述の WARD_PARAM 定数で指定されたワード形式に変換します。


```VHDL:src/main/vhdl/examples/bubble_sorter/bubble_sorter.vhd
    process (I_DATA, I_ATRB)
        variable   data     :  std_logic_vector(DATA_BITS-1 downto 0);
        variable   atrb     :  std_logic_vector(ATRB_BITS-1 downto 0);
        variable   word     :  std_logic_vector(WORD_PARAM.BITS-1 downto 0);
    begin
        for i in 0 to WORDS-1 loop
            data := I_DATA((i+1)*DATA_BITS-1 downto i*DATA_BITS);
            atrb := I_ATRB((i+1)*ATRB_BITS-1 downto i*ATRB_BITS);
            word(WORD_PARAM.DATA_HI downto WORD_PARAM.DATA_LO) := data;
            word(WORD_PARAM.ATRB_NONE_POS    ) := atrb(0);
            word(WORD_PARAM.ATRB_PRIORITY_POS) := atrb(1);
            word(WORD_PARAM.ATRB_POSTPEND_POS) := atrb(2);
            i_word((i+1)*WORD_PARAM.BITS-1 downto i*WORD_PARAM.BITS) <= word;
        end loop;
    end process;

```




前節で説明した Bubble_Sort_Network.New_Network 関数を使ってバブルソートのソーティングネットワークを構築して Sorting_Network_Core に渡します。これにでバブルソートを行うソーティングネットワークが出来ます。


```VHDL:src/main/vhdl/examples/bubble_sorter/bubble_sorter.vhd
    CORE: Sorting_Network_Core
        generic map (
            NETWORK_PARAM   => Bubble_Sort_Network.New_Network(
                                   LO    => 0,
                                   HI    => WORDS-1,
                                   ORDER => SORT_ORDER,
                                   QUEUE => Sorting_Network.Constant_Queue_Size(QUEUE_SIZE)
                               ),
            WORD_PARAM      => WORD_PARAM      , -- 
            INFO_BITS       => INFO_BITS         -- 
        )                                        -- 
        port map (                               -- 
            CLK             => CLK             , -- In  :
            RST             => RST             , -- In  :
            CLR             => CLR             , -- In  :
            I_WORD          => i_word          , -- In  :
            I_INFO          => I_INFO          , -- In  :
            I_VALID         => I_VALID         , -- In  :
            I_READY         => I_READY         , -- Out :
            O_WORD          => o_word          , -- Out :
            O_INFO          => O_INFO          , -- Out :
            O_VALID         => O_VALID         , -- Out :
            O_READY         => O_READY         , -- In  :
            BUSY            => BUSY              -- Out :
        );
```




最後にソート結果を O_WORD と O_ATRB に変換して出力します。


```VHDL:src/main/vhdl/examples/bubble_sorter/bubble_sorter.vhd
    process (o_word)
        variable   data     :  std_logic_vector(DATA_BITS-1 downto 0);
        variable   atrb     :  std_logic_vector(ATRB_BITS-1 downto 0);
        variable   word     :  std_logic_vector(WORD_PARAM.BITS-1 downto 0);
    begin
        for i in 0 to WORDS-1 loop
            word := o_word((i+1)*WORD_PARAM.BITS-1 downto i*WORD_PARAM.BITS);
            data := word(WORD_PARAM.DATA_HI downto WORD_PARAM.DATA_LO);
            atrb    := (others => '0');
            atrb(0) := word(WORD_PARAM.ATRB_NONE_POS    );
            atrb(1) := word(WORD_PARAM.ATRB_PRIORITY_POS);
            atrb(2) := word(WORD_PARAM.ATRB_POSTPEND_POS);
            O_DATA((i+1)*DATA_BITS-1 downto i*DATA_BITS) <= data;
            O_ATRB((i+1)*ATRB_BITS-1 downto i*ATRB_BITS) <= atrb;
        end loop;
    end process;
end RTL;

```





## 参照



### 参考記事

* [「VHDL で書くマージソーター(はじめに)」]
* [「VHDL で書くマージソーター(ワードの定義)」]
* [「VHDL で書くソーティングネットワーク(コアパッケージ)」]
* [「VHDL で書くソーティングネットワーク(バイトニックマージソート)」]
* [「VHDL で書くソーティングネットワーク(バッチャー奇偶マージソート)」]
* [「VHDL で書くソーティングネットワーク(非対称マージソート)」]


### ソースコード

* https://github.com/ikwzm/Merge_Sorter/blob/1.4.1/src/main/vhdl/core/sorting_network.vhd
* https://github.com/ikwzm/Merge_Sorter/blob/1.4.1/src/main/vhdl/core/bubble_sort_network.vhd
* https://github.com/ikwzm/Merge_Sorter/blob/1.4.1/src/main/vhdl/examples/bubble_sorter/bubble_sorter.vhd


### 出典

* [https://wikipedia.org/wiki/Bubble_sort]
* [『Pythonで学ぶアルゴリズム　第17弾：並べ替え（バブルソート）』@Qiita](https://qiita.com/Yuya-Shimizu/items/99349001f0fccc0d8d41)


[「VHDL で書くマージソーター(はじめに)」]: ./01_introduction.md "「VHDL で書くマージソーター(はじめに)」"
[「VHDL で書くマージソーター(ワードの定義)」]: ./02_word_package.md "「VHDL で書くマージソーター(ワードの定義)」"
[「VHDL で書くマージソーター(ワード比較器)」]: ./03_word_compare.md "「VHDL で書くマージソーター(ワード比較器)」"
[「VHDL で書くソーティングネットワーク(コアパッケージ)」]: ./04_sorting_network.md "「VHDL で書くソーティングネットワーク(コアパッケージ)」"
[「VHDL で書くソーティングネットワーク(バイトニックマージソート)」]: ./05_bitonic_sorter.md "「VHDL で書くソーティングネットワーク(バイトニックマージソート)」"
[「VHDL で書くソーティングネットワーク(バッチャー奇偶マージソート)」]: ./06_oddeven_sorter.md "「VHDL で書くソーティングネットワーク(バッチャー奇偶マージソート)」"
[「VHDL で書くソーティングネットワーク(バブルソート)」]: ./16_bubble_sorter.md "「VHDL で書くソーティングネットワーク(バブルソート)」"
[「VHDL で書くソーティングネットワーク(非対称マージソート)」]: ./17_asymmetric_mergesorter.md "「VHDL で書くソーティングネットワーク(非対称マージソート)」"
[https://wikipedia.org/wiki/Bubble_sort]: https://wikipedia.org/wiki/Bubble_sort "https://wikipedia.org/wiki/Bubble_sort"
