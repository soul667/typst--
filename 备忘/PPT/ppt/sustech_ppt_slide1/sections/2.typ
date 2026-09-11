#import "../lib.typ": two-col, three-col, sustech-orange

// 实心方块 = 支持，空心方块 = 不支持
#let cmark = box(width: 0.55em, height: 0.55em, fill: black, stroke: 1pt + black, radius: 1.5pt, baseline: 15%)
#let xmark = box(width: 0.55em, height: 0.55em, fill: none, stroke: 1pt + black, radius: 1.5pt, baseline: 15%)

= 相关工作

== 现有数据合成方法对比

#table(
  columns: (2fr, 1fr, 1fr, 1.2fr, 1.5fr, 1.5fr),
  align: (left, center, center, center, center, center),
  table.header(
    [*方法*], [*单臂*], [*双臂*], [*可变形*], [*物体泛化*], [*Sim2Real*],
  ),
  // ─── 类别一：传统仿真平台 ───
  table.cell(colspan: 6, fill: luma(230), align: center)[*仿真平台数据生成*],
  text(fill: luma(160))[MimicGen / SkillMimicGen], text(fill: luma(160))[#cmark], text(fill: luma(160))[#xmark], text(fill: luma(160))[#xmark], text(fill: luma(160))[空间位姿], text(fill: luma(160))[5% / 35%#footnote[SkillMimicGen 通过技能分解将零样本 sim-to-real 从 5% 提升至 35%（原论文 Table 2）。]],
  [RoboTwin 2.0], [#xmark], [#cmark], [#xmark], [有限], [有限],
  [Genie Sim 3.0], [#cmark], [#cmark], [#xmark], [LLM 场景], [#cmark],
  // ─── 类别二：3DGS / 渲染数据生成 ───
  table.cell(colspan: 6, fill: luma(230), align: center)[*3DGS / 渲染数据生成*],
  [RoboSplat], [#cmark], [#xmark], [#xmark], [6 类实例], [#cmark 87.8%],
  [RoboGSim], [#cmark], [#xmark], [#xmark], [有限], [有限#footnote[更接近高保真 Real2Sim2Real 仿真 / 遥操 / 评测平台；虽然支持 novel view / scene / object 渲染，但并不是像 RoboSplat 那样面向策略学习的大规模自主合成数据流水线。]],
  [R2R2R], [#cmark], [#xmark], [#xmark], [种类 + 姿态], [#cmark],
  [AOMGen], [#cmark], [#xmark], [#xmark], [铰接体], [#cmark],
  // ─── 类别三：真机数据生成 ───
  table.cell(colspan: 6, fill: luma(230), align: center)[*真机数据生成 / 增强*],
  [DemoGen], [#cmark], [#cmark], [有限], [空间位姿], [只有点云],
  [Tether], [#cmark], [#xmark], [#xmark], [语义], [#cmark],
  // ─── Ours ───
  table.cell(colspan: 6, fill: sustech-orange.lighten(90%), align: center)[],
  [*DualDeform-Gen (Ours)*], [*#cmark*], [*#cmark*], [*#cmark*], [*全面*], [*目标 \> 60%*],
)

== MimicGen 与 DemoGen

#two-col(ratio: (35%, 65%))[
  #align(center)[
    #figure(
      image("../img/mimicgen/133aed6faf88ab67b9cca1110edc807836f7976c71fa1901c96c796e8a8f13f6.jpg", width: 90%),
      caption: [MimicGen：从少量演示自动生成多样化仿真数据],
    )
  ]

  *仿真平台路线*：在已有仿真环境中通过轨迹分割与重组生成新演示。优势是成本低，但 sim-to-real 仅 *5%*。
][
  #align(center)[
    #figure(
      image("../img/demogen/35dcd2914bc2aee77d3ceeab910278737e6b2c038ba5f6d1643ccae6ab897038.jpg", width: 100%),
      caption: [DemoGen：基于点云的双臂轨迹迁移生成],
    )
  ]

  *真机点云路线*：利用点云分割与技能分解实现跨场景轨迹迁移，支持双臂但只有点云输入，缺乏视觉渲染。
]

== RoboSplat — 论文概览

#figure(
  image("../img/robosplat/teaser.jpg", width: 98%),
  caption: [RoboSplat 总览（Fig. 1）：从单条演示 + 多视图图像出发，生成 6 类泛化增强数据，真机验证全面超越人工采集与 2D 增强],
)

== RoboSplat — 方法流程

#figure(
  image("../img/robosplat/method.jpg", width: 88%),
  caption: [RoboSplat 方法（Fig. 2）：3DGS 重建 → 帧对齐与分割 → 自主编辑，通过五大技术生成 6 类增强演示],
)


== RoboSplat — 数据规模与鲁棒性

#two-col[
  #figure(
    image("../img/robosplat/7c0ee42e2207295b362773c05b96cce7bdf9cb3c5a14fb57c35ec76aca30ed78.jpg", width: 80%),
    caption: [生成数据随规模增长的平均成功率（Fig. 7）],
  )

  #set text(size: 10.5pt)
  生成数据（红）初期劣于手动采集（蓝），但随规模增大*反超*：800 条生成 ≈ 200 条真实；1800 条生成达 *94.7%*。
][
  #figure(
    image("../img/robosplat/object_type_generalization.jpg", width: 80%),
    caption: [新物体类型泛化（Fig. 10）：基于 50 种类型训练],
  )

  #set text(size: 10.5pt)
  RoboSplat 利用 3D 生成模型将策略推广到新物体，成功率 *76.7%*，比仅用真实数据（23.3%）*提升超过 40%*。#footnote[测试物体与训练全不重合，体现了数据生成流程在物体泛化上的有效性。]
]

