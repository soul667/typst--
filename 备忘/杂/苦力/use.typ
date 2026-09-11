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
#show math.equation: i-figured.show-equation.with(only-labeled: true) // 只有引用的公式才会显示编号
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
== 线性空间与线性变换
=== 线性空间
在矩阵论中，将在线性代数的基础上，推广向量空间$R^n$,一般地定义线性空间的概念。这里参考杨明教授的《矩阵论》@杨明2003矩阵论 和Strang, Gilbert的 《Linear Algebra and Its Applications》@strang2012linear。
#definition([#gls("linear space")])[
  $V$是一个非空集合，$F$是一个数域，在其中定义两种运算，加法($forall alpha,beta in V ,alpha+beta in V$)和数乘($forall k in F,alpha in V,k alpha in V$)，如果满足若干运算法则，就称$V$是数域$F$上的线性空间。
]
比如$F_{n,1}={(x_1,x_2,...,x_n)^T} | x_i in F$ 是F上的${m,1}$维线性空间。

$F_{n,m}={A=(a_(i j))_{m times n}|a_(i j )in F}$是F上的${m,n}$维矩阵空间 记作$R_{2,2}$ #footnote()[这里与教课书上$R^(2 times 2)$的写法不同，读者注意。]

$P_n (x)={sum_(i=0)^(n-1)a_i x_i|a_i in R}$称为多项式空间$P_n[x]$
#definition[
  如果对于线性空间$V$ 存在一组*线性无关*的向量#vecs($alpha$)，使得空间中任意一个向量可以由它表示，#vecs($alpha$)张成了向量空间,此时有$V$的维度$ dim(V)=n $
]
#definition("矩阵的逆")[
  如果对于向量$A$，如果存在B 使得$A B=I$ ,则称B是A的逆矩阵，记作$A^(-1)$，并且说A是可逆的，有时候也叫做非奇异矩阵#footnote([在数值运算中，我们很少求解矩阵的逆，计算他的计算量是行变换解方程的三倍 @strang2012linear])。并且
  1. $(A B)^(-1)=B^(-1)A^(-1)$
  2. A的各列线性无关，$dim(A)=n$
]
=== 内积空间
==== 欧氏空间和酉空间
#definition[
  对数域$F$上的线性空间$V_n (F)$,定义一个从$V_n (F)$到$F$的二元运算$(alpha,beta)$，记作$(alpha,beta):V_n (F)->F$，满足以下条件
  1. $(alpha,beta)=(beta,alpha)$
  2. $(k alpha,beta)=k(alpha,beta)$
  3. $(alpha,alpha)>=0,& quad (alpha,alpha)=0"仅当" alpha=0$
  我们就称这个二元运算是线性空间的一个内积，并且定义了内积的线性空间称作内积空间$[V_n(F);(alpha,beta)]$。如果$F=R$（实数域）就称作欧氏空间；如果$F=C$（复数域）就称作酉空间。
]
下面举几个欧氏空间的例子
1. $[RR^n;(alpha,beta)=alpha^T beta]$,习惯上，我们直接将$RR^n$记作欧氏空间。
2. $[R_{n,n};(A,B)=Tr[A B^T]]$
3. $[P_(n )lr(\[ x \])\;lr(\( f lr(\( x \))\,g lr(\( x \))\))= integral_(0 )^(1 )f lr(\( x \))dot g lr(\( x \))upright(d)x ).]$

#definition($norm(alpha)$)[
  在内积空间，称$ norm(alpha)=sqrt((alpha,alpha))=alpha^T alpha $ 为向量$alpha$的长度。在欧式空间中，也称作*欧几里得范数*,常表示为$norm(alpha)_2$(*注意下标*)。下面给出几条它的性质
  1. (*Cauchy 不等式*) $abs((alpha,beta))^2<=norm(alpha)norm(beta)$
  2. $norm(alpha+beta)<=norm(alpha)+norm(beta)$
  3. 定义$alpha,beta$夹角$display(theta=arccos ((alpha,beta))/(norm(alpha)norm(beta)))$
]
==== 标准正交基
#let ji_(use) = {
  return ${#use _1 ,#use _2 , ... , #use _n}$
}
#let sum_(use) = {
  return $#use _1 + #use _2 + ... + #use _n$
}
#let xl_(use) = {
  return $mat(#use _1, #use _2, ..., #use _n)$
}
#let sum__(use1, use2) = {
  return $#use1 _1 #use2 _1 + #use1 _2 #use2 _2 + ... + #use1 _n #use2 _n$
}
#definition[
  在$V_n$中一组基${epsilon_1,epsilon_2,...,epsilon_n}$满足$ (epsilon_i,epsilon_i)=0#h(0.5em) \& #h(0.5em) norm(epsilon_i)=1 #h(0.5em) \& #h(0.5em) (epsilon_i,epsilon_j)!=0 & quad 0<=i,j<=n,i!=j $
  就称作其为标准正交基。
]
从一组基${alpha_1,alpha_2,...,alpha_n}$转换到标准正交基#ji_($beta$)有
$ beta_i= alpha_i-sum_(i=1)^(k-1)((a_k,beta_i))/((beta_i.beta_i))beta_i $

证明方法参考@杨明2003矩阵论 [p.~18],这里略去。用矩阵的方式表示为$ (alpha_1,alpha_2,...,alpha_n)=(beta_1,beta_2,...,beta_n)mat((beta_1,beta_1), (alpha_2,beta_1), ..., (alpha_n,beta_1); , (beta_2,beta_2), ..., (alpha_n,beta_2); , , ..., ...; , , , (beta_n,beta_n)) $ <标准正交基>
==== 线性变换
#definition([*线性变换*])[
  如果存在一个单射$T:V_n (F)->V_n (F)$,满足
  1. $T(alpha+beta)=T(alpha)+T(beta)$
  2. $T(k alpha)=k T(alpha)$
  就称$T$是一个$V_n (F)$上的线性变换。
]
#definition([*线性变换的矩阵*])[
  $forall alpha in V_n (F)$,取一组基#ji_($alpha$)
  $ alpha & = #sum__($x$, $alpha$) $
  $ mat(T(alpha_1), T(alpha_2), ..., T(alpha_n))^T=A^T mat(alpha_1, alpha_2, ..., alpha_n)^T $
  称$A$为基#ji_($alpha$)下的*矩阵*。
  //  \ T(alpha)&=x_1 T(alpha_1)+x_2T(alpha_2)+...+x_n T(alpha_n)
  // 令$a=a_1,a_2,...,a_n$,@eqt:suma
]
#theorem()[
  如果 #ji_($alpha$)到#ji_($beta$)有过渡矩阵$C$
  $ "其中   "#xl_($alpha$)=#xl_($beta$)C $,同时在两组基下的矩阵分为为$A,B$，则有$ B=C^(-1) A C $
]

