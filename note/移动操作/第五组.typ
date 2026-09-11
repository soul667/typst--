// 基本模板
#import "@preview/rubber-article:0.5.2": *
#show: article.with()
#import "@preview/mitex:0.2.4": * // latex 兼容包
#import "@preview/cmarker:0.1.1" //  md兼容包
#import "@preview/codly:1.3.0": * // 设置代码块
#import "@preview/note-me:0.3.0": * //提示
// #show: codly-init.with()
#import "@preview/showybox:2.0.4": showybox // 彩色盒子
#import "@preview/i-figured:0.2.4"
#show math.equation: i-figured.show-equation.with(only-labeled: false) // 只有引用的公式才会显示编号
#show figure: i-figured.show-figure // 图1.x
#import "@preview/physica:0.9.3": * // 数学公式简写
#import "@preview/lovelace:0.3.0": * // 伪代码算法
#set text(font: ("Times New Roman", "Source Han Serif SC"), size: 12pt) // 设置中英语文字体 小四宋体 英语新罗马
// #import "@preview/cuti:0.2.1": show-cn-fakebold  // 中文伪粗体 像我们使用的Source Han Serif SC是粗体字体不用开启
// #show: show-cn-fakebold
#import "@preview/dashy-todo:0.0.1": todo
#import "@preview/pavemat:0.1.0": * // show matrix beautifully

#let 行间距转换(正文字体, 行间距) = ((行间距) / (正文字体) - 0.75) * 1em
#set par(leading: 行间距转换(12, 20), justify: true, first-line-indent: 2em)
#import "@preview/indenta:0.0.3": fix-indent
#show: fix-indent() // 修复第一段的问题
#show heading: it => {
  it
  par()[#let level = (-0.3em, 0.2em, 0.2em);#for i in (1, 2, 3) {
      if it.level == i { v(level.at(int(i) - 1)) }
    };#text()[#h(0.0em)];#v(-1em);]
} // 修复标题下首行 以及微调标题间距
#show ref: it => {
  let eq = math.equation
  let el = it.element
  if el != none and el.func() == eq {
    link(el.location(), "式" + numbering(el.numbering, ..counter(eq).at(el.location())))
  } else { it }
} // 设置引用公式为式
#show figure.where(kind: image): set figure(supplement: [图]) // 设置图
#show figure.where(kind: "tablex"): set figure(supplement: [表]) // 设置表
#import "@preview/mannot:0.1.0": * // 公式突出
// #import "@preview/oasis-align:0.1.0" // 自动布局
#import "@preview/tablex:0.0.9": * // 表格
// ------------定理 证明----------------
// 默认可间断了，可调
#import "@preview/ctheorems:1.1.3": *
#show: thmrules
#let theorem = thmbox("定理", "定理", stroke: rgb("#ada693a1") + 1pt, breakable: true) //定理环境
#let example = thmbox("例", "例", stroke: (paint: blue, thickness: 0.5pt, dash: "dashed"), breakable: true) //定理环境

#let definition = thmbox(
  "定义",
  "定义",
  inset: (x: 0.5em, top: -0.25em, bottom: -0.25em),
  stroke: rgb("#ada693a1") + 0pt,
  breakable: false,
) // 定义环境
#let proof = thmproof("证", "证", breakable: true) //证明环境
// ----------------------------

// #import "@preview/grayness:0.2.0": * // 基本图片编辑功能
#import "@preview/glossarium:0.5.1": gls, glspl, make-glossary, print-glossary, register-glossary

#let image1(img, name) = {
  // return
  figure(
    img,
    caption: [
      #name
    ],
    kind: image,
  )
}
//公式简写
#import "@preview/quick-maths:0.2.1": shorthands
#show: shorthands.with(
  ($+-$, $plus.minus$),
  ($|-$, math.tack),
  ($<=$, math.arrow.l.double), // Replaces '≤'
)

// 算法
#import "@preview/algorithmic:1.0.7"
#import algorithmic: algorithm-figure, style-algorithm
#show: style-algorithm


// 有关可断开和不可断开块的更多信息，请参阅块文档。
#let publish = 0

// #register-glossary(entry-list)
#set math.mat(delim: "[")
#set page(columns: 1)

// = 目录
#outline(title: none)
// -----------------------------
#set page(columns: 1)

#align(center, [
  #text(size: 1.5em)[*Structured Gaussian Latent Dynamics Model for Deformable Objects*]]
)
= Motivation
---

Recent studies have shown that data endows imitation learning policies with universal generalization ability, and such capability improves as the scale and diversity of pretraining data expand @lbmtri2025 @lin2024data .

