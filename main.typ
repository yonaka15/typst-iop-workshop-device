#import "@preview/typewind:0.1.0": *
#import "@preview/gantty:0.2.0": gantt // https://typst.app/universe/package/gantty/
// #import "@preview/timeliney:0.2.1" //https://typst.app/universe/package/timeliney/
#import "@preview/cineca:0.5.0": * // https://typst.app/universe/package/cineca/
#import "@preview/cetz:0.3.4": canvas, draw, tree
#import "parts.typ": main_color, header_line, iop_color, header_page // https://cetz-package.github.io/docs/

#set text(lang: "ja", font: ("Noto Sans CJK JP", "Noto Sans JP"))
#set text(size: 18pt)
#set par(leading: 0.5em, spacing: 1.0em)
#set heading(numbering: "1.")
#show link: it => underline(text(fill: blue)[#it])
#show heading: it => [#v(0.3em)#it#v(0.3em)]

#set page(
  paper: "a4",
  flipped: true,
  margin: (x: 20mm, y: 10mm),
  footer: [
    #set text(size: 8pt)
    #align(center)[Copyright © 2025 PROMPT-X, Inc. All Rights Reserved.]
  ],
  background: [
    #place(
      top+right,
      dx: -10mm,
      dy: 5mm,
      image("./images/logo.png", height: 15mm)
    )
  ],
)

#include "title_page.typ"

#header_page([= 概要],[])

== 本講座の全容
#header_line
#v(20mm)
#align(center)[
  #set text(size: 24pt, fill: orange-400)
  温湿度データを計測するデバイスを製作し、\
  SAWACHIを経由してデータ取得とグラフ化を行います。
]
#figure(
  image("./images/Screenshot 2025-06-23 at 10.07.27.png"),
  caption: [SAWACHIを経由して温湿度データを取得し、グラフ化する]
)
#pagebreak()

#v(15mm)
#header_line
#v(5mm)
#align(center)[
  #figure(
  image("./images/Screenshot 2025-06-23 at 10.09.44.png", width: 80%),
  caption: "データを表示するダッシュボード「詳細分析画面」"
  )
]
#pagebreak()

== SAWACHIの仕組み
#header_line
#v(5mm)
#align(center)[
  #set text(size: 24pt)
  SAWACHIには用途別に2つのAPIが用意されています
]
#figure(
  image("./images/Screenshot 2025-06-23 at 10.17.01.png", width: 60%),
  caption: [IoPクラウド連携における開発範囲\
  出典: 【配布用】SAWACHI技術資料ライブラリ_API編\
  30_SAWACHI_デバイスAPIを活用した開発手法説明]
)
#align(left)[
  補足:\
  APIは、*Application Programming Interface*の略で、
  ソフトウェア同士が通信するための*インターフェース*です。
  *インターフェース*とは、*接点*や*境界*を意味します。
]
#pagebreak()

== 本講座の内容
#header_line
#v(5mm)
#align(center)[
  #set text(size: 24pt)
  *MQTT*と呼ばれる通信方式で温湿度データを送信します
]
#figure(
  image("./images/Screenshot 2025-06-23 at 10.24.08.png", width: 80%),
  caption: [温湿度データの送信は MQTT を使用します]
)
#pagebreak()

== 全体手順図
#header_line
#v(5mm)
#align(center)[
  #set text(size: 22pt)
  講座の前半でデバイスの製作を行い、後半にSAWACHIに接続します
]
#figure(
  image("./images/Screenshot 2025-06-23 at 10.37.51.png", width: 60%),
  caption: [講座の全体手順図]
)
#pagebreak()

== 本講座の難易度
#header_line
#v(5mm)
#align(center)[
  #set text(size: 24pt)
  後半にかけて難易度が高く感じられるかもしれません
]
#figure(
  image("./images/Screenshot 2025-06-23 at 10.37.36.png", width: 80%),
  caption: [講座の難易度]
)
#pagebreak()

== 事前準備の確認
#header_line
#v(70mm)
#align(center)[
  #set text(size: 24pt)
  事前準備は完了していますか？

  // TODO: correct the link
  #link(
    "https://ptk-y-nakahira.github.io/typst-iop-advance-materials/",
    "事前準備資料",
  )
]
#pagebreak()