#definition([*不变子空间*])[
  如果$T$是$V_n (F)$上的线性变换，$W$是$V_n (F)$的一个子空间，如果$T(W) in W$，就称$W$是$T$的不变子空间。
]
#definition([*正交变换*])[
  如果$T$是$V_n (F)$上的线性变换，且满足$forall alpha,beta in V_n (F),(T(alpha),T(beta))=(alpha,beta)$，就称$T$是正交变换。
  当空间是欧式空间就叫做正交变换，其对应矩阵我们叫做正交矩阵$C$,酉空间就叫做酉变换,其矩阵叫做酉矩阵$U$。
]

== Jordan标准形
=== Jordan标准形及其求解
// 关于特征值，不再赘述，我们直接给出Jordan标准形的定义。

形如$display(J lr(\( lambda \))= mat(lambda zws, 1 zws, zws, zws; zws, lambda zws, 1 zws, zws; zws, zws, dots.down zws, 1 zws; zws, zws, zws, lambda))$的矩阵叫做$r$阶Jordan块，若干个Jordan块组成的矩阵叫做Jordan矩阵，如下
$
  J = mat(J_(1 )\(lambda_(1 )\)zws, zws, zws, zws, zws; zws, J_(2 )\(lambda_(2 )\)zws, zws, zws, zws; zws, zws, dots.down zws, zws, zws; zws, zws, zws, J_(m )\(lambda_(n )\))
$
// 比如$ J = mat(5 zws ,1 zws ,0 zws ,0 zws ,0 zws ;0 zws ,5 zws ,0 zws ,0 zws ,0 zws ;0 zws ,0 zws ,2 zws ,0 zws ,0 zws ;0 zws ,0 zws ,0 zws ,2 zws ,1 zws ;0 zws ,0 zws ,0 zws ,0 zws ,2 )= mat(J _(1 )\(5 \)zws ;zws ,J _(2 )\(2 \)zws ;zws ,zws ,J _(3 )\(2 \)) $

#h(2em)在复数域上，每个方阵矩阵都可以相似于Jordan矩阵，并且唯一（若不计较Jordan的排列次序），即$A=S^(-1) J S$，其中$S$是可逆矩阵，$J$是Jordan矩阵。
#definition([*特征值和特征向量*])[
  对于定义在$E$ 上的变换 $T$, 如果 $exists lambda$ $ T(mu)=lambda mu $
  这里的$lambda$就是$T$的特征值，$mu$是特征向量。
]
#definition([*直和* $plus.circle$])[
  $ A plus.circle B=mat(A, 0; 0, B)=diag(A, B) $
]
#definition([*矩阵的核* $"Null"(A)$])[
  $ upright(N u l l)\(A \)= \{v in V : A v= 0\} . $
]
#theorem([*秩-零化度定理*])[
  $rank A+ "nullity" A("A的特征值空间维度") =n$
  $ [A|E]^T=mat(1, 2, 3, 1, 0, 0; 1, 1, 1, 0, 1, 0; 0, 1, 1, 0, 0, 1) $
  #h(2em) 对其做行初等变换，将A的下几行消元成0，对应的右边行即为一个解。可以理解为其核空间每一个维度可以消解A空间一个冗余维度。

]
首先我们可以求解出其所有特征值。 $ display(abs(lambda I-A)=sum_(i=0)^k (lambda-lambda_i)^mark((a_i), tag: #<dscs>)#annot(<dscs>, pos: top)[代数重数$"gm"$]) $

#h(2em) 然后对于每一个特征值,$dim("Null"(lambda_i I-A))$是多少就有多少jordan块，同时我们也要求解出其核空间的向量,记作$x$,然后使用jordan链进行递归求解直到无解,求解每一个jordan块的大小。

$
  A mark(mat(p_1, p_2, p_3, p_4), tag: #<p>)=mat(p_1, p_2, p_3, p_4)mat(lambda, 1, 0, 0; 0, lambda, 1, 0; 0, 0, lambda, 1; 0, 0, 0, lambda) =mat(lambda p_1, lambda p_2 +p_1, lambda p_3 +p_2, lambda p_4 +p_3)
  #annot(<p>)[$P$]
$
$
  (A-lambda E)p_1 = & 0 quad (1) \
  (A-lambda E)p_2 = & P_1 quad (2) \
                ... & \
  (A-lambda E)p_n = & P_(n-1 ) quad (n) \
$
上式叫做jordan链，直到$(k+1)$无法解出。则这个特征向量对应的jordan块的大小确定。

// #theorem()[
//   如果$A="Diag"(B,C)$ 那么 $A$ 的代数重数和几何重数也是$B,C$的和。]
#example()[求可逆矩阵P和jordan矩阵J使得$A=P^(-1)J P$
  $ A=mat(-3, 3, -2; -7, 6, -3; 1, -1, 2) $
  #h(2em)$abs(lambda I-A)=0=>(lambda-1)(lambda-2)^2$,确定其有两个jordan矩阵$J_1,J_2$组成，对于$J_1$,向量$alpha_1=mat(1, 2, 1)^T$。

  求解$(2I-A)x=0$,只有一个特征向量$alpha_2=mat(-1, -1, 1)^T$，所以$J_2$只由一个jordan块构成。根据jordan链求出$beta_1=(-1,-2,0)^T$。所以得
  $ P=mat(alpha_1, alpha_2, beta_1) $
]
=== 最小多项式
#definition([*矩阵多项式*])[
  首先定义$g(lambda)=sum_(i=0)^m a_i lambda^i$,那么就可以定义矩阵 $g(A)=sum_(i=0)^m a_i A^i$ 为A的矩阵多项式。给出如下性质

  1. $A x=lambda x=> g(A) x=g(lambda) x$
  2. $P^(-1)A P=B=>P^(-1) g(A) P=g(B)$
  3. $A=diag(A_1, A_2, ..., A_n)=>g(A)=diag(g(A_1), g(A_2), ..., g(A_n))$
  4. $A$的特征多项式($f(lambda)=|lambda I-A|=sum_(i=0)^m a_i lambda^i$)就是$A$的化零多项式($g(A)=0$)。

  #proof([of 4])[
    左式$lambda$换$A$。
  ]
]
#example([求$A^m$])[
  假设$g(A)=A^m=>g(lambda)=lambda^m="Hl"(lambda)+ sum b_i lambda_i => g(A)=sum b_i A_i$
]
#definition([*最小多项式*])[
  $A$的所有化零多项式中次数最低,$a_0=0$（首项系数为零）的最小多项式，记作$m_r (lambda)$。和特征多项式有相同的根，重数可以不同。
]

#theorem()[
  一个矩阵可以对角化的充分必要条件是$m_r (lambda)$的所有重数为1. $ m_r(lambda)=Pi(lambda-a_i) #h(0.5em) & #h(0.5em) a_i"互不相等" $
]

== 矩阵分解
=== 矩阵的三角分解
设$A in F_{n,n}$
1. $L,U in F_{n,n}$分别为下三角和上三角矩阵，$A=L U$称作$L U$分解
2. $L,V in F_{n,n}$分别为对角元素为1的下三角和上三角矩阵，$D$是对角矩阵，称作$L D V$分解

