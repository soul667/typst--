#import "../lib.typ": two-col, video

= 实验

== 实验设计：平台与任务矩阵

#two-col[
  *仿真与硬件平台*

  #table(
    columns: (1.5fr, 2fr),
    align: (left, left),
    [*平台类型*], [*具体平台与用途*],
    [仿真平台], [Genie Sim 3.0（轨迹迁移验证与 Baseline 对比）],
    [单臂硬件], [Franka Panda（单臂任务与 RoboSplat 对比）],
    [双臂硬件], [大族双臂机械臂（双臂协作与可变形验证）],
  )
][
  *核心评测任务*

  *单臂刚体与可变形*：抓取放置 / 快递分拣 / 布料折叠 / 可变形物体操作

  *双臂协作与可变形*：双臂交接 / 协作搬运 / 双臂布料抖平

  *泛化能力验证*：跨物体类型（零样本真机迁移）
]

== 实验结果：主任务性能对比（不同轨迹数）

#align(center)[
  #table(
    columns: (2fr, 1fr, 1fr, 1fr, 1fr),
    align: (left, center, center, center, center),
    table.header(
      [*方法*], [*100 条*], [*200 条*], [*800 条*], [*1800 条*]
    ),
    [人类遥操作（真实数据）], [], [], [], [],
    [Genie Sim 3.0#super[@geniesim2026]], [], [], [], [],
    [RoboSplat#super[@robosplat2025]], [], [], [], [],
    [ReBot#super[@rebot2025]], [], [], [], [],
    [Tether#super[@tether2026]], [], [], [], [],
    [*DualDeform-Gen (Ours)*], [], [], [], [],
  )
]

== 实验：单臂 vs 双臂 Scaling Law 验证

参照 Lin et al.#super[@lin2024data] 的幂律实验设计：固定每对演示数 K，沿*环境对数 M* 和*物体类型对数 N* 两个维度扩增，观察策略泛化性的提升。*首次在双臂任务上*系统验证该 Scaling Law。

#two-col[
  *单臂 Scaling Law*

  固定每对演示数 K，分别扩增：
  - *物体类型数 N*（5 / 10 / 20 / 50 / 100）
  - *环境配置数 M*（5 / 10 / 20 / 50）

  绘制 *成功率 vs N* 和 *成功率 vs M* 的幂律曲线。
][
  *双臂 Scaling Law*

  同样的实验范式应用于双臂协作任务，验证：
  - 双臂场景下幂律关系是否仍然成立？
  - 达到饱和的 N / M 阈值与单臂相比是否显著不同？
  - 环境多样性 vs 物体类型多样性，哪个维度对双臂任务更关键？
]