== マイコンについて
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  === マイコンとは
  マイコンは、マイクロコントローラの略称で、
  コンピュータの機能を持つ小型の集積回路です。
  主に組み込みシステムやIoTデバイスで使用されます。
]
#figure(
  image("./images/Screenshot 2025-06-23 at 11.13.31.png", width: 80%),
  caption: [本講座でのマイコンの役割]
)
#pagebreak()

== Arduino と ESP32
#header_line
#v(20mm)
#align(left)[
  //#set text(size: 24pt)
  Arduino は専門家でなくても扱いやすいマイコンです。
  ArduinoIDEを使用して、簡単にプログラムを書いて動かすことができます。\
  ESP32 は、Wi-Fi や Bluetooth 機能を備えたArduinoよりさらに高性能なマイコンです。
  ESP32 は Arduino IDE でプログラムできます
]
#figure(
  image("./images/Screenshot 2025-06-23 at 11.09.44.png", width: 80%),
  caption: [Arduino と ESP32]
)
#pagebreak()

== Arduino IDE とは
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  Arduino IDE は、Arduino や ESP32 のプログラムを\
  書くための統合開発環境です。\
  プログラムを書いて、マイコンにアップロードすることができます。\
  C言語に似たArduino言語を使用して、マイコンを制御するプログラムを書くことができます。
]
#figure(
  image("./images/Screenshot 2025-06-23 at 11.32.50.png", width: 50%),
  caption: [Arduino IDE の画面]
)
#pagebreak()

== ESP32を使用したLED点灯
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  === ESP32を使用したLED点灯
  Arduino IDE を使用して、ESP32 の GPIO ピンを制御し、LED を点灯させるプログラムを書きます。
  / GPIO ピン: General Purpose Input/Output の略で、マイコンの入出力ピンのことです。
]
#figure(
  image("./images/Screenshot 2025-06-23 at 11.36.14.png", width: 60%),
  caption: [LEDが点灯している様子 (通称Lチカ)]
)
// ADDED LINK
#align(center)[
  #link("https://iop-workshop.vercel.app/0001_led", "LED点灯のサンプルコードはこちら")
]
#pagebreak()

== ブレッドボードについて
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  === ブレッドボードについて
  ブレッドボードは、電子回路を組み立てるための\
  プロトタイピングボードです。\
  はんだ付けせずに部品を差し込むだけで回路を組むことができます。\
  GPIOピンを使用して、LEDやセンサーなどの部品を接続するのに便利です。
]
#figure(
  image("./images/Screenshot 2025-06-23 at 11.53.55.png", width: 50%),
  caption: [ブレッドボード: 背面を見ると、内部の配線がわかります。]
)
#align(center)[
  #set text(size: 20pt, fill: orange-500)
  同じ番号のA-F列、G−L列はそれぞれ内部で導通しています。\
  *+*, *-* は電源用の接続です。横一列に導通しています。
]
#pagebreak()

== 使用する部品
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  === 使用する部品
  本講座では、以下の部品を使用します。
]
#align(center)[
  #grid(align:left, columns: 2, column-gutter: 5mm, [
  - ESP32-WROVER-E
  - 温湿度センサー (AE-SHT31)
  - ブレッドボード
    ],[
  - 抵抗
  - LED
  - USBケーブル (Type-A)
  - ジャンパー線
])]
#figure(
  image("./images/Screenshot 2025-06-23 at 12.08.47.png", width: 50%),
  caption: [使用する部品]
)
#pagebreak()

== ブレッドボードの番号
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  ブレッドボードの穴には番号が振られています。\
  行はAからLまで、列は1から30までです。\
  アルファベットと数字を組み合わせて、
  各穴を特定します。\
]
#figure(
  image("./images/Screenshot 2025-06-23 at 12.16.42.png", width: 40%),
  caption: [ブレッドボードの指定例]
)
#v(10mm)
#align(center)[
  #set text(size: 18pt, fill: orange-500)
  これ以降の結線図では、アルファベットと数字を組み合わせて位置を表現します。
]
#pagebreak()

#header_page([= LED点灯],[プログラム不要でLEDを点灯させてみましょう])

