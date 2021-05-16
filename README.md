NDC Recommender
====

WebページのタイトルとDescriptionを元に、日本十進分類法(NDC)での分類を推測します。
NDCの推測には、[NDC Predictor](https://lab.ndl.go.jp/ndc/)  を使用しています。

## Requirement

 * rubyで動作します。
 * metainspector が必要です。

## Usage

```shell
$ ruby ndc_recommender.rb {URI}
```

### sample

```shell
$ ruby ndc_recommender.rb https://www.naro.go.jp/laboratory/carc/
ページタイトル:
中日本農業研究センター | 農研機構
Description:
中日本農業研究センターでは、本州中央地域(関東・東海・北陸)の農業発展のため、多くの専門分野を結集した総合研究を展開し、新たな米政策に対応した水田の高度利用や地域バイオマスの有効利用など、新技術体系の開発を行います。また、新技術開発の基盤となる専門研究や土壌肥料、病害虫・雑草防除など環境保全型農業生産のための専門研究を行います。

NDC predicter による候補：
615 / 作物栽培．作物学
613 / 農業基礎学
616 / 農業--食用作物
$
```

## ToDo

 * もうちょっとコードをエレガントにしたい。
 * オプション指定で、解析対象を タイトル＋Description とタイトルのみ、Descriptionのみ、とか切り替えたい。
 * CSVファイルからのURI読み込み→結果をCSV出力、などできれば。

## Lisence

CC-BY

## Author

Takanori Hayashi
