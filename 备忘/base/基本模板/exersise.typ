#import "@preview/grape-suite:1.0.0": exercise
#import exercise: project, task, subtask

#show: project.with(
    title: "Lorem ipsum dolor sit",

    university: [University],
    institute: [Institute],
    seminar: [Seminar],

    abstract: lorem(100),
    show-outline: true,

    author: "John Doe",

    show-solutions: false
)
#set text(font:("Times New Roman","Source Han Serif SC"), size: 12pt) 
// #import "@preview/cuti:0.2.1": show-cn-fakebold
// #show: show-cn-fakebold
#let 行间距转换(正文字体,行间距) = ((行间距)/(正文字体)-0.75)*1em
// // #show par: set block(spacing: 行间距转换(12,20))
#set par(leading: 行间距转换(12,20),justify: true,first-line-indent: 2em)
#show heading: it =>  {
    set text(font: ("Times New Roman","Source Han Serif SC"))
    it
    par()[
      #if it.level==1{
        v(-0.3em)
      }
      #if it.level==2{
        v(0.2em)
      }
      #if it.level==3{
        v(0.2em)
      }
      #text()[#h(0.0em)]
      #v(-1em)
      ]
      }
    = 你好
    == 你好
    这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要deded迪岑的对接的金额哦i的的死哦的
    
    我是你爹。