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

#include "title_page.typ" // This will be updated later

#header_page([= 概要],[])

== 本講座のゴール
#header_line
#v(20mm)
#align(center)[
  #set text(size: 24pt, fill: orange-400)
  温湿度データを計測するデバイスを製作し、\
  取得したデータをクラウドで可視化します。
]
#figure(
  image("./images/Screenshot 2025-06-23 at 10.07.27.png"),
  caption: [自作デバイスで取得した温湿度データをクラウドで可視化する]
)
#pagebreak()

#v(15mm)
#header_line
#v(5mm)
#align(center)[
  #figure(
  image("./images/Screenshot 2025-06-23 at 10.09.44.png", width: 80%),
  caption: "完成イメージ：リアルタイムに更新されるデータダッシュボード"
  )
]
#pagebreak()

== なぜMQTT？ 現場で選ばれる通信技術
#header_line
#v(5mm)
#align(center)[
  #set text(size: 24pt)
  IoTの現場では、HTTPよりMQTTが適している場面が多くあります
]
#figure(
  image("./images/Screenshot 2025-06-23 at 10.17.01.png", width: 60%),
  caption: [本講座で学ぶ技術スタックの全体像]
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
  caption: [温湿度データの送信には、軽量なMQTTプロトコルを利用します]
)
#pagebreak()

== 全体手順図
#header_line
#v(5mm)
#align(center)[
  #set text(size: 22pt)
  講座の前半でデバイスの製作を行い、後半にクラウドへ接続します
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

  #link(
    "https://yonaka15.github.io/iop-workshop-device-codes/prep.html",
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
  #link("https://yonaka15.github.io/iop-workshop-device-codes/0001_led", "LED点灯のサンプルコードはこちら")
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
  caption: [はんだ付け: 上手なはんだ付けには熟練の技術が必要です。\
  ブレッドボードの利点は、
  はんだ付けせずに部品を差し込むだけで\
  回路を組むことができる点です。]
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
#pagebreak()

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

== ボード設定の確認
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  Arduino IDEでESP32を使用するためには、
  ボードの設定を確認する必要があります。\
  ボードの設定は、*ツール*メニューから行います。\
  #v(10mm)
  *ボード*メニューから、使用するESP32 Wrorver Moduleを選択します。\
]
#figure(
  image("./images/image (3).png", width: 50%),
  caption: [Arduino IDEのボード設定]
)
#align(left)[
  もしボードの設定が表示されない場合は、
  *ツール*メニューから*ボードマネージャー*を開き、
  ESP32のボードをインストールしてください。\
  #link(
    "https://yonaka15.github.io/iop-workshop-device-codes/prep.html",
    "事前準備資料",
  )
]
#pagebreak()

== シリアルポートの設定
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  Arduino IDEでESP32を使用するためには、
  シリアルポートの設定を確認する必要があります。
  シリアルポートの設定は、*ツール*メニューから行います。\
  *シリアルポート*メニューから、ESP32が接続されているポートを選択します。(COM3)\
]
#figure(
  image("./images/image (4).png", width: 40%),
  caption: [Arduino IDEのシリアルポート設定]
)
#align(left)[
  もしシリアルポートの設定が表示されない場合は、
  USBケーブルが正しく接続されているか確認してください。
  また、ドライバが正しくインストールされているかも確認してください。\
]
#pagebreak()

== LED点滅のプログラム
#header_line
#v(20mm)
#align(left)[
  //#set text(size: 24pt)
  Arduino IDEで、ESP32のGPIOピンを制御し、LEDを点滅させるプログラムです。\
  以下のコードをArduino IDEにコピーしてください。\
  #v(10mm)
  *`setup()`*関数で、GPIOピンのモードを設定し、\
  *`loop()`*関数で、LEDを点灯・消灯させる処理を繰り返します。\
]
#v(20mm)
#align(center)[
  #link("https://yonaka15.github.io/iop-workshop-device-codes/0001_led", "LED点滅のサンプルコードはこちら")
]
#pagebreak()

