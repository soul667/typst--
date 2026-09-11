// 基本模板
#import "@preview/rubber-article:0.1.0": *
#show: article.with()
#import "@preview/mitex:0.2.4": * // latex 兼容包
#import "@preview/cmarker:0.1.1" //  md兼容包
#import "@preview/codly:1.3.0": * // 设置代码块
#import "@preview/note-me:0.3.0": * //提示
// #show: codly-init.with()
#import "@preview/showybox:2.0.3": showybox // 彩色盒子
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
#set page(columns: 1)

// = 目录
#outline(title: none)
// -----------------------------
#set page(columns: 1)

#align(center, [
  #text(size: 1.5em)[#text(font: "SimHei")[*基于激光轮廓扫描的多段圆柱工件半径测量方法研究*]]
])

*摘要*:在制造业中，多段圆柱形工件的半径精确测量至关重要。传统激光轮廓扫描方法常受分割不准确、噪声高和误差大的困扰。为此，本文提出一种半自动分割与稳健圆柱拟合方法，有效提升测量精度。该方法首先在用户界面进行初步分割，将测量工件点云分割出来，确定测量区域的半径范围。接着，采用 B 样条曲线对原始测点进行迭代平滑，计算平滑后曲线的切线斜率，并转换为二次函数进行分割。对每条点云线划分分割区域后，通过聚类筛选得到最终的测量区域。在测量区域确定后，利用 RANSC 算法识别圆柱轴线，并将点云线投影至轴线。随后，对每条投影后的点云线应用二维 RANSC 算法去噪，并采用 Hyper fit 算法拟合圆柱半径。最后，通过去除半径序列中的异常值，分析得出各段圆柱的精确半径。

*关键词*：多段圆柱工件，半径测量，B样条迭代平滑，RANSC算法，Hyper fit算法
#align(center, [
  #text(size: 1em)[= *引言*]
  #v(1em)
])
== 背景
暂略。
== 一般方程
=== 圆柱方程
如果只考虑单个圆柱体，我们使用点到直线距离方程推导来推导出其圆柱方程。
轴线$r$可以表示为
$ r'=p+t v $
其中$p_0=(p_x,p_y,p_z)$是轴上一点，$v=(v_x,v_y,v_z)$是方向向量，
点到直线的距离可以表示为
// #mitex("\frac{\|(\mathbf{r}-\mathbf{p}) p \mathbf{v}\|}{\|\mathbf{v}\|}=r")
$ "dis"(p,r',p_0)=(||(p-p_0) times v||)/(||v||) $ <距离公式>

所以圆柱的方程可以表示为到轴线的距离为$ "dis"(p,r',p_o)=r $代入$p=(x,y,z)$化简可得

$
  &lr(\[ \(y - p_(y )\)v_(z ) - \(z - p_(z )\)v_(y ) \])^(2 ) + lr(\[ \(z - p_(z )\)v_(x ) - \(x - p_(x )\)v_(z ) \])^(2 ) + \ & lr(\[ \(x - p_(x )\)v_(y ) - \(y - p_(y )\)v_(x ) \])^(2 ) = r^(2 ) \(v_(x )^(2 ) + v_(y )^(2 ) + v_(z )^(2 )\)
$
化简后另一种表达方式为
$
  & \(x - x_(0 )\)^(2 )+ \(y - y_(0 )\)^(2 )+ \(z - z_(0 )\)^(2 )-\ & frac(\(\(x - x_(0 )\)v_(1 )+ \(y - y_(0 )\)v_(2 )+ \(z - z_(0 )\)v_(3 )\)^(2 ), v_(1 )^(2 )+ v_(2 )^(2 )+ v_(3 )^(2 ))= r^(2 )
$

或者圆柱还可以用 @bederDirectSolutionsComputing2006 中的方程表示。

=== 圆的方程
$ (x-a)^2+(y-b)^2=r^2 $
$ A (x^2 + y^2) + B x + C y + D =0 #h(0.5em) "st" B^2+C^2-4 A >0 #h(0.5em) $ <圆公式>

上述 @eqt:圆公式 中的约束其实完全可以写作
$ B^2+C^2-4 A =1 $
完全成立。
== 轮廓仪
=== 轮廓仪的标定问题

对于激光轮廓扫描仪，如果未进行标定，会在y轴存在一个缩放系数。
假使底面真实移动速度为$V_("true")$,轴$v'=(v'_x,v'_y,v'_z) #h(0.5em) \& #h(0.5em) v'_x^2+v'_y^2+v'z^2=1$
也就是$y= beta y'$
$ V_y'=v_y V_("true") $
后面的计算在经过标定$v'$后直接省略掉了这个缩放系数。下面给出仿真中有无$beta$的oyz截面

#grid(
  columns: (50%, auto),
  [
    #image1(image("./img/4.png", height: 6cm), [$(0.99,0.03,0.05),beta=1,"oyz"$])
  ],
  [#image1(image("./img/5.png", height: 6cm), [$(0.99,0.03,0.05),beta=0.9，"oyz"$])],
)

#grid(
  columns: (50%, auto),
  [
    #image1(image("./img/7.png", height: 6cm), [$(0.99,0.09,0.05),beta=1，"轴面"$])
  ],
  [#image1(image("./img/8.png", height: 6cm), [$(0.99,0.09,0.05),beta=0.9，"轴面"$])],
)

// #image1(image("./img/1.png"),"无缩放系数 轴为(0.99,0.3,0.1)")

// #image1(image("./img/2.png",width: 70%),"沿着(0.99,0.3,0.1)的y*=0.6 轴为(1,0,0")



// == 另一种表示方法
// 参考@bederDirectSolutionsComputing2006 中的定义，一个圆柱的方程可以表示为
// $ X C X=0 $
// 存在一个平面使得

// 如果有九个点，可以使用简单的线性方程组
// $ A "vech" C = "vech"^T (X_i X_i^T)"vech" C =0 $
// == 求解算法综述
// 直接求解的方法可以转换成线性最小二乘使用非迭代算法求解，也可以使用无约束算法进行优化，和RANSC（大部分是基于表面法线，有一种直接的最少五点式直接算法 @bederDirectSolutionsComputing2006）。迭代法求解受初值影响非常大，并且难以收敛，圆心角越小越是如此。

// 不过大部分方法都是先寻找到圆柱轴，将问题降维到四个参数的最优化问题，本文中也采用这种思路。*寻找轴线*的方法有PCA、鲁棒PCA、圆柱切面椭圆拟合以及其他一些方法（RANSC）。

// 对于降维后的问题，也存在多种求解方法，比如非迭代算法，使adam优化过后的梯度下降等。

// == 激光轮廓扫描仪的调节
=== 参数调节
曝光参数会影响最终点云的质量,如果曝光增益调的太高,则测量部分中间会出现空洞,太低则效果不好,目前参数是
// #definition([*对称、实对称、正定、半正定、海森矩阵*])[
#align(center, [
  #tablex(
    columns: 2,
    align: center + horizon,
    auto-vlines: false,
    repeat-header: true,

    /* --- header --- */
    [*曝光*],
    [*增益*],
    [200],
    [0],
  )
])
// ]


