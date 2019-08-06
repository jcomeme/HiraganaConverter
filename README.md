# HiraganaConverter

Convert sentence to hiragana!


## 複数行入力、縦書き（master）

![IMG_0980](https://user-images.githubusercontent.com/670343/62518553-d0c01380-b864-11e9-9a93-5790a2f7d7b1.jpg)
![IMG_0983](https://user-images.githubusercontent.com/670343/62518554-d0c01380-b864-11e9-85b1-3d30473d0842.jpg)

- 複数行が入力できる
- 縦書き本文にルビをつけて出力
- 小説家になろうのルビ書式（ `|対象文字《ルビ》` という書式）でユーザがルビを振っていたらそちらを優先
- [Yahooのルビ振りAPI](https://developer.yahoo.co.jp/webapi/jlp/furigana/v1/furigana.html)を利用





## 一行入力、横書き（normal-dev）

![IMG_0985](https://user-images.githubusercontent.com/670343/62518555-d0c01380-b864-11e9-9a4d-d4d43910d2d5.jpg)
![IMG_0986](https://user-images.githubusercontent.com/670343/62518556-d158aa00-b864-11e9-9228-1b84bdbe3134.jpg)

- 一行だけ入力できて、一行のラベルに出力。
- [Gooのひらがな化API](https://labs.goo.ne.jp/api/jp/hiragana-translation/)を利用