== LED点灯
#header_line
#v(5mm)
#align(left)[
  #set text(size: 14pt)
  まず*プログラム不要*でLEDを点灯させる回路を組みます。
  ブレッドボードで、LEDと抵抗を接続します。\
]
#figure(
  image("./images/Artboard 1.png", width: 60%),
  caption: [LED点灯の結線図]
)
#v(10mm)
#align(left)[
  #set text(size: 14pt)
  LEDの長い方の足がアノード、短い方の足がカソードです。\
  アノードはプラス側、カソードはマイナス側に接続します。\
  #set text(size: 16pt, fill: orange-500)
  USBケーブルを接続して、ESP32に電源を供給するとLEDが点灯します。\
]
#pagebreak()

== ブレッドボードへの取り付け
#header_line
#v(40mm)
#align(left)[
  //#set text(size: 24pt)
  ブレッドボードにESP32を取り付ける際は、\
  向きをよく確認し、奥までしっかりと差し込みます。\
]

#figure(
  image("./images/Screenshot 2025-06-23 at 13.29.30.png", width: 60%),
  caption: [ブレッドボードにESP32を取り付ける]
)
#pagebreak()

== ブレッドボードの利点
#header_line
#v(20mm)
#align(left)[
  //#set text(size: 24pt)
  ブレッドボードを使用する利点は、\
  *はんだ付けせずに*部品を差し込むだけで回路を組むことができる点です。\
  回路の変更や修正が容易で、試作や実験に適しています。\
  また、部品の交換も簡単に行えます。
]
#figure(
  image("./images/Screenshot 2025-06-23 at 13.31.26.png", width: 30%),
  caption: [はんだ付け: ブレッドボードの利点は、\
  はんだ付けせずに部品を差し込むだけで回路を組むことができる点です。]
)
#pagebreak()

== LEDの点灯の様子
#header_line
#v(5mm)
#align(center)[
  #set text(size: 24pt)
  *LEDが点灯しましたか?*
]
#figure(
  image("./images/IMG_1765.jpg", fit:"cover", width: 80%, height: 100mm),
  caption: [LEDが点灯している様子]
)
#pagebreak()


#v(15mm)
#header_line
#v(50mm)
#align(center)[
  #set text(size: 24pt, fill: orange-500)
  LEDは点灯しましたか?\
  #v(10mm)
  次はいよいよ*Arduino IDE*を使用して、\
  プログラムを書いてLEDを点滅させます。
]
#pagebreak()

#header_page([= LED点滅],[プログラムを書いてLEDを点滅させてみましょう])

== Arduino IDEのライセンスについて
#header_line
#v(40mm)
#align(left)[
  //#set text(size: 24pt)
  === GPL ライセンス v2.0
  *Arduino IDE*は、オープンソースのソフトウェアであり、\
  GNU General Public License (GPL) バージョン2に基づいて配布されています。\
  GPLライセンスは、*ソフトウェアの自由な使用、コピー、変更を許可*しますが、\
  ソフトウェアを再配布する場合は、同じライセンス条件を適用する必要があります。\
  (コピーレフト)\
]
#v(10mm)
#align(center)[
  #set text(size: 18pt, fill: orange-500)
  *GPLライセンスのソフトウェアにはソースコードの公開が求められます。*
]

#pagebreak()

== 様々なライセンス
#header_line
#v(10mm)
#align(left)[
  //#set text(size: 24pt)
  今回使用するソフトウェアやライブラリそれぞれにライセンスがあります。
]
#align(center)[
  #block[
    #align(left)[
  / Arduino IDE: GPL v2.0
  / espressif/arduino-esp32: LGPL v2.1
  / knolleary/pubsubclient: MIT License
  / bblanchon/ArduinoJson: MIT License
]]]
#v(5mm)
#align(center)[
  #set text(size: 18pt, fill: orange-500)
  基本的に制約の強い規約に従ってライセンスが適用されます。\
  今回はGPL v2.0 が適用されることになります。\
]
#v(10mm)
#align(left)[
  #set text(size: 20pt, fill: orange-500)
  実際に商用利用で組み込み機器を開発する場合は、
  ライセンスの内容をよく確認する必要があります。\
  #v(10mm)
  #set text(size: 20pt, fill: red-500)
  #set align(center)
  法的な問題を避けるために、
  専門家に相談することをお勧めします。\
]

#pagebreak()

