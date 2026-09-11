#import "../lib.typ": two-col, sustech-orange, video

= 方法

== DualDeform-Gen：总体框架

#align(center)[
  #block(
    width: 100%,
    fill: sustech-orange.lighten(92%),
    inset: 0.8em,
    radius: 15pt,
    stroke: 1pt + sustech-orange.lighten(50%),
  )[
    *输入*：少量人类演示 $arrow.r$ *四大模块* $arrow.r$ *输出*：大规模多样化合成轨迹 → 零样本真机部署
  ]
]

#v(0.8em)

+ *3DGS 场景与物体重建*：从多视角图像对操作场景和物体进行 3D 高斯溅射重建，获得高保真的可编辑 3D 表示

+ *人类视频资产提取与 GNN 动力学建模*：从人类操作视频中提取物体资产；构建基于 GNN 的粒子级力传播网络，对可变形物体的动力学进行建模与仿真

+ *物理驱动的动力学仿真*：在 3DGS 场景中结合 GNN 动力学模型，进行带物理约束的闭环仿真，实现对软体物体交互的逼真模拟

+ *类 Tether 的轨迹迁移*：利用语义关键点对应关系，将演示轨迹 warping 到不同物体实例和场景配置上，实现跨物体、跨场景的大规模轨迹扩增

== 双臂场景重建 (Depth Anything V3)

为了从真实视频中提取双臂协作的高保真 3D 资产，我们设计了先通过深度估计再进行修复的 3DGS 重建管线。

#two-col[
  *Depth Anything V3 (DA3) 纯视频重建*

  首先，我们使用最先进的单目深度估计模型 *DA3* 对大族双臂机械臂的操作视频进行处理。依靠 DA3 提供的精确几何先验，网络能从极少视角的纯视频中恢复出场景的点云模型。

  然而在双臂遮挡下直接训练 3D 高斯场，渲染新视角（Novel Viewpoints）时仍然会出现区域破损和漂浮伪影。
][
  #figure(
    video("img/视频1.mp4", width: 100%, use_gif: true),
    caption: [纯视频通过 DA3 重建 3DGS 的渲染结果],
  )
]

== 新视角点云修复与高斯再优化 (DiFix3D)

为了解决初始高斯场在新视角下的几何度缺陷问题，我们在管线中引入 *DiFix3D* 修复点云，随后对 3DGS 进行再优化。

#align(center)[
  #grid(
    columns: (1fr),
    row-gutter: 0.8em,
    figure(
      image("../img/图片1.png", width: 75%),
      caption: [修复示意图1],
    ),
    figure(
      image("../img/图片2.png", width: 75%),
      caption: [修复示意图2],
    )
  )
]

== 双臂 3D 资产重建完整结果展示

经过这套重建管线，我们成功提取出可以自由视角的双臂机器人数字资产。相比原始 2D 视频，它极大提升了仿真物理迁移的数据基础。

#two-col[
  #figure(
    video("img/视频2.mp4", width: 100%, use_gif: true),
    caption: [*原始真机演示*（2D 单视角拍摄视频）],
  )
][
  #figure(
    video("img/视频3.mp4", width: 100%, use_gif: true),
    caption: [*3DGS 修复与渲染结果*（可自由改变视角的数字资产）],
  )
]

// ════════════════════════════════════════════════════════════
// Section 4: 实验
// ════════════════════════════════════════════════════════════
