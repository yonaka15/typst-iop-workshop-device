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
= IoP 技術者コミュニティ デバイス編
]]

