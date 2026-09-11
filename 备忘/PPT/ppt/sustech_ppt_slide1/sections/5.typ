#import "../lib.typ": two-col, sustech-orange

= 结论

== 总结与贡献

#align(center)[
  #block(
    width: 100%,
    fill: sustech-orange.lighten(90%),
    inset: 0.9em,
    radius: 20pt,
    stroke: 1pt + sustech-orange.lighten(45%),
  )[
    *DualDeform-Gen*：首个*同时支持灵巧双臂与可变形物体*的 Real-to-Sim-to-Real 闭环数据合成框架 \
    $1 arrow.r infinity$ 条演示 → 50K+ 合成轨迹 → 零样本真机部署
  ]
]

#v(0.6em)

#two-col[
  *五大核心贡献*

  + *统一框架*：首个同时覆盖单臂 / 双臂、刚体 / 铰接体 / 可变形物体的 3DGS 数据合成框架
  + *自动化资产库*：VLM 驱动将视频自动转化为仿真就绪资产，支持*10 万级*规模
  + *双臂解耦引擎*：并行 / 协调 / 顺序三类子任务自适应适配，OmniH2O 重定向#super[@omnih2o2024]
  + *GNN 神经动力学*：3DGS + GNN 同时消除动力学鸿沟与视觉鸿沟，支持闭环校准#super[@soma2025]#super[@phystwin2025]
  + *Scaling Law 验证*：首次在双臂场景系统验证数据多样性的幂律效应#super[@lin2024data]
][
  *时间规划（6 个月）*

  #table(
    columns: (1fr, 3fr),
    align: (center, left),
    [*阶段*], [*工作内容*],
    [月 1-2], [VLM 资产流水线 + 单臂刚体基线],
    [月 2-3], [3DGS-GNN 软体仿真 + 可变形重建],
    [月 3-4], [双臂解耦引擎 + TAMP 集成],
    [月 4-5], [5+1 轴域随机化 + 50K 轨迹生成 + Scaling Law 验证],
    [月 5-6], [真实部署评估 + 论文撰写],
  )
]

// ════════════════════════════════════════════════════════════
// 参考文献
// ════════════════════════════════════════════════════════════
