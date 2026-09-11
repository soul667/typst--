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



// #set par(justify: true,first-line-indent: 2em)
// #show: show-cn-fakebold
#maketitle(
  title: "能量机关仿真手册",
  authors: (
    "洛白",
  ),
  date: "2024 10 月22 日",
)
= 前期准备
#v(1em)
== 软件
首先下载`solidworks 2024`、`UE`用于仿真环境的搭建，如果你要进行文档的修改，还需要下载`Typst`。
=== solidworks 2024

下载地址：#link("https://pan.baidu.com/s/1w5w7Nhx3QhqsRe4lYHjROg?pwd=89v3")

安装教程放在了本文件夹下。队伍网盘的密码语雀里面有。
==== bug
不过由于它的兼容性问题，你还需要写在一下Microsoft Webview Runtime最新版，不然你的`sepup`只会一直卡死。

打开你的`powershell`然后安装Geek卸载软件。

```shell
winget install  GeekUninstaller.GeekUninstaller
```
#figure(
  align(center, image("img/1.png", width: 50%)),
  caption: [强制删除就行],
)

#h(2em) 这里已经卸载过了，所以没有，选择强制删除就行。

PS: 也可以抓个机械来帮你安装。
=== UE
官方地址: #link("https://www.unrealengine.com/zh-CN/download")
1. 下载启动器
#h(2em)在安装和运行 Unreal Editor 之前，需要下载并安装 Epic Games 启动程序。
2. 安装Epic Games启动程序
#h(2em)下载并安装后，打开启动程序，创建或登录你的Epic Games账户。
3. 安装虚幻引擎
#h(2em)登录后，移动至“虚幻引擎”选项卡，并点击“安装”按钮，下载最新版本。

=== solidworks插件


== 模型处理和导出
=== 简化模型
下载官方的场地模型#link("https://bbs.robomaster.com/article/9601"),使用`solidworks`打开
#figure(
  align(center, image("img/2.png", width: 110%)),
  caption: [打开官方模型],
)

#h(2em)首先，将父模型的断开连接，然后找到能量机关的装配体。右键，创建新的装配体。
#figure(
  align(center, image("img/3.png", width: 110%)),
  caption: [新的装配体],
)

#h(2em)然后开始简化，只留一边的能量机关即可，并且将中央资源岛删去。

#figure(
  align(center, image("img/4.png", width: 70%)),
  caption: [第一步简化后],
)

#h(2em)删掉所有的螺丝。
#figure(
  align(center, image("img/5.png", width: 100%)),
  caption: [筛选螺丝并删除],
)

现在还有427个零件，我们一个一个化简以及重命名。

将不可运动的部分使用`Defeature`简化。

=== 下载插件
插件地址 #link("https://www.unrealengine.com/zh-CN/datasmith/plugins")

=== solidworks导出

solidworks中从主工具栏，打开"保存（Save）"菜单（软盘图标），然后选择"另存为（Save As）

=== UE导入
UE中，创建新的项目，安装两个插件Datasmith Import 和 Datasmith CAD Import

然后参照

#link("https://dev.epicgames.com/documentation/zh-cn/unreal-engine/importing-datasmith-content-into-unreal-engine")


=== 修改solidworks中的坐标系
由于UE的坐标系默认的不对，影响我们在UE中的操作，做如下修改。

==== 整个能量机关
先右键解锁浮动，然后旋转到正确位置。
#figure(
  align(center, image("img/8.png", width: 100%)),
  caption: [现在位置],
)
用截图工具测出偏移11度，固定度数旋转。原点位置正确，
整个模型的原点在底座两条线的交点，如下图
#figure(
  align(center, image("img/6.png", width: 100%)),
  caption: [原点示意图],
)
#h(2em) 坐标系定义如下所示（右x后y，右手坐标系）
#figure(
  align(center, image("img/7.png", width: 111%)),
  caption: [坐标系示意图],
)

==== 扇叶部分
#figure(
  align(center, image("img/9.png", width: 100%)),
  caption: [扇叶部分原点],
)

可以看到原点严重偏移，我们需要将原点放在扇叶的中心，以便能够正确旋转
（将所有装配体改为浮动，添加N个配合，添加原点配合使其在轴心）
#figure(
  align(center, image("img/11.png", width: 100%)),
  caption: [变换后的中心位置],
)

// 导出一个新的装配体到新的坐标系，再原装配体中重新配合。


= 模块制作
#h(1em)
== 流水灯模块

= 关键点检测模型
#v(1em)
== COCO关键点股价定义
= UE UI 菜单

= 渲染目标

$ i(y)=("FanCenter"_y"-Center"_y,"FanCenter"_x"-Center"_x) $
$ i(x)=plus.minus(i(x)_y, -i(x)_x)=(i(x)_y,-i(x)_x) $

所有的点从$(i(x),i(y))$变换而来。