#h(2em)ROI直接设置为`FULL`模式

然后接下来是一键调参的参数,设置
#align(center, [
  #tablex(
    columns: 4,
    align: center + horizon,
    auto-vlines: false,
    repeat-header: true,

    /* --- header --- */
    [*移动速度(mm/ s)*],
    [*x轴精度*],
    [*y轴精度*],
    [*行程长度(mm)*],
    [2],
    [50],
    [5],
    [20],
  )
])


#h(2em) 然后控制步进电机根据工件上激光痕迹将要测量区域周围测量完毕.


= 轴拟合方法/圆柱拟合 #footnote()[一开始我们尝试使用大圆柱的轴当作测量部份圆柱的轴，但是其实由于加工误差这两部分的轴并不完全一致，这个很小的轴向偏差最终影响很大，所以最终还是只是用测量部份进行轴的估计。]
#v(0.5em)
根据@lalondeAutomaticThreeDimensionalPoint 3-D 拟合技术产生的结果比 2-D 投影差大约 25%。3-D 拟合很可能对噪声敏感,而 2-D 投影可以更好地平均化噪声,因为圆上的点密度高于圆柱上的点密度。
== 相关研究
现有的圆柱拟合方法主要集中在完整数据上，即假设圆柱物体被完全扫描。目前很少有针对受异常值污染的不完整点云数据中的圆柱拟合进行全面研究的文献@nurunnabiRobustCylinderFittinga 。

大多数用于几何基元（例如平面和圆柱）提取和拟合的方法都是基于最小二乘法（LS）和/或奇异值分解（SVD），这两种方法都对异常值敏感，并且在统计上不具备稳健性。

众所周知的RANdom SAmple Consensus (RANSAC)方法已被用于在存在异常值的情况下进行稳健的模型拟合。Bolles和Fischler在@bolles1981ransac 中首次提出了使用RANSAC进行圆柱拟合的工作(使用最小二乘) 。后来~~ 改进了RANSC算法,引入了5-9个点的直接代数解法.
#footnote()[RANSAC并不能完全摆脱异常值的影响 根据@nurunnabiRobustCylinderFittinga]
在后来的阶段，表面拟合方法被用于在3D数据中寻找圆柱@lukacsFaithfulLeastsquaresFitting1998 。


(多年来，许多修订版的RANSAC已被开发出来。@nurunnabiROBUSTCYLINDERFITTING2017 考虑RANSAC（Fischler和Bolles，1981）进行比较，因为其众所周知，并且许多人（参见Wang等人，2016）将其作为首选，考虑到其高质量的结果、稳健性和通用性。)

Faber和Fisher @faberBuyersGuideEuclidean2001 通过约束欧几里得拟合方法解决了3D数据圆柱拟合的问题，并声称他们的方法比更常用的代数拟合方法产生更好的结果。Wang和Suter@WANG20032953  成功地使用了稳健回归，并结合@Su2001674 中定义的对称距离，用于在2D图像数据中进行稳健圆和椭圆拟合。然而，指出，他们的方法并不适用于空间不对称（即*部分*）数据。

Lalonde等人@lalondeAutomaticThreeDimensionalPoint 沿用了Kwon等人使用主成分分析（PCA）进行圆柱拟的想法，并将其应用于树干估计。基于圆拟合的方法，包括@lalondeAutomaticThreeDimensionalPoint，已被许多圆柱拟合方法采用。作者@lalondeAutomaticThreeDimensionalPoint 展示了他们基于PCA的方法比其他方法显著更快且更准确，但他们没有考虑异常值的存在。


