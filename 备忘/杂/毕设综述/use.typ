#import "@preview/rubber-article:0.1.0": *
#import "@preview/mitex:0.2.4": *
#import "@preview/cmarker:0.1.1"
// #import "@preview/quick-maths:0.1.0": shorthands

// 设置公式标号
#import "@preview/i-figured:0.2.4"
#show math.equation: i-figured.show-equation.with(only-labeled: true)
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

#show: codly-init.with()

#show: article.with()
#import "@preview/physica:0.9.3": *

#set text(font: ("Times New Roman", "Source Han Serif SC"), size: 12pt)
// #import "@preview/cuti:0.2.1": show-cn-fakebold
// #show: show-cn-fakebold
#let 行间距转换(正文字体, 行间距) = ((行间距) / (正文字体) - 0.75) * 1em
// // #show par: set block(spacing: 行间距转换(12,20))
#set par(leading: 行间距转换(12, 20), justify: true, first-line-indent: 2em)
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


#align(center, [
  #text(size: 1.5em)[*毕设综述*]
])
// #set math.equation(numbering: "(1)")
// #set math.equation(numbering: "(1.1)")
// #show math.equation.where(block: true): it => {
//  if not it.has("label") {
//    let fields = it.fields()
//    fields.remove("body")
//    fields.numbering = none
//    return [#counter(math.equation).update(v => v - 1)#math.equation(..fields, it.body)<math-equation-without-label>]
//  }
//  return it
// }
//

= 实验室研究方向和近期论文
#v(1em)
机器人与计算机视觉实验室（RCV Lab）是深圳市机器人视觉与导航重点实验室（筹）的所在单位。该重点实验室位于南方科技大学（SUSTech）电子与电气工程系，由南方科技大学的讲座教授张宏教授领导。RCV Lab于2020年由张教授创立，张教授在国外学术界工作了30多年后回到中国。RCV Lab目前支持25名以上成员的研究，包括博士后、博士生、硕士生以及研究助理。实验室配备了多种机器人设备和传感器，并获得了来自公共和私营部门的资金支持。

RCV Lab致力于自主机器人导航、机器人操控和人机交互算法的开发。我们的研究旨在开发能够可靠导航的自主或自驾车辆，无论是在室内还是室外，以执行有用的操作，例如帮助人们和传递物品。我们特别关注利用视觉作为机器人感知环境的主要信息源，以创建其表征并做出智能决策。同时，我们还研究包括LiDAR和偏振成像在内的其他传感方式，以补充视觉感知。目前的研究项目包括：

- 同时定位与地图构建（SLAM）
- 语义场景理解
- 人机交互
- 偏振相机感知（可以不做综述）

== SLAM
引言：SLAM（同步定位与地图构建）是一种用于获取未知环境的三维结构及传感器在环境中运动的技术。该技术最初是为了实现机器人在机器人领域的自主控制而提出的。基于SLAM的应用已广泛扩展，如基于计算机视觉的在线3D建模、增强现实（AR）/虚拟现实（VR）以及无人自主驾驶车辆（UAV）。相机和激光雷达（LiDAR）是SLAM中用于地图建模的两种主要外部传感器，SLAM因此分为两个主要子集，分别为视觉SLAM（V-SLAM）和基于LiDAR的SLAM。近年来，深度学习促进了计算机视觉的发展。深度学习与SLAM的结合越来越引起关注。在目标检测、语义分割和高层环境信息的帮助下，SLAM能够使机器人更好地理解自我运动及周围环境。

详细信息：多传感器融合SLAM、密集跟踪与映射系统、视觉定位、点云位置识别、密集映射、基于自然地标的机器人定位性能评估、视觉定位、LiDAR位置识别、基于特征的主动视图规划与优化的视觉SLAM、长期SLAM、点云配准、基于场景图预测的导航、3D LiDAR映射和指定路线的稳定导航。
== 语义场景理解
引言：在机器人领域，语义场景理解（SSU）是指对视觉场景的解释和理解，以便于后续机器人任务的执行。它涉及从多种类型的来源提取高层次的信息，如图像、视频、点云和自然语言，并在这些信息的元素之间建立上下文联系。尤其是在我们团队中，我们解决场景图生成、语义重排、语义抓取、语义映射、主动SLAM和变化检测等问题。我们的最终目标是赋予机器人以人类水平的感知和推理能力，同时能够基于语义知识与非结构化环境进行互动。SSU与“具身人工智能”的概念密切相关，但我们更感兴趣的是将SSU算法应用于现实世界的机器人应用。




