// #set page(width: auto, height: auto)
#import "@preview/cetz:0.4.2": *

// We are working on

#set text(font: ("Times New Roman", "Source Han Serif SC"), size: 12pt)
#let PinCanModel() = {
  return align(center, canvas({
    import draw: *
    // 视角变换矩阵
    // let color="#8f1c1c"
    set-transform(matrix.transform-rotate-dir((1, 1, -1.3), (1, 0, 0)))
    let end_ = 5
    let xyz_line_weight = 1pt
    // content((0.1,1,0), [#text(size: 3pt)[$y$]],mark: (symbol: "triangle"))
    let linePlaneIntersection(recta, rectb, vec) = {}
    content((1em, end_, 0), [#text(size: 1em)[$x$]])
    content((1em, 0, end_), [#text(size: 1em)[$z$]])

    content((-end_, 1em, 0), [#text(size: 1em)[$y$]])

    line((end_, 0, 0), (-end_, 0, 0), stroke: xyz_line_weight, mark: (
      end: "stealth",
      fill: black,
      width: 0.5em,
      height: xyz_line_weight,
    ))
    line((0, -end_, 0), (0, end_, 0), stroke: xyz_line_weight, mark: (
      end: "stealth",
      fill: black,
      width: 0.7em,
      height: xyz_line_weight,
    ))
    line((0, 0, -end_), (0, 0, end_), stroke: xyz_line_weight, mark: (
      end: "stealth",
      fill: black,
      width: 0.6em,
      height: xyz_line_weight,
    ))
    // circle((0,0,0), radius: .02,fill: blue, stroke: 0em)
    content((0.23, 0., 0), [#text(size: 1.8em, black)[*$.$*]])

    content((0.2, 0., 0.2), [#text(size: 0.8em, black)[*$O$*]])

    // circle((1,1,1), radius: .02,fill: blue, stroke: 0em)
    let use_point = (3, 0, 4)
    let circle_point = (0, 0, 0)
    circle((..use_point,), radius: 0.1em, stroke: 0.04em)
    line((..use_point,), (..circle_point,), stroke: (paint: blue, thickness: 0.5pt, dash: "dashed"))
    content((use_point.at(0) + 0.3, use_point.at(1), use_point.at(2) + 0.2), [#text(size: 1em)[$P_1$]])
    let z_use_point = (0, 0, use_point.at(2))
    circle((..z_use_point,), radius: .02, fill: blue, stroke: 0em)
    // p1的延长线-----------------------
    let use_scale = -1.2
    line(
      (..use_point,),
      (use_point.at(0) * use_scale, use_point.at(1) * use_scale, use_point.at(2) * use_scale),
      stroke: (paint: blue, thickness: 0.5pt, dash: "dashed"),
    )
    //-------------------------------------
    let line_(point1, point2) = {
      line((..point1,), (..point2,), stroke: (paint: blue, thickness: 0.5pt, dash: "dashed"))
    }
    let line_1(point1, point2) = {
      line((..point1,), (..point2,), stroke: (paint: rgb("#f75f5f"), thickness: 0.5pt, dash: "dashed"))
    }
    let f = 3
    rect((2, -4, -f), (-4, 1.5, -f), fill: rgb("#a124c048"), stroke: (rgb("#01010100")))
    // mark((1,0,0),(-1,0,0), stroke: 0.3pt, symbol: "straight")
    // mark((0,0,0))
    content((0.23, 0., -f), [#text(size: 1.8em, black)[*$.$*]])
    content((use_point.at(0) + 0.23, use_point.at(1), use_point.at(2)), [#text(size: 1.8em, black)[*$.$*]]) //P1

    let CamP1 = (-f / use_point.at(2) * use_point.at(0), 0, -f)
    let Add(p1, p2) = {
      return (p1.at(0) + p2.at(0), p1.at(1) + p2.at(1), p1.at(2) + p2.at(2))
    }
    let Point(p1) = {
      content((Add(p1, (0.23, 0, 0))), [#text(size: 1.8em, black)[*$.$*]])
    }

    // content((..CamP1), [#text(size: 1.8em,black)[*$.$*]]) //P1
    let p1_ = CamP1
    // Point()
    line_(CamP1, (0, 0, -f))
    content((0.23, 0., -f), [#text(size: 1em, black)[$A$]])
    // content((), [#text(size: 1em,black)[$P'_1$]])

    let ContentUse = (2, 0, 7.2)
    content((..ContentUse,), [#text(size: 0.8em, black)[$
         P_i & =(x_i,y_i,z_i)^T \
         O A & =f \
      A P'_1 & =h'_1 \
      P_1B_1 & =h_1 \
       O B_1 & =f_1
    $]])


    let BiaoZhu = (4, 0, -7.4)
    content((..BiaoZhu,), [#box(fill: rgb("#a124c048"), width: 2em)[#underline("         ")] #text(
        size: 0.9em,
      )[相机平面$A^((x y))$]])
    content(Add(BiaoZhu, (-0.8, 0, 0)), [#text(blue)[-- - -  ] #text(size: 0.9em)[$P_1$辅助线]])
    content(Add(BiaoZhu, (-0.8 * 2, 0, 0)), [#text(rgb("#f75f5f"))[-- - -  ] #text(size: 0.9em)[$P_2$辅助线]])
    content(Add(BiaoZhu, (-0.8 * 3, 0, 0)), [#box(fill: rgb("#5278b63d"), width: 2em)[#underline("         ")] #text(
        size: 0.9em,
      )[$P_1^((x y))$]])
    content(Add(BiaoZhu, (-0.8 * 4, 0, 0)), [#box(fill: rgb("#e4716d33"), width: 2em)[#underline("         ")] #text(
        size: 0.9em,
      )[$P_2^((x y))$]])
    // content(Add(BiaoZhu,(-0.8*2,0,0)), [#text( rgb("#000000"))[------] #text(size: 0.9em)[$P_1P_2$连线]])
    content(Add(BiaoZhu, (-0.8 * 6, 0, 0)), [#text(
      size: 0.9em,
    )[$M^((x y))&=> M in M^((x y)) \ &=> M^((x y)) \/\/ O x y$]])

    content(Add(ContentUse, (-0.8 * 5.5, 0, -0.7)), [#text(
      size: 0.9em,
    )[$P'_21,P_21,P_1 &in O x z \ P'_22, P_22&in O y z \ P'_22,P'_21,P'_2,P'_1,A&in A^((x y)) \ P_21.P_22&in P_2^((x y))$]])
    let B1 = (0, 0, use_point.at(2))
    Point(B1)
    line_(B1, use_point)
    content((Add(B1, (-0.4, 0, 0.1))), [#text(size: 1em, black)[$B_1$]])

    // content((-2+0.23,0.,-f), [#text(size: 1.8em,black)[*$.$*]])

    let use_point1 = (2.5, 2, 2)
    Point(use_point1)
    Point((0, 0, use_point1.at(2)))
    content((Add((0, 0, use_point1.at(2)), (-0.4, 0, 0.3))), [#text(size: 1em, black)[$B_2$]])
    line_1(use_point1, (0, 0, use_point1.at(2)))

    line_1(use_point1, (0, 0, 0))
    content((Add(use_point1, (-0.5, 0, 0.3))), [#text(size: 1em, black)[$P_2$]])
    line(use_point, use_point1, stroke: (paint: rgb("#000000"), thickness: 0.7pt))
    // line(use_point,use_point1, luma(58.8%, 0.4%),stroke: xyz_line_weight,mark: (end: "stealth",fill: rgb("#9db939a8"),width: 0.5em,height: xyz_line_weight))

    rect((4, 2, 4), (-1, -1, 4), fill: rgb("#5278b63d"), stroke: (rgb("#01010100")))
    rect((3, 2, 2.5), (-1, -1.4, 2.5), fill: rgb("#e4716d33"), stroke: (rgb("#01010100")))
    let p21 = Add(use_point1, (0, -use_point1.at(2), 0))
    Point(p21)
    line_1(p21, use_point1)

    let p22 = Add(use_point1, (-use_point1.at(0), 0, 0))
    Point(p22)
    line_1(p22, use_point1)
    line_1(p22, (-2 * p22.at(0), -2 * p22.at(1), -2 * p22.at(2)))
    let Scale(point, use) = {
      return (point.at(0) * use, point.at(1) * use, point.at(2) * use)
    }
    content((Add(p22, (-0.5, 0, 0.3))), [#text(size: 1em, black)[$P_22$]])
    let p22_ = Scale(p22, -f / use_point1.at(2))
    Point(p22_)
    content((Add(p22_, (0.5, 0, 0.3))), [#text(size: 1em, black)[$P'_22$]])
    let p21_ = Scale(p21, -f / use_point1.at(2))
    Point(p21_)
    content((Add(p21_, (-0.5, 0, 0.3))), [#text(size: 1em, black)[$P'_21$]])

    let p2_ = Scale(use_point1, -f / use_point1.at(2))
    Point(p2_)
    content((Add(p2_, (-0.5, 0, 0.3))), [#text(size: 1em, black)[$P'_2$]])

    line_1(p21_, p2_)
    line_1(p22_, p2_)
    line(p1_, p2_, stroke: (paint: rgb("#000000"), thickness: 0.7pt))
    Point(p1_)
    content((Add(p1_, (-0.2, 0, 0.3))), [#text(size: 1em, black)[$P'_1$]])

    // Point((Add(p_,(0,-p_.at(1),0))))


    content((Add(p21, (0.5, 0, 0.3))), [#text(size: 1em, black)[$P_21$]])
    line_1(p21, (-2 * p21.at(0), -2 * p21.at(1), -2 * p21.at(2)))


    let scale_line = 1.5
    line_1(use_point1, (-use_point1.at(0) * scale_line, -use_point1.at(1) * scale_line, -use_point1.at(2) * scale_line))
    let oc = (2, -4, -f)
    Point(oc)
    content((Add(oc, (0.5, 0, 0.3))), [#text(size: 1em, black)[$O_c (P_0)$]])
    line(oc, Add(oc, (0, 5.6, 0)), stroke: xyz_line_weight, mark: (
      end: "stealth",
      fill: black,
      width: 0.7em,
      height: xyz_line_weight,
    ))
    content((Add(Add(oc, (0, 5.6, 0)), (0.2, 0, 0.3))), [#text(size: 1em, black)[$x$]])
    line(oc, Add(oc, (-6, 0, 0)), stroke: xyz_line_weight, mark: (
      end: "stealth",
      fill: black,
      width: 0.7em,
      height: xyz_line_weight,
    ))
    content((Add(Add(oc, (-6, 0, 0)), (0.2, 0, 0.3))), [#text(size: 1em, black)[$y$]])
  }))
}

#PinCanModel()
// #import "@preview/i-figured:0.2.4"
#import "@preview/rubber-article:0.1.0": *
#import "@preview/mitex:0.2.4": *
#import "@preview/cmarker:0.1.1"
#import "@preview/i-figured:0.2.4"
#show math.equation: i-figured.show-equation.with(only-labeled: true)
#show heading: i-figured.reset-counters
#show figure: i-figured.show-figure
// 设置代码块
#import "@preview/codly:1.3.0": *
#codly(
  languages: (
    python: (
      name: "Python",
      // icon: [#tabler-icon("brand-github-filled")]
    ),
  ),
)
#import "@preview/showybox:2.0.3": showybox
// #show: codly-init.with()

#show: article.with()
#import "@preview/physica:0.9.3": *
#import "@preview/lovelace:0.3.0": *
#set text(font: ("Times New Roman", "Source Han Serif SC"), size: 12pt)
// #import "@preview/cuti:0.2.1": show-cn-fakebold
// #show: show-cn-fakebold
#import "@preview/dashy-todo:0.0.1": todo
#let 行间距转换(正文字体, 行间距) = ((行间距) / (正文字体) - 0.75) * 1em
#set par(leading: 行间距转换(12, 20), justify: true, first-line-indent: 2em)
#import "@preview/indenta:0.0.3": fix-indent
#show: fix-indent() // 修复第一段的问题
#show heading: it => {
  // set text(font: ("Times New Roman","Source Han Serif SC"), size: 12pt)
  it
  par()[
    #if it.level == 1 {
      v(-0.3em)
    }
    #if it.level == 2 {
      v(0.2em)
    }
    #if it.level == 3 {
      v(0.2em)
    }
    #text()[#h(0.0em)]
    #v(-1em)
  ]
}

#show ref: it => {
  let eq = math.equation
  let el = it.element
  if el != none and el.func() == eq {
    // Override equation references.
    link(
      el.location(),
      "式"
        + numbering(
          el.numbering,
          ..counter(eq).at(el.location()),
        ),
    )
  } else {
    // Other references as usual.
    it
  }
}
#show figure.where(kind: image): set figure(supplement: [图])
#show figure.where(kind: "tablex"): set figure(supplement: [表])
//#import "@preview/lasaveur:0.1.3" //数学公式简写
#import "@preview/mannot:0.1.0": * // 公式突出
#import "@preview/oasis-align:0.1.0" // 自动布局
// ------------定理 证明----------------
#import "@preview/ctheorems:1.1.3": *
#show: thmrules

#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong,
)
#let theorem = thmbox("theorem", "Theorem", stroke: rgb("#ada693a1") + 1pt)

#let definition = thmbox(
  "definition",
  "Definition",
  inset: (x: 0.5em, top: -0.25em, bottom: -0.25em),
  stroke: rgb("#ada693a1") + 0pt,
)
#let proof = thmproof("proof", "Proof")
// ----------------------------
#import "@preview/grayness:0.2.0": * // 基本图片编辑功能
#import "@preview/glossarium:0.5.1": gls, glspl, make-glossary, print-glossary, register-glossary
#show: make-glossary
#let entry-list = (
  // minimal term
  (
    key: "lanbda",
    short: $lambda$,
    long: "特征值",
    description: [
      对于矩阵A,如果满足
      $ A x=lambda x $
      $lambda$就是A的特征值，x是特征向量

    ],
  ),
  // a term with a long form and a group
  (
    key: "tr",
    short: $Tr$,
    long: "迹",
    // group: "Matrix",
    description: [
      Tr表示矩阵的迹，是用于求矩阵对角元素之和的算子
      $ Tr[X]= sum_i X_(i i) $
    ],
  ),
  // a term with a markup description
  (
    key: "linear space",
    short: "linear space",
    long: "线性空间",
    // group: "Acronyms",
  ),
  // a term with a short plural
  // *外参*(Camera Extrinsics)
  (
    key: "ct",
    short: "外参数矩阵",
    // "plural" will be used when "short" should be pluralized
    long: "Camera Extrinsics",
    description: [一个$3*4$的矩阵$T$,$ T=mat(1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0)T' $],
  ),
  // a term with a long plural
  (
    key: "ck",
    short: "内参数矩阵",
    // "plural" will be used when "short" should be pluralized
    long: "Camera Intrinsics",
    // description: [一个$3*4$的矩阵$T$,$ T=mat(1,0,0,0;0,1,0,0;0,0,1,0)T' $],
  ),
)
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

// 有关可断开和不可断开块的更多信息，请参阅块文档。
#let publish = 0

#register-glossary(entry-list)
#set math.mat(delim: "[")
#set page(columns: 2)
#place(
  [#align(center, [
    #text(size: 1.3em)[*术语表*]
  ])],
  dx: 90%,
  dy: -5%,
)
1. 矩阵统一用大写字母表示，如$A,X$标量用小写字母表示，如$x,y$；
  - 对于返回值是矩阵的函数，同理应该为$F(X)$,标量函数就记作$f(x)$
  - 另外，对于不混淆意思的$x*1$维度矩阵，也就是*向量，允许用小写字母表示*，如$x,y,x_i$
2. 对于矩阵的行列数，统一用${m,n}$下标表示，如$display(A_{m,n})$
#print-glossary(entry-list)
// Some Matrix Function
#let Mabij(MatrixName1, MatrixName2) = {
  return $sum_k #MatrixName1 _(i k)#MatrixName2 _(k i)$
}
#let matrix_(a, m, n) = {
  return [$mat(#a _(11), #a _(12), ..., #a _(1 #n); #a _(21), #a _(22), ..., #a _(2#n); dots, dots, dots, dots; #a _(#m 1), #a _(#m 2), ..., #a _(#m#n))$]
}
#let vecs(a) = {
  // return [$mat(#a _1;#a _2;...;#a _n)$]
  return [$(#a _1,#a _2,...,#a _n)$]
}
// -----------------------------
#set page(columns: 1)

#align(center, [
  #text(size: 1.5em)[*数学知识杂烩*]
])
#align(center, [
  = 矩阵论
])
#show figure.where(kind: image): set figure(supplement: [图])
#show figure.where(kind: "tablex"): set figure(supplement: [表])
// #figure(
//   align(center,
//   image("./1.png",width: 80%)
//   )
//   , caption: []
// )