#example([求解$display(P=mat(2, 2, 3; 4, 7, 7; -2, 4, 5))$的LU和PDV分解])[
  这里简单给出一个定理，
  $
    mark(H, tag: #<hang>)[P|E]=[H P|P] quad mat(P; "--"; E)L=mat(P L; "--"; mark(L, tag: #<l>,)) #annot(<hang>, yshift: 1em)[行初等变换]#annot(<l>, pos: bottom, yshift: 0.5em)[列初等变换]
  $
  将其写成增广矩阵$display(mat(P, "|", E)=>mat(U, "|", L'))$,做行初等变换将P消成上三角矩阵。$L'A=U=>A=(L')^(-1)U=L U$

  对$U$建立$display(mat(P; "--"; E))$，做列初等变换，$display(mat(P; "--"; E))=>display(mat(D; "--"; V'))$,有$U V'=D=>U=D (V')^-1=D V$
]
#h(2em)
接下来我们将分析一个矩阵有LU,LDV分解的条件，并且注意，矩阵的$"LDV"$分解并不唯一。

对于$A$,设k阶顺序余子式$display(Delta_i=abs(A_[0:i;0:i]))$，如果$"Rank"(A)=k$,其$1-k$阶顺序余子式不为0，则可LU分解，$1"到"(n-1)$阶顺序余子式不为0，则可LDV分解。
=== 满秩分解
#theorem([$R_"行" (A)=R_"列" (A)=R(A)$])[
  行的秩表示为行向量张成向量空间的维度，列的秩表示为行向量张成向量空间的维度。
  #proof()[根据高斯变换，得到行的秩等于主元个数等于列空间维度。]
]<行列秩相等>
#theorem[
  任意不为零的矩阵$A_{m,n}$都有满秩分解 $ A_{m,n}=B_{m,r}C_{r,n} $
  求解方法①$B'mat(A, "|", E)=>mat(mark(C', tag: #<hjt>), "|", B')=> A= mat(B_{m,r}, 0_{m,n-r}) mat(C_{r,n}; 0_{n-r,n}) =B_{m,r}C_{r,n} #annot(<hjt>)[行阶梯型]$

  ② 先化为Hermite 标准形$H$(带主元行阶梯型),找到A中主元列取出构成$B=(alpha_1,alpha_2,...,alpha_n)$,$H$中非零行构成$C$
]
=== 可对角化矩阵的谱分解
$
  A=P^(-1)diag(mark(lambda_1" ,..., "lambda_1, tag: #<lam1>), lambda_2, ..., mark(lambda_n, tag: #<lam2>)) P= mark(P^(-1)sum(lambda_i I_(r_i)) P, tag: #<pufenjie>, color: #blue) #annot(<lam1>)[$r_1$个] #annot(<lam2>)[$r_n$个] #annot(<pufenjie>)[谱分解]
$
其中$lambda_i$表述矩阵的特征值，$r_i$表示特征值的重数。并且我们有
$
  sum I_(r_i)=E #h(0.5em) \& #h(0.5em)I_(r_i)I_(r_j)=0(i!=j) #h(0.5em) \& #h(0.5em) I_(r_i)^2=I_(r_i)^2 #h(0.5em) \& #h(0.5em) I_(r_i)^T=I_(r_i )
$
=== Schur分解与正规矩阵
// #definition([*实对称矩阵和Hermit矩阵*])[
//   $ "（实对称阵）" A^T=A $
//   $ "（Hermit矩阵）" A^H=mark((macron(A))^T,tag:#<macrom>)=A  #annot(<macrom>)[复共轭转置] $

// ]
// 在欧式空间中，一个实对称矩阵$A$一定正交相似于一个对角阵。
// $ A=C^T diag(lambda_1,...,lambda_n) C=C^(-1) diag(lambda_1,...,lambda_n) C $
// 在酉空间,一个 Herm ite 矩阵 A (A H =A )一定可酉相似于对角形:即存在酉矩阵 U 。
// $ A=U^H diag(lambda_1,...,lambda_n) U $
#theorem([*UR分解*])[
  对于一个可逆矩阵$A$,存在$ A=U"( 可逆矩阵)" R "(上三角矩阵)" $
  #proof()[根据 @eqt:标准正交基,可知]
]
#theorem[
  如果$A$ 列满秩，则$ A_{m,k}=Q_{m,k}R_{k,k} #h(0.55em) & #h(0.55em) "Q的列向量是A列空间的标准正交基" $
]

#definition([*正规矩阵*])[
  对于矩阵$A_{m,n}$,如果$A^H A=A A^H$ 就称$A$是正规矩阵。
]
#h(2em) 常见的对角矩阵，对称反对称$(A^T=plus.minus A)$,Hermite矩阵与反Hermite矩阵$(A^H=plus.minus A)$,正交矩阵与酉矩阵$(A A^T=A^T A=I,A A^H=A^H A=I)$都是正规矩阵。
#theorem[
  对于矩阵$A_{n,n}$,其是正规矩阵的充要条件是$A$相似于对角矩阵，即$ exists U_{n,n} #h(1em) U^H A U=diag(lambda_1, lambda_2, ..., lambda_n) $
  #h(0em)推论充分必要条件

  ①A的特征向量是空间的标准正交基。

  ②有*谱分解*$A=sum_(i=1)^s lambda_i I_i$,
]
=== 矩阵的奇异值分解
矩阵的奇异值分解是在线性动态系统的辨识,最佳逼近问题,实验数据处理,数字 图像存储中应用广泛的一种分解。
#theorem[
  对于$A A^H in C_{m,n} #h(0.5em) A^H A in C_{m,n}$, 有如下性质
  1. $"Rank"(A A^H)="Rank"(A^H A)="Rank"(A)$ （Use @行列秩相等）
  2. $lambda_i!=0 #h(0.5em)$,$#h(0.5em) A A^H x=lambda_i x => A^H A x=lambda_i x$
  3. 均为半正定矩阵，行满秩$(A A^H)_{m,m}$ 正定，列满秩$(A^H A)_{n,n}$ 正定。

  #proof([of 2])[
    $display(abs(A A^H -lambda_i E)=0=abs((A A^H -lambda_i E)^T)=abs(A^H A-lambda_i E))$
  ]
]

// #theorem([*矩阵秩和特征值关系*])[
// $"Rank"(A_{m,n})=r,"特征值的个数"<=r $
// ]
#definition([*奇异值*])[
  对于矩阵$A_{m,n}$,其奇异值是$A A^H$的特征值的平方根$ sigma_i=sqrt(lambda_i) #h(0.5em) \& #h(0.5em) (A A^H)x=lambda_i x $
  其奇异值个数等于矩阵的秩。
]

