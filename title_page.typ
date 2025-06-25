#import "parts.typ": main_color, header_line, iop_color // https://cetz-package.github.io/docs/

#set page(
  paper: "a4",
  flipped: true,
  margin: (top: 12mm, bottom: 20mm, y: 10mm),
  footer: [
    #set text(size: 8pt)
    #align(center)[Copyright © 2025 PROMPT-X, Inc. All Rights Reserved.]
  ],
  background: [
    #place(
        box(height:101%, width:50mm, fill: gradient.linear(main_color, white))
    )
    #place(
      top+right,
      dx: -10mm,
      dy: 5mm,
      image("./images/logo.png", height: 15mm)
    )
  ],
)

#v(80mm)

#align(center)[
  #text(size: 36pt)[
    *SAWACHIエンジニア養成講座 (デバイス編)*
  ]
#v(30mm)

  2025年6月27日\
  IoP技術者コミュニティ
]