= SLAM综述
#v(1em)首先可以分为激光SLAM和纯视觉SLAM。激光SLAM是指使用激光雷达作为传感器的SLAM系统，而纯视觉SLAM是指使用单目相机或双目相机作为传感器的SLAM系统。激光SLAM和纯视觉SLAM各有优势，激光SLAM的优势在于其精度高，但是成本昂贵，而纯视觉SLAM的优势在于成本低，但是精度相对较低。因此，激光SLAM和纯视觉SLAM各有适用的场景。在实际应用中，激光SLAM和纯视觉SLAM可以结合使用，以充分发挥各自的优势。

== SLAM的历史
SLAM
=== 视觉SLAM(VSLAM)

系统的输入可以与其他传感器数据集成以提供更多信息，例如惯性测量单元（IMU）和激光雷达，而不是只有视觉数据。

首篇实时单目VSLAM于2007年由Davison提出，名为Mono SLAM的框架@davison2007monoslam。他们的间接框架可以使用扩展卡尔曼滤波（EKF）算法估计现实世界中的相机运动和3D元素。尽管缺乏全局优化和回环检测模块，Mono SLAM开始在VSLAM域中发挥主要作用。

然而用这种方法重建的地图只包括地标，没有提供关于该区域的进一步详细信息。Klein等人[14]在同一年提出了Parallel Tracking and Mapping（PTAM），他们将整个VSLAM系统分为两个主要线程：tracking和mapping。PTAM为后续很多工作奠定了基石。PTAM方法的主要思想是降低计算成本，并使用并行处理来实现实时性能。当tracking实时估计摄像机运动时，mapping预测特征点的3D位置。PTAM也是第一个利用光束法平差（BA）联合优化相机姿态和3D地图创建的方法。

=== 激光SLAM

FastLio和FastLio2。

相较于早期基于滤波器的 SLAM 方法， 通常可以得出全局一致性更好的地图， 且随着求解方法的不断发展，在相同计算量的前提下， 图优化 SLAM 的求解速度也已经超过滤波器方法， 是目前 SLAM 领域内的主流方法，也是三维激光 SLAM 采取的主要方案，Hauke 等［9］研究了图优化方法为什么较滤波器方法能取得更优的效果。
= 点云工件测量
#v(1em)
== 点云配准

使得拍摄时工件的角度不再影响测量结果，提高了测量的准确性。常见的点云配准的方法和结果

== 点云分割

分割出我们要识别尺寸的工件的点云，减少了后续的计算量，提高了测量的效率。

== 函数拟合
我们假设一个在空间中的圆柱面,半径$r$，方向向量$(a,b,c)$，圆心$(x_0,y_0,z_0)$，其圆柱面满足方程
因此，圆柱面的方程为：

#mitex(
  `
\boxed{\left( (y - y_0)c - (z - z_0)b \right)^2 + \left( (z - z_0)a - (x - x_0)c \right)^2 + \left( (x - x_0)b - (y - y_0)a \right)^2 = r^2 (a^2 + b^2 + c^2)}
`,
)
#mitex(
  `
\boxed{f(x)=\left( (y - y_0)c - (z - z_0)b \right)^2 + \left( (z - z_0)a - (x - x_0)c \right)^2 + \left( (x - x_0)b - (y - y_0)a \right)^2 -r^2 (a^2 + b^2 + c^2)=0}
`,
)

损失函数
$ "error="|f(x)|^2 $
#h(2em) 我们现在有来自六个平面的点云数据，我们可以通过梯度下降法拟合出圆柱面的参数，并使用不同的损失函数来评估拟合的效果。

一共有七个变量需要回归，如果经过点云配准，我们可以认为圆柱面的方向向量是已知的，那么我们只需要回归圆柱面的半径和圆心坐标，四个变量。

这里我们先使用未经回归的数据进行拟合。


=== 对于在yoz平面上
$(a,b,c)=(1,0,0)$

$ f(x)=(z-z_0)^2+(y-y_0)^2-r^2 $

= 具身智能

#set page(columns: 1)
#bibliography(
  "use.bib",
  title: [
    参考文献#v(1em)
  ],
  style: "nature",
)