#theorem[
  For $A_{m,n}$,其奇异值可分解为$ A=U_{m,m} Sigma_{m,n} V^H_{n,n} $其中$U,V$是酉矩阵，$ Sigma=diag(sigma_1, sigma_2, ..., sigma_w) plus.circle 0_{m-w,n-w} #h(0.5em) \& #h(0.5em) w=rank(A^H A) #h(0.5em) \& #h(0.5em) sigma_i !=0 $

  #proof()[对于$A^H A$ 因为其是半正定矩阵，所以有$ V^H A^H A V=diag(lambda_1, lambda_2, ..., lambda_k) plus.circle 0 $
    其中$display(V=mat(v_1, v_2, ..., v_n))$ 是$A^H A$标准正交的特征向量
    $
      (A v_i,A v_j)&=(A v_j)^H A v_i=v_j^H (A^H A v_i)=v_j^H (lambda_i v_i)=lambda_i (mark(v_j^H v_i, tag: #<vjvi>, color: #black))\ &= 0 #h(0.5em) \& #h(0.5em) (i!=j) \ &=lambda_i=sigma_i^2 #h(0.5em) \& #h(0.5em) (i=j,lambda_i!=0) #annot(<vjvi>, pos: top)[$ 0 & #h(0.5em) \& #h(0.5em) i!=j \
      1 & #h(0.5em) \& #h(0.5em) i=j $]
    $
    设$display(u_i=1/sigma_i A v_i)=>A v_i=sigma_i u #h(0.5em) \& #h(0.5em) i=1,2,...,rank(A).$ 所以
    $
      A V=A mat(v_1, v_2, ..., v_n) & =mat(sigma_1 u_1, sigma_2 u_2, ..., sigma_r u_r, 0, ..., 0) \
                                    & = mat(u_1, u_2, ..., u_r, 0_{1,n-r})diag(sigma_1, sigma_2, ..., sigma_r, 0, ..., 0)
    $
    $ A=U mat(Delta, ; , 0) V^(-1) =U Sigma V^H =sum_(i=1)^r (u_i sigma_i v_i^H) $
    后面这一项可以取$k<r$,做近似压缩。
  ]

]
#theorem([*极分解*])[
  对于$A_{n,n}$,有$A=P_{n,n}"(半正定)" Q_{n,n}"(酉矩阵)"$
  #proof()[
    $display(A=U Sigma V^H=U Sigma(E) V^H =U Sigma(U^H U) V^H=(U Sigma U^H) (U V^H)=P Q)$
  ]
  P是缩放，Q是旋转。所以得名极分解。
]

#definition([*对称、实对称、正定、半正定、海森矩阵*])[
  #align(center, [
    #tablex(
      columns: 3,
      align: center + horizon,
      auto-vlines: false,
      repeat-header: true,

      /* --- header --- */
      [*名称*],
      [*定义*],
      [注释],
      [实对称矩阵],
      [$display(A in RR^(n,n) #h(0.5em) A=A^T)$ ],
      [反对称$A=-A^T$],
      [Hermite(厄米特)矩阵],
      [$display(A in CC^(n,n) #h(0.5em) A=A^H)$],
      [反Hermite$A=-A^H$],
      // [实对称矩阵],[$forall x,y in RR^n,(A x,y )=(x,A y )$],[元素是*实数*的对称阵],
      [正交矩阵],
      [$T in RR #h(0.5em) (alpha,beta)=(T(alpha),T(beta))$],
      [ $A A^T =E,A^(-1)=A^T$],
      [酉矩阵],
      [$T in CC #h(0.5em) (alpha,beta)=(T(alpha),T(beta))$],
      [$A^H A=A A^H=E$],
      [正规矩阵],
      [$A A^H=A^H A$],
      [与正交矩阵相似的矩阵],
      [正定矩阵],
      [$forall x in RR^n,x^T A x>0$],
      [正定矩阵的特征值都是正的],
      [半正定矩阵],
      [$forall x in RR^n,x^T A x>=0$],
      [特征值都是非负的],
      [#v(0.7em)海森矩阵#v(0.7em)],
      [$display(H_{i,j}=(partial^2 f)/(partial x_i partial x_j))$],
      [二阶偏导数矩阵],
      /* -------------- */
    )
  ])
]
==== 最小二乘应用

参考 @akritasApplicationsSingularvalueDecomposition2004,我们简述其在最小二乘问题上的应用。考虑$ min norm(A c -y)_2 #h(0.5em) \& #h(0.5em) (A "为数据矩阵" c "为参数矩阵") $
比如对于 $f(x)=c_1x+c_2x^2+c_3x^3$ $ A=mat(x_1, x_1^2, ..., x_1^3; x_2, x_2^2, ..., x_2^3; , ..., ..., ; x_n, x_n^2, ..., x_n^3) #h(0.5em) \& #h(0.5em) c=mat(c_1; c_2; ...; c_n) & y=mat(y_1; y_2; ...; y_n) $

首先我们知道$A=U sum V^H #h(0.5em) \& #h(0.5em) U"是酉矩阵",norm(U)=1$,所以
$
  norm(y-A c)^2_mark(2, tag: #<l2fs>)&=norm(U^H (y- A c))^2_2=norm(U^H (y- U sum V^H c))^2_2 \ &=norm(U^H y -sum V^H c)_2^2=norm(D-sum Z)_2^2 \ &= norm(mat(delim: "(", d_1, d_2, ..., d_n)^T -mat(delim: "(", sigma_1 z_1, ..., sigma z_r, 0_{1,n-r};)^T)^2_2 \ &= norm(mat(delim: "(", d_1-sigma_1 z_1, d_2-sigma_2 z_2, ..., d_r-sigma_r z_r, d_(r+1), ..., d_n)^T)^2_2 \ &= sum_(i=1)^r (d_i-sigma_i z_i)^2+ sum_(i=r+1)^n d_i^2 #annot(<l2fs>)[L2 范数 #footnote[L2范数表示欧几里得空间上符合直觉的向量长度$display(norm(x)_2)=sqrt(x^T x)=sqrt(x_1^2+x_2^2+...+x_n^2)$ ]]
$

因为$A=U sum V^H$ $A"为定值",U,sum,V_H$ 也为定值，所以$d$也为定值

$ min norm(y-A c)_2^2= min sum_(i=1)^r (d_i-sigma_i z_i)^2 => z_i= d_i / sigma_i #h(0.5em) \& #h(0.5em) (i=1,2,...,r) $
$ V^H c=z -> c=V z $


== 矩阵的广义逆
=== 减号广义逆
#definition([*逆的推广*])[
  $"for" A_{m,n}$
  $ A^(-1)_{m,m}A_{m,n} quad "(左逆)" #h(1.5em) #h(1.5em) A_{m,n}A^(-1)_{n,n} quad "(右逆)" $
  左逆列满秩$(m>=n)$，右逆行满秩$(m<=n)$。
  $ "（左逆求解）" P_{n,m} mat(A_{m,n}, E_{m,m})= mat(E_{m,m}, ..., P_{m,m})=mat(E_{m,m}, ..., P_{n,m}; , , ...) $
  $ "（右逆求解）" mat(A_{m,n}; E_{n,n})P_{n,m}= mat(E_{m,m}; ...; P_{n,n})=mat(E_{m,m}; ...; P_{n,m} #h(0.5em) ...) $

  // #align(center,[
  //   #tablex(
  //   columns: 3,
  //   align: center + horizon,
  //   auto-vlines: false,
  //   repeat-header: true,

  //   /* --- header --- */
  //   [*名称*],
  //   [*定义*],[注释],[减号广义逆],[]
  //   )
  // ])
]

#definition([*减号广义逆*])[
  对于$A_{m,n} in CC^(n,n)$ 存在$G_{n,m} in CC^(n,n)$
  使得 $A G A=A$,就称$G$是$A$的减号广义逆。
  $G in A{1} #h(0.5em) \& #h(0.5em) A{1}={A_1^-,A_2^-,...,A_n^-}$
]
$G in A{1}$*的充分必要条件*
$ "PAQ"=diag(I_r, 0) #h(0.5em) \& #h(0.5em) G=Q mat(I_r, U; V, W) P #h(0.5em) \& #h(0.5em) U V W"大小合适，任意矩阵" $
#proof()[
  ①必要性，$P(A G A)Q=diag(I_r, 0)mat(I_r, U; V, W)diag(I_r, 0)=diag(I_r, 0)=P A Q$

  ②充分性 $P A Q=P(A G A)Q=diag(I_r, 0)Q^(-1) G P^(-1) diag(I_r, 0)=diag(I_r, 0)$
  $ mat(I_r, ; , 0) Q^(-1) G P^(-1)mat(I_r, ; , 0)=mat(I_r, ; , 0)=> Q^(-1) G P^(-1)=mat(E_{r,r}, U; V, W) $
  所以$display(G=Q mat(E_{r,r}, U; V, W) P)$
]
至于求解过程就是$ mat(A_{m,n}, E_{m,m}; E_{n,n}, 0) =>("做行列初等变换")=>mat(diag(E_r, 0), P_{m,m}; Q_{n,n}, 0) $

=== M-P逆
#definition([*M-P逆*])[
  对于$A_{m,n}$,其M-P逆$A^(+)=G$, 有(任意矩阵都存在，并且唯一)
  $ A G A= A #h(0.5em) \& #h(0.5em) G A G = G #h(0.5em) \& #h(0.5em) (A G)^H=A G #h(0.5em) \& #h(0.5em) (G A)^H= G A $
]
不做具体赘述了，记住在python中可以使用`np.linalg.pinv`求解就足够了。
// === 投影变换
// #definition([*投影变换*])[
//   对于$CC^n=L plus.circle M , x=y+z #h(0.5em) \& #h(0.5em) x in L ,y in M  $,线性变化$sigma$满足$sigma(x)=y$,就称其为$CC^n$沿着自空间M到L的投影变换。并且有充分必要条件
//   $ sigma=sigma^2 $
// ]
// #example([$display(L="span" mat(1,0)^T #h(0.5em) \& #h(0.5em) M="spam" mat(1,-1)^T),"求"RR^2 "沿M到L的投影矩阵" $])[]

#theorem([*最佳的最小二乘解*])[
  $ min norm(A x -b)_2^2 = (x=A^+b) $
]
== 矩阵分析
// === 向量范数

