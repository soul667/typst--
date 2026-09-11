// 基本模板
#import "@preview/rubber-article:0.1.0": *
#show: article.with()
#import "@preview/mitex:0.2.4": * // latex 兼容包
#import "@preview/cmarker:0.1.1" //  md兼容包
#import "@preview/codly:1.3.0": * // 设置代码块
#import "@preview/note-me:0.3.0": * //提示
// #show: codly-init.with()
#import "@preview/showybox:2.0.3": showybox // 彩色盒子
#import "@preview/cetz:0.4.2": canvas, draw // CeTZ 绘图包
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

// #include "use.typ"
#set page(columns: 1)
= 初高衔接
== 和差公式
=== 平方和差公式
$
  (a+b)(a-b) & =a^2-b^2 \
     (a+b)^2 & =a^2+b^2+2 a b
$
=== 完全n次方公式 $#h(-0.5em)" "^*$
可以使用杨辉三角来进行记忆


// #align(center,[#image("img/23.png",width: 70%)])
$
  (a+b)^0 & =1 \
  (a+b)^1 & =a+b \
  (a-b)^1 & =a-b \
  (a+b)^2 & =a^2+2a b -b^2 \
  (a-b)^2 & =a^2 - 2 a b + b^2 \
  (a+b)^3 & =a^3+3a^2b+3 a b^2 + b^3 \
  (a-b)^3 & =a^3-3a^2b+3 a b^2 - b^3 \
        . & ..
$

Q: 请自己写出$(a+b)^4$和$(a-b)^4$的公式

$
  (a+b)^4 & = a^4 + 4a^3b + 6a^2b^2 + 4a b^3 + b^4 \
  (a-b)^4 & = a^4 - 4a^3b + 6a^2b^2 - 4a b^3 + b^4
$
=== 立方和差公式

$
  a^3+b^3 & =(a+b)(a^2-a b+b^2) \
  a^3-b^3 & =(a-b)(a^2+a b+b^2)
$

=== 拓展到n方和差公式
$ a^n-b^n=(a-b)(a^(n-1)+a^(n-2)b+dots +a b^(n-2) +b^(n-1))#h(1em)n"为任意整数" $
$ a^n+b^n=(a+b)(a^(n-1)-a^(n-2)b+dots +a b^(n-2) -b^(n-1))#h(1em)n"为正奇数" $

==== 例题1
$ 27a-a^4=a(3^3-a^3)=a(3-a)(3^2+3a+a^2) $
==== 例题2
$ 729a^6-243a^4+27a^2-1 $

#mitex(
  `
\begin{align}&\text{原式 }=9^3a^6-3^5a^4+3^3a^2-1\\&=(9a^2)^3-3(9a^2)^2+3(9a^2)\cdot1^2-1^2\\&=(9a^2-1)^3\end{align}
`,
)
=== 例题3
$ 9x^5-72x^2y^3 $
$ "原式"=9x^2[x^3-(2y)^3]= 9x^2(x-2y)(x^2+2x y+4y^2) $

=== 例题4
#mitex(
  `
\begin{pmatrix}2x+y\end{pmatrix}^3-\begin{pmatrix}2y-x\end{pmatrix}^3
`,
)

$ "原式"=(3x-y)(3x^2+3x y+7y^2) $
=== 例题5
$ x^5-1 $

$ (x-1)(x^4+x^3+x^2+x+1) $
==== 对于根式套根式
$ sqrt(5-2sqrt(6)) #h(3em) sqrt(4-sqrt(15)) "的化简" $

$ sqrt(5-2sqrt(6)) & = sqrt(sqrt(2)^2+sqrt(3)^2-2 sqrt(2) sqrt(3))=|sqrt(2)-sqrt(3)|=sqrt(3)-sqrt(2) $

$ sqrt(4-sqrt(15)) & = sqrt(1/2(8-2sqrt(15)))=sqrt(2)/2(sqrt(5)-sqrt(3))=1/2(sqrt(10)-sqrt(6)) $
== 因式分解
=== 十字相乘
$
  (a x +b)(c x + d) & =a c x^2+ (a d +a c)x + b d \
                    & = A x^2 + B x + C
$

==== 例题
$
       x^2-3x-4 & \
     x^2 -5x +6 & \
  x^2 -12x + 20 & \
   x^2 + 2x - 8 & \
$


$
      6x^2-7x-3 & \
     x^2 -5x +6 & \
  x^2 -12x + 20 & \
   x^2 + 2x - 8 & \