Abdul 等@nurunnabiRobustCylinderFittinga 针对离群点的敏感性和圆柱采样不完全的问题，提出并比较了两种稳健的圆柱拟合方。新提出的两种算法使用了稳健主成分分析（RPCA）、稳健回归。


Chaperon和Goulette（2001）提出了一种两步方法；第一步在Gaussian球面上使用RANSAC来找到圆柱的方向，而第二步则找到圆柱的位置和大小。

Beder和Förstner（2006）使用RANSAC在原始点云上获得直接解决方案，用于估计圆柱参数。
Vosselman等人（2004）引入了一种基于HT的圆柱检测算法，该算法*使用数据点的法*来获得圆柱方向。



=== PCA
PCA主要是受到@nurunnabiROBUSTCYLINDERFITTING2017 @nurunnabiRobustCylinderFittinga 这两篇文章，但其实这两篇文章均使用的是RPCA得到了较好的效果，但是在我们的仿真中RPCA并没有得到较好的效果。

// Deschaud和Goulette[34]认为，RANSAC在检测噪声点云中的大平面时非常高效，但在提取大型点云中的小平面时速度很慢
下面简单推导一下二维的PCA

从最小点集中提取圆柱体和圆锥体 一种直接的代数求解方法
先推导二维的PCA

计算一维数据的方差
$ s^2(X)=1/(n-1) sum_(i=1)^n (x_i-macron(x))^2 $

对于二维数据有协方差
$ "cov" (X,Y)=1/(n-1) sum_(i=1)^n (x_i-macron(x))(y_i-macron(y)) $

将数据进行归一化后协方差矩阵C 其实是$(X_1=X-macron(X))$
$ C=1/(n-1) X_1^T X_1 $


定义一个投影方向$v=(x_0,y_0) #h(0.5em) "st" #h(0.5em) x_0^2+y_0^2=1$
// #figure(
//   image("img/5,png",width:50%),
//   caption: [

//   ]
// )
//
// #image1(image("../苦力/img/5.png", height: 7cm),"示意图")


$ S=arrow(v) arrow(x) =|arrow(x)| cos theta $
在这个方向投影后的长度的方差其实可以表示为
$
  1/(n-1) sum S^2 =1/(n-1)(arrow(v)X_1^T)(arrow(v)X_1^T)^T= arrow(v) (X_1^T X_1 )/(n-1) arrow(v)^T=arrow(v) C arrow(v)^T
$

最优化方差最小值

$ J=arrow(v) C arrow(v)^T #h(0.5em) "st" #h(0.5em) arrow(v) arrow(v)^T=1 $

等式约束的最优化问题，引入拉格朗日函数

$ F(arrow(v))=arrow(v) C arrow(v)^T -lambda(1-arrow(v)arrow(v)^T) $//

$ pdv(, v)F(arrow(v))=0 => 2C v^T -2 lambda v^T=0 #h(3em) (pdv(, v) f(x) v=f(x)^T ,pdv(, v) A^T v A=A v+A^T v),C=C^T $
$ C v^T = lambda v $

对C做特征值分解，得到两个特征向量PC1,PC2对应沿轴方差最大和最小。

对于三维的话，我们思考一个圆柱，当其长度远远大于半径的时候，并且圆心角不是特别小，投影方差最大的方向应该是轴向，之前论文里面也是如此。
#image1(
  image("./img/3.png", height: 7cm),
  "主成分（PC1、PC2和PC3）用于定义圆柱方向的示意图；PC1一般指向圆柱的轴线方向，而PC2和PC3则编码圆柱宽度垂直方向上的数据变异性。",
)

但是如果对于只有部分点云的时候，并不是如此，但是三个特征值中必有一个是轴向（根据实验可得），所以向特征值方向重投影，计算轮廓面积，取最小的即为轴向。

仿真里面PCA的效果很好，但是在实际点云上效果并不佳。继续尝试鲁棒PCA后效果也不好，可能是圆柱圆心角过小。之前查阅过的论文里面使用PCA方法寻找轴都是对于完整的圆柱点云，如树木，管道等，其更容易求解。但是更有可能是缩放系数$beta$干扰了PCA，使得我们的实际点云并不是严格的圆柱，根本无法使用PCA求解，因为原论文中和我们的仿真中都对于小圆心角进行了测试。也有可能是采样点过多，论文中的点都比较稀疏。

这部分仿真代码在`Simulation/PcaTest` 。PCA相关算法封装在了`algorithm/PcaAxis`，鲁棒PCA部分使用了`robpy`库，其移植了一系列统计相关的方法。

TODO: RPCA（鲁棒PCA）部分可能因为库中的实现方法和论文中不一样导致效果不是很好，可以重新修改一下，主要加入了MCD算法，这个在`robpy`库中也有实现#footnote()[对于1000个模拟的四分之一圆柱，其中包含10%的聚集离群点，基于主成分分析（PCA）的方法Lalonde拟合圆柱的平均方向误差θ为5.87度，而基于新RPCA算法的拟合圆柱的平均方向误差仅为0.36度。]。

*下面是实验结果*

$ v_"true"=(0.99463613,0.09042056,0.05023031),theta=30,r_("true")=9,"len"=20 $
$ v_("pca")=(0.99463714 0.09041336 0.05022337) $

这是一个测试@hubertROBPCANewApproach2005a  @nurunnabiROBUSTCYLINDERFITTING2017


