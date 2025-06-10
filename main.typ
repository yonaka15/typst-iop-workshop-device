#import "@preview/typewind:0.1.0": *
#import "@preview/gantty:0.2.0": gantt // https://typst.app/universe/package/gantty/
// #import "@preview/timeliney:0.2.1" //https://typst.app/universe/package/timeliney/
#import "@preview/cineca:0.5.0": * // https://typst.app/universe/package/cineca/
#import "@preview/cetz:0.3.4": canvas, draw, tree
#import "parts.typ": main_color, header_line, iop_color // https://cetz-package.github.io/docs/

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


#block(
width: 100%,
height: 100%,
)[
#align(center+horizon)[
= ログイン履歴データ分析

== データについて

KC番号・氏名・団体名を伏せて匿名化した1ヶ月ごとのログイン回数のデータ。

#block()[
#grid(
columns: 2,
[
#align(left)[
- 出荷情報登録数
- 機器保有数
- 市町村
]],[
- 所管普及所
- 担当JA
- 主な栽培品目
]
)]

== 指標について

#text(size: 18pt, weight:"black")[アクティブ率 = 1 ヶ月間に 1 回以上のログインがあったユーザーの割合]

#block()[
#align(left)[
- ログイン回数の多い特定のヘビーユーザーに過剰に影響されない
- 栽培品目、管轄普及所、地域、JAの違い等でアクティブ率に差があるかを調べる
]]
]];



#pagebreak()

#image("./images/栽培品目別アクティブ率_関係者除外後.png")

#pagebreak()

#image("./images/詳細分析画面_品目別アクティブ率_統計的有意差色分け.svg")