=== 矩阵函数及其应用

== 计算机视觉中的应用
我们会用到的向量$in RR^2 RR^3 #h(0.2em)#footnote[$RR^n$表示n维向量空间]$。
=== $RR^3$中的变换（相机相关）
#definition("齐次坐标")[
  对于$n$维度向量$x=#vecs($x$)$，其在$n+1$维向量空间中的齐次向量（坐标）为$(x_1,x_2,...,x_n,1)^T$,称为$n$维齐次坐标，记作$tilde(x)$。他对于$RR^2 RR^3$中的变换非常有用，它统一了旋转、平移和缩放。（但是注意齐次坐标并不能相加或者相乘，只能乘以$T_{n+1,n+1}$来做变换）。
]
#h(2em) 比如对于一个向量$p$,一个混合变换$p'=A p+t$,使用分块矩阵的知识，也可以看作是$ p'=mat(A_{n,n}, t_{1,1}; B_{1,n}, s_{1,1})mat(p; 1)=T "Hm"(p) #h(1em) "&"(t=0,B=0_{1,n}) $
这里的$T$,我们称作透视矩阵(Transform Matrix)。$T$的第一行代表的是以$(x,y,z)^T$为基的坐标系下的变化，$T_21$一般直接以$0$,$T_22$也可以表示缩放性质。

#align(center, [
  #table(
    columns: 3,
    table.header([变换], [条件], [自由度]),
    [欧几里得变换], [$A=R #h(0.5em)"&"#h(0.5em) s=1 #h(0.5em)"&"#h(0.5em) B=0_{1,3}$], [6],
    [缩放变换], [$A=c R #h(0.5em)"&"#h(0.5em) s=1 #h(0.5em)"&"#h(0.5em) B=0_{1,3}$], [7],
    [纯缩放变换], [$A=c E #h(0.5em)"&"#h(0.5em) s=1 #h(0.5em)"&"#h(0.5em) B=0_{1,3},t=0_{3,1}$], [1],
    [仿射变换], [$s=1 #h(0.5em)"&"#h(0.5em) B=0_{1,3}$], [15],
    [射影变换], [$"None"$], [12],
  )
])

==== *欧几里得变换*、缩放变换

欧几里得变换包括绕原点旋转，平移，轴对称，中心对称（正交变换），在欧几里得变换中的$T_A$是正交矩阵，只有三个自由度（之后三维空间刚体变换会讲到）。
#definition("正交矩阵", numbering: none)[
  @wiki:正交矩阵 正交矩阵(Orthogonal Matrix)是指矩阵的转置等于逆矩阵的矩阵，也就是说$A^(-1)=A^T$，并且可以推证$|A|=1$。
  其中，$det(A)=1$的时候叫做*旋转矩阵*，$det(A)=-1$的时候叫做*瑕旋转矩阵*（瑕旋转是旋转加上镜射。镜射也是一种瑕旋转）。所有$A_{n,n}$构成一个*正交群*。
]
#h(2em)至于缩放变换呢,略去介绍。
// 其实它对应笛卡尔坐标系中几种变化，如欧几里得变换、仿射变换、透视变换等，他们得到
==== 小孔成像模型

我们直接俄导一下基于小孔成像的相机模型，也就是三维物体在二维计算机屏幕上的表示。
#import "img/ctez1.typ": PinCanModel
#figure(
  PinCanModel(),
  caption: [相机模型示意图],
)<cammodel>