== プログラムのアップロード
#header_line
#v(10mm)
#align(left)[
  //#set text(size: 24pt)
  プログラムを書いたら、*書き込み*ボタンをクリックして、ESP32にプログラムをアップロードします。\
  アップロードが完了すると、LEDが点滅するはずです。\
]
#figure(
  image("./images/image (5).png", width: 60%),
  caption: [Arduino IDEの書き込みボタン(→のアイコン)]
)
#v(20mm)
#align(left)[
  #set text(size: 18pt, fill: orange-500)
  書き込みに失敗する場合、ユーザー名に全角文字が含まれていることが原因の可能性があります。
  可能であれば半角英数字のみのユーザー名を使用してください。\
]

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

== 温湿度取得のプログラム
#header_line
#v(10mm)
#align(left)[
  //#set text(size: 24pt)
  温湿度センサーからデータを取得するプログラムです。\
  以下のコードをArduino IDEにコピーしてください。\
  #v(10mm)
  *`setup()`*関数で、I2C通信の初期化とセンサーの初期化を行い、\
  *`loop()`*関数で、温湿度データを取得してシリアルモニタに出力します。\
]
#v(20mm)
#align(center)[
  #link("https://yonaka15.github.io/iop-workshop-device-codes/0002_sht31", "温湿度取得のサンプルコードはこちら")
]
#pagebreak()


== シリアルモニタとは
#header_line
#v(10mm)
#align(left)[
  //#set text(size: 24pt)
  シリアルモニタは、Arduino IDEの一部で、\
  マイコンとPC間の*シリアル通信*を行うためのツールです。\
  シリアルモニタを使用して、マイコンからの情報やセンサーデータを確認できます。\
  シリアルモニタは、*ツール*メニューから開くことができます。\
]
#v(10mm)
#figure(
  image("./images/serial_monitor.png", width: 60%),
  caption: [ツールメニューからシリアルモニタを選択]
)
#pagebreak()

== ボーレート
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  シリアルモニタを使用する際は、*ボーレート*を設定する必要があります。\
  ボーレートは、シリアル通信の速度を表す単位です。\
  *115200bps (ビット/秒)* を使用してください。\
  シリアルモニタの右下にあるボーレートのドロップダウンメニューから設定できます。\
]
#v(10mm)
#figure(
  image("./images/set_baud_rate.png", width: 60%),
  caption: [シリアルモニタのボーレート設定]
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

#header_page([= MQTT通信],[IoTに適した通信方式を学びます])

== HTTP vs MQTT: なぜMQTTなのか？
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  Webで一般的なHTTP通信と、IoTでよく使われるMQTT通信。
  それぞれの特徴と、なぜ現場でMQTTが選ばれるのかを探ります。
]
#figure(
  image("./images/Screenshot 2025-06-23 at 14.37.18.png", width: 70%),
  caption: [デバイスとクラウドの通信方式]
)
#pagebreak()

== まずはHTTP通信を試す
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  HTTP通信は、クライアントがサーバーにリクエストを送り、サーバーがレスポンスを返す「リクエスト/レスポンス型」の通信です。
  まずはこの基本的な動きを体験してみましょう。
]
#align(center)[
  #link("https://yonaka15.github.io/iop-workshop-device-codes/0003_http/", "HTTP通信のサンプルコード") 
]
#v(10mm)
#figure(
  image("./images/Screenshot 2025-06-26 at 11.20.34.png", width: 60%),
  caption: [同じネットワーク上の*Node-RED*を簡易サーバーとして、\
  ESP32からのHTTPリクエストを確認します。]
)
#v(10mm)
#align(center)[
  #set text(size: 16pt, fill: red-300)
  / Node-RED: プログラミング知識が少なくても、様々な機能をブロックのようにつなげてIoTアプリを作れるツールです。\
]
#pagebreak()


== 次にMQTT通信
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  MQTTは、*Message Queuing Telemetry Transport*の略で、
  軽量なメッセージングプロトコルです。「Publisher/Subscriber」モデルを採用し、非力なデバイスや不安定なネットワークでも効率的な双方向通信が可能です。*そのためIoTデバイスとクラウド間の通信に適しています*。
]
#figure(
  image("./images/Screenshot 2025-06-23 at 14.42.59.png", width: 60%),
  caption: [MQTTが現場で選ばれる理由]
)
#pagebreak()

== MQTTの仕組み
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  デバイスは「Publisher」として、特定の「Topic」に対してメッセージを送信します。
  メッセージは「Broker」と呼ばれる中継サーバーに届き、同じ「Topic」を購読（Subscribe）している「Subscriber」に配信されます。
]
#figure(
  image("./images/Screenshot 2025-06-23 at 14.55.04.png", width: 60%),
  caption: [Publish/SubscribeモデルのMQTT通信]
)
#pagebreak()

