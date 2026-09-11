#import "@preview/diatypst:0.2.0": *
#set text(font: ("Times New Roman", "Source Han Serif SC"), size: 12pt)
#show: slides.with(
  title: "1,2单元", // Required
  subtitle: "",
  date: "01.07.2024",
  authors: "",
)
// #import "@preview/rubber-article:0.1.0": *
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
#import "@preview/physica:0.9.3": *

// #set text(font:("Times New Roman","Source Han Serif SC"), size: 12pt)
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

= PART1
// 先讲解试卷
1. bored 无聊的
  - bored （感到无聊的），用来描述人的感觉或状态。
    - I'm bored.（我感到无聊。）
    - （*反义词*）Interested，Excited
  - boring （令人无聊的），但它用来描述事物、活动或经历本身。
    - The meeting was so boring that I fell asleep.（会议太无聊了，我竟然睡着了。）
    - （*反义词*）Interesting（有趣的），Exciting（令人兴奋的）

== 阅读
1. Hang out - 闲逛、逗留
2. Take time to - 花时间去做…
3. surely：确定地，无疑地。
4. show off：炫耀，展示。这里表示将自己的才能展示给别人看。
5. interested in：对...感兴趣
6. take time to do something：花时间做某事
= 复习第一单元
在英语中，“anyone”和“someone”都可以用在疑问句中，但它们的用法和含义略有不同。

"( )wants to join the hiking club?" 这句话中使用 "someone" 是因为它询问的*是某个不确定的人是否有兴趣加入徒步俱乐部*。

"Is there( )here who speaks Spanish fluently?" 这句话中使用 "anyone" 是因为它询问的是在场的*所有人中是否有人*能说流利的西班牙语。

- "Someone" 用于期望得到肯定回答的情况，或者当说话者认为很可能有人符合条件时。
  - "Is there someone who can help me with this?"
  - "Someone must have left the door open."
- "Anyone" 用于询问开放性的问题，说话者不知道是否有人符合条件。
  - "Is there anyone here who has a smartphone?"
  - "Does anyone know the way to the train station?"


=
