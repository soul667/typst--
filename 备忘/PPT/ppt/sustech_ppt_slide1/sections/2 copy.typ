#import "../lib.typ": two-col, three-col, sustech-orange

// 实心方块 = 支持，空心方块 = 不支持
#let cmark = box(width: 0.55em, height: 0.55em, fill: black, stroke: 1pt + black, radius: 1.5pt, baseline: 15%)
#let xmark = box(width: 0.55em, height: 0.55em, fill: none, stroke: 1pt + black, radius: 1.5pt, baseline: 15%)

= 相关工作

== 现有数据合成方法对比

#table(
  columns: (2fr, 1fr, 1fr, 1.2fr, 1.5fr, 1.5fr),
  align: (left, center, center, center, center, center),
  [*方法*], [*单臂*], [*双臂*], [*可变形*], [*物体泛化*], [*Sim2Real*],
  [MimicGen / SkillMimicGen#super[@mandlekar2023mimicgen]#super[@skillmimicgen2024]], [#cmark], [#xmark], [#xmark], [空间位姿], [5% / 35%#footnote[SkillMimicGen 通过技能分解将零样本 sim-to-real 从 5% 提升至 35%（原论文 Table 2）。]],
  [DemoGen#super[@demogen2025]], [#cmark], [#cmark], [有限], [空间位姿], [只有点云],
  [RoboSplat#super[@robosplat2025]], [#cmark], [#xmark], [#xmark], [6 类实例], [#cmark 87.8%],
  [AOMGen#super[@aomgen2025]], [#cmark], [#xmark], [#xmark], [铰接体], [#cmark],
  [R2R2R#super[@yu2025r2r2r]], [#cmark], [#xmark], [#xmark], [种类 + 姿态], [#cmark],
  [RoboTwin 2.0#super[@robotwin2025]], [#xmark], [#cmark], [#xmark], [有限], [有限],
  [Tether#super[@tether2026]], [#cmark], [#xmark], [#xmark], [语义], [#cmark],
  [*DualDeform-Gen (Ours)*], [*#cmark*], [*#cmark*], [*#cmark*], [*全面*], [*目标 > 60%*],
)

== 三大技术瓶颈

#three-col[
  *瓶颈一：资产成本高昂*

  现有 3D 模型库（ShapeNet, Objaverse）仅含几何网格，缺少质量、摩擦、碰撞体积、抓取点等物理交互语义，不是“仿真就绪”的。

  MimicGen 零样本 sim-to-real 仅 *5%* 成功率#super[@mandlekar2023mimicgen]。
][
  *瓶颈二：双臂协同复杂性*

  双臂动作空间翻倍导致高度*多模态动作分布*#super[@liu2024rdt]。

  DexMimicGen#super[@chen2024dexmimicgen] 定义三类时空依赖：
  - *并行*：左右手独立目标
  - *协调*：双手共持物体
  - *顺序*：因果依赖子任务
][
  *瓶颈三：可变形物体双重鸿沟*

  *动力学鸿沟*：物理参数（杨氏模量、泊松比）极难现实辨识#super[@soma2025]#super[@phystwin2025]。

  *视觉鸿沟*：软体受压或折叠时产生的高频几何细节（褶皱、自阴影），传统网格渲染无法逼真再现。
]

== 综述确认的领域空白

#two-col[
  *综述一：Robotic Manipulation via IL: Taxonomy*
  (Li et al., 2025)

  Section VII-B 的 5 大 open challenges：
  - _"Dual-arm collaborative manipulation and high-DoF manipulation are still in their early stages"_
  - _"Current methods remain heavily reliant on expert data...restricts the scalability"_

  *综述二：Interactive IL for Dexterous Manipulation*
  (Frontiers, 2025)

  - _"IIL for dexterous manipulation is an emerging field...notable gap in concrete studies"_
  - 训练数据需求随动作空间维度*指数增长*
][
  #align(center)[
    #block(
      width: 100%,
      fill: sustech-orange.lighten(90%),
      inset: 1.2em,
      radius: 20pt,
      stroke: 1pt + sustech-orange.lighten(40%),
    )[
      *综合确认的核心 Gap*

      #v(0.5em)
      目前*无任何方法*同时低成本解决：

      #v(0.3em)
      *双臂协作* + *可变形物体* \
      + *大规模物体泛化* \
      的数据合成问题
    ]
  ]
]

// ════════════════════════════════════════════════════════════
// Section 3: 方法
// ════════════════════════════════════════════════════════════
