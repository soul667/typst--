#import "../lib.typ": two-col, sustech-orange

= 总结与展望

== 3.1. 小结 + 我们工作的切入点

数据合成已从刚体时代进入**可变形物体泛化时代**——4大范式+SoftMimicGen等让"新毛巾/新绳子"操作成为可能。

但deformable物体泛化仍是瓶颈（真实占比高、数据少）。

#align(center)[
  #block(
    width: 95%,
    fill: sustech-orange.lighten(90%),
    inset: 1em,
    radius: 15pt,
    stroke: 2pt + sustech-orange,
  )[
    #text(size: 1.2em, weight: "bold")[我们工作：面向可变形物体泛化的数据合成]

    #v(0.5em)

    结合**SoftMimicGen非刚性配准** + **物理感知生成** + **闭环虚实飞轮**

    从少量真实demo生成高质量、泛化强的deformable数据，直接喂给VLA！
  ]
]

== 3.2. 关键参考文献

*核心文献（2024-2026）：*

- SoftMimicGen: arXiv:2603.25725 (2026) - 可变形物体非刚性数据合成
- Open X-Embodiment (2023-2024) - 最大真实机器人数据集
- Neural Scaling Laws in Robotics (2024) - 机器人数据scaling规律
- PhysDreamer / PIE-NeRF (2025) - 物理感知生成
- RMDO Workshop ICRA 2025 - 可变形物体操作综述

*后续工作方向：*
+ 多范式融合的数据合成框架
+ deformable专用的质量评估指标
+ 端到端的sim2real迁移优化

#align(center)[
  #v(2em)
  #text(size: 1.5em, weight: "bold", fill: sustech-orange)[谢谢！]
  #v(1em)
  #text(size: 1em)[欢迎提问与交流]
]
