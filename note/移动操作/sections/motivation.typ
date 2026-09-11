= Motivation
#v(-1.5em)
== 讲故事
Deformable bag manipulation is a useful capability for robotic systems with applications such as grocery automation, packaging, recycling, and household assistance. However, this task is highly challenging for robotic systems due to the physical properties and visual characteristics of typical bags. @Chen:EECS-2025-111

there has been relatively little work on the manipulation of 3D deformables such as bags.
== big task
robot manipulation data synthesis for deformable objects
== existing methods and their limitations
难以成规模构建物理真实仿真就绪的可变形物体，尤其是容器类物体（如袋子）。现有的仿真资产库不够。真实世界获取如此多的物体又非常耗时并且不现实。
== small task

Large-scale SimReady deformable container assets generation and simulation

 + how to generate Physical  accurate  and diverse assets at scale
 + how to simulation the assets with accurate and stable dynamics and deal the contact with robot and other assets like the bottle in the bag

== in this small area,relevant works and their problems
#image("/assets/image.png",height: 5cm)
#image("/assets/image-1.png",height: 5cm)
is that collecting high quality demonstration data with dynamic and diverse actions is actually very hard and expensive, especially for deformable objects.

#image("/assets/image-2.png")
=== SOMA
Existing simulators rely on predefined physics or data-driven dynamics without robot-conditioned control, limiting accuracy, stability, and generalization.

a 3D Gaussian Splat simulator
=== Diffusion Dynamics Models with Generative State Estimation for Cloth Manipulation
Coference on Robot Learning (CoRL) 2025

将状态估计表述为从稀疏重建全布状态 RGB-D观测基于典型布网和动力学建模，预测当前状态和机器人动作的未来状态。
=== NOVEL REPRESENTATIONS FOR 3D CLOTH SIMULATION

== 存在的一些局限
- 都难以整合到现有的成熟的仿真生态系统中，以利用先用的成熟的刚体动力学仿真的资源
- focus on just robot arm interaction, ignoring the complex dynamics of deformable objects with other objects ，比如说我袋子里面装一个瓶子，就是对于这种三维可变形容器物体，现有的SOTA方法几乎都无能为力
- 如何生成初始的不同的褶皱和折叠状态
== our method and contributions


== experiment
=== 仿真实验
考虑不同diversity，不同状态，不同内容物，不同位置，做一些定量的泛化实验。分不同条数再做一个图

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, center, center, right),
    inset: 10pt,
    stroke: none,                    // 先关闭所有默认边框

    // 顶线（较粗）
    table.hline(stroke: 0.8pt),

    table.header(
      [*数据来源*], [*数值*], [*单位*], [*备注*]
    ),

    // 中线（较细）
    table.hline(stroke: 0.5pt),

    [人遥操采集的数据], [10], [cm], [测量值],
    [softmimicgen], [5],  [kg], [测量值],
    [ours], [25], [°C], [室温],

    // 底线（较粗）
    table.hline(stroke: 0.8pt),
  ),
  caption: [实验1]
)

=== 消融实验
不同动力学参数在仿真中，验证动力学是否是一个gap.
== PSNR
