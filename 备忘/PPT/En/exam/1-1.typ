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


// #set page(columns: 2)

#set page(columns: 2)
= PART1
#h(1em)
1. I can't find my phone #underline("         ").
  / A: anywhere
  / B: somewhere
  / C: something
  / D: everyone

2. I would like to meet #underline("         ") important in the industry.
  / A: anyone
  / B: something
  / C: somewhere
  / D: someone

3. #underline("         ") wants to join the hiking club?
  / A: Everyone
  / B: Someone
  / C: Anywhere
  / D: Anyone

4. I left my glasses #underline("         ") in the office.
  / A: somewhere
  / B: anywhere
  / C: someone
  / D: nothing

5. #underline("         ") wants to come along to the beach?
  / A: Anywhere
  / B: Everything
  / C: Someone
  / D: Everyone

6. #underline("         ") here knows how to fix the computer?
  / A: Anyone
  / B: Someone
  / C: Somewhere
  / D: Everyone

7. I'm looking for #underline("         ") to read on my vacation.
  / A: something
  / B: anywhere
  / C: someone
  / D: someplace

8. Is there #underline("         ") here who speaks Spanish fluently?
  / A: anyone
  / B: something
  / C: somewhere
  / D: someone

9. #underline("         ") is interested in joining the cooking class?
  / A: Anywhere
  / B: Everything
  / C: Someone
  / D: Anyone

10. I would like to go #underline("         ") somewhere#underline("         ") for my vacation.
  / A: warm  ;#h(0.5em) /
  / B: #h(0.5em) /;warm
// / C: someone
// / D: something

// Answers:
// 1. A: anywhere
// 2. D: someone
// 3. D: Anyone
// 4. A: somewhere
// 5. C: Someone
// 6. A: Anyone
// 7. A: something
// 8. A: anyone
// 9. C: Someone
// 10. B


#set page(columns: 2)
= PART2
1. #underline("          ") the traffic jam, we were late for the meeting.
  / A: because
  / B: because of
  / C: due to
  / D: because of the

2. #underline("          ") the weather was bad, we decided to cancel the picnic.
  / A: Because
  / B: Because of
  / C: Due to
  / D: Because of the

3. #underline("          ") she was feeling unwell, she didn't go to work.
  / A: because
  / B: because of
  / C: due to
  / D: because of the

4. #underline("          ") the rain, the sports event was postponed.
  / A: Because
  / B: Because of
  / C: Due to
  / D: Because of the

5. #underline("          ") oversleeping(睡过头) , I missed the bus.
  / A: because
  / B: because of
  / C: due to
  / D: because of the

6. #underline("          ") her hard work, she passed the exam with flying colors.
  / A: Because
  / B: Because of
  / C: Due to
  / D: Because of the

7. #underline("          ") the new mayor's policies, the city has become more prosperous.
  / A: because
  / B: because of
  / C: Due to
  / D: Because of the

8. #underline("          ") the strong wind, the tree fell down.
  / A: Because
  / B: Because of
  / C: Due to
  / D: Because of the

9. #underline("          ") the lack of evidence, the case was dismissed.
  / A: Because
  / B: Because of
  //  / C: Due to
  / D: Because of the

10. #underline("          ") his injuries, the athlete decided to retire.
  / A: Because
  / B: Because of
  / C: Due to
  / D: Because of the

// Answers:
// 1. B: because of
// 2. A: Because
// 3. A: because
// 4. B: Because of
// 5. B: because of
// 6. B: Because of
// 7. B: because of
// 8. B: Because of
// 9. C: Due to
// 10. B: Because of
//
#set page(columns: 2)
= PART3

// Apologies for the oversight. Here are the corrected questions with the proper format:

1. I have #underline("           ") friends, but I enjoy spending time with them.
  / A: little
  / B: few
  / C: a little
  / D: a few

2. She has #underline("           ") money, so she can't afford to buy a new car.
  / A: little
  / B: few
  / C: a little
  / D: a few

3. There are #underline("           ") clouds in the sky today; it might rain later.
  / A: little
  / B: few
  / C: a little
  / D: a few

4. #underline("           ") of the students in our class failed the exam.
  / A: Little
  / B: Few
  / C: a little
  / D: a few

5. I was surprised to see #underline("           ") people at the concert（音乐会）; I thought it would be more crowded(拥挤).
  / A: little
  / B: few
  / C: a little
  / D: a few

6. She spoke with #underline("           ") enthusiasm(热情) about her new job.
  / A: little
  / B: few
  / C: a little
  / D: a few

7. There is #underline("           ") sugar left in the jar; would you like some?
  / A: little
  / B: few
  / C: a little
  / D: a few

// 8. #underline("           ") of the guests at the party knew each other before they arrived.
//    / A: Little
//    / B: Few
//    / C: a little
//    / D: a few

9. He has #underline("           ") free time these days because he's working two jobs.
  / A: little
  / B: few
  / C: a little
  / D: a few

10. I only need #underline("           ") more information to finish my report.
  / A: little
  / B: few
  / C: a little
  / D: a few

// Answers:
// 1. D) a few
// 2. A) little
// 3. D) a few
// 4. B) Few
// 5. B) few
// 6. A) little
// 7. C): a little
// 8. D) A few
// 9. A) little
// 10. C): a little
