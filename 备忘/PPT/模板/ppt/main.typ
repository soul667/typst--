#import "./lib.typ" : slides
#set text(font:("New Computer Modern","Source Han Serif SC"), size: 10pt) // 设置中英语文字体 小四宋体 英语新罗马 
#let 行间距转换(正文字体,行间距) = ((行间距)/(正文字体)-0.75)*1em
#set par(leading: 行间距转换(12,20),justify: true,first-line-indent: 2em)
#import "@preview/indenta:0.0.3": fix-indent
#show: fix-indent() // 修复第一段的问题
#show heading: it =>  {it;par()[#let level=(-0.3em,0.2em,0.2em);#for i in (1, 2, 3) {if it.level==i{v(level.at(int(i)-1))}};#text()[#h(0.0em)];#v(-1em);]} // 修复标题下首行 以及微调标题间距
#import "@preview/mitex:0.2.5": * // latex 兼容包
#import "@preview/pavemat:0.2.0":* // show matrix beautifully
#import "@preview/physica:0.9.5":* // 数学公式简写
#import "@preview/i-figured:0.2.4"
#show math.equation: i-figured.show-equation.with(only-labeled: false) // 只有引用的公式才会显示编号
#show figure: i-figured.show-figure // 图1.x
#import "@preview/mannot:0.3.0": * // 公式突出
#set math.mat(delim: "[")
#show: slides.with(
title: "A Brief Survey on VLA for Manipulation",
subtitle: "based on the competition of ZhiYuan 2025",
  date: "01.07.2024",
  authors: (
    "name": "Aoxiang Gu",
    "affiliation": "2024/09/16",
    // "email": "liujk22@mails.tsinghua.edu.cn",
    // Arbitrary number of informations can be added
  ),

  // The configurations belows should not be changed
  ratio: 16/9,
  layout: "medium",
  toc: true,
)
= 毕设
= 智元比赛
= Principles
// == 引言
// #h(2em) In recent years, Artificial Intelligence has made remarkable progress in various fields. For instance, large language models (LLMs), 
// such as GPT-4 and Grok-4, have demonstrated impressive capabilities in natural language understanding and generation. In parallel, Vision Foundation Models (VFMs)#footnote[Models that are pre-trained on large-scale image datasets and can be directly generalized to various downstream tasks.] like CLIP and DINO excel at learning general visual features and supporting diverse downstream applications.
// Build upon these, Vision-Language-Models（VLMs）, such as GPT-4o and Qwen2.5-VL, put vision and language together, which can understand and generate multimodal content. 

// In addition, generative VFMs such as Stable Diffusion and Sora are capable of producing high-quality photorealistic images and videos, showcasing strong world modeling and physical plausibility.很自然地，我们就想知道这种能力能不能被用于Robotics里面地一些问题，比如Manipulation and navigation。
// 。。。
// #lorem(20)
// / *Term*: Definition  测试测试
// #lorem(20)

// == 关于VLA的定义
//   #h(2em) VLA，Vison-Language-Action Models，指的是至少包含一个Vision-Language Model (VLM)的系统，这些系统接受多模态输入（如原始观测数据和任务描述等），并利用VLA模块（包括感知编码器、推理组件、动作专家、运动规划等）生成中间表示，并最终转换为可执行的机器人动作@zhongSurveyVisionLanguageActionModels2025。

//   *输入*

//   *感知*

//   *操作*


= Challenges
== 数据 
#h(2em)这里我们就以Pi0为例，训练时候使用的数据（第$i$条轨迹中帧数为$j$）$"data"_(i,j)=[I^(i,j),S^(i,j),ell^{i,j},A^(i,j)]$，其中

① 不同视角图像观测$I^(i j)=[i^(i,j)_(1),i^(i,j)_(2),...,i^(i,j)_(n_a)]$ 

② 机器人状态观测$S^(i,j)=[s^(i,j)_(1),s^(i,j)_(2),...,s^(i,j)_(n_s)]$