#h(2em)如@cammodel 中所示，
对于任意一点，相当于关于原点的一个对称。对于大部分教程，都教大家用相似三角形求解,你可以在上图中寻找对应的三角形。诚然，这就是一个*纯缩放变换*，只需要求出缩放系数$c$可。
$ c=-f/z_i $

在现代相机中，我们对像做了预处理，使得原本成倒像的小孔成像可以正确成像，成像平面于$A'^((x y ))$平面（*实际像平面*），所以实际上$c_a=-c=display(f/z_i)$。
// 观察得知，一个坐标经过纯缩放变换后对应相机平面点不会改变。并且其实

同时我们定义像素坐标系如图中所示，以$O_c=(x_0,y_0,z_0=f)^T$为原点，$x,y$轴如图所示的坐标系（实际上它应该定义在实际像平面上）。假设$alpha=c_a k_x,beta=c_a k_y，gamma=c_a k_z$,($k_x,k_y$为两个尺度因子，表示从米变换为像素)从$P_i$到$P'_i$有变换

$
  tilde(P'_i)_mark(a, tag: #<a>)=mat(alpha, 0, 0, x_0; 0, beta, 0, y_0; 0, 0, gamma, 0; 0, 0, 0, 1)tilde(P_i)
  #annot(<a>)[实际像平面]
$

定义$u=tilde(P'_i)_a (0),v=tilde(P'_i)_a (1)$
$
  mat(u; v; 1)
  =mat(alpha/z_i, 0, x_0; 0, beta/z_i, y_0; 0, 0, 1)mat(x_i; y_i; 1)=mat(alpha/z_i, 0, x_0/z_i; 0, beta/z_i, y_0/z_i; 0, 0, 1/z_i)mat(x_i; y_i; z_i)=1/z_i mark(mat(alpha, mark(0, tag: #<s>), x_0; 0, beta, y_0; 0, 0, 1), color: #rgb("#4160eb"), tag: #<neican>)mat(x_i; y_i; z_i) #annot(<neican>)[ #gls("ck")]=1/z_i K p_i
  #annot(<s>, pos: top, yshift: 0.7em)[$c$ 缩放因子#footnote()[*【缩放因子$c$】*代表图像轴$u,v$的的非垂直性,表示$u,v$的夹角偏离 90° 的情况。理想情况下，图像平面上的 x 轴和 y 轴是垂直的$c=0$，但在某些特殊情况下，可能由于镜头设计或制造偏差，它们并非严格垂直。一般来说它等于0，Opencv中也是将其设置为0进行的标定。]]
$

同时我们的相机平面并不一定这么理想，它可能是各种姿态，我们需要先将初始的$p_i^("s")$ 转换到可以求解

$
  p_i=mat(1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0)tilde(p_i)=mat(1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0)T' tilde(p_i^("s"))=T_{3,4}tilde(p_i^("s"))
$

我们将这里的$T_{3,4}$称作相机的#gls("ct")。综上所述有
$
  mat(u; v; 1)=1/z_i K T tilde(p_i^("s"))= K T mark(mat(x_i/z_i; y_i/z_i; 1), tag: #<qczb>) #annot(<qczb>)[位于归一化平面]
$

==== 畸变模型
我们先来简单介绍一下几何光学中的成像模型以及像差理论。@李湘宁2022工程光学

实际的光学系统总是与理想的光学系统存在很大差异（如不同的孔径和视场），一个物点发出的光线经过实际光线汇聚后，其实不再汇聚于一点，而是一个*弥散斑*。对于单色光而言，从几何光学的角度分析，常见的像差有球差，惠差，场曲，畸变，像散。

其中，只有畸变影响几何形状，其他像差影响成像的清晰度（这个我们无能为力，选择好的镜头，合适的焦距，孔径，使用距离）。

// 畸变分为径向畸变（由透镜形状引起的畸变）和切向畸变（透镜和CCD不共面导致的畸变）

// #image1(image("img/1.png", height: 4cm),"径向畸变的几种类型(b)枕形畸变 (c)桶形畸变")
// #image1(image("img/2.png", height: 5cm),"切向畸变产生原因")


我们将$(u,v)^T$表示成极坐标形式，即$(r,theta)^T$。

对于径向畸变而言，主要是随着$r$的增大，畸变程度增大，其矫正公式如下(使用$k_1$就足够)
$
  x_(c o r r e c t e d )= x \(1 + k_(1 )r^(2 )+ k_(2 )r^(4 )+ k_(3 )r^(6 )\)\ y_(c o r r e c t e d )= y \(1 + k_(1 )r^(2 )+ k_(2 )r^(4 )+ k_(3 )r^(6 )\)
$

#h(2em)对于切向畸变,引入$p_1,p_2$
$
  x_(c o r r e c t e d )= x + 2 p_(1 )x y + p_(2 )\(r^(2 )+ 2 x^(2 )\)\ y_(c o r r e c t e d )= y + p_(1 )\(r^(2 )+ 2 y^(2 )\)+ 2 p_(2 )x y
$

然后通过相机标定标定相机内参和畸变系数即可。
// ==== 相机到相机
// 假设有两个相机$"CAM"_1,"CAM"_2$ ,
==== 双目相机
单个相机是无法确定$z$的，通常我们采用双目相机或者RGBD相机来解决这个问题。双目相机的原理是显然的，对于单个相机，我们能确定图像上一点在相机坐标系下一条直线上，只要两个直线有交点，物点可知。
#image1(image("img/3.png", height: 6cm), "双目相机原理")
双目相机一般由左眼和右眼两个水平放置的相机组成，如上图所示。
根据相似三角形原理，
$ (z-f)/z=(b-U_L+U_R)/b=> z = frac(f b, d)\,quad d = u_(L )- u_(R ). $
这里 d 为左右图的横坐标之差,称为视差(Disparity)，求解它需要知道左边相机像素在右边相机上对应哪一个位置。
=== 李群和李代数
#definition("群")[
  一个集合$G$和一个二元运算$*$，如果满足以下条件，就称$G$是一个群。
  1. 封闭性：对于任意$a,b in G$，有$a*b in G$
  2. 结合律：对于任意$a,b,c in G$，有$(a*b)*c=a*(b*c)$
  3. 单位元：存在一个元素$e in G$，使得对于任意$a in G$，有$e*a=a*e=a$
  4. 逆元：对于任意$a in G$，存在一个元素$b in G$，使得$a*b=b*a=e$
]
=== 三维空间刚体变换
==== 旋转矩阵
上一章节有详细的讲解，掠过。
==== 旋转向量
旋转矩阵有九个量，但实际上作为正交矩阵，它只有三个自由度，并且还被约束为正交矩阵，有时会使求解变得困难。我们可以用旋转向量来表示旋转矩阵。
==== 欧拉角
==== 四元数
#align(center, [
  = 矩阵导数
])
== 基本介绍

从一个最基本的函数$f(x)=a x$ 开始，显然
$ pdv(, x)f(x)=a $

拓展 $display(f(x)=sum_i a_i x_i)=a^T x quad "&" quad A=[a_1,a_2,...,a_n]^T quad X=[x_1,x_2,...,x_n]$
$
  pdv(, mark(x, tag: #<x>), color: #red)mark(f(x), tag: #<fx>, color: #blue)=mat(pdv(, x_1)f(x); pdv(, x_2)f(x); ...; pdv(, x_n)f(x))=mat(a_1; a_2; ...; a_n)=a
  #annot(<x>)[$n$维向量]
  #annot(<fx>, pos: top)[标量$display(sum_i^n a_i x_i)$]
$ <1.1>
#h(2em)注意到这里$display(pdv(, x)f(x))$的维度等于$display(x)$的维度。那如果我们继续拓展呢？$x$是任意维度矩阵的时候，结果又会怎么样呢？
// #import "@preview/great-theorems:0.1.1": *
// #import "@preview/rich-counters:0.2.1": *
// #let mathcounter = rich-counter(
//   identifier: "mathblocks",
//   inherited_levels: 1
// )

// #let theorem = mathblock(
//   blocktitle: "Theorem",
//   counter: mathcounter,
// )

// #let lemma = mathblock(
//   blocktitle: "Lemma",
//   counter: mathcounter,
// )

// #let remark = mathblock(
//   blocktitle: "Remark",
//   prefix: [_Remark._],
//   inset: 5pt,
//   fill: lime,
//   radius: 5pt,
// )

// #let proof = proofblock()
// #show: great-theorems-init

#theorem[
  $pdv(, X)f(x)$应和$display(X)$的行列数相同（$f(x)$是标量的时候），并且
  $ [pdv(, X)f(x)]_(i j)=pdv(, X_(i j))f(x) $
] <the1>
#h(2em)
$ pdv(f, X^T)=pdv(f, X)^T $ <pdvt>
#h(2em)
并且我们继续分析@eqt:1.1 它表明，至少对于我们给出的例子 有$display(pdv(a^T x, x)=a)$，那对于所有呢？显然它也成立

#theorem[
  // $pdv(,X)f(x)$应和$display(X)$的行列数相同，并且
  如果存在一个多元标量函数$f(x)=#gls("tr")\[A_T X\]$，那么
  $ [pdv(f, X)]=A $
] <the2>

#theorem("Tr性质")[
  我们给出一些关于迹的性质，其中矩阵 #mi("\(A\)") 和 #mi("\(B\)") 的大小适当，且 #mi("\(c\)") 是一个标量值。
  1. $Tr[A+B]=Tr[A]+Tr[B]$
  2. $Tr[c A]=c Tr[A]$
  3. $Tr[A B]=Tr[B A]=sum_(i=1)^n sum_(k=1)^n A_(i k) B_(k i)$
  4. $Tr[A^T]=Tr[A]$
  5. $Tr[A_1A_2...A_n]=Tr[A_n A_(n-1)...A_1]$
  6. $Tr[A^T B]=sum A_(i j)B_(i j )$
  7. $Tr[A]=sum #gls("lanbda")$
  8. $f(x)=Tr[f(x)]=Tr[f(x)^T]#h(1em) \& #h(0.5em) "When" #h(0.5em) f(x)_{1,1}$ <ddd>
  // #v(-1.5em)
  #proof([of @the3(3) $Tr[A B]=Tr[B A]$])[
    $ display(A B_(i j )=sum_(k=1)^n A_(i k) B_(k j) =>A B_(i i )=sum_(k=1)^n A_(i k) B_(k i)) $
    $ sum_(i=1)^n sum_(k=1)^n A_(i k) B_(k i)=sum_(i=1)^n sum_(k=1)^n B_(i k) A_(k i) $<proof3.1>
    $i k " "k i$的情况都会出现，所以显然@eqt:proof3.1 成立，证毕。
  ]

] <the3>
// #theorem[111]<the4>
== 标量矩阵导数$f(x)$
=== 矩阵微分

