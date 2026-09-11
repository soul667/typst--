#import "./lib.typ": slides, three-col, two-col
#set text(font: ("Times New Roman", "Noto Sans SC"), size: 12pt)


// #set text(font: "Times New Roman", size: 12pt)
#import "@preview/mitex:0.2.6": *  //https://typst.app/universe/package/mitex
#import "@preview/pavemat:0.2.0": * //https://typst.app/universe/package/pavemat
#import "@preview/physica:0.9.5": *
#import "@preview/mannot:0.3.0": *
#import "@preview/cetz:0.4.2"
#set math.mat(delim: "[")
#import "@preview/frame-it:1.2.0": *
#import "@preview/fletcher:0.5.8" as fletcher: edge, node
#import "@preview/algo:0.3.5": algo, comment, d, i

#let sustech-orange = color.rgb(237, 108, 0)
#let frame-color = sustech-orange.lighten(60%)
#let (example, feature, variant, syntax) = frames(
  feature: ("Feature", frame-color),
  variant: ("Variant", frame-color),
  example: ("Example", frame-color),
  syntax: ("Syntax", frame-color),
)

#show: slides.with(
  title: "EfficientViT: Lightweight Vision Transformer with Linear Attention",
  subtitle: "Efficient Architectures for Visual Understanding",
  date: "2025/03/23",
  authors: ("Xiao Guang", "Advisor: Prof. Zhang"),

  ratio: 16 / 9,
  layout: "medium",
  toc: true,
  footer: false,
)

// frame-it 样式（必须放在 slides.with 之后）
#show: frame-style(styles.boxy)

// ════════════════════════════════════════════════════════════
// Section 1: Motivation
// ════════════════════════════════════════════════════════════
= Motivation

== Research Background

#two-col(ratio: (3fr, 2fr))[
  Vision Transformer (ViT) @dosovitskiy2021image 将 Transformer @vaswani2017attention 引入视觉领域，取得了超越 CNN 的性能。

  *核心挑战：*
  - Self-attention 的计算复杂度为 $O(n^2)$
  - 模型参数量大，难以部署到边缘设备
  - 训练需要大规模数据集#footnote[ViT 原文使用 JFT-300M 进行预训练]

  *研究目标：*
  设计一种轻量级 ViT 架构，在保持竞争力的同时将 FLOPs 降低 $5 times$ 以上。
][
  #figure(
    fletcher.diagram(
      node-stroke: 1pt,
      spacing: 2em,
      node((0, 0), [Image], shape: rect, fill: sustech-orange.lighten(85%)),
      edge((0, 0), (0, 1), "->"),
      node((0, 1), [Patch\ Embedding], shape: rect, fill: sustech-orange.lighten(85%)),
      edge((0, 1), (0, 2), "->"),
      node((0, 2), [Transformer\ Encoder], shape: rect, fill: sustech-orange.lighten(70%)),
      edge((0, 2), (0, 3), "->"),
      node((0, 3), [MLP Head], shape: rect, fill: sustech-orange.lighten(85%)),
      edge((0, 3), (0, 4), "->"),
      node((0, 4), [Class], shape: rect, fill: sustech-orange.lighten(85%)),
    ),
    caption: [ViT 架构流程],
  )
]

== Problem Formulation

标准 self-attention 的计算公式为：

$ "Attention"(Q, K, V) = "softmax"(Q K^top / sqrt(d_k)) V $

其中 $Q, K, V in bb(R)^(n times d)$，计算复杂度为 $O(n^2 d)$#footnote[$n$ 为序列长度，$d$ 为特征维度]。

#feature[Complexity Analysis][][
  对于 $224 times 224$ 的输入图像，patch size $= 16$：

  $ n = (224 / 16)^2 = 196, quad "FLOPs"_"attn" approx 2 n^2 d approx 4.7 times 10^7 $

  当分辨率增大至 $512 times 512$ 时，$n = 1024$，计算量增长 *27 倍*。
]

// ════════════════════════════════════════════════════════════
// Section 2: Related Work
// ════════════════════════════════════════════════════════════
= Related Work