③ 语言指令#mi("\ell^{i j}")

④ 动作块$A^(i,j)=[a^(i,j+1),a^(i,j+2),...,a^(i,j+n_a)]$ #footnote[$a^(i,j+1)=S^(i,j+1)-S^(i,j)$]。

最终在推理的时候我们是基于$[I^(i,j),S^(i,j),ell^(i,j)]$推理出在当前frame下的动作块$A^(i,j)$。

== memoryess and open-loop

现在的VLA缺少记忆和历史观测,每一次推理都要重新感知整个场景，无法从过去的经验中学习，但实际上对于大多数任务来说，大部分场景和背景在任务中不会发生变化。
=== 认知感知记忆库

相关工作比如理想车机的VLA做了记忆的功能，会记忆用户的偏好和习惯。
UniVLA()将过去动作纳入输入提示中,首次尝试了时间建模。然而, 它仅作为一个思维链(Chain‐of‐Thought,Wei et al., 2022)过程,未能有效利用历史信

RoboFlamingo(Li et al., 2023)将 视觉‐语言表示压缩为一个潜在标记,并通过 LSTM(Hochreiter & Schmidhuber, 1997)传播它。 潜在表示以一种相对粗糙的方式获得,且细粒度的感知历史在很大程度上被丢弃。TraceVLA( Zheng et al., 2024b)采取了不同的路径,将历史状态绘制为当前帧上的轨迹,但又丢弃了丰富的语 义细节。

比如MemoryVLA@shiMemoryVLAPerceptualCognitiveMemory2025 (Hao Shi,2025.8.26)。人类依赖工作记忆来缓冲短期表示以实现即时控制,而海 马系统则保存过去经验的详细情节和语义主旨以形成长期记忆。

这篇工作视觉编码器用的是 DINOv2 和 SigLIP 主干处理当前的 RGB 观测，


在每个时间步，当前工作记忆充当查询，通过缩放点积交叉注意力检索相关的历史信息。然后，一个复杂的记忆门融合机制自适应地将检索到的历史上下文与当前观测进行整合：

$ tilde(x )= g _(x )dot.circle  H _(x )+ \(1 - g _(x )\)dot.circle  x  $
其中 $g_x$ 是一个通过 MLP 和 sigmoid 激活计算得到的学习门控向量，它允许模型动态地平衡当前观测与历史上下文。

当记忆容量达到上限时，具有高余弦相似度的相邻条目通过平均进行合并，从而保留最显著的历史表示，同时丢弃冗余信息。


Leveraging the memory-augmented working memory {˜p, ˜c}, ... we adopt a diffusion-based Transformer (DiT) (Peebles & Xie, 2023) implemented with Denoising Diffusion Implicit Models (DDIM) (Song et al., 2020), using 10 denoising steps.

DiT 被用来去噪行动 tokens，每个去噪步骤包括 cognition-attention（注入 ˜c）和 perception-attention（注入 ˜p），然后是 FFN 来精炼表示（如论文 Fig.2 和 3.4 节所述）。所以 FFN 保留了原始 DiT 的设计，但被整合到自定义的注意力机制中，以适应机器人行动生成。
#figure(
  align(center,
  image("img1/1.png",width: 100%)
  )
  , caption: [11111]
)

=== 视频输入
还有一种工作是直接使用视频输入，以使用短的时序信息。

/ VideoMamba: 视频编码器
=== 融合
TTF-VLA@liuTTFVLATemporalToken2025 (2025,8,10) 这篇工作  对图像中的小块（patches）进行融合的。简单来说，视觉编码器会先把输入图像分成多个小的patch（比如每个patch是14×14像素），然后提取出对应的tokens。对于每个patch，框架会通过双维度检测（像素差异和注意力相关性）来决定融合策略：如果这个patch的变化不大且不关键，就复用历史帧的tokens；然后给定一个关键帧，比如20帧以后Reset.