测似乎111@brohanRT2VisionLanguageActionModels2023
#grid(
  columns: (auto, auto),
  [
    #image1(image("./img/10.png", height: 7cm), "PCA1轴面投影")
  ],
  [#image1(image("./img/11.png", height: 7cm), "PCA2轴面投影")],
)
#grid(
  columns: (auto, auto),
  [
    #image1(image("./img/12.png", height: 7cm), "PCA3轴面投影")
  ],
  [#image1(image("./img/9.png", height: 7cm), "原oyz面投影")],
)
$v_"true"=(0.891710,0.450359,0.045035),theta=10,r_("true")=9,"len"=10 "noise"=0.01$
$ v_("pca")=(0.8917198,0.45034084,0.04504355) $
#grid(
  columns: (auto, auto),
  [
    #image1(image("./img/14.png", height: 7cm), "PCA1轴面投影")
  ],
  [#image1(image("./img/15.png", height: 7cm), "PCA2轴面投影")],
)
#grid(
  columns: (auto, auto),
  [
    #image1(image("./img/16.png", height: 7cm), "PCA3轴面投影")
  ],
  [#image1(image("./img/13.png", height: 7cm), "原oyz面投影")],
)


$v_"true"=(0.891710,0.450359,0.045035),theta=10,r_("true")=9,"len"=10 beta=0.9$
$ v_("pca")=(0.90947708,0.41307121,0.04715522) $


#grid(
  columns: (auto, auto),
  [
    #image1(image("./img/18.png", height: 7cm), "PCA1轴面投影")
  ],
  [#image1(image("./img/19.png", height: 7cm), "PCA2轴面投影")],
)
#grid(
  columns: (auto, auto),
  [
    #image1(image("./img/20.png", height: 7cm), "PCA3轴面投影")
  ],
  [#image1(image("./img/17.png", height: 7cm), "原oyz面投影")],
)

在*实际的点云*上求解的结果如下（仅PCA）
=== RPCA


RPCA方法（@hubertROBPCANewApproach2005 Hubert等人，2005），该方法适用于低维（3D）点云处理（@nurunnabiROBUSTCYLINDERFITTING2017 @nurunnabiRobustCylinderFittinga）。

如果一个点是异常值，那么必定存在某个一维投影使该点也是一元异常值。因此，导出了一个“异常性”度量，通过将数据值投影到多个一维方向上来识别异常值

在每个方向上，每个点根据其作为异常值的可能性进行评分，其中第i个点在方向v上的异常性计算为
$
  w_(i )= a r g m a x_(v )frac(lr(| p_(i )v^(T )- mu_(upright(F M C D))\(p_(i )v^(T )\)|), sum_(upright(F M C D))\(p_(i )v^(T )\))
$

$mu_(upright(F M C D))\(p_(i )v^(T ))$是基于FMCD的稳健均值，$sum_(upright(F M C D))\(p_(i )v^(T )\)$是基于FMCD的稳健协方差矩阵


通过将数据投影到多个单变量方向上来计算。对于每个方向，计算投影点的基于快速最小协方差行列式（FMCD；Rousuw和van Driessen，1999）的稳健中心μFMCD和协方差矩阵ΣFMCD，如公式（1）所示。接下来，使用具有最小wi值的多数份额（$h>n/2$）的点来构建一个稳健的协方差矩阵，该矩阵随后用于主成分分析（PCA）并获得稳健的主成分。Hubert等人（2005）声称，所得的稳健主成分具有位置和正交不变性，他们的方法对无异常值的数据产生准确的估计，对有异常值的数据产生更稳健的估计。
=== 使用椭圆方程拟合

但最终问题也是圆心角过小，并且我们的噪声有的过大，拟合椭圆误差很大。

=== RANSC
这里直接使用了PCA的RANSC算法#footnote()[RANdom SAmple Consensus（随机抽样一致）]，使用pyblind11库进行了封装，便于python调用。

步骤主要是先对点云构建kdtree，计算法线。（这里需要注意不同的点云密度需要设置不同的求解法线时候使用的周围点数量），然后从点集中随机选取若干点，计算圆柱参数，划分内点，计算误差，满足时候退出。

实现有一个这个库 @leyderRobPyPythonPackage2024
#grid(
  columns: (auto, auto),
  [
    #image1(image("./img/26.png", height: 7cm), "原始oyz平面投影")
  ],
  [#image1(image("./img/25.png", height: 7cm), "沿RANSC轴线投影")],
)

#grid(
  columns: (auto, auto),
  [
    #image1(image("./img/35.png", height: 7cm), [使用PCL的投影])
  ],
  [#image1(image("./img/25.png", height: 7cm), "沿RANSC轴线投影")],
)


#image1(image("./img/27.png", height: 7cm), [对投影后点云进行半径滤波 $"std"=0.02,n=100$])


#image1(image("./img/36.png", height: 7cm), [使用不带MCD的RobuPCA投影面])
// 效果还是非常好的

*代码*

封装在`Pyblind11Ransc`包中，使用示例如下
```python
import PclRansc
NormalDistanceWeight = 0.5
max_iterations = 10000
distance_threshold = 0.1
radius_min = 5
radius_max = 12
k=60
axis1=PclRansc.find_cylinder_axis(
    PointCloud.points, NormalDistanceWeight,
    max_iterations, distance_threshold, radius_min, radius_max,k
)
```