== Vision Transformer Evolution

#table(
  columns: (auto, auto, auto, auto),
  align: (left, center, center, left),
  [*Method*], [*Year*], [*Top-1 Acc.*], [*Key Innovation*],
  [ResNet-152 @he2016deep], [2016], [78.3%], [Residual connections],
  [ViT-B/16 @dosovitskiy2021image], [2021], [77.9%], [Pure Transformer for vision],
  [Swin-T @liu2021swin], [2021], [81.3%], [Shifted window attention],
  [EfficientViT (ours)], [2025], [*82.1%*], [Linear attention + FFN fusion],
)

*主要改进方向：*
+ *局部注意力*：Swin Transformer @liu2021swin 使用 shifted window 机制实现线性复杂度
+ *高效注意力*：通过核化方法#footnote[将 softmax 替换为可分解的核函数] 降低计算量
+ *混合架构*：结合 CNN 的局部特征提取与 Transformer 的全局建模能力

== Attention Mechanism Comparison

#two-col[
  *Standard Attention* ($O(n^2)$)

  $ A = "softmax"(Q K^top / sqrt(d)) $
  $ "Output" = A dot V $

  缺点：
  - 需要 $n times n$ 注意力矩阵
  - 内存消耗随序列长度二次增长
][
  *Linear Attention* ($O(n)$) #text(fill: sustech-orange, weight: "bold")[(Ours)]

  $ A' = phi(Q) dot phi(K)^top $
  $ "Output" = phi(Q) (phi(K)^top V) $

  优势：
  - 利用矩阵乘法结合律
  - 先计算 $phi(K)^top V in bb(R)^(d times d)$
  - 复杂度降至 $O(n d^2)$
]

// ════════════════════════════════════════════════════════════
// Section 3: Method
// ════════════════════════════════════════════════════════════
= Method

== Architecture Overview

#align(center)[
  #figure(
    fletcher.diagram(
      node-stroke: 1pt,
      spacing: (2.5em, 1.5em),
      // Stage 1
      node((0, 0), [Patch Embed\ $H\/4 times W\/4$], shape: rect, fill: sustech-orange.lighten(85%)),
      edge((0, 0), (0, 1), "->"),
      node((0, 1), [Stage 1\ Conv Block $times 2$], shape: rect, fill: sustech-orange.lighten(75%)),
      edge((0, 1), (0, 2), "->"),
      // Stage 2
      node((0, 2), [Stage 2\ Linear Attn $times 3$], shape: rect, fill: sustech-orange.lighten(60%)),
      edge((0, 2), (0, 3), "->"),
      // Stage 3
      node((0, 3), [Stage 3\ Linear Attn $times 6$], shape: rect, fill: sustech-orange.lighten(45%)),
      edge((0, 3), (0, 4), "->"),
      // Head
      node((0, 4), [Classification Head], shape: rect, fill: sustech-orange.lighten(85%)),
    ),
    caption: [EfficientViT 整体架构（hybrid design）],
  ) <fig:arch>
]

== Linear Attention Module

#two-col(ratio: (3fr, 2fr))[
  核心改进：用 ReLU 核函数替代 softmax：

  $ phi(x) = "ELU"(x) + 1 = cases(x + 1 &"if" x >= 0, e^x &"if" x < 0) $

  计算流程：
  + 计算 $phi(Q)$ 和 $phi(K)$
  + 先算 $S = phi(K)^top V in bb(R)^(d times d)$
  + 再算 $"Output" = phi(Q) dot S$

  复杂度从 $O(n^2 d)$ 降至 $O(n d^2)$，当 $d << n$ 时显著节省。
][
  #figure(
    fletcher.diagram(
      node-stroke: 1pt,
      spacing: 2em,
      node((0, 0), $Q$, shape: rect, width: 2.5em),
      node((1, 0), $K$, shape: rect, width: 2.5em),
      node((2, 0), $V$, shape: rect, width: 2.5em),
      edge((0, 0), (0, 1), "->", label: $phi$),
      edge((1, 0), (1, 1), "->", label: $phi$),
      node((0, 1), $phi(Q)$, shape: rect, width: 3em),
      node((1, 1), $phi(K)$, shape: rect, width: 3em),
      edge((1, 1), (1.5, 2), "->"),
      edge((2, 0), (1.5, 2), "->"),
      node((1.5, 2), $phi(K)^top V$, shape: rect),
      edge((0, 1), (0.75, 3), "->"),
      edge((1.5, 2), (0.75, 3), "->"),
      node((0.75, 3), [Output], shape: rect, fill: sustech-orange.lighten(80%)),
    ),
    caption: [Linear Attention 计算图],
  )
]

