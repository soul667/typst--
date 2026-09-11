#import "@preview/graceful-genetics:0.2.0" as graceful-genetics
#import "@preview/physica:0.9.3"
#let 行间距转换(正文字体, 行间距) = ((行间距) / (正文字体) - 0.75) * 1em
#set par(leading: 行间距转换(12, 20), justify: true, first-line-indent: 2em)
#import "@preview/mitex:0.2.4": * // latex 兼容包
#import "@preview/cmarker:0.1.1" //  md兼容包
#import "@preview/codly:1.3.0": * // 设置代码块
#import "@preview/note-me:0.3.0": * //提示
// #show: codly-init.with()
#import "@preview/showybox:2.0.3": showybox // 彩色盒子
#import "@preview/i-figured:0.2.4"
// #show math.equation: i-figured.show-equation.with(only-labeled: true) // 只有引用的公式才会显示编号

#set text(font: ("Times New Roman", "Source Han Serif SC"), size: 12pt) // 设置中英语文字体 小四宋体 英语新罗马

#show figure.where(kind: image): set figure(supplement: [图]) // 设置图
#show figure.where(kind: "tablex"): set figure(supplement: [表]) // 设置表
#import "@preview/mannot:0.1.0": * // 公式突出
// #import "@preview/oasis-align:0.1.0" // 自动布局
#import "@preview/tablex:0.0.9": * // 表格
#show heading: it => {
  it
  par()[#let level = (-0.3em, 0.2em, 0.2em);#for i in (1, 2, 3) {
      if it.level == i { v(level.at(int(i) - 1)) }
    };#text()[#h(0.0em)];#v(-1em);]
} // 修复标题下首行 以及微调标题间距

#show: graceful-genetics.template.with(
  title: [#text(font: ("Times New Roman", "Source Han Serif SC"))[基于激光轮廓扫描的多段圆柱工件半径测量方法研究]],
  authors: (
    (
      name: "AoXiang Gu",
      department: "Primary Logistics Department",
      institution: "Delivery Institute",
      city: "Berlin",
      country: "Germany",
      mail: "2194521087@hrbeu.com",
    ),
    // (
    //   name: "Egon Stellaris",
    //   department: "Communications Group",
    //   institution: "Space Institute",
    //   city: "Florence",
    //   country: "Italy",
    //   mail: "stegonaris@space.it",
    // ),
    // (
    //   name: "Oliver Liam",
    //   department: "Missing Letters Task Force",
    //   institution: "Mail Institute",
    //   city: "Budapest",
    //   country: "Hungary",
    //   mail: "oliver.liam@mail.hu",
    // ),
  ),
  date: (
    year: 2022,
    month: "May",
    day: 17,
  ),
  keywords: (
    "多段圆柱工件",
    "半径测量",
    "B样条迭代平滑",
    "RANSC算法",
    "Hyper fit算法",
  ),
  doi: "10.7891/120948510",
  abstract: [
    在制造业中，多段圆柱形工件的半径精确测量至关重要。传统激光轮廓扫描方法常受分割不准确、噪声高和误差大的困扰。为此，本文提出一种半自动分割与稳健圆柱拟合方法，有效提升测量精度。该方法首先在用户界面进行初步分割，将测量工件点云分割出来，确定测量区域的半径范围。接着，采用 B 样条曲线对原始测点进行迭代平滑，计算平滑后曲线的切线斜率，并转换为二次函数进行分割。对每条点云线划分分割区域后，通过聚类筛选得到最终的测量区域。在测量区域确定后，利用 RANSC 算法识别圆柱轴线，并将点云线投影至轴线。随后，对每条投影后的点云线应用二维 RANSC 算法去噪，并采用 Hyper fit 算法拟合圆柱半径。最后，通过去除半径序列中的异常值，分析得出各段圆柱的精确半径。
  ],
)

= 引言
== 背景介绍
== 传统方法不足
= 相关工作

== 分割方法
== 圆柱轴线
== 圆拟合方法
= 方法
== 基本分析
=== 圆柱方程
使用点到直线距离方程推导，轴线可以表示为
$ r=p+t v $
$p_0=(p_x,p_y,p_z)$是轴上一点，$v=(v_x,v_y,v_z)$是方向向量，
点到直线的距离可以表示为
// #mitex("\frac{\|(\mathbf{r}-\mathbf{p}) p \mathbf{v}\|}{\|\mathbf{v}\|}=r")
$ "dis"(p,r,p_0)=(||(p-p_0) times v||)/(||v||) $ <距离公式>

