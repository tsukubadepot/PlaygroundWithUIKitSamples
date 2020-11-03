# PlaygroundWithUIKitSamples
Swift Playground で UIKit の部品や外部フレームワークを使うためのサンプルです。

Some samples to use UIKits and other frameworks in the Playground.swif

- Add UITableView and UIButton on the view controller running on the playground
- Instantiate new View Controller and present demonstration
- Using third party frameworks, such as Alamofire, RealmSwift, PKHUD and so on, in the playground

Supplimental English instructions will be added step by step.

Playground でも UIKIt の部品や Alamofire などの外部フレームワークを使ったインタラクティブなプロトタイプを作成することが可能です。
普通に ViewController を作成し、シミュレータで動作させるよりも立ち上げ時間が少ないことが多いため、ごく初期のプロトタイプ作成には有効かもしれません。

UIKit だけを使うのであれば、普通に Playground をするだけで利用可能なのですが、外部フレームワークを import する場合には

- まず一つプロジェクトを作り、プロジェクトを閉じる
- Podfile に取り込みたいフレームワークを追加する
- `pod install` でインストールしてから `.xcworkspace` を起動する。
- Playground をプロジェクトに追加する作業が必要です。

という作業が必要です。

外部ワークフレームを撮り込んだ　Playground を作る方法については、以下のリンクをご参照ください（見るまでもないほど簡単です）。
- [Playground でサードパーティーのフレームワークを使う](https://www.tsukubadepot.net/archives/670)

## UITableViewWithButton.playground
![画像1](/images/TableViewTest.png)

UITableView と UIButton を各一個ずつ配置しただけのサンプルです。
Playground での実行ですが、AutoLayout を使うことができます。
また、ボタン操作に応じたコンテンツの変更など、動的なサンプルを作ることも可能です。

画面下部の **[Change Value]** ボタンを押すと UITableView のセルに表示された数字が更新されます。

## InstantiateNewViewController.playground
![画像2](/images/TransitionTest.png)

一つの ViewController だけでなく、新しい ViewController をインスタンス化し、表示させるサンプルです。

![動画1](/images/Transition.gif)

このサンプルでは、セルを選択すると設定したトランジッションに応じて新しい ViewController を表示し、セルに表示されていた値を表示します（いわゆる直渡し）。

もちろん、`dismiss` させることも可能です。

## AlamofireTest.playground
![画像3](/images/AlamofireTest.png)

外部フレームワークとして、Alamofire と PKHUD を使ったサンプルです。

![動画2](/images/Alamofire.gif)

実行前に Xcode を終了させておき、

```
pod install
```

で実行に必要となるフレームワークを取り込んでおく必要があります。
また、Xcode を起動した直後はこれらのフレームワークをコンパイルしていますので、コンパイルが終了するまでは Playground を実行することができません（実行しても、フレームワークが無いと怒られます）。

画面上部の UITextField に入力した内容に応じて GitHub の API を叩き、検索結果を表示させます。

API を叩く部分に [Alamofire](https://github.com/Alamofire/Alamofire)、Heads Up Display として [PKHUD](https://github.com/pkluz/PKHUD) を使っています。

通常はここまで作る必要はありませんが、たとえば Alamofire や `URLSession` を使ったデータのやり取りのサンプルを作りたい場合に便利かもしれません。