其中`axis1[0-2]`表示中心，`axis1[3-5]`表示方向，`axis1[6]`表示半径。`axis1[7]`表示内点。这里虽然有一部分噪点被滤除了，但是可以看到二维图中还是有一些点没有被滤除，所以又使用了一次半径滤波。


Nurunnabi等（2014，2015）指出，RANSAC受到了众所周知的掩蔽效应的影响（参见Rousseeuw和Leroy，2003）@nurunnabiROBUSTCYLINDERFITTING2017。


== 误差分析
参考@nurunnabiROBUSTCYLINDERFITTING2017

为了评估拟合圆柱体的参数C、R、L和O，我们计算真实圆柱体中心与拟合圆柱体中心之间的平均距离AD(C)，估计的平均半径A(R)，平均长度A(L)，以及平均偏差方向A(θ)的多个样本值。这些指标定义如下：
$
   "AD"(C) & =1/(m-1) sum|C_i -hat(C_i)| \
      A(R) & =1/(m-1) sum hat(R_i) \
  A(theta) & =1/(m-1) sum hat(theta)
$

$ theta= arccos|v_2^T hat(v_2)| $
其中$v_2$是真实轴线，$hat(v_2)$是估计轴线。


提出的圆柱拟合算法在多个人造和真实的点云上进行了演和评估。从数据完整性、稳健性、一致性以及圆柱半径的大小方面评估了新算法的性能，并将结果与三种现有方法进行了比较：（i）最小二乘法，（ii）基于主成分分析的方法（Lalonde et al., 2006），以下称为Lalonde方法，以及（c）RANSAC方法。


#image1(image("./img/31.png", height: 5cm), [论文@nurunnabiROBUSTCYLINDERFITTING2017 中实验的结果])

#image1(image("./img/32.png", height: 7cm), [论文@nurunnabiROBUSTCYLINDERFITTING2017 中实验的结果（包含10%的集群异常）])

#image1(image("./img/33.png", height: 10cm), [论文@nurunnabiROBUSTCYLINDERFITTING2017 中实验的结果])

#image1(image("./img/34.png", height: 8cm), [论文@nurunnabiROBUSTCYLINDERFITTING2017 中实验的结果])

#align(center, [
  #text(size: 1em)[= *圆拟合方法*]
  #v(1em)
])


// https://people.cas.uab.edu/~mosya/cl/CPPcircle.html
在选取测量区域后，我们先将每根线（$x$相同的点）投影到以圆柱轴为法线的平面上，然后接下来对于每条线$X_i,Y_i$,进行一个圆拟合问题。

圆拟合方法主要包括两类：（i）几何拟合法，和（ii）代数拟合法。

第一类方法最小化几何距离，而第二类方法最小化代数函数。几何拟合计算量大，而代数拟合速度更快，因为它们不像几何拟合那样需要迭代。我们强调更快的方法，因为我们处理的是大型点云数据（PCD）。下文中我们将不考虑几何圆拟合，只考虑代数圆拟合
== 去噪
我们拿到的数据一定程度上是具有噪声的，对于每一条
#grid(
  columns: (auto, auto),
  [
    #image1(image("./img/28.png", height: 7cm), "噪点图像1")
  ],
  [#image1(image("./img/29.png", height: 7cm), "噪点图像2")],
)

所以我们必须要对噪点进行剔除，或者直接剔除该条数据。
上述这种噪点，有的因为拟合值偏差较大会被剔除，但是还是有绝大多数保留了下来对最终的测量结果造成影响。
=== RANSC 去除噪点

下面先仿真一下并且撰写RANSC去噪算法

#image1(image("./img/30.png", height: 10cm), [RANSC算法仿真 $r_("true")=5,r_"ransc"=5.69,r_"final"=5.14$])
实际上还可以调节参数使得结果更加真实。我们将这个算法用于实际点云上，效果如下：
=== LTS回归
参考@nurunnabiROBUSTCYLINDERFITTING2017 文中的做法，
我们将LTS回归原理与超圆拟合方法结合。使用LTS回归，新算法修剪掉残差平方和最大的(n − h)个点，并用最接近圆弧的一致的h (h ≥ n/2)个点进行圆拟合。
== 代数方法
@al-sharadqahErrorAnalysisCircle2009 这篇文章讲述了很多方法，同时也给出了误差分析。 @mosya_cl_matlabcircle 这里是使用Matlab实现的各种圆拟合算法，可以很简单的转为python。
也有人实现了上述各个算法的python版本，使用circle-fit包。
拟合圆的标准方程为：
$ x^2 + y^2 + A x + B y + C = 0 $

目标是从点云数据 $(x_i, y_i)$ 中找到最优参数 \(A\)、\(B\)、\(C\)，以使得这些点尽可能满足上述方程。
将方程写成矩阵形式：
// \[
#mitex("(x^2 + y^2) + A \cdot x + B \cdot y + C = 0")
定义设计矩阵 #mi("\(A_{design}\)")：
#mitex(
  "\[
A_{{design}} = \begin{bmatrix} x_1^2 + y_1^2 & x_1 & y_1 & 1 \\\\ x_2^2 + y_2^2 & x_2 & y_2 & 1 \\\\ \vdots & \vdots & \vdots & \vdots \\\\ x_n^2 + y_n^2 & x_n & y_n & 1 \end{bmatrix}
\]",
)
定义参数向量 $P = \[A \, B \, C \, D \]^(T )$ ，其中 \(D\) 表示偏置项。

