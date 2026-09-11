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
  #text(size: 1.5em)[*吴恩达机器学习*]
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

= 监督学习
#v(0.5em)
== 单变量线性回归(Linear Regression with One Variable)

#set terms(indent: 1em)
// #show terms:
/ 输入特征 Input Feature: $x$
/ 输出标签 Output Label: $y$
/ 样本 Sample: $(x,y)$
/ 样本数量 Sample Number: $m$
/ 第i个样本: $(x^(i),y^(i))$
/ 数据集: training set
/ model: $f$  or $h$
/ 输出的结果 esitimate: $hat(y)$
/ 损失函数 Cost function: $J(...)$

#h(2em)how to represent the function $f$? We can konw $f$ is a linear function,So we have
$ hat(y)=f_(w,b)(x)=w x+b $

#h(2em)we call $w,b$ as weights or parameters权重或是参数.

Then we define a function called cost function $J(w,b)$ to measure the error between the real value and the estimated value. The cost function is defined as

$ hat(y^(i))=f_(w,b)(x^(i)) $
$ "Cost"=J(x)=J(w,b)=1/(2m) sum_(i=1)^m (hat(y)^(i)-y^(i))^2 $ <1>

// $ J(theta)=pdv(,x)f(x)=dv(x,y)f(x)  $
#h(2em)$1/2$ is just used to make the derivation easier.

c

#h(2em)先将b设置为0，关于w的损失函数是个抛物线。
#figure(
  align(center, image("img/1.png", width: 100%)),
  caption: [],
)

// for each $b$ you can divided the task into minimize the cost function $J(w)$ to get the answer.

#h(2em) for tow parameters it can display in three dimensions
#figure(
  align(center, image("img/2.png", width: 100%)),
  caption: [],
)

#h(2em)同理也可以用等高线图表示
#figure(
  align(center, image("img/3.png", width: 100%)),
  caption: [],
)

#h(2em) 想象一座山来具象这个等高线图(Counter plot)。

=== 梯度下降算法 gradient descent
Keep change $w,b$ to reduce $J(w,b)$ to minimize it.
对于我们使用的平方损失函数,他总是上图所示的抛物面形状.
对于其他的损失函数,可能是各种各样的.


梯度下降对于不同的起点会有不同的结果,有可能进入局部最小值.


/ 学习率 Learning rate: $alpha$

先给出公式
$ w=w-alpha pdv(, w)J(w,b) $
$ w=b-alpha pdv(, b)J(w,b) $
#h(2em)
正确的算法流程是
$
  "tem"_w & = w-alpha pdv(, w)J(w,b) \
  "tem"_b & = w-alpha pdv(, b)J(w,b) \
        w & = "tem"_w \
        b & = "tem"_b
$

其中
==== 数值求解积分
如@张韵华2000数值计算方法和算法,对于一个连续的一元函数，$f(x,y)$在$[a,b]$上的定积分
$ integral_a^b f(x)=f(b)-f(a) $
#h(2em)但是如果$f(x)$是一个离散的如$f(x_i),i=1,2,3...n$，只能使用估计值
$
     "I"(f) & =integral_a^b f(x) d x \
  "I"_n (f) & =sum_(i=1)^n f(x_i) h_i
$
#h(2em)如果有$I_n (x^k)-I(x^k)=0$,就说具有k次精度.
===== New Cote,s 积分
将$[a,b]$分成$n$段，步长$display(h=(b-a)/b ","x_i=a+i h)$,构造拉格朗日插值多项式#footnote([#cmarker.render(read("md/拉格朗日多项式.md"), math: mitex)])$L(x)$
$ integral_a^b f(x) d x approx integral_a^b L(x) d x $
#h(2em)由此得到的数值积分称为牛顿 - 柯特斯积分。

#h(-2em)*梯形积分*

取端点$a,b$构造拉格朗日多项式，显然，这是一个一次函数（$n+1=2,n=1$）,显然其积分等于面积，具有一阶代数精度。
$ integral_a^b f(x) d x approx integral_a^b L_1(x) d x approx [(f(a)+f(b))times (b-a)/2 ] $