== Training Strategy

使用 AdamW @loshchilov2019decoupled 优化器配合 cosine learning rate schedule，训练在 ImageNet-1K @deng2009imagenet 上进行。

#two-col[
  *训练超参数*

  #table(
    columns: (1fr, 1fr),
    [参数], [值],
    [Optimizer], [AdamW],
    [Base LR], [$1 times 10^(-3)$],
    [Weight Decay], [$0.05$],
    [Batch Size], [$1024$],
    [Epochs], [$300$],
    [Warmup Epochs], [$20$],
  )
][
  *数据增强策略*

  - RandAugment ($N = 2$, $M = 9$)
  - Mixup ($alpha = 0.8$)
  - CutMix ($alpha = 1.0$)
  - Random Erasing ($p = 0.25$)
  - Label Smoothing ($epsilon = 0.1$)

  归一化：Layer Normalization @ba2016layer
]

== Algorithm: EfficientViT Forward Pass

#{
  let orange = color.rgb(237, 108, 0)
  algo(
    title: [
      #set text(fill: orange, weight: "bold")
      Algorithm 1: EfficientViT Forward
    ],
    parameters: ($x in bb(R)^(B times C times H times W)$,),
    fill: orange.lighten(95%),
    stroke: 1.2pt + orange.lighten(50%),
    radius: 5pt,
    indent-guides: 1pt + orange.lighten(70%),
    indent-size: 18pt,
    row-gutter: 8pt,
    column-gutter: 8pt,
    inset: 12pt,
    comment-styles: (fill: luma(120)),
    line-number-styles: (fill: orange.lighten(30%)),
    main-text-styles: (size: 0.85em),
  )[
    $z_0 <- "PatchEmbed"(x)$ #comment[Patch embedding]\
    for $ell <- 1$ to $L$ do:#i\
    if $ell <= 2$:#i\
    $z_ell <- "ConvBlock"(z_(ell-1))$ #comment[Local features]#d\
    else:#i\
    $Q, K, V <- W_Q z_(ell-1), W_K z_(ell-1), W_V z_(ell-1)$\
    $S <- phi(K)^top V$ #comment[$O(d^2)$ computation]\
    $"Attn" <- phi(Q) dot S$ #comment[Linear attention]\
    $z_ell <- "LN"("Attn" + z_(ell-1))$ #comment[Residual + LayerNorm]#d#d\
    $hat(y) <- "MLP"("GAP"(z_L))$ #comment[Classification]\
    return $hat(y)$
  ]
}

// ════════════════════════════════════════════════════════════
// Section 4: Experiments
// ════════════════════════════════════════════════════════════
= Experiments

== ImageNet-1K Results

在 ImageNet-1K @deng2009imagenet 验证集上的分类结果#footnote[所有模型均在 ImageNet-1K 上从头训练 300 epochs，不使用额外数据]：

#table(
  columns: (auto, auto, auto, auto, auto),
  align: (left, center, center, center, center),
  [*Model*], [*Params (M)*], [*FLOPs (G)*], [*Top-1 (%)*], [*Throughput*],
  [ResNet-50 @he2016deep], [25.6], [4.1], [78.5], [1,226],
  [ViT-S/16 @dosovitskiy2021image], [22.1], [4.6], [79.8], [932],
  [Swin-T @liu2021swin], [28.3], [4.5], [81.3], [755],
  [*EfficientViT-S (ours)*], [*15.2*], [*0.9*], [*80.4*], [*3,421*],
  [*EfficientViT-M (ours)*], [*23.8*], [*1.8*], [*82.1*], [*2,106*],
)

