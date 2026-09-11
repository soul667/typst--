#import "../lib.typ": two-col, three-col, sustech-orange

= 数据合成领域综述

== 2.1 为什么数据合成要特别关注可变形物体泛化？

真实世界里，机器人最头疼的不是抓刚体盒子，而是**软乎乎、会变形的物体**：毛巾、绳子、衣服、塑料袋......

*可变形物体在真实任务中占比极高：*
- 家庭/家务场景：衣服、食品、家居用品#footnote([袋子、床单、枕头、毯子,..... ])——"most household objects that robots must interact with are deformable"（RMDO Workshop ICRA 2025）
- 物流/工业：柔性包装、绳缆、布料是"large portion of real-world manipulation"（SoftMimicGen 2026）

#grid(
  columns: 4,
  column-gutter: 0.8em,
  row-gutter: 0.8em,
  align: center + horizon,
  [
    #image("../img/deformable_clothing.png", width: 80%)
    #v(-0.4em)
    #text(size: 0.7em, weight: "bold")[衣物]
  ],[
    #image("../img/deformable_bedsheet.png", width: 80%)
    #v(-0.4em)
    #text(size: 0.7em, weight: "bold")[床单/毯子]
  ],[
    #image("../img/deformable_pillows.png", width: 80%)
    #v(-0.4em)
    #text(size: 0.7em, weight: "bold")[枕头/靠垫]
  ],[
    #image("../img/deformable_towels.png", width: 80%)
    #v(-0.4em)
    #text(size: 0.7em, weight: "bold")[毛巾]
  ],[
    #image("../img/deformable_takeout_new.png", width: 80%)
    #v(-0.4em)
    #text(size: 0.7em, weight: "bold")[外卖袋]
  ],[
    #image("../img/deformable_foodpack.png", width: 80%)
    #v(-0.4em)
    #text(size: 0.7em, weight: "bold")[食品包装袋]
  ],[
    #image("../img/deformable_cables.png", width: 80%)
    #v(-0.4em)
    #text(size: 0.7em, weight: "bold")[电子线缆]
  ],[
    #image("../img/deformable_parcels_new.png", width: 80%)
    #v(-0.4em)
    #text(size: 0.7em, weight: "bold")[快递包裹]
  ],
)

*现有数据集严重欠代表：*

Open X-Embodiment（最大真实机器人数据集，1M+ 轨迹）：**most skills belong to pick-place family**（rigid 主导），folding/rope/cloth 等 deformable 为"long tail"。

BridgeData V2：虽含少量 deformable，但占比远低于 rigid pick-place。

结果：deformable 在真实任务中占比高，但数据集里**明显小于 15%**——这正是 VLA 泛化失败的根源！

*可变形物体维度更高：*
RMDO Workshop（ICRA 2024-2025）反复强调：deformable的**非线性、高自由度**让传统方法成功率暴跌。
#align(center)[
  #image("../img/1774905052509.png", width: 70%)
  #text(size: 0.8em)[Open X 技能分布：刚体主导]
]




== 2.2 传统数据合成在可变形物体泛化上的尴尬


早期数据合成（2021年前主流）主要依赖以下几种方法：

#table(
  columns: (1.2fr, 2fr, 2fr),
  align: (left, left, left),
  [*方法*], [*原理*], [*局限性*],
  [Domain Randomization], [随机化光照、纹理、材质参数], [仅适合刚体，deformable非线性变形无法随机化],
  [Copy-Paste], [从真实图像剪切粘贴物体], [只能处理固定形状，新材质即失效],
  [Rigid SE(3)变换], [旋转、平移、缩放示范轨迹], [deformable会"自己变形状"，pose估计失效],
  [早期物理仿真], [FEM/PBD建模物体动态], [需要精确物理参数，计算极慢，高自由度建模困难],
)

这些方法**对刚体还凑合**，但遇到**deformable物体**就直接崩溃！