是增强了模型对视觉噪声的鲁棒性，比如光线波动、运动模糊。选择性复用Query矩阵不但不损害性能

=== 移动物体

设想一个场景，很简单的分拣任务，流水线上快递的抓取。这种带记忆的VLA会不会能够解决这类问题，或者在视频中加入Track这类的。


== 记忆

== 其他模态
=== 触觉 

但从视觉的角度出发，有些状态看起来可能是一样的，但是实际上力不一样。比如

=== 3D信息
同时比赛中我们越发现纯使用Visoon效果并不好，物体的操作都在3D空间之内，应该使用3D信息或者特征。对3D信息的表示有不同的方法，我们下面介绍不同的方法以及他们的代表性工作：

/ 稀疏点云: 
   基本我们在VLA中使用的是经过后处理的稀疏点云（下采样之后的点云），常用的下采样方法比如最远点采样（FPS），体素化（Voxelization）等。其对应的常用VLA模块为PointNet@charlesPointNetDeepLearning2017/PointNet++ @NIPS2017_d8bf84be，甚至是几层MLP（used by DP3@ze3DDiffusionPolicy2024）。
/ TSDF:
  首先将某一3D区域划分为 $L times W times H$ 个体素，我们要计算的SDF值其实就是每个体素到最近的物体表面的距离，每次我们可以计算得到一个这个体素沿相机光心方向到物体的距离，然后就可以去更新它。优点是可以多帧融合补全物体的TSDF地图，增量式的更新。也可以去看TSDF++ 、DeepSDF(用神经网络学习连续的有向距离函数来表示3D形状，通过引入形状编码向量，一个网络就能表示整类物体，实现高质量的形状重建、补全和插值),但是还是TSDF比较成熟和快速。
/ NeRF:

/ 3DGS:


== 生成图片/视频-> 动作 （辅助监督）

#h(2em) UniPi @duLearningUniversalPolicies2023 ，RoboDreamer 等使用文字描述先生成任务视频，再用逆动力学提取动作序列驱动智能体执行，实现“先拍计划，再执行”的闭环。以及9月16号宇树的UnifoLM-WMA-0。但这种通过多步去噪过程或者世界生成模型生成显式未来帧的方法对于实时控制来说速度太慢。

Video Prediction Policy, VPP 通过在合成数据集上训练的Stable Video Diffusion只进行一次前向推理而不生成视频来生成动作，提高了控制速度。

另外一个比较有意思的是字节的GR-2，再使用VLA生成动作的基础上生成了未来帧的图像，作为一种辅助的监督信号，来提升动作生成的效果。
并且在视频-语言预训练的初始阶段，GR-2 学习理解语言指令与视频序列之间的关系。模型通过在多样化数据集上训练，根据文本描述和先前帧预测未来视频帧。这些数据集包括带有叙述的教学视频（Howto100M）、日常活动的第一人称视角（Ego4D）、基本物体交互（Something-Something V2）、厨房活动（EPIC-KITCHENS）、各种环境中的人类动作（Kinetics-700），以及机器人操作视频（RT-1、Bridge）
== 数据稀缺
解决数据稀缺的方法主要有如下几种：

- *Sim/真机 遥操*
- *从人类世界视频中学习/使用合成数据集*
- *使用世界生成模型*
- *RL*

== 训练速度优化
// Pi0-fast
- 输入的压缩
  - pi0-fast
- 数据清洗优化
== 推理
异步推理 
RTC
== 分层VLA
== 意义

这些任务现有的这些模型都完成的不够好？我们真的要追求所谓的全任务泛化吗？
大部分都是简单都是Pick and Place，真的有意义吗？ 

单任务泛化比多任务泛化更有意义，这里指的是某种特定任务下的不同环境的泛化，比如我只是对抓取这件事情做到泛化，我可以抓取任何东西。
#bibliography(("all.bib"), title: [
参考文献#v(1em)
],style: "institute-of-electrical-and-electronics-engineers",)
 