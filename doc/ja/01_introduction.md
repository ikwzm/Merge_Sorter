
# VHDL で書くマージソーター(はじめに)



## はじめに


[アダプティブコンピューティング研究推進体(ACRi)] にて「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化」という記事が投稿されています。

*  [「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化(1)」] 
*  [「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化(2)」] 
*  [「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化(3)」] 
*  [「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化(4)」] 
*  [「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化(5)」] 



筆者はここに書かれているアイデアやアルゴリズムに興味を持ち、勝手ながらVHDL で実装して Ultra96-V2で実行してみました。VHDL のソースコードおよび Ultra96-V2 で動作する FPGA ビットストリームファイルとテストプログラムは GitHub にて公開しています。

*  https://github.com/ikwzm/Merge_Sorter
*  https://github.com/ikwzm/ArgSort-Ultra96
*  https://github.com/ikwzm/ArgSort-Kv260



ここでは VHDL でどのように実装したかを、いくつかにわけて紹介します。



なお、あくまでもこれらの基本的なアイデアは 「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化」を元にしたものです。これらのアイデアを記事として公開してくださった方々に感謝します。




## お品書き


1. はじめに (この記事)
2. [ワードの定義]
3. [ワード比較器]
4. [ソーティングネットワーク(コアパッケージ)]
5. [ソーティングネットワーク(バイトニックマージソート)]
6. [ソーティングネットワーク(バッチャー奇偶マージソート)]
7. [シングルワード マージソート ノード]
8. [マルチワード マージソート ノード]
9. [マージソート ツリー]
10. [端数ワード処理]
11. [ストリーム入力]
12. [ストリームフィードバック]
13. [ArgSort]
14. [ArgSort-Ultra96]
15. [ArgSort-Kv260]


## 参照



### ACRi


1. [アダプティブコンピューティング研究推進体(ACRi)]
2. [「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化(1)」] 
3. [「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化(2)」] 
4. [「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化(3)」] 
5. [「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化(4)」] 
6. [「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化(5)」] 


### GitHub


7. https://github.com/ikwzm/Merge_Sorter
8. https://github.com/ikwzm/ArgSort-Ultra96
9. https://github.com/ikwzm/ArgSort-Kv260
10. https://github.com/ikwzm/ZynqMP-FPGA-Linux
11. https://github.com/ikwzm/ZynqMP-FPGA-Ubuntu20.04


[はじめに]: ./01_introduction.md "はじめに"
[ワードの定義]: ./02_word_package.md "ワードの定義"
[ワード比較器]: ./03_word_compare.md "ワード比較器"
[ソーティングネットワーク(コアパッケージ)]: ./04_sorting_network.md "ソーティングネットワーク(コアパッケージ)"
[ソーティングネットワーク(バイトニックマージソート)]: ./05_bitonic_sorter.md "ソーティングネットワーク(バイトニックマージソート)"
[ソーティングネットワーク(バッチャー奇偶マージソート)]: ./06_oddeven_sorter.md "ソーティングネットワーク(バッチャー奇偶マージソート)"
[シングルワード マージソート ノード]: ./07_merge_sort_node_single.md "シングルワード マージソート ノード"
[マルチワード マージソート ノード]: ./08_merge_sort_node_multi.md "マルチワード マージソート ノード"
[マージソート ツリー]: ./09_merge_sort_tree.md "マージソート ツリー"
[端数ワード処理]: ./10_merge_sort_core_1.md "端数ワード処理"
[ストリーム入力]: ./11_merge_sort_core_2.md "ストリーム入力"
[ストリームフィードバック]: ./12_merge_sort_core_3.md "ストリームフィードバック"
[ArgSort]: ./13_argsort.md "ArgSort"
[ArgSort-Ultra96]: https://github.com/ikwzm/ArgSort-Ultra96/blob/1.2.1/doc/ja/argsort-ultra96.md "ArgSort-Ultra96"
[ArgSort-Kv260]: https://github.com/ikwzm/ArgSort-Kv260/blob/1.2.1/doc/ja/argsort-kv260.md "ArgSort-Kv260"
[ACRi]: https://www.acri.c.titech.ac.jp/wp "アダプティブコンピューティング研究推進体(ACRi)"
[アダプティブコンピューティング研究推進体(ACRi)]: https://www.acri.c.titech.ac.jp/wp "アダプティブコンピューティング研究推進体(ACRi)"
[「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化(1)」]: https://www.acri.c.titech.ac.jp/wordpress/archives/132 "「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化(1)」"
[「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化(2)」]: https://www.acri.c.titech.ac.jp/wordpress/archives/501 "「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化(2)」"
[「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化(3)」]: https://www.acri.c.titech.ac.jp/wordpress/archives/2393 "「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化(3)」"
[「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化(4)」]: https://www.acri.c.titech.ac.jp/wordpress/archives/3888 "「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化(4)」"
[「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化(5)」]: https://www.acri.c.titech.ac.jp/wordpress/archives/4713 "「FPGAを使って基本的なアルゴリズムのソーティングを劇的に高速化(5)」"