然后问题可以表示为：
#mitex(" \[
 A_{{design}} \cdot \mathbf{P} = 0
 \]")

为了非平凡解 #mi("\(\mathbf{P}\)")，需要约束 #mi("\(\mathbf{P}\)") 的长度。这里使用二次约束条件：#footnote()[由于参数 (A, B, C, D) 只需确定到标量倍数，因此施加一个约束是合理的。]
$ P^(T) Q P = 1 $

其中 $Q$ 是二次约束矩阵，用来保证拟合圆弧的几何意义：
#mitex(" Q = \begin{bmatrix} 0 & 0 & 0 & -2 \\\\ 0 & 1 & 0 & 0 \\\\ 0 & 0 & 1 & 0 \\\\ -2 & 0 & 0 & 0 \end{bmatrix}")

最终问题转化为一个广义特征值问题：


$A_"design"$简称为$A_"d"$
问题转换为
$ "minimize" ||A_d P||^2=P^T A_d^T A_d P #h(1em) "st." #h(1em) P^(T) Q P = 1 $

构建拉格朗日函数
$ G(P)=P^T A_d^T A_d P -lambda (P^(T) Q P-1) $
应用矩阵求导法则 $pdv(, P)P^T A P=A^T P +A P$

$ pdv(, P)G(P)= 2A_d^T A P -lambda (Q^T P+Q P) =0 => A_d^T A_d P=lambda Q P $
// #mitex("M \cdot \mathbf{P} = \lambda Q \cdot \mathbf{P}")
$
  Q^(-1)A_d^T A_d P & =lambda p \
                M P & = lambda P
$

求解M的特征值,求解该广义特征值问题，得到所有特征值 $lambda$￥和对应的特征向量 $P$。特征值对应的是不同解的代价，选择最小非负特征值对应的特征向量作为解$P$。

通过变形可以得出圆心和半径：
#mitex("\((h, k)\): \(h = -\frac{A}{2}\), \(k = -\frac{B}{2}\)")
#mitex("\(r\): \(r = \sqrt{\frac{A^2 + B^2 - 4C}{4}}\)")

这种方法结合了最小二乘和约束优化，能够较好地拟合圆弧，特别适合包含部分圆弧点的情形。

该算法封装在`algorithm/PreciseArcFitting`中，使用示例如下：
```python
from algorithm.PreciseArcFitting import CircleArc
arc=CircleArc()
points=...
arc.fit_circle_arc(np.array(points))
center = arc.first_param[0:2]
radius = arc.first_param[2]
```

=== 对约束矩阵的拓展
当约束矩阵为
#mitex(" Q = \begin{bmatrix} 0 & 0 & 0 & -2 \\\\ 0 & 1 & 0 & 0 \\\\ 0 & 0 & 1 & 0 \\\\ -2 & 0 & 0 & 0 \end{bmatrix}")

这种方法叫做*Pratt fit*.

#mitex(
  "\[
Q= \begin{bmatrix}
4\bar{z} & 2\bar{x} & 2\bar{y} & 0 \\\\
2\bar{x} & 1 & 0 & 0 \\\\
2\bar{y} & 0 & 1 & 0 \\\\
0 & 0 & 0 & 0
\end{bmatrix}\]",
)
这种方法加*Taubin fit*.

#mitex(
  "\[
Q=\begin{bmatrix}
8\bar{z} & 4\bar{x} & 4\bar{y} & 2 \\\\
4\bar{x} & 1 & 0 & 0 \\\\
4\bar{y} & 0 & 1 & 0 \\\\
2 & 0 & 0 & 0
\end{bmatrix}
\]",
)

这种方法加*Hyper fit*.#footnote()[
  我们的误差分析引出了另一个惊人的发现——一种完全没有本质偏差的代数拟合。据我们所知，这是曲线拟合问题中此类算法的首次出现 @al-sharadqahErrorAnalysisCircle2009。
]
// == 几何圆拟合
// 直接使用(a,b,R)进行求解

=== adam优化的梯度下降法

主要参考的是@feiNewShortarcFitting2020，这篇文章。虽然作者自己说

Finally, simulation and experimental results show that our ICF method is more robust and high-precision than TLSF and Hyper method, so it is very competent to measure short arcs with noise even their central angles are *close to 5°*.

但是我们仿真测试下来并非如此。

=== 优化的L-M方法
上一篇文章的参考文献中提到的方法，计算量较大。

=== 使用半径或者圆心约束或者其他几何约束的最优化

暂时没有尝试，因为缺少一般性质，我们不只要测量一个工件。

== 其他优化方法
@nurunnabiROBUSTCYLINDERFITTING2017 也是使用Hyper，但他使用了迭代的方法。
== 误差分析

直线和圆拟合的精度并不依赖于线或圆的厚度 @PAL 。

根据@al-sharadqahErrorAnalysisCircle2009 代数拟合速度更快，但通常精度较低。同时，对它们准确性的评估仅基于实际经验，尚未有人对各种圆拟合的精度进行详细的理论比较。

同时这篇文章也介绍了一种超精确拟合，跟我们第一个推到的类似，只是约束矩阵变为


#align(center, [
  #text(size: 1em)[= *去噪和测量区域选取*]
  #v(1em)
])

== 三维深度方法
使用PointNet++  选取测量部分