== PubSubClientのインストール
#header_line
#v(5mm)
#align(left)[
  #set text(size: 16pt)
  MQTT通信を行うために、*PubSubClient*ライブラリをArduino IDEにインストールします。\
  *PubSubClient*は、MQTTプロトコルを使用してメッセージを送受信するためのライブラリです。\
  インストール方法は以下の通りです。\
  #v(5mm)
  + *ツール*メニューから*ライブラリを管理*を選択します。\
  + 検索バーに「PubSubClient」と入力します。\
  + *PubSubClient*を見つけて、*インストール*ボタンをクリックします。\
  https://www.arduino.cc/reference/en/libraries/pubsubclient/
]
#figure(
  image("./images/pubsub_install.png", width: 60%),
  caption: [PubSubClientのインストール]
)
#pagebreak()

== MQTTでデータを送信 (Publish)
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  MQTTのPublish（送信）を体験します。
  ESP32から送信されたメッセージを、Node-REDで受信してみましょう。
]
#v(5mm)
#align(center)[
  #link("https://yonaka15.github.io/iop-workshop-device-codes/0004_mqtt_pub", "MQTT送信(Publish)のサンプルコード") \
]
#v(5mm)
#figure(
  image("./images/Screenshot 2025-06-26 at 12.21.04.png", width: 40%),
  caption: [Node-REDをSubscriberとして、MQTTメッセージを受信します。]
)
#pagebreak()

== MQTTでデータを受信 (Subscribe)
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  次に、MQTTのSubscribe（受信）を体験します。
  Node-REDから送信されたメッセージを、ESP32で受信してみましょう。
]
#v(5mm)
#align(center)[
  #link("https://yonaka15.github.io/iop-workshop-device-codes/0005_mqtt_sub", "MQTT受信(Subscribe)のサンプルコード") \
]
#figure(
  image("./images/Screenshot 2025-06-26 at 12.21.04.png", width: 30%),
  caption: [（再掲）今度はESP32がSubscriberになります。]
)
#v(10mm)
#align(center)[
  #set text(size: 20pt, fill: orange-500)
  このように、MQTTは手軽に双方向の通信を実現できます。
]
#pagebreak()

== （補足）ボタンでイベントを送信
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  定期的なデータ送信だけでなく、ボタンが押された時など、*デバイス側でのイベント発生をきっかけに*MQTTメッセージを送信することもできます。
]
#v(10mm)
#align(center)[
  #link("https://yonaka15.github.io/iop-workshop-device-codes/0006_button", "ボタンを使ったMQTT送信デモ")
]
#v(10mm)
#figure(
  image("./images/IMG_1766.jpg", width: 30%),
  caption: [ボタンを押すとMQTTでメッセージが送信されるデモ]
)
#pagebreak()

== データをJSON形式で送る
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  実際のIoTシステムでは、構造化されたデータ形式として*JSON*がよく使われます。
  温度と湿度をまとめてJSON形式で送信してみましょう。
]
#figure(
  image("./images/Screenshot 2025-06-23 at 15.29.22.png", width: 60%),
  caption: [実際のデータ連携のイメージ]
)
#pagebreak()

== JSON送信演習
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  `ArduinoJson`ライブラリを使って、温度と湿度のデータをJSONオブジェクトにまとめ、MQTTで送信します。
  `PubSubClient`と同様に、ライブラリマネージャからインストールしてください。
]
#align(center)[
  #link("https://yonaka15.github.io/iop-workshop-device-codes/0007_qsu", "JSON形式でのデータ送信サンプルコード")
]
#figure(
  image("./images/arduinojson.png", width: 60%),
  caption: [ArduinoJsonライブラリのインストール]
)
#pagebreak()

== 送信されるJSONデータ
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  プログラムを実行すると、下記のようなJSON形式のデータがMQTTで送信されます。
]
#align(left)[
  ```json
  {
    "device_id": "PromptX-Nakahira",
    "data": {
      "temperature": 27.34,
      "humidity": 71.14
    }
  }
  ```
]
#figure(
  image("./images/Screenshot 2025-06-26 at 13.32.59.png", width: 60%),
  caption: [MQTTで送信されるJSONデータの例（Node-REDで確認）]
)
#pagebreak()


