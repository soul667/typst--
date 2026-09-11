#import "../lib.typ": two-col, sustech-orange

= 研究动机

== 研究背景：数据驱动机器人操作的瓶颈

#two-col(ratio: (70%, 25%))[
  #align(center)[
    #figure(
      image("../img/data_saturation.jpg", width: 95%),
      caption: [固定环境\/物体下，性能随数据量增加的饱和现象#super[@lin2024data]],
    )
  ]
][
  *数据是通用机器人策略的核心燃料。* 模仿学习的泛化能力与训练数据的规模和多样性呈*幂律关系*#super[@lin2024data]，然而当前最大的机器人数据集规模仍比视觉/语言数据小 *10 万倍以上*#super[@brohan2023rt1]#super[@khazatsky2024droid]#footnote[RT-1 耗费 17 个月、13 台机器人仅收集约 13 万条演示；DROID 动用 50 名采集员、12 个月积累 7.6 万条轨迹。]。尤其对于双臂灵巧手与可变形物体操作，高维动作空间使数据需求呈指数增长#super[@liu2024rdt]#super[@chen2024dexmimicgen]。
]

== 研究背景：数据驱动机器人操作的瓶颈

// #two-col(ratio: (80%, 00%))[
    #align(center)[
    #figure(
      image("../img/data_scaling_law.jpg", width: 75%),
      caption: [泛化能力随物体与环境数的幂律缩放规律#super[@lin2024data]],
    )
  ]

== 研究背景：数据驱动机器人操作的瓶颈
  *解决方案：数据合成。* 核心问题是合成*能泛化到真机*且具备*多样性*（环境、物体、位姿、光照）的数据。
#table(
  columns: (1fr, 2fr, 3fr),
  align: (left, left, left),
  [*方法路线*], [*核心优势*], [*主要瓶颈*],
  text(fill: luma(100))[真实采集], text(fill: luma(100))[——], text(fill: luma(100))[成本高#super[@brohan2023rt1]],
  text()[真实合成], text()[零虚实差距], text()[成本高、难以实现多样性规模化#footnote[物体和环境的多样性规模化，例如需要购买数百个同类物体，或将机械臂移动到数百个不同环境。]、仍需人工监管],

  [传统仿真], [资产/环境可规模化、刚体动力学较成熟], [视觉 gap、可变形物体仿真],
  [R2S2R], [资产/环境可规模化 + 视觉保真], [动力学、双臂协同、可变形物体],
)

我们聚焦 *(R2S2R) 基于 3DGS 的数据合成*，成本低于真机采集，保真度高于传统仿真#super[@robosplat2025]，并具备优秀的 sim-to-real zero-shot 迁移能力#footnote[RoboSplat 证实：单条演示 + 3DGS 编辑即可将策略成功率从 57.2% 提升至 87.8%。]。但现有方法局限于*有限刚体*，忽略动力学，且缺乏对合成数据的系统性研究。

// 在机器人的未来应用场景下
== 研究目标

#align(center)[
  #block(
    width: 100%,
    fill: sustech-orange.lighten(90%),
    inset: 1em,
    radius: 20pt,
    stroke: 1pt + sustech-orange.lighten(50%),
  )[
    *核心目标：* 构建首个*聚焦双臂与可变形物体*的 Real2Sim2Real 闭环数据合成框架，实现 $1 arrow.r infinity$ 条演示扩增与*零样本真机部署*。
  ]
]

#two-col[
  *探索合成数据的规律*

  + 合成数据与真实数据的*关键差距*在哪里？
      - 是否需要完全消除视觉鸿沟？
      - 不同动力学参数如何影响策略的真机表现？
  + 真实数据上的 Scaling Law#super[@lin2024data] 在合成数据及双臂场景中同样成立吗？
][
  *解决现有方法的瓶颈*

  + 构建大规模的物体高斯资产库#super[@mandlekar2023mimicgen]#super[@yu2025r2r2r]
  + 基于语义关键点实现同类物体间的轨迹迁移
  // + 设计双臂*时空解耦*引擎#super[@chen2024dexmimicgen]
  + 融合 3DGS + GNN 实现*可变形物体*神经动力学仿真#super[@soma2025]#super[@phystwin2025]#footnote[GNN 驱动高斯点实现力传播与真实变形，支持闭环 Real-to-Sim 校准。]
  // + 验证 6+ 轴结构化域随机化的泛化增益
]

// ════════════════════════════════════════════════════════════
// Section 2: 相关工作
// ════════════════════════════════════════════════════════════