// *关键局限（我们的突破方向）*：#text(fill: red)[不支持可变形物体] · #text(fill: red)[不支持双臂协作] · 无物理动力学约束

== RoboGSim — 工作介绍

#figure(
  image("../img/robogsim/main11.jpg", width: 86%),
  caption: [RoboGSim 工作概览：基于 3D Gaussian Splatting 构建 Real2Sim2Real 机器人仿真器，支持 novel view / scene / object 合成与闭环评测],
)

== RoboGSim — 管线细节

#figure(
  image("../img/robogsim/pipeline.jpg", width: 90%),
  caption: [RoboGSim 管线：Gaussian Reconstructor → Digital Twins Builder → Scene Composer → Interactive Engine],
)

== RoboGSim — 核心总结

#v(1em)

*主要贡献*：RoboGSim 将 *3DGS 重建* 与 *Isaac Sim 数字孪生*结合，构建了一个面向机器人学习的 *Real2Sim2Real* 仿真平台。

*核心方法*：
- 从多视角 RGB 与机械臂 MDH 参数重建真实场景、物体与机械臂表示
- 通过布局对齐和数字孪生构建，把真实场景映射到可交互的仿真环境
- 在 Interactive Engine 中支持 *novel view / novel scene / novel object* 数据生成，以及策略*闭环评测*

*与我们的关系*：它说明了 *3DGS + 仿真闭环* 能有效缩小 sim2real gap，但对象仍以*刚体资产*为主，对双臂可变形操作支持不足。

== Tether — 工作介绍

#figure(
  image("../img/tether/method_play.jpg", width: 100%),
  caption: [Tether 方法概览：少量演示初始化轨迹 warping 策略，并通过 VLM 规划、执行与成功判别驱动真机 autonomous functional play],
)

== Tether — Warp 推理流程

#figure(
  image("../img/tether/method_inference.jpg", width: 96%),
  caption: [Tether 推理流程：关键点对应选择源示范，并将示范轨迹 warping 到当前观测场景#footnote[推理过程包括：1）用少量 demo 提取初始图像、waypoint 与轨迹；2）对当前场景和各 demo 做语义关键点 correspondence；3）选最匹配的源示范；4）由关键点恢复目标场景中的 3D waypoint；5）按 waypoint 的相对位置把源轨迹 warping 到当前场景，生成动作计划。]],
)

== Tether — 核心总结

*主要贡献*：Tether 将*少量演示下的跨场景轨迹迁移*与 *VLM 引导的真机自主采集*结合，使机器人能从极少人工示范持续扩充高质量训练集。

*核心方法*：
- 基于*语义关键点对应*选择最匹配的源示范，并将 3D waypoints 与整段轨迹 *warping* 到当前场景；这种对应不只适用于外观相似物体，也能迁移到语义角色相近但外观差异明显的对象
- 通过 VLM 完成*任务选择*与*成功判别*，形成“规划—执行—评估—再收集”的闭环 autonomous play

*结果与启发*：
- 由 *≤10* 条演示出发，在约 *26 小时* 真机 play 中生成 *1000+* 成功轨迹
- 证明*语义对应 + 自动探索*能显著放大真机数据规模，但仍局限于*单臂、刚体、真实场景采集*

== Tether — 语义泛化示例

#figure(
  image("../img/tether/pineapple_strawberry_correspondence.jpg", width: 80%),
  caption: [Tether 的语义泛化：对应关系不只适用于“相似物体”，也可从 pineapple 迁移到外观差异明显的 strawberry 一类目标，关键在于对功能相关区域的语义对应。],
)

== ReBot — 2D 视频合成

ReBot 提出了一种新型的 Real-to-Sim-to-Real 数据扩增方法，主要利用 2D 视频合成与 Inpainting 技术在相同背景下渲染新轨迹。作为 RoboSplat 和我们的直接 2D 方法对比基线。

#figure(
  image("../img/rebot/method-v16.jpg", width: 100%),
  caption: [ReBot 数据流水线：场景解析 → 真实背景 Inpainting (ProPainter) → 渲染模拟机械臂 → 2D 视频合成的新轨迹。],
)

== ReBot — 2D 视觉差距

#figure(
  image("../img/图片5.png", width: 90%),
  caption: [ReBot 生成视频存在物理与 3D 约束缺失的问题。如图中红框所示，尽管使用了最先进的 2D 扩散模型，在生成类似胡萝卜新物体操作时，夹爪与物体的接触点存在显著瑕疵和不自然的非物理透视问题。],
)

// == 三大技术瓶颈

// #three-col[
//   *瓶颈一：资产成本高昂*

//   现有 3D 模型库（ShapeNet, Objaverse）仅含几何网格，缺少质量、摩擦、碰撞体积、抓取点等物理交互语义，不是"仿真就绪"的。

//   MimicGen 零样本 sim-to-real 仅 *5%* 成功率。
// ][
//   *瓶颈二：双臂协同复杂性*

//   双臂动作空间翻倍导致高度*多模态动作分布*。

//   DexMimicGen 定义三类时空依赖：
//   - *并行*：左右手独立目标
//   - *协调*：双手共持物体
//   - *顺序*：因果依赖子任务
// ][
//   *瓶颈三：可变形物体双重鸿沟*

//   *动力学鸿沟*：物理参数（杨氏模量、泊松比）极难现实辨识。

//   *视觉鸿沟*：软体受压或折叠时产生的高频几何细节（褶皱、自阴影），传统网格渲染无法逼真再现。
// ]


// ════════════════════════════════════════════════════════════
// Section 3: 方法
// ════════════════════════════════════════════════════════════