So, we talk about diversity and generalization. For robot manipulation, what are diversity and generalization capability?

We first talk about what is a a single demonstration. In imitation learning, a single demonstration is a recorded session where a human teleoperates a robot — combining the video feed with the robot's end-effector pose and gripper state over time.

Diversity means how varied these demonstrations are. Generalization is the model's ability to handle situations it hasn't seen before — which depends directly on that diversity.

--- 


The main focus of our group’s research is data synthesis [辛塞西斯] for deformable objects, especially cloth manipulation.
Why? Because the diversity of deformable objects far exceeds [伊克西兹] that of rigid bodies, making it extremely difficult for models to generalization [杰纳赖泽申]. Taking our ‘clothes folding’ task as an example: starting from a random initial state already involves different categories [凯特格里斯] of garments [嘎门茨] (T-shirts, pants [潘茨], hoodies [胡迪兹], etc [埃特塞特拉]), varying materials and sizes, as well as different environments.
All these factors combined [康拜恩德] make generalization extremely challenging in real-world scenarios [斯纳里欧兹]. Deformable objects simply require much more diverse data to truly learn well.
However, manually collecting such data on real robots is extremely costly — it requires skilled operators, expensive professional hardware, and a huge amount of human labor, with very low efficiency [伊菲申西].
Therefore, a highly feasible [菲泽布尔] solution is data synthesis [辛塞西斯] — using a small number of demonstrations, or even zero demonstrations, to generate a large amount of diverse synthetic data, thereby improving the model’s generalization capability.
--- 

== Related Work
// 介绍现有相关工作，分析他们共性问题

下面我们分析一些和我们task相同的工作，我们简要进行介绍并分析他们的共性问题

2026.4.10 : SIM1: Physics-Aligned Simulator as Zero-Shot Data Scaler in Deformable Worlds


=== FoldNet 
问题： 服装资产稀缺，衣物操作的错误恢复机制 
方法： 使用模板创建服装几何形状，通过关键点定义服装的形状。引入KG-DAgger方法通过引入错误恢复策略来增强演示质量。

=== SIM1
解决的问题是叠衣服的动力学不完全对齐
方法是对扫描后的资产使用Augmented Vertex Block Descent（AVBD）方法进行物理对齐

=== 

== Our Approach 
我们认为现有的这些工作一个是逃避了STAGE1 （将衣物从随机状态恢复到标准状态）的数据合成，本质还是SIM和REAL的动力学的GAP问题，我们主要解决的是同一衣物类型材质下的衣物状态的多样性的问题。

构建基础模型A
我们先用 Transformer 架构搭建一个基础模型A，让它能够在真机中完整地感知衣物的状态。然后，利用仿真器合成一些初步的数据，训练这个模型的基本能力。
快速数据采集和真实数据集B
接下来，使用 UMI Gripper 在真机中快速收集一些数据，构建一个小规模的真实数据集B。这个数据集要尽量覆盖不同的衣物状态，模拟真实操作中的各种情况。同时，我们还需要收集一个包含动力学信息的数据集C，确保数据能反映真实世界的物理和动态。
训练动力学模型D
基于数据集C，我们训练一个 图神经网络（GNN） 动力学模型D，来模拟衣物操作的物理行为。然后用这个模型来校准仿真器，使得仿真器的动力学和真实世界更匹配，减少仿真和现实之间的差异。
构建仿真数据合成策略E
接着，我们设计一个数据合成策略E，使用已经校准过的仿真器来进行大规模的数据合成。这些合成数据会覆盖不同的衣物状态，比如不同的材质、不同的折叠方式等，确保训练数据足够多样化。
仿真中用HG-DAgger训练
在仿真环境中，我们用 HG-DAgger 方法来训练模型A，帮助它在仿真中更好地学习如何折叠衣物。而且，在训练过程中，模型还会学习如何从失败中恢复，提升训练效率和鲁棒性。
真机测试和反馈
然后，我们把训练好的模型A拿到真机上进行测试，记录下失败的情况。通过分析这些失败场景，找出问题并改进模型。之后，我们把失败的情况回放到仿真环境中，再用 DAgger 方法进行再训练，进一步提升模型在真机上的表现。
迭代优化
最后，我们重复步骤5和6，进行多次迭代，直到模型在真机上的表现达到我们的要求。每次迭代都解决新出现的问题，持续优化模型。

== experiments 


// #include "sections/task.typ"
// #include "sections/motivation.typ"```````
// #include "sections/notes.typ"
// #include "sections/task_def.typ"
// #include "sections/related.typ"

#bibliography(
  "mylib.bib",
  title: [
    参考文献#v(1em)
  ],
  style: "american-physics-society",
)