== 2.3 数据合成分类新框架

基本上现有方法有提出**4大生成范式**（更贴合deformable物体泛化）。每类都隐含支持**物体泛化**（新形状/材质/变形）。

#align(center)[
  #block(
    width: 95%,
    fill: sustech-orange.lighten(90%),
    inset: 1em,
    radius: 10pt,
    stroke: 1pt + sustech-orange.lighten(50%),
  )[
    #three-col[
      #align(center)[
        **范式1** \\ 内生真实 \\ 神经编辑
      ]
    ][
      #align(center)[
        **范式2** \\ 物理感知 \\ 生成
      ]
    ][
      #align(center)[
        **范式3** \\ 示范适应/ \\ 认知合成
      ]
    ]
    #v(0.5em)
    #align(center)[**范式4 — 闭环虚实飞轮**]
  ]
]

*核心思想*：从"死记硬背固定形状"升级为"理解变形规律，泛化到新物体"

== 2.4 范式1：内生真实神经编辑

直接在真实捕获数据上用3DGS/NeRF编辑，不用从零建仿真。

*核心能力：*
- **物体泛化**：真实Dashcam/传感器上插入/修改deformable物体（e.g. DC-Gaussian去遮挡+新毛巾注入）
- **Deformable亮点**：保留真实光照/纹理，生成新材质变形的视角

*代表工作*：RadarSplat、SceneCrafter（2025）

*优势*：Domain Gap最小

*局限*：全局物理逻辑弱

// #two-col(ratio: (55%, 40%))[
//   在deformable上已用于garment manipulation：
//   - 从真实视频提取3DGS表示
//   - 注入新deformable物体（不同材质/形状的毛巾）
//   - 生成新视角的合成数据
// ][
//   #align(center)[
//     #image("../img/IMG-20260331020132487.png", width: 90%)
//     #text(size: 0.8em)[真实视频→3DGS编辑新deformable物体]
//   ]
// ]

== 2.5 范式2：物理感知生成

核心解决deformable"会自己动"的问题：显式/隐式嵌入物理约束。

// #two-col(ratio: (50%, 45%))[
  *物体泛化能力*：
  生成新形状/材质的deformable动力学（布料飞溅、绳子弯曲）

  *Deformable专项工作*：
  - PhysDreamer（MPM+扩散生成布料/弹性体）
  - PIE-NeRF（粒子物理交互）
  - Movement Primitive Diffusion（gentle manipulation of soft objects）

  *分类*：
  - PAG-E（显式）：Gen-to-Sim + MPM
  - PAG-I（隐式）：大视频模型自发学物理
// ][
//   #align(center)[
//     #image("../img/IMG-20260331020143171.png", width: 90%)
//     #text(size: 0.8em)[扩散生成deformable布料动态序列]
//   ]
// ]

// 2025-2026爆款：已支持folding/whipping等真实任务。一句话：这是deformable物体泛化的"物理灵魂"！

== 2.6 范式3：示范适应/认知合成

从少量真人demo自动"变"出海量新物体数据——最适合我们物体泛化！

// #two-col(ratio: (50%, 45%))[
  *核心思想*：
  - SE(3)变换 + 非刚性配准，适应全新deformable形状/材质

  *Deformable王牌*：
  **SoftMimicGen (arXiv:2603.25725, 2026)**——MimicGen扩展
  - 用non-rigid registration从1-10个demo生成万级轨迹
  - 支持stuffed animal、rope、tissue、towel
  - 支持threading/folding/whipping/pick-and-place
  - 跨4种机器人本体

  *其他*：DexMimicGen（bimanual扩展）、IntervenGen（失败增强）
// ][
//   #align(center)[
//     #image("../img/IMG-20260331020250846.png", width: 90%)
//     #text(size: 0.8em)[SoftMimicGen pipeline：少量demo→非刚性变换→大规模数据]
//   ]
// ]

