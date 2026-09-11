# SUSTech Typst 幻灯片模板

南方科技大学风格的 Typst 幻灯片模板。

## 文件结构

```
sustech_ppt_slide1/
├── lib.typ              # 模板核心文件
├── main.typ             # 示例演示文稿
├── video_probe.wasm     # 视频尺寸探测插件（用于支持视频嵌入）
├── img/                 # 图片资源
│   ├── SUSTech LOGO CN.svg
│   └── 页面 1.png
└── refs.bib             # 参考文献（可选）
```

## 快速开始

1. 复制整个 `sustech_ppt_slide1` 文件夹到新项目
2. 编辑 `main.typ` 修改内容
3. 使用 Typst 编译：`typst compile main.typ`

## 模板配置

```typst
#show: slides.with(
  title: "演示标题",
  subtitle: "副标题",
  date: "2025年",
  authors: ("作者",),

  // 页面设置
  ratio: 16 / 9,        // 页面比例: 16/9 或 4/3
  layout: "medium",     // 内容区域大小: "small"/"medium"/"large"

  // 功能开关
  toc: true,            // 是否显示目录
  footer: true,         // 是否显示页脚
  count: "dot",         // 页面指示: "dot"/"number"/"dot-section"/none
  theme: "normal",      // 主题风格: "normal"/"full"

  // 可选：自定义颜色（默认南科大橙色）
  // title-color: color.rgb(237, 108, 0),

  // 可选：自定义Logo和章节图片路径
  // logo: "img/logo.svg",
  // section-image: "img/section.png",
)
```

## 布局函数

### 双栏布局
```typst
#two-col[
  左侧内容
][
  右侧内容
]

// 自定义比例
#two-col(ratio: (3fr, 2fr))[
  较宽的左侧
][
  较窄的右侧
]
```

### 三栏布局
```typst
#three-col[
  第一栏
][
  第二栏
][
  第三栏
]
```

## 章节结构

```typst
// 一级标题 = 新章节（自动生成章节页）
= 章节标题

// 二级标题 = 新幻灯片
== 幻灯片标题

幻灯片内容...
```

## 视频嵌入（可选）

模板支持视频嵌入功能（需要 `video_probe.wasm`）：

```typst
#video("video.mp4", width: 80%, poster: "poster.png")
```

## 自定义主题色

```typst
// 定义自定义颜色
#let my-color = color.rgb(100, 150, 200)

// 在内容中使用
#block(fill: my-color.lighten(90%), ...)
```

## 注意事项

- 模板使用南科大橙色作为默认主题色（RGB: 237, 108, 0）
- 如需替换 Logo，修改 `img/` 目录下的 SVG 文件
- 如需自定义章节页背景图，替换 `img/页面 1.png`
- `video_probe.wasm` 是视频尺寸探测插件，如需视频嵌入功能请勿删除
sustech_ppt_slide1/
├── lib.typ              # 模板核心文件
├── main.typ             # 示例演示文稿
├── img/                 # 图片资源
│   ├── SUSTech LOGO CN.svg
│   └── 页面 1.png
└── refs.bib             # 参考文献（可选）
```

## 快速开始

1. 复制整个 `sustech_ppt_slide1` 文件夹到新项目
2. 编辑 `main.typ` 修改内容
3. 使用 Typst 编译：`typst compile main.typ`

## 模板配置

```typst
#show: slides.with(
  title: "演示标题",
  subtitle: "副标题",
  date: "2025年",
  authors: ("作者",),

  // 页面设置
  ratio: 16 / 9,        // 页面比例: 16/9 或 4/3
  layout: "medium",     // 内容区域大小: "small"/"medium"/"large"

  // 功能开关
  toc: true,            // 是否显示目录
  footer: true,         // 是否显示页脚
  count: "dot",         // 页面指示: "dot"/"number"/"dot-section"/none
  theme: "normal",      // 主题风格: "normal"/"full"

  // 可选：自定义颜色（默认南科大橙色）
  // title-color: color.rgb(237, 108, 0),

  // 可选：自定义Logo和章节图片路径
  // logo: "img/logo.svg",
  // section-image: "img/section.png",
)
```

## 布局函数

### 双栏布局
```typst
#two-col[
  左侧内容
][
  右侧内容
]

// 自定义比例
#two-col(ratio: (3fr, 2fr))[
  较宽的左侧
][
  较窄的右侧
]
```

### 三栏布局
```typst
#three-col[
  第一栏
][
  第二栏
][
  第三栏
]
```

## 章节结构

```typst
// 一级标题 = 新章节（自动生成章节页）
= 章节标题

// 二级标题 = 新幻灯片
== 幻灯片标题

幻灯片内容...
```

## 自定义主题色

```typst
// 定义自定义颜色
#let my-color = color.rgb(100, 150, 200)

// 在内容中使用
#block(fill: my-color.lighten(90%), ...)
```

## 注意事项

- 模板使用南科大橙色作为默认主题色（RGB: 237, 108, 0）
- 如需替换 Logo，修改 `img/` 目录下的 SVG 文件
- 如需自定义章节页背景图，替换 `img/页面 1.png`