== 三维配准方法
先手动选取部分后，将该点云和测量点云做点云配准，精配准后使用固定的部分提取测量部份。

== 二维方法

先对每一根线做B样条优化平滑，
考虑圆弧切线方程
正常一个圆弧的切线方程（只考虑上半部分，应该是）
#mitex("m(x)=-\frac{x-x_0}{\sqrt{r^2-(x-x_0)^2}}")
$
  f \(x \)= frac(1, frac(1, m \(x \))^(2 )+ 1)= lr(\( frac(x - x_(0 ), r) \))^(2 )= a \(x - x_(0 )\)^(2 )= a \(x^(2 )+ x_(0 )^(2 )- 2 x_(0 )x \)
$

#image1(image("./img/37.png", height: 7cm), [函数完全没有断点])

如果函数是分段的情况下
#mitex(
  `
&r=r_{1},x_{0}=x_{1} \quad  x<m_{1} \\
&r=r_{2},x_{0}=x_{2} \quad  x\geq m_{1} \& x<m_{2} \\
&r=r_{3},x_{0}=x_{3} \quad  x>m_{2} \\
  `,
)

#mitex(
  `
  f(x)=\begin{align}
& \frac{1}{r_{1}^2}(x-x_{1})^{2} \quad  x<m_{1}   \\
& \frac{1}{r_{2}^2}(x-x_{2})^{2} \quad x\geq m_{1} \& x<m_{2}\\
& \frac{1}{r_{3}^2}(x-x_{3})^{2}   \quad  x>m_{2}
\end{align}
  `,
)

#image1(image("./img/38.png", height: 7cm), [函数完全没有断点])

一种可能的方法是对其求二阶导数，然后直接分割
#mitex(
  `
  f(x)''=\begin{align}
& \frac{2}{r_{1}} \quad  x<m_{1}   \\
& -\frac{2}{r_{2}} \quad x\geq m_{1} \& x<m_{2}\\
& \frac{2}{r_{3}}   \quad  x>m_{2}
\end{align}
  `,
)
但是实际效果其实并不好。

#image1(image("./img/39.png", height: 7cm), [中间部分二阶导数并不是直线])

但是其实也能分割，除了传统的分割方法，也可以训练一个简单的全连接神经网络。

如果下半部分的圆弧，切线方程只是变成
#mitex(`m(x)=\frac{x-x_0}{\sqrt{r^2-(x-x_0)^2}}`)


#mitex(`f(x)=\frac{1}{\frac{1}{m(x)}^2+1}=\left( \frac{x-x_{0}}{r} \right)^2=a(x-x_{0})^2=a(x^2+x_{0}^2-2x_{0 }x)`)

方程是一样的表达形式。

== 去噪
去噪暂时就是最简单的半径滤波，效果很好。
#grid(
  columns: (50%, 50%),
  [
    #image1(image("./img/40.png", height: 5cm), "去噪前截面")
  ],
  [#image1(image("./img/41.png", height: 5cm), "去噪后截面")],
)

#align(center, [
  #text(size: 1em)[= *最优化方法*]
  #v(1em)
])

== 无约束优化方法
考虑无约束优化问题
$ min_(x in RR^n) f(x) $
#v(1em)

=== 梯度下降法
找到可微函数的局部最小值

#pseudocode-list[
  + 给定*初始值* $x_0,k=0$
  + *while*
    + 计算出$pdv(f, x),"cost"$
    + $x=x-alpha(pdv(f, x))$
    + *if* $"cost"<epsilon$
      + *break*
  + *end*

]
$
  theta(j)' & =theta (j)-alpha pdv(, x_j)f(x) #h(0.5em) \& #h(0.5em) "每一个参数都更新完再下一步" \
   theta(j) & =theta(j)'
$ <梯度下降>

*容易走出锯齿路线，从而增加迭代次数*。

这里优化的话有adam法优化学习率，随机梯度下降，小批量梯度下降。
=== 牛顿法
梯度下降法基本策略是沿着一阶最速下降方向迭代，当$grad^2f(x)$较大时，收敛较慢。如果我们的$f(x)$足够光滑（数据量足够大），我们可以利用二阶信息改进下降方向。

对于函数$f(x)$考虑其在$x_k$点处的二阶泰勒近似
$ f(x_k+d_k)=f(x_k)+grad f(x_k)^T d_k+1/2 d_k^T grad^2 f(x_k)^T d_k +o(||x_k||^2) $

忽略高阶项，右边看作关于$d_k$的函数，并且最小化（矩阵求导）
$ (f(x_k)^T)^T+ 1/2(grad^2 f d_k+(grad^2 f )^T d_k)=0 $
这里也能看出来为什么其一定要满足正定条件。

$ grad^2 f(x_k) d_k=-grad f(x_k) $

$ x_(k+1)=x_k - alpha_k grad^2 f(x_k)^(-1) grad f(x_k) $

// $ f(x) &=f(x_0)(x-x_0)^0+f'(x_0)(x-x_0)+((f''(x_0))/2!)(x-x_0)^2+...\
//        &approx f(x_0)(x-x_0)^0+f'(x_0)(x-x_0)+(f''(x_0)(x-x_0)^2)/2
//  $<1>

// $ g(x)=dv(,x)f(x)=f'(x_0)+f''(x_0)(x-x_0) =g(x) $