所以圆柱的方程可以表示为到轴线的距离为$r$，代入$p=(x,y,z)$化简可得

== 分割
== 轴线
== 圆拟合

= 仿真及比较
== 分割
== 轴线
== 圆拟合
= 实验
= 结论


$
  lr(\[ \(y - p_(y )\)v_(z ) - \(z - p_(z )\)v_(y ) \])^(2 ) + lr(\[ \(z - p_(z )\)v_(x ) - \(x - p_(x )\)v_(z ) \])^(2 ) + lr(\[ \(x - p_(x )\)v_(y ) - \(y - p_(y )\)v_(x ) \])^(2 ) & = r^(2 ) \(v_(x )^(2 ) + v_(y )^(2 ) + v_(z )^(2 )\)
$
化简后另一种表达方式为
#mitex(
  "$$
(x-x_{0})^2+(y-y_{0})^2+(z-z_{0})^{2}-\frac{((x-x_{0})v_{1}+(y-y_{0})v_{2}+(z-z_{0})v_{3})^2}{v_{1}^2+v_{2}^2+v_{3}^2}=r^2
$$",
)

上述方程一共七个参数，并且无约束条件。如已经数据，求参数，这是一个七个参数非线性最优化问题。

但对于真实问题，会存在一个缩放系数。也就是$y= beta y'$，后面的计算直接省略掉了这个缩放系数，实际上应该考虑。下面给出仿真中有无$beta$的oyz截面
= 介绍
Our concept suggests three ways that A-Mail can be best utilized.
我们的世界不是这样的。希望你能李解
- First is to reduce the probability of the failure of a space mission. This problem, known as the Mars problem, suggests that the high round-trip time required for communication between Mars and Earth inhibits successful human developments on the planet. Thanks to A-Mail's faster-than-light delivery system this problem could be solved once and for all.

- As A-Mails are written using pen and paper, no digital technology is needed for short and long distance communication. This suggests a possibility of reducing the communication monopoly currently held by an entity known as the "internet". Our suggestion of A-Mail being responsible for postal delivery would reduce dependence on online services by delivering the vast majority of mail offline. Space is a place where drastic changes in methods of production and distribution can easily occur.

- Lastly, A-Mail is capable of performing high-level complex calculations. It is this capability that distinguishes A-Mail from traditional space mailers. This is an especially useful capability when planning long-distance space missions.

The delivery speed of an A-Mail can be determined through this simple formula:

$ v(t) = lim_(t -> infinity) integral^infinity c dot sqrt(t^2) physica.dd("t") $

Building on the strong foundations of A-Mail, we extend our platform to predict problems and apply existing and new best practices to ensure the mail is delivered without any issues. We call this extension AI-Mail. AI-Mail is a new concept designed and delivered by artificially intelligent (AI) agents. The AI-Mail agents are intelligently designed to solve problems at various points in the delivery chain. These problems are related to targeting, delivery delay, tone of delivery, product information, product return, system crash, shipment error and more. AI-Mail provides a one-stop solution for A-Mail's shortcomings.

== Proven technology
A-Mail has been under development four the past ten years and in the process has consolidate different space programmes. Over the course of the last year, our space P.I.s have already found over ten thousand lost letters. These letters had been drifting in space since the stone ages when they were originally mailed. Only now we had the technology to recover them. In this way, A-Mail technology has already proven invaluable to human advancement and research, bringing us closer to our ancestors.

== Limitless possibilities
Through A-Mail's _faster-than-light_ technology, for the first time, humans have the capability to rearch far away solar systems to find out whether we are, after all, alone in this universe.
During our research, we have already established pen pal relations with at least three potential extraterrestrial living forms.

== Direct implications
One of the most direct implications of A-Mail is the solution of the Mars problem. This means that people stuck on Mars can now finally watch football games live, a significant achievement on the grand scale of things. The complex communication interactions arising between Earth, Mars, and the \+

#figure(
  image("a-mail.png"),
  caption: [
    Visualization of the FTL Earth-to-Mars communication capabilities enabled by A-Mail.
  ],
)
