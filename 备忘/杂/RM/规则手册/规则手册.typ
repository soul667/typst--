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


#align(center, [#text(size: 2em)[*视觉组校内赛规则手册*]])
#align(center, [#text(size: 1.5em)[*V1.0*]])


// = 参赛
// #h(0.5em)
= 比赛形式
比赛将分组别进行，不同组别（视觉组和导航组）有不同比赛形式。下面将介绍不同步别的任务及其比赛背景。
== 视觉组
视觉组的主要任务是通过图像识别目标，实现一些特定任务。如识别装甲板完成自动瞄准，识别飞镖引导灯进行飞镖姿态自动调整，识别兑换站实现自动对矿等任务。

本次校内赛视觉组的任务分为基础任务和进阶任务。
基础任务是识别比赛中的飞镖引导灯，进阶任务是识别比赛中的装甲板。我们将提供比赛中录制的视频或图片。
=== 飞镖以及引导灯介绍
飞镖系统相当于战争中的”导弹“。其目标是且仅是比赛中的建筑物：前
哨战和基地。可以造成巨量伤害以及对对方的视障效果（闪光弹）。

比赛中的飞镖引导灯安装在前哨战或基地上方，飞镖检测模块下方，用于引导飞镖击打目标。
其发射 520nm 波段的绿色可见光,飞镖引导灯在近似为点光源时其发光强度约为 10cd,发光部分直径约为 55mm。

#figure(
  align(center, [
    #image("./img/1.png", width: 80%)
  ]),
  caption: [基地飞镖检测模块示意图],
)
=== 装甲板介绍
由于机器人上安装的图传模块到操作手看到的第一视角的传输延迟加上操作手反应速度的滞后，操
作手几乎很难手动瞄准高速运动的机器人上的装甲板（如下图）。

#figure(
  align(center, [
    #image("./img/2.png", width: 40%)
  ]),
  caption: [装甲板示意图],
)
因此，视觉组的一个任务是，通过处理图像找到相机视野范围内的装甲板，（相机一般安装在云台上，和枪
口平行放置并指向同一个方向，类似瞄准镜），进而向下位机（STM32等用于控制的
MCU,microcontroller unit,单片机）发送此装甲板的相对枪口的角度数据，电控根据此数据控制电机自动转向目标装甲板，实现装甲板的自动打击。

装甲板的具体尺寸信息将在下一版规则手册中给出，可以先尝试完成基础任务。
== 导航组
导航组的比赛背景主要是比赛中的哨兵机器人，其需全自主运行，拥有强力的增益和输出。

本次校内赛导航组的任务简单来说是通过识别特定位置的ApriTag进行导航，到达指定位置，获得得分。


我们将提供比赛中的步兵机器人并留出一个可以控制机器人底盘速度的函数。你需要通过识别ApriTag来获取自己的位置信息，来控制机器人的运动实现特定的任务#footnote([云台姿态固定，与底盘相对姿态不变])。ApriTag的示意图如下#footnote([
  AprilTag是一种视觉基准系统，可用于多种任务。使用一些算法即可计算标签相对于相机的精确3D位姿。(AprilTag官网介绍：#link("https://april.eecs.umich.edu/software/apriltag.html"))])


#figure(
  align(center, [
    #image("./img/tag52_13_00000.svg", width: 40%)
  ]),
  caption: [ApriTag示意图],
)
#h(2em)
具体场地信息,机器人信息以及ApriTag位置，尺寸会在下一版规则手册中给出，可以先学习ApriTag的识别方法。

附比赛中用到的ApriTag：
#link("https://lark-assets-prod-aliyun.oss-cn-hangzhou.aliyuncs.com/yuque/0/2024/7z/29137445/1732543000680-09685ebd-cfee-46dc-9482-233c4b3dca53.7z?OSSAccessKeyId=LTAI4GKnqTWmz2X8mzA1Sjbv&Expires=1732544811&Signature=LbPZIBxzX5DvC3gPLOX00XUvEpQ%3D&response-content-disposition=attachment%3Bfilename*%3DUTF-8%27%27apriltag-imgs-master.7z")[ApriTag下载链接] （依次编号为$1,2,3,...,8$）
= 组队

请加入比赛QQ群，相关报名组队和后续比赛信息都将在群内发布。
#figure(
  align(center, [
    #image("./img/3.png", width: 40%)
  ]),
  caption: [群聊照片],
)

#h(2em)组队形式为两人一组（推荐#footnote([对于单人组队，我们尊重个人意愿])），选择视觉和导航其中一个任务（推荐#footnote([对于愿意两个都参加的，我们尊重个人意愿。但需要注意的是很可能你会很累，并且难以完成任务，但毋庸置疑你会有所收获。])）。