#definition[
  $ "d" X = #matrix_($"d"X$, 1, $n$) $ <dx定义>
  矩阵里面的每一个如$d X_(11)$,其实
]

#theorem[
  // #footnote[这里比较常用的还有$f(x)=Tr[f(x)]=Tr[f(x)^T]$]
  $ d Tr[A]=Tr[d A] $
  #v(-1.5em)
  #proof[
    $ display(Tr[d A]=sum_i d A_(i i)=sum_i d A_(i i)=d sum_i A_(i i)=d Tr[A]) $
  ]
]
标量形式的微分和导数可以用下式表示
$ d f= pdv(f, x)d x $
对于矩阵，有如下定理
#theorem[
  $ d f(X)=Tr[pdv(f, X)^T d X] #footnote[这里的$f(X),f$小写，应该为标量函数] $ <dftr>
  $ f(x)=Tr[f(x)]=Tr[f(x)^T] $ <ftr>
  #v(-1.5em)
  #proof[
    For @eqt:dftr
    $ d f(X)= & sum_(i j ) pdv(f, X_(i j))d X_(i j) $
    使用@eqt:proof3.1
    $
      Tr [pdv(f, X)^T d X] & =sum_i sum_k [(pdv(f, X)^T)_(i k)(d X)_(k i ) ] \
                           & =sum_i sum_k [(pdv(f, X))_(k i)(d X)_(k i ) ]
    $
    For @eqt:ftr,只需要意识到$f(x)_{1,1}$即可。证毕。
  ]
]

#theorem[
  对于矩阵微分，有如下几个性质及延伸性质
  1. $d(A+B)=d(A)+d(B)$
  2. $d(c A)=c d(A)$
  3. $d(A B)=d(A)B+A d(B)$
  4. $d(X^T)=d(X)^T$
  5. $pdv(x^T A x, x)=A x+A^T x #h(1em)$
  6. #mi("\mathrm{d}(X^{-1})=-X^{-1}\mathrm{d}XX^{-1}") #h(0em) (if $X^(-1)$exists)
  #proof([of *3 $d(A B)=d(A)B+A d(B)$*])[
    $
      "LEFT"=d f(A B) & = d #Mabij($A$, $B$) \
                      & = sum_k d (A_(i k))B_(k i)+ A_(i k) d(B_(k i))
      // d f(A B)_(i j)&= pdv(f,A B_(i j))d (sum_k A_(i k)B_(k i))
    $
    $ "RIGHT="[d(A)B+A d(B)]_(i j ) & = #Mabij($d(A)$, $B$)+#Mabij($d(B)$, $A$)="LEFT" $
  ]
  #proof([of *4: $d(X^T)=d(X)^T$*])[
    使用@eqt:dx定义
  ]

  #proof([of *5: $pdv(x^T A x, x)=A x+A^T x #h(1em)$*])[
    $
                     d(x^T A x) & = d Tr[x^T A x] \
                                & =Tr[d(x^T)A x+x^T d(A x)] \
                                & =Tr [d(x)^T A x+x^T mark(d(A), tag: #<da>, color: #blue) x+x^T A d(x)] \
      // & =Tr [d(x)^T A x+0+x^T A d(x)] \
          (Tr[A+B]=Tr[A]+Tr[B]) & = Tr [d(x)^T A x]+Tr[x^T A d(x)] \
                (Tr(A^T)=Tr[A]) & =Tr [x^T A^T d(x)]+Tr[x^T A d(x)] \
      "Then" => pdv(x^T A x, x) & =(x^T A^T+x^T A)^T \
                                & =A x + A x^T
                                  #annot(<da>)[0]
    $

  ]

  #proof([of 6 $d X^(-1)=-X^(-1) d X X^(-1)$])[
    $
      d(I)=0=d(X X^(-1)) & =d(X) X^(-1) +X d(X^(-1)) \
               d(X^(-1)) & =-X^(-1)d(X)X^(-1)
    $
  ]
]<the2213>
=== 标量对矩阵求导的求解过程
从上面的例子中，我们可以得到对于一个$f(x)$求解$display(pdv(f(x), x))$的固定步骤
#pseudocode-list[
  1. $d f(x)=d Tr[f(x)]= Tr[ d f(x)]$ or $d f(x)=d Tr[f(x)^T]= Tr[ d f(x)^T]$
    - 见@eqt:ftr
  2. 使用@the3 中关于trace的各种性质，化简成$sum_i Tr[U_i d(x)]$的形式
  3. 如@eqt:dftr，所以$display(pdv(f(x), x)=sum_i (U_i)^T)$
]