优势：少样本→大规模，物理真实。已让IL成功率3-10×提升！

== 2.7 范式4：闭环虚实飞轮

真实种子 → 仿真增强 → 真实fine-tune，形成飞轮。

// #two-col(ratio: (50%, 45%))[
  *物体泛化*：
  数字孪生里无限变deformable形状，再回真实世界。

  *Deformable亮点*：
  - X-Sim/ReBot（视频合成+控制）
  - GRIP（soft grippers+10万deformable grasp）
  - RGBench（garment高保真sim benchmark）
  - Co-Sim 2.0实时同步真实+虚拟deformable交互

  *优势*：最佳真实性+规模。2025后已含deformable动态。
// ][
//   #align(center)[
//     #image("../img/IMG-20260331020143171.png", width: 90%)
//     #text(size: 0.8em)[Real-to-Sim-to-Real飞轮循环]
//   ]
// ]

// == 2.8 可变形物体泛化专项案例

// 2025-2026最新突破：

// #three-col[
//   **SoftMimicGen**
//   - 1-10 demo → 万级deformable轨迹
//   - 非刚性配准完美支持新形状泛化
// ][
//   **PokeFlex/RGBench**
//   - 真实+高保真sim dataset
//   - 18种deformable物体
//   - drop/poke生成变形
// ][
//   **MoDeSuite/DaXBench**
//   - mobile manipulation
//   - benchmark移动+变形任务
// ]

// #v(1em)

// #three-col[
//   **D-CODA/Diffusion扩展**
//   - bimanual deformer数据增强
//   - 物体泛化成功率大涨
// ][
//   **PhysDreamer**
//   - MPM+扩散生成
//   - 布料/弹性体动力学
// ][
//   **UniSim**
//   - 扩散模型生成
//   - photorealistic轨迹
// ]

// 这些工作证明：**deformable物体泛化已从"gap"变成可规模化解决的问题**。

== 2.8 当前存在的问题

尽管进展巨大，但从deformable物体泛化视角看仍有痛点：

#table(
  columns: (1fr, 3fr),
  align: (left, left),
  [*问题*], [*具体表现*],
  [sim2real gap], [deformable接触力/变形建模难，仿真与真实物理差异大],
  [长时序一致性], [folding等多步操作后形状漂移，误差累积],
  [质量评估无标准], [SDQM/7 Cs等metric缺乏deformable专项指标],
  [计算开销], [物理模拟+扩散生成速度慢，难以实时],
  [真实数据集仍稀缺], [deformable数据占比小于15%，长尾问题严重],
)

Gemini报告+RMDO workshop共识：**模型坍塌、物理幻觉仍是最大威胁**。



== 2.9 四大范式对比总结

#table(
  columns: (1.2fr, 1.5fr, 1.5fr, 1.5fr),
  align: (left, left, left, left),
  table.header([*范式*], [*核心思想*], [*优势*], [*局限*]),
  [内生真实编辑], [3DGS/NeRF编辑真实数据], [Domain Gap最小], [物理逻辑弱],
  [物理感知生成], [显式/隐式嵌入物理约束], [动力学真实], [计算开销大],
  [示范适应合成], [少量demo→大规模数据], [少样本启动], [依赖配准质量],
  [闭环虚实飞轮], [Real→Sim→Real循环], [真实性+规模], [系统复杂度高],
)

*关键洞察*：
- 没有单一范式能解决所有问题
- **SoftMimicGen**等最新工作开始融合多范式优势
- 我们工作的机会：结合非刚性配准+物理感知+闭环飞轮

#align(center)[
  #block(
    width: 90%,
    fill: sustech-orange.lighten(90%),
    inset: 0.8em,
    radius: 10pt,
    stroke: 1pt + sustech-orange.lighten(50%),
  )[
    **我们工作的切入点**：面向可变形物体泛化的数据合成——结合SoftMimicGen非刚性+物理感知+闭环飞轮
  ]
]
