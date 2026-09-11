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
  #text(size: 1.5em)[#text(font: "SimHei")[*移动操作数据合成相关笔记*]]
])


// *摘要*:在制造业中，多段圆柱形工件的半径精确测量至关重要。传统激光轮廓扫描方法常受分割不准确、噪声高和误差大的困扰。为此，本文提出一种半自动分割与稳健圆柱拟合方法，有效提升测量精度。该方法首先在用户界面进行初步分割，将测量工件点云分割出来，确定测量区域的半径范围。接着，采用 B 样条曲线对原始测点进行迭代平滑，计算平滑后曲线的切线斜率，并转换为二次函数进行分割。对每条点云线划分分割区域后，通过聚类筛选得到最终的测量区域。在测量区域确定后，利用 RANSC 算法识别圆柱轴线，并将点云线投影至轴线。随后，对每条投影后的点云线应用二维 RANSC 算法去噪，并采用 Hyper fit 算法拟合圆柱半径。最后，通过去除半径序列中的异常值，分析得出各段圆柱的精确半径。

// *关键词*：多段圆柱工件，半径测量，B样条迭代平滑，RANSC算法，Hyper fit算法
// #align(center, [
//   #text(size: 1em)[= *引言*]
//   #v(1em)
// ])

// #grid(
//   columns: (50%, auto),
//   [
//     #image1(image("./img/4.png", height: 6cm), [$(0.99,0.03,0.05),beta=1,"oyz"$])
//   ],
//   [#image1(image("./img/5.png", height: 6cm), [$(0.99,0.03,0.05),beta=0.9，"oyz"$])],
// )
= Motivation
#v(-1.5em)
== task
#showybox(
  [OUR TASK: 面向移动操作任务的通用数据合成范式],
)
我们认为在未来，机器人智能会像大模型一样，沿着一条向上弯曲的绿色箭头曲线不断进化，从“专才”到“通才”再到“通用专家”。
#image1(image("./img/1.png", height: 9cm), [机器人智能的进化路径])
// #image("/assets/image.png")

要实现通用专家，我们会对数据更加饥渴，需要海量的 环境、物体、视角多样化的数据来进行训练，然而在移动操作下数据采集的成本也陡然上升，所以急需数据合成技术来降低数据采集的成本。


// #v(-1.5em)
== problem of the current mobile manipulation data synthesis method
// #image("/assets/image.png")
#set page(columns: 1)

=== 场景构建代价高昂，难以支撑规模化数据需求
每构建一个高保真的资产就要多位3D建模师对环境进行扫描重建，后处理，分割出我们操作的区域，物体，手工标注物理属性，这大大影响了迭代速度以及diversity（环境、物体、视角）的提升。
#v(0.5em)
但是，要实现哪怕单任务的通用专家，我们也需要成千上万的场景以及资产去采集数据，如果用传统的方法（遥操作或者传统的场景重建+人工后处理）显然是不现实的，我们需要的是一个能够快速重建海量多样化场景，生成多样化任务相关资产以及任务操作数据的范式。
#v(0.5em)

我们真正需要什么呢？有哪些Gap呢？
+ 大量预先构建的高保真 scenes
  - 需要花费大量时间，对于一个大型的场景，可能数周
+ 大量物理精确的simready物体资产
  - SimReady assets may be diverse，比如外观，物理属性，并且对于deformable物体本身状态的diverse，怎么去做到这些不同diverse的数据，采集或者合成，都是一个巨大的挑战
  - 物体资产的标注，标注到任务相关的affordance，比如可以用语义关键点，抓取pose
+ 能够去生成任务相关数据的仿真器
  - 资源占用以及并行数据生成，其所占用的资源越少我们就可以在单位GPU hour上产出更多的数据，其潜力巨大


= 一些基础知识
== 3D Gaussian Splatting
就正常按照点云来理解，不一样的是在每一个点的位置，实际上他会是一个椭圆，并且有一个密度分布，按照原文来理解的话就是

= 相关工作
== GEN-1
// #image("./img/2.png", height: 6cm)
通过GEN-0，我们首次展示了尺度定律1 存在于机器人领域——将物理人工智能模型带入预训练时代；构建GEN-1并不容易——我们重新设计了分布式培训基础设施，以支持数PB的物理交互数，对我们来说，GEN-1不仅仅是一个模型。它捕捉了人工智能中我们认为在当今聊天机器人中缺失的重要部分。那是从现实世界中行动中产生的直觉和开放式问题解决能力——结合了基于真实物理的知识，以及对空间和时间重要性的深刻理解，以及行动带来后果的深刻理解。
#bibliography(
  "mylib.bib",
  title: [
    参考文献#v(1em)
  ],
  style: "american-physics-society",
)