#h(2em)对于更普遍的,可以写成
```python
def df(x, h=1e-10):
    return (f(x+h) - f(x-h)) / (2*h)
```


*辛普森积分*

具有三阶代数精度,对于次数不超过三次的多项式准确成立。
以$( a ,f ( a)) ,(( a + b)/ 2 ,f(( a + b)/2))和( b ,f( b))$为插值节点构造二次插值函数 $L_2 ( x)$

#mitex(
  `
\int_a^bf(x)dx\approx I_2(f)=S(f)=\frac{b-a}6\bigg[\begin{array}{c}f(a)+4f\bigg[\frac{a+b}2\bigg]+f(b)\bigg]\end{array}
`,
)

```python
def df_xps(x, h=1e-10):
    return (f(x+h) + 4*f(x)+f(x-h))*h/3
```

*New Cote,s*

#figure(
  align(center, image("img/4.png", width: 100%)),
  caption: [牛顿科特斯积分的系数],
)

#h(2em)$m=1$是梯形积分，$m=2$是辛普森积分。不过由插值的龙格现象可知 ,高阶牛顿 柯特斯积分不能保证等距数值积分系列的#text(red)[收敛性] ,同时可证(略)高阶牛顿 柯特斯积分的计算是不稳定的 。 因此 ,实际计算中常用低阶 复化梯形等积分公式

==== 数值微分
分为前向微分，后向微分，和中心微分。有两点式和三点式。

$h=x_(i+1)-x_(i-1)$
$
  dv(, x)f(x) & =(f(x_(i+1))-f(x_(i)))/(x_(i+1)-x_i) +o(h) \
              & =(f(x_(i))-f(x_(i-1)))/(x_(i)-x_(i-1)) +o(h) \
              & =(f(x_(i+1))-f(x_(i-1)))/(x_(i+1)-x_(i-1)) +o(h^2) \
              & =
                (3f(x_i)-4f(x_(i+1))+f(x_(i+2)))/(-2h)+o(h^2) \
              & =
                (3f(x_i)-4f(x_(i-1))+f(x_(i-2)))/(2h)+o(h^2)
$
=== python 中一些常用的数值计算库
==== numpy
===== 生成数组
#import "./numpy.typ": *
#numpy_make()
// ===== 数组操作

=== matplotlib:pyplot

=== linear regration梯度下降算法的实现
首先我们的损失函数如 @eqt:1 所示,Let,t we simplify it
$ J(x)=J(w,b)=1/(2m) sum_(i=1)^m (hat(y)^(i)-y^(i))^2=1/(2m)sum_(i=1)^m (x_1X_i_1+x_0X_i_0-y_i)^2 $ <2>

#h(2em)对 @eqt:2 求导

$ dv(, x_1)J(x)=1/m sum_(i=1)^m dv(, x_1)(x_1X_i_1+x_0X_i_0-y_i)=1/m sum_(i=1)^m X_i_1(x_1X_i_1+x_0X_i_0-y_i) $ <3>
#h(2em)这是我们对原函数十分熟悉的时候，如果不熟悉就需要数值求解原函数的导数，下面我们分别给出两种解法。

==== 解析解法
// #ti-brand-python()
// #ti-brand-qq()
```python
def gradientDescent(X, y, theta, alpha, iters):
    temp = np.matrix(np.zeros(theta.shape))
    parameters = int(theta.ravel().shape[1])
    cost = np.zeros(iters)
    for i in range(iters):
        for j in range(parameters):
            term = np.multiply((X * theta.T) - y, X[:,j])
            temp[0,j] = theta[0,j] - alpha*((1 / len(X)) * np.sum(term))
        theta = temp
        cost[i] = computeCost(X, y, theta)

    return theta, cost
```
#showybox([
  上述的$theta$理解为我们文中的$x$。
])

同时，其求解得到的结果为
#showybox([
  matrix([[-3.25095985,  1.12837093]])
])

==== 数值解法