// $ d f(x) =Tr[]$
// 对于$display(d (X^T A X))$

// #gls("potato")是我们都喜欢吃的一种菜肴
#align(center, [
  = 最优化理论
])
所谓最优化问题，就是求解 $min f(x) #h(0.5em) \& #h(0.5em) x in K$
== 最小二乘的几种解法
$ "min"F(x)=||f(x)||_2^2=||b-A hat(x)|| $
#v(1em)
=== 牛顿法
$
  f(x) & =f(x_0)(x-x_0)^0+f'(x_0)(x-x_0)+((f''(x_0))/2!)(x-x_0)^2+... \
       & approx f(x_0)(x-x_0)^0+f'(x_0)(x-x_0)+(f''(x_0)(x-x_0)^2)/2
$<1>

$ g(x)=dv(, x)f(x)=f'(x_0)+f''(x_0)(x-x_0) =g(x) $

$g(x)=0,x=x_1$的时候是极值，
$ x_1-x_0=(f'(x))/(f''(x)) => x_1= x_0 - (f'(x))/(f''(x)) $


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
                              #annot(<jjdeltax>, pos: top)[@the2213(5)]
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
==== 随机梯度下降法
=== Example
#align(center, [
  = 概率论+随机过程
])

== 随机变量
#definition()[
  定义从n中取出r个元素的排列数为$display(C_n^r=n!/(n-r)!r!)$
]
#definition([*样本空间、随机事件、概率频率，常见公理*])[
  #align(center, [
    #tablex(
      columns: 3,
      align: center + horizon,
      auto-vlines: false,
      repeat-header: true,

      /* --- header --- */
      [*名称*],
      [*定义*],
      [注释],
      [样本空间$Omega$],
      [全部事件的空间],
      [*所有可能的结果*],
      [事件$A$],
      [样本空间的*子集*],
      [*可能发生的事件*],
      // [频率$P_n$],[事件发生的频率],[*事件发生的频率*],
      [概率$P$],
      [事件发生的可能性],
      [*事件发生的可能性*],
      [事件独立],
      [$P(Pi A_i)=Pi P(A_i )$],
      [],
      [条件概率],
      [$P(A|B)=P(A B)"/"P(B)$],
    )
  ])
  // 事件的严格定义需要引入$sigma"-代数"$,需要测度学。
  一些基本概率公理
  $
    "(全概率公式)" & P(A)=sum_(i=1)^n P(A B_i) #h(0.5em) \& #h(0.5em) B_i "是样本空间的分割" \
      "(乘法公式)" & P(A B)=P(A|B)P(B) \
    "(贝叶斯公式)" & P(B_i|A)=P(A B_i)/P(A)=P(B_i|A)=P(A B_i)/(sum_(i=1)^n P(A B_i))=(P(A B_i))/(P(A|B_i)P(B_i))
  $
]

常见的分布如下
#align(center, [
  = 最优化
])

== 拉格朗日乘数法
一个函数的极值可以通过驻点来求解，驻点不一定是极值点，有可能是鞍点。

// 这是一个无约束问题
// $ "minize" fvec(x) $


== PCA
先推导二维的PCA

计算一维数据的方差
$ s^2(X)=1/(n-1) sum_(i=1)^n (x_i-macron(x))^2 $
// \alpha
$alpha beta sum delta Delta pdv(f, x) plus.minus 11111$
对于二维数据有协方差
$ "cov" (X,Y)=1/(n-1) sum_(i=1)^n (x_i-macron(x))(y_i-macron(y)) $

协方差矩阵C 其实是$(X_1=X-macron(X))$
$ C=1/(n-1) X_1^T X_1 $


定义一个投影方向$v=(x_0,y_0) #h(0.5em) "st" #h(0.5em) x_0^2+y_0^2=1$
// #figure(
//   image("img/5,png",width:50%),
//   caption: [

//   ]
// )
//
#image1(image("img/5.png", height: 7.8cm), "示意图")


$ S=arrow(v) arrow(x) =|arrow(x)| cos theta $
在这个方向投影后的长度的方差其实可以表示为
$
  1/(n-1) sum S^2 =1/(n-1)(arrow(v)X_1^T)(arrow(v)X_1^T)^T= arrow(v) (X_1^T X_1 )/(n-1) arrow(v)^T=arrow(v) C arrow(v)^T
$

最优化方差最小值

$ J=arrow(v) C arrow(v)^T #h(0.5em) "st" #h(0.5em) arrow(v) arrow(v)^T=1 $

$ F(arrow(v))=arrow(v) C arrow(v)^T -lambda(1-arrow(v)arrow(v)^T) $//

$ pdv(, v)F(arrow(v))=0 => 2C v^T -2 lambda v^T=0 $
$ (pdv(, v) f(x) v=f(x)^T ,pdv(, v) A^T v A=A v+A^T v),C=C^T $
C是实对称矩阵并且使用矩阵求导@the2213

$ C v^T = lambda v $

对C做特征值分解，得到两个特征向量PC1,PC2


#image1(image("img/6.png", height: 7cm), "PC1 PC2示意图")

// #gls("海森矩阵", display: "whatever you want")
#outline(title: "TODOs", target: figure.where(kind: "todo"))
= 一些其他概率论知识
#set page(columns: 1)
#bibliography(
  // ("use.bib", "mylib.bib"),
  ("use.bib", "mylib.bib"),

  title: [
    参考文献#v(1em)
  ],
  style: "nature",
)