*Key Findings:*
- EfficientViT-M 以 *1.8G FLOPs* 达到 *82.1%* Top-1 精度
- 吞吐量是 Swin-T 的 *2.8×*，参数量减少 *16%*

== Ablation Study

#two-col[
  *注意力机制对比*

  #table(
    columns: (auto, auto, auto),
    [Attention Type], [FLOPs], [Top-1],
    [Softmax (standard)], [4.5G], [81.3%],
    [Linear (ReLU)], [0.9G], [79.1%],
    [Linear (ELU+1)], [0.9G], [*80.4%*],
    [Linear + Conv FFN], [1.2G], [*81.6%*],
  )
][
  *关键发现*

  + ELU+1 核函数比 ReLU 好 *1.3%*
  + 加入 Depthwise Conv FFN 进一步提升 *1.2%*
  + 混合架构（前 2 层用 Conv）比纯 Transformer 好 *0.8%*

  #variant[Takeaway][重要][
    Linear attention + Conv FFN 的组合是精度与效率的最佳平衡点。
  ]
]

== Latency Analysis

#two-col[
  *不同硬件上的延迟对比*（ms/image）

  #table(
    columns: (auto, auto, auto, auto),
    [Model], [GPU], [CPU], [Mobile],
    [Swin-T], [6.8], [342], [N/A],
    [EfficientViT-S], [*1.9*], [*89*], [*28*],
    [EfficientViT-M], [3.2], [156], [52],
  )

  EfficientViT 在移动端实现了 *实时推理*#footnote[测试设备：NVIDIA RTX 3090 (GPU), Intel i9-12900K (CPU), Snapdragon 8 Gen 2 (Mobile)]。
][
  *FLOPs vs Accuracy*

  #align(center)[
    #cetz.canvas(length: 1cm, {
      import cetz.draw: *
      // Axes
      set-style(stroke: 0.8pt)
      line((0, 0), (5, 0), mark: (end: ">"))
      line((0, 0), (0, 4), mark: (end: ">"))
      content((5.3, 0), text(size: 0.7em)[FLOPs])
      content((-0.2, 4.3), text(size: 0.7em)[Acc])
      // Points
      circle((1.0, 2.0), radius: 0.12, fill: gray, name: "resnet")
      content((1.0, 1.5), text(size: 0.55em)[ResNet])
      circle((4.0, 2.8), radius: 0.12, fill: gray, name: "swin")
      content((4.0, 2.3), text(size: 0.55em)[Swin-T])
      circle((0.8, 2.5), radius: 0.15, fill: sustech-orange, name: "ours-s")
      content((0.8, 3.0), text(size: 0.55em, fill: sustech-orange)[*Ours-S*])
      circle((1.6, 3.2), radius: 0.15, fill: sustech-orange, name: "ours-m")
      content((1.6, 3.7), text(size: 0.55em, fill: sustech-orange)[*Ours-M*])
    })
  ]
]

// ════════════════════════════════════════════════════════════
// Section 5: Conclusion
// ════════════════════════════════════════════════════════════
= Conclusion

== Summary & Future Work

#two-col[
  *主要贡献*

  + 提出 *EfficientViT* 架构，首次实现 sub-1G FLOPs 的高性能 ViT
  + 设计 *ELU+1 线性注意力*，在精度和效率间取得最佳平衡
  + 在 ImageNet-1K 上以 *1.8G FLOPs* 达到 *82.1% Top-1* 精度
  + 在移动端实现 *实时推理*（28ms/image）
][
  *未来工作*

  - 扩展到目标检测和语义分割任务
  - 探索知识蒸馏进一步压缩模型
  - 研究动态 token 剪枝机制
  - 适配更多边缘部署场景（FPGA, NPU）

  #feature[Open Source][][
    Code: `github.com/efficientvit`\
    Models: HuggingFace Hub
  ]
]

= References
== Bibliography
#bibliography("refs.bib")