#header_page([= クラウドでデータ可視化],[作成したデバイスをクラウドに接続し、データを可視化します])

== クラウド連携とセキュリティ
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  実際のIoTシステムでは、セキュリティが非常に重要です。
  安全な通信を確立するために、*クライアント証明書*を用いた認証が行われます。
  
+ クラウドサービス(AWS IoT Coreなど)が提供する堅牢なMQTTブローカーを利用
+ 暗号化された通信経路
+ 許可されたデバイスのみが接続できる厳格なアクセスポリシー
]
#figure(
  image("./images/Screenshot 2025-06-26 at 13.40.59.png", width: 80%),
  caption: [セキュアなIoTシステムの概要]
)
#pagebreak()

== クラウドへのデータ送信
#header_line
#v(5mm)
#align(left)[
  //#set text(size: 24pt)
  各参加者ごとに用意された証明書をコードに設定し、
  実際にクラウド上のMQTTブローカーへデータを送信します。
]
#align(center)[
  #link("https://yonaka15.github.io/iop-workshop-device-codes/0008_sawachi", "クラウドへのデータ送信サンプルコード")
]
#pagebreak()

== ダッシュボードで確認
#header_line
#v(30mm)
#align(left)[
  送信したデータがリアルタイムでダッシュボードに反映されるか確認しましょう。
  #set text(size: 20pt, fill: orange-500)
  自分のデバイスからのデータがグラフ化されれば、本講座のゴール達成です！
]
#figure(
  image("./images/Screenshot 2025-06-23 at 16.20.05.png", width: 80%),
  caption: [クラウド上のダッシュボードに表示されたデータ]
)
#pagebreak()

#header_page([= 応用編：ドローンとの連携],[])

#v(10mm)
#align(center)[
  #set text(size: 24pt, fill: main_color)
  学んだ技術のその先へ
]
#v(20mm)
#align(left)[
  今日学んだセンサーと通信の技術は、様々な分野に応用できます。
  その一つが、*ドローン*との連携です。
]
#figure(
  image("./images/drone_image.jpg", width: 60%), // Replace with an actual drone image
  caption: [応用例：ドローンによる広域環境センシング]
)
#pagebreak()

== 地上と上空からのハイブリッドセンシング
#header_line
#v(10mm)
#align(left)[
  皆さんが今日作ったデバイスは、*地上*の特定の場所のデータを継続的に取得する「定点観測」デバイスです。
  
  一方、ドローンにセンサーを搭載すれば、*上空*を移動しながら広範囲のデータを取得できます。
]
#grid(columns: (1fr, 1fr), column-gutter: 10mm,
  [
    #figure(
      image("./images/IMG_1765.jpg", width: 80%),
      caption: [地上デバイス（定点）]
    )
  ],
  [
    #figure(
      image("./images/drone_flying.jpg", width: 80%), // Replace with another drone image
      caption: [ドローン（移動体）]
    )
  ]
)
#v(10mm)
#align(center)[
  #set text(size: 20pt, fill: orange-500)
  これらを組み合わせることで、より立体的で高精度な環境把握が可能になります。
]
#pagebreak()

== 未来の活用イメージ
#header_line
#v(10mm)
#grid(columns: (2fr, 1fr), column-gutter: 5mm,
  [
    #set text(size: 16pt)
    - *農業:* 畑に設置した地上センサーのデータと、ドローンで撮影した作物の生育状況を組み合わせ、ピンポイントで水や肥料を散布する。
    - *防災:* 災害時、地上に設置した水位センサーと、ドローンからの空撮映像をリアルタイムで分析し、避難経路を判断する。
    - *インフラ点検:* 橋梁に設置した振動センサーと、ドローンによる近接撮影で、劣化状況を効率的に診断する。
  ],
  [
    #canvas({
      draw.tree(
        node-stroke: main_color,
        node-fill: white,
        edge-stroke: main_color,
        for "node" text-size: 10pt,
        for "edge" text-size: 10pt,
        node-h-spacing: 2cm,
        level-v-spacing: 2cm,
        "ハイブリッド\nセンシング",
        "農業", "防災", "インフラ",
      )
    })
  ]
)
#v(10mm)
#align(center)[
  #set text(size: 22pt)
  本日学んだMQTTの技術は、こうした多数のデバイスが連携するシステムにおいても中心的な役割を果たします。
]