== LED点滅
#header_line
#v(15mm)
#align(left)[
  //#set text(size: 24pt)
  Arduino IDEを使用して、ESP32のGPIOピンを制御し、LEDを点滅させるプログラムを書きます。\
  下記のように結線を行います。\
]
#figure(
  image("./images/Screenshot 2025-06-23 at 12.19.37.png", width: 60%),
  caption: [LED点滅の結線図]
)
#v(10mm)
#align(left)[
  #set text(size: 18pt, fill: orange-500)
  #set align(center)
  ESP32の32番ピンがLEDのアノードに接続されていることに注目してください
]

#pagebreak()

#v(15mm)
#header_line
#v(5mm)
#align(center)[
  #set text(size: 24pt)
  *正しく配線できていますか?*
]

#figure(
  image("./images/Screenshot 2025-06-23 at 13.14.34.png", width: 80%),
  caption: [結線の写真]
)

== Arduino IDEでプログラムを書く
#header_line
#v(20mm)
#grid(columns: (1fr, 1fr),
[#align(left)[
  //#set text(size: 24pt)
  === Arduino言語の特徴
  Arduino言語は、C言語に似た構文を持つプログラミング言語です。\
  2つの主な関数、*`setup()`* と *`loop()`* を使用してプログラムを構成します。
  #v(10mm)
  setup():\
  プログラムの初期化を行う関数で、マイコンが起動したときに一度だけ実行されます。\
  #v(5mm)
  loop():\
  setup()関数の後に実行される関数で、\
  マイコンが起動している間、繰り返し実行されます。\
]],[
  #figure(
    image("./images/Screenshot 2025-06-23 at 13.39.27.png", width: 80%),
    caption: [Arduino IDEのコードエディタ]
  )
])
#pagebreak()

#include "arduino-ide-sample-sketch.typ"
#include "arduino-ide-sketch-ops.typ"
#include "arduino-ide-ui.typ"
#include "arduino-ide-setup.typ"
#include "arduino-ide-setup.typ"
#include "arduino-ide-ui.typ"
#include "arduino-ide-sketch-ops.typ"
#include "arduino-ide-sample-sketch.typ"

== LED点滅のプログラム
#header_line
#v(20mm)
#align(center)[
  #link("https://iop-workshop.vercel.app/0001_led", "LED点滅のサンプルコードはこちら")
]
#pagebreak()

#header_page([= 温湿度の取得],[])

== 使用する機器
#header_line
#v(10mm)
#align(center)[#grid(columns: (1fr, 1fr), 
  align(left)[
    - ESP32-WROVER-E
    - 温湿度センサー (AE-SHT31)
    - ブレッドボード
  ],
  align(left)[
    - USBケーブル (Type-A)
    - ジャンパー線
  ]
)]
#figure(
  image("./images/Screenshot 2025-06-23 at 13.48.54.png", width: 80%),
  caption: [使用する機器]
)
#pagebreak()

== ESP32と温湿度センサーの接続
#header_line
#v(10mm)
#figure(
  image("./images/Screenshot 2025-06-23 at 14.18.34.png", width: 80%),
  caption: [結線図]
)
#pagebreak()

== 結線
#header_line
#v(10mm)
#figure(
  image("./images/Screenshot 2025-06-23 at 14.20.29.png", width: 80%),
  caption: [結線の写真]
)
#pagebreak()

== SHT31のアドレス確認
#header_line
#v(10mm)
#align(left)[
  //#set text(size: 24pt)
  もし配線が間違っていないのに接続できない場合は、
  SHT31のアドレスを確認してください。\
]
#figure(
  image("./images/Screenshot 2025-06-23 at 14.33.12.png", width: 60%),
  caption: [SHT31のアドレス確認]
)
#pagebreak()

== シリアルモニタで確認
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  Arduino IDEの*シリアルモニタ*を使用して、\
  温湿度センサーからのデータを確認します。\
  シリアルモニタは、Arduino IDEのツールメニューから開くことができます。\
]
#figure(
  image("./images/Screenshot 2025-06-23 at 14.35.00.png", width: 80%),
  caption: [シリアルモニタの画面]
)
#pagebreak()

== 温湿度取得のプログラム
#header_line
#v(20mm)
#align(center)[
  #link("https://iop-workshop.vercel.app/0002_sht31", "温湿度取得のサンプルコードはこちら")
]
#pagebreak()

#header_page([= MQTT通信],[IoTに適した通信方式を学びます])

