#import "./lib.typ": slides, two-col, three-col, sustech-orange
#set text(font: ("inter", "Noto Sans SC"), size: 12pt)

// ════════════════════════════════════════════════════════════
// 模板配置
// ════════════════════════════════════════════════════════════
#show: slides.with(
  title: "机器人操作模仿学习的数据合成综述",
  subtitle: "面向可变形物体泛化的数据合成方法研究",
  date: "2026 / 03 / 31",
  authors: ("文献综述报告",),

  ratio: 16 / 9,
  layout: "medium",
  toc: true,
  footer: true,
  count: "number",
  theme: "normal",
)

#include "sections/1_motivation.typ"
#include "sections/2_survey.typ"
#include "sections/3_conclusion.typ"