$
=== 长除法$#h(-0.2em)" "^*$
将一个多项式（被除式）除以另一个多项式（除式），以找到商式和余式
如$x^3+2x^2-5x-6$，我们能找到其一个根$x=2$，对于剩下的根，使用长除法
$
  & (x^3+2x^2-5x-6) / (x-2) \
  & = (4x^2-5x-6) / (x-2)+x^2 \
  & = (3x-6) / (x-2) +x^2+4x \
  & = x^2+4x-3 \
  & =(x-3)(x-1)
$
// = 集合
// == 定义
// // 群是抽象代数的概念，群是一种集合加上一种运算的代数结构，我们将集合记作 $A$, 那么群就可以记作是 $G=(A,.)$，该运算满足如下几个条件
// // / 封闭性: $forall  a_1,a_2 in A$,$a_1 dot a_2 in A$
// // // #set font:
// //

//
== 三角形相关知识
=== 直角三角形相关
// page()
= 集合
== 基本概念
/ 集合: *研究对象所组成的整体*
  - 比如自然数集合 $NN$, 实数集合 $RR$，一个教室里的学生等都可以叫做集合
  - 一般用大写字母来表示，如 $A$, $B$, $C$ 等
/ 元素: *组成集合的各个对象*
  - 比如自然数集合 $NN$ 中的元素有 $0, 1, 2, 3, ...$ 等
  - 一般用小写字母来表示，如 $a$, $b$, $c$ 等
集合中的元素具有 *无序性*和*唯一性*，即集合中的元素不考虑顺序，且每个元素只能出现一次。

常见的集合有 自然数集
=== 集合的表示方法
/ 列举法: *直接列出集合中的所有元素*，如 $A = {1, 2, 3, 4}$
/ 描述法: *用条件描述集合中的元素*，如 $B = {x in RR | x > 0}$ 表示所有大于0的实数
=== 集合的相关符号（集合关系）
属于、包含、交并补。
/ 属于($a in A "或" a in.not A$): 元素$a$属于集合$A$
/ 包含($A subset.eq B$): 集合$A$是集合$B$的子集
  / 真包含(#mi("A \subsetneqq B")): 集合$A$是集合$B$的*真*子集，真子集的定义是$A subset.eq B,exists("存在") x in A,x in.not B$
/ 空集($diameter$): 没有任何元素的集合，*空集是任意集合的子集*

=== 集合之间的运算
主要包括交、并、补运算
/ 交集($A inter B$): ${x| x in A " 且 " x in B }$
/ 并集($A union B$): ${x| x in A " 或 " x in B }$
/ 全集($U$): 包含所研究对象元素的集合，通常用大写字母$U$表示
/ 补集($C_u A$): ${x| x in U " 且 " x in.not A }$
/ venn图: 用来表示集合之间的关系和运算，如下例子

#figure(
  canvas({
    import draw: *

    // 设置坐标系
    set-style(
      stroke: (thickness: 1.5pt, paint: black),
      fill: none,
    )

    // 绘制外边框（全集U）
    rect((-3, -2.5), (3, 2.5), stroke: (thickness: 2pt, paint: black), name: "universe")
    content((-2.5, 2), [U], anchor: "center")

    // 绘制集合A（左圆）
    circle((-0.8, 0), radius: 1.2, fill: rgb(255, 0, 0, 50), stroke: (thickness: 1.5pt, paint: red), name: "A")
    content((-1.5, 0), text(size: 14pt, fill: red)[A], anchor: "center")

    // 绘制集合B（右圆）
    circle((0.8, 0), radius: 1.2, fill: rgb(0, 0, 255, 50), stroke: (thickness: 1.5pt, paint: blue), name: "B")
    content((1.5, 0), text(size: 14pt, fill: blue)[B], anchor: "center")

    // 标记交集区域
    content((0, 0), text(size: 10pt, fill: purple)[A∩B], anchor: "center")

    // 标记并集外的区域
    content((0, -1.8), text(size: 12pt, fill: black)[A∪B], anchor: "center")
  }),
  caption: [两个集合的 Venn 图示例],
  supplement: [图],
)
== 关于集合的一些基本定理
*德摩根定律*
$ C_u (A inter B) = C_u A union C_u B $
$ C_u (A union B) = C_u A inter C_u B $
#bibliography(
  "mylib.bib",
  title: [
    参考文献
    #v(1em)
  ],
  style: "gb-t-7714-2015-numeric-hit.csl",
  full: false,
)