// $g(x)=0,x=x_1$的时候是极值，
// $ x_1-x_0=(f'(x))/(f''(x)) => x_1= x_0 -  (f'(x))/(f''(x)) $

// 对于多元函数的话，我们推导一下海森矩阵
=== 拟牛顿法



=== 高斯牛顿法

#mitex("
f(x_k + \Delta x) \approx f(x_k) + J(x_k)^T \Delta x
")

我们的目标函数可以近似为：
#mitex("
min \frac{1}{2} \| f(x_k) + J(x_k)^T \Delta x \|^2_2
")

// === 3. 构造近似的二次目标函数

现在，我们将近似的目标函数展开：


$
  M(Delta X)=1/2 f(x+Delta X)^2&=1/2 (f(x)+J^T Delta X)^T ( f(x)+J^T Delta X) \
  &= 1/2 [mark(f(x)^T+Delta X^T J, tag: #<E>) ][mark(f(x)+J^T Delta X, tag: #<F>)] \
  &= 1/2 [ mark(||f(x)||^2, tag: #<A>)+mark(f(x)^T J^T Delta X, tag: #<B>) +mark(Delta X^T J f(x), tag: #<C>)+mark(Delta X^T J J^T Delta X, tag: #<D>) ] \
  // &= 1/2 [ ||f(x)||^2+2Delta x ^T J f(x) +Delta x ^T J J^T Delta x ] \
  #annot(<A>)[A]
  #annot(<B>)[B]
  #annot(<C>)[C]
  #annot(<D>)[D]
  #annot(<E>)[E]
  #annot(<F>)[F]
$<mdeltax>
$
  d C & = d Tr[f(x)^T J^T Delta X]=Tr[d(f(x)^T J^T Delta X)] \
      & = Tr[f(x)^T J^T d Delta X] => pdv(C, Delta X)= J f(x)
$

$
  pdv(M (Delta X), Delta X) & = 1/2(0+ J f(X)+ J f(x)+ mark(2(J J^T Delta X ), color: #blue, tag: #<jjdeltax>)) \
                            & =J f(x)+J J^T Delta X =0
                              #annot(<jjdeltax>, pos: top)[使用了矩阵求导的定理]
$
$ H Delta X=g #h(0.5em) \& #h(0.5em) H=J J^T #h(0.5em) \& #h(0.5em) g=-J f(x) $

所以高斯牛顿法的步骤是
#pseudocode-list[
  + 给定*初始值* $x_0,k=0$
  + *while*
    + 计算出$J(x_k),f(x_k) #h(0.5em) \& #h(0.5em) H=J J^T #h(0.5em) \& #h(0.5em)g=-J f(x)$
    + 使用$H Delta X=g$求出$Delta x$
    + *if* $Delta x<epsilon$
      + *break*
    + *else*
      + $x_(k++)=x_k+Delta x$

  + *end*
]

它的缺点是要求$H$矩阵可逆，而且计算量大，有时候可能无解。并且$Delta x$过大会导致其局部近似不精确，严重的时候，可能无法保证迭代收敛。同时也会锯齿状增大迭代次数（和梯度下降一样）。
==== 列文伯格-马夸特法(LM)
为了避免其迭代次数过长的缺点，在高斯牛顿的基础上进行优化，提出一个信赖区域。
$ rho=(f(x+Delta x)-f(x)) /(J^T Delta x) $
如果它接近一就不需要更改，如果过大就需要缩小步长，如果过小就需要增大步长，这样的话，就可以动态调整步长了。最优化问题变为
$ min 1/2 norm(f(x)+J^T Delta x)_2^2 #h(0.5em) s.t #h(0.5em) norm(D Delta x)_2^2< mu $
构建拉格朗日函数#footnote[目标函数为f在约束条件g下的极值与其拉格朗日函数的极值相同。λ被称为拉格朗日算子]$ L(Delta x,lambda)=1/2 norm(f(x)+J^T Delta x)+lambda(norm(D Delta x)_2^2-mu) $
$
  pdv(L(Delta x,lambda), Delta x)=J f(x)+J J^T Delta X+ lambda pdv((Delta x^T D^T D Delta x), Delta x)=J f(x)+J J^T Delta x+ lambda D^T D Delta x
$
之前的$H$变为$display(J J^T+lambda D^T D)$,求解步骤变为
#pseudocode-list[
  + 给定*初始值* $x_0,k=0$
  + *while*
    + 计算出$J(x_k),f(x_k) #h(0.5em) \& #h(0.5em) H=J J^T+lambda D^T D #h(0.5em) \& #h(0.5em)g=-J f(x)$
    + 计算出$Delta x$
    + 计算$rho_k=(f(x+Delta x)-f(x)) /(J^T Delta x)$
    + *if* $rho_k <1/4$
      + $#h(0.5em) Delta x_(k)=1/4 Delta x_k$
    + *else*
      + *if* $rho_k >3/4$
        + $Delta x_(k)=min(2 Delta x_k, mu)$
      + *else*
        + $Delta x_(k)=Delta x_k$
    + *if* $rho_k>xi$
      + $x_(k+1)=x_k+Delta x$
    + *else*
      + $x_(k+1)=x_k$
    + k=k+1
    + *if* $Delta x_k<epsilon$
      + *break*

  + *end*
]

#set page(columns: 1)



#bibliography(
  ("mylib.bib", "my.bib"),
  title: [
    参考文献#v(1em)
  ],
  style: "american-physics-society",
)