```python
def gradientDescent_(X, y, theta, alpha, iters):
    temp = np.matrix(np.zeros(theta.shape))
    parameters = int(theta.ravel().shape[1])
    cost = np.zeros(iters)

    d_len=0.01
    for i in range(iters):
        theta_=np.matrix(np.ones(theta.shape)*d_len)
        for j in range(parameters):
            # 对于第i个变量 忽略其他
            theta_use=np.matrix(np.zeros(theta.shape))
            theta_use[0,j]=theta[0,j]
            term = (computeCost(X, y, theta+theta_use)-computeCost(X, y, theta-theta_use))/(2*d_len)
            temp[0,j] = theta[0,j] - alpha*term
        theta = temp
        cost[i] = computeCost(X, y, theta)

    return theta, cost
```

#h(2em) 结果是一样的。

=== 梯度下降算法的拓展
==== 一般函数
比如$a sin(omega x)+2.09-a$
```python
np.random.seed(12891832)
a=0.780+0.265*np.random.rand()
omega=1.884+0.116*np.random.rand()

size=1000
def f_(x,a_=a,omega_=omega):
    return a_*np.sin(omega_*x)+2.09-a_
data=np.array([])
X=np.linspace(0,4,size)
Y=f_(X)+np.random.normal(0, 0.8, size)*a
X=np.matrix(X)
Y=np.matrix(Y)

def computeCost(X, y, theta):
    a_ = theta[0,0]
    omega_ = theta[0,1]
    inner = np.power(((a_*np.sin(omega_*X)+2.09-a_) - y), 2)
    return np.sum(inner) / (2 * len(X))
    # return 0
```

这里为了简单，我们还是直接使用了MSE loss function，只需要修改Cost部分即可。

#pagebreak()
==== 其他的损失函数及其应用场景
/ Regration Loss 回归损失:
  / Mean Absolute Error: $display(J(theta)=|hat(y)-y)|$
    - 也叫做L1LOSS MAE 平均绝对五擦汗
    / 优点: 收敛速度慢，小的损失值和其他一样，不利于网络学习
    / 缺点: 鲁棒性好（对离群点和异常值）
/ Regration Loss 回归损失:
  / Mean Squred Error: $display(J(theta)=(hat(y)-y)^2)$
    - 也叫做L2LOSS 均方误差MSE
    / 优点: 收敛速度快
    / 缺点: 鲁棒性差
- Classification Loss 分类损失
==== 梯度下降的优化
===== 随机梯度下降
随机梯度下降对于大数据集有很好的效果，但是对于小数据集，效果不好。
===== 小批量梯度下降

==== 损失函数的可视化
3d图，我们还是用matlab画吧。

=== 高斯牛顿法
// = 能量机关关键点检测实战
// #v(0.5em)
// == COCO数据集及其定义
// 对于每张图，其注释如下所示
// ```jsonnet
// {"segmentation":[[0.43,299.58,2.25,299.58,9.05,287.78,32.66,299.13,39.01,296.4,48.09,290.96,43.55,286.87,62.16,291.86,61.25,286.87,37.65,279.15,18.13,272.8,0,262.81]],
// "num_keypoints":1,
// "area":1037.7819,
// "iscrowd":0,
// "keypoints":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,277,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
// "image_id":397133,
// "bbox":[0,262.81,62.16,36.77],
// "category_id":1,
// "id":1218137}
// ```

// #h(2em) 其中的`keypoints`部分，每三个数字为一组，代表一个关键点，三个值分别为x坐标、y坐标、标志位，其中，标志位有三个值：

// 0：未标注
// 1：标注，但被遮挡
// 2：标注，未遮挡


// == 搭建深度学习环境
// 使用Docker Desktop 直接搭建Docker镜像。安装Pytorch Transformer 自动标注工具，
// Dockerfile如下所示
// ```dockerfile
// FROM nvidia/cuda:11.0-cudnn8-devel-ubuntu18.04
// RUN apt-get update && apt-get install -y python3 python3-pip
// RUN pip3 install torch torchvision
// ```
#set page(columns: 1)
#bibliography(
  "use.bib",
  title: [
    参考文献#v(1em)
  ],
  style: "nature",
)