== HTTP通信とは異なる方式
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  IoPクラウドでは、環境測定装置とクラウド側の通信の仕組みを総じて「デバイスAPI」と呼んでいます。
  一般的な*「HTTP通信によるAPI」とは異なる方式*が採用されています。
]
#figure(
  image("./images/Screenshot 2025-06-23 at 14.37.18.png", width: 70%),
  caption: [デバイス開発用途のAPI について\
  出典: 【配布用】SAWACHI技術資料ライブラリ_API編\
  30_SAWACHI_デバイスAPIを活用した開発手法説明]
)
#pagebreak()

== MQTT通信
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  MQTTは、*Message Queuing Telemetry Transport*の略で、
  軽量なメッセージングプロトコルです。Brokerによる双方向通信が可能で、*IoTデバイスとクラウド間の通信に適しています*。
]
#figure(
  image("./images/Screenshot 2025-06-23 at 14.42.59.png", width: 60%),
  caption: [IoPクラウドが MQTT を採用する理由\
    出典: 【配布用】SAWACHI技術資料ライブラリ_API編\
  30_SAWACHI_デバイスAPIを活用した開発手法説明]
)
#pagebreak()

== MQTTの構成
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  環境測定装置はPublisherとしてSAWACHIの提供するBrokerに接続します。
  *`topic`*、*`broker`*などの用語がわからなくなったらこの図を思い出してください。
]
#figure(
  image("./images/Screenshot 2025-06-23 at 14.55.04.png", width: 60%),
  caption: [Pub/Sub 方式の MQTT 通信を採用\
    出典: 【配布用】SAWACHI技術資料ライブラリ_API編\
  30_SAWACHI_デバイスAPIを活用した開発手法説明]
)
#pagebreak()

== MQTT送信
#header_line
#v(5mm)
#align(center)[
  #link("https://iop-workshop.vercel.app/0004_mqtt_pub", "MQTT送信テストのコード") \
]
#pagebreak()

== MQTT受信
#header_line
#v(5mm)
#align(center)[
  #link("https://iop-workshop.vercel.app/0005_mqtt_sub", "MQTT受信テストのコード") \
]
#pagebreak()

== （補足）ボタンを使ったMQTT送信デモ
#header_line
#v(5mm)
#align(center)[
  #link("https://iop-workshop.vercel.app/0006_button", "ボタンを使ったMQTT送信デモ")
]
#pagebreak()

== Qsuプロトコル
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  SAWACHIでは、環境測定装置とクラウド側の通信のために\
  JSONベースの*Qsuプロトコル*を策定しています。\
  プロトコルとは、通信のルールや手順を定めたものです。
]
#figure(
  image("./images/Screenshot 2025-06-23 at 15.29.22.png", width: 60%),
  caption: [デバイス API のデータ連携の概要\
    出典: 【配布用】SAWACHI技術資料ライブラリ_API編\
  30_SAWACHI_デバイスAPIを活用した開発手法説明]
)
#pagebreak()

== Qsuプロトコル
#header_line
#v(5mm)
#align(center)[
  #link("https://iop-workshop.vercel.app/0007_qsu", "Qsuプロトコルでのデータ送信")
]

#pagebreak()

#header_page([= SAWACHIでのデータ確認],[詳細分析画面＝モデルメソッドを使用してデータを確認します])

== データの送信のプログラム
#header_line
#v(5mm)
#align(center)[
  #link("https://iop-workshop.vercel.app/0008_sawachi", "SAWACHIへのデータ送信")
]
#pagebreak()

== 詳細分析画面へのアクセス
#header_line
#v(5mm)
#align(left)[
  SAWACHIの詳細分析画面にアクセスするには、\
  ブラウザで以下のURLを開きます。\
  #v(10mm)
  // TODO: correct URL
  #link("https://sawachi.iot-community.jp/analysis", "詳細分析画面")
]
#figure(
  image("./images/Screenshot 2025-06-23 at 16.17.40.png", width: 80%),
  caption: [詳細分析画面のログイン画面]
)
#pagebreak()

== データの確認
#header_line
#v(30mm)
#align(left)[
  今回は表示に必要な設定を既に行っています。\
  #set text(size: 20pt, fill: orange-500)
  データが確認できれば、今回の講座は成功です!\
]
#figure(
  image("./images/Screenshot 2025-06-23 at 16.20.05.png", width: 80%),
  caption: [詳細分析画面のデータ表示例]
)

