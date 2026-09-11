#import "./lib.typ": slides, two-col, three-col, sustech-orange
#set text(font: ("inter", "Noto Sans SC"), size: 12pt)

// 导入常用包（按需使用）
// #import "@preview/cetz:0.4.2": canvas
// #import "@preview/fletcher:0.5.8" as fletcher: edge, node
// #import "@preview/frame-it:1.2.0": *

// ════════════════════════════════════════════════════════════
// 模板配置
// ════════════════════════════════════════════════════════════
#show: slides.with(
  title: "DualDeform-Gen: Real-to-Sim-to-Real Data Synthesis for Bimanual Deformable Object Manipulation",
  subtitle: "面向双臂可变形物体操作的闭环数据合成框架",
  date: "2026 / 03 / 25",
  authors: ("古翱翔",),

  ratio: 16 / 9,
  layout: "medium",
  toc: true,
  footer: false,
  count: none,
  theme: "normal",
)

#include "sections/1.typ"
#include "sections/2.typ"
#include "sections/3.typ"
#include "sections/4.typ"
#include "sections/6.typ"
