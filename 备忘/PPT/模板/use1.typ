// 基本模板
#import "@preview/rubber-article:0.5.0": *
// #show: article.with()

// For math
#import "@preview/mitex:0.2.5": * // latex 兼容包
#import "@preview/pavemat:0.2.0":* // show matrix beautifully
#import "@preview/physica:0.9.5":* // 数学公式简写
#import "@preview/i-figured:0.2.4"
#show math.equation: i-figured.show-equation.with(only-labeled: false) // 只有引用的公式才会显示编号
#show figure: i-figured.show-figure // 图1.x
#import "@preview/mannot:0.3.0": * // 公式突出
#set math.mat(delim: "[")
#import "@preview/equate:0.3.2" // <breakable>  <dot-product>
// For Code
#import "@preview/lovelace:0.3.0": * // 伪代码算法
                                     // 
// For paper
#import "@preview/showybox:2.0.3": showybox // 彩色盒子
// #set text(font:("Times New Roman","Source Han Serif SC"), size: 12pt) // 设置中英语文字体 小四宋体 英语新罗马 
#import "@preview/tablex:0.0.9": * // 表格
                                   // 
                                   // 
// Tools
#import "@preview/dashy-todo:0.1.1": todo
#import "@preview/cetz:0.4.2" // 绘图

#set page(columns: 1)

// = 目录
// #outline(title: none)
// -----------------------------
#set page(columns: 1)
#show: article

#maketitle(
  title: "A Brief Review of Vision-Language-Action Models",
  authors: ("Aoxiang Gu",),
  date: "September 2025",
)
#set text(font:("New Computer Modern","Source Han Serif SC"), size: 10pt) // 设置中英语文字体 小四宋体 英语新罗马 
#let 行间距转换(正文字体,行间距) = ((行间距)/(正文字体)-0.75)*1em
#set par(leading: 行间距转换(12,20),justify: true,first-line-indent: 2em)
#import "@preview/indenta:0.0.3": fix-indent
#show: fix-indent() // 修复第一段的问题
#show heading: it =>  {it;par()[#let level=(-0.3em,0.2em,0.2em);#for i in (1, 2, 3) {if it.level==i{v(level.at(int(i)-1))}};#text()[#h(0.0em)];#v(-1em);]} // 修复标题下首行 以及微调标题间距

= Introduction
In recent years, Artificial Intelligence has made remarkable progress in various fields. For instance, large language models (LLMs), 
such as GPT-4 and Grok-4, have demonstrated impressive capabilities in natural language understanding and generation. In parallel, Vision Foundation Models (VFMs)#footnote[Models that are pre-trained on large-scale image datasets and can be directly generalized to various downstream tasks.] like CLIP and DINO excel at learning general visual features and supporting diverse downstream applications.
Build upon these, Vision-Language-Models（VLMs）, such as GPT-4o and Qwen2.5-VL, put vision and language together, which can understand and generate multimodal content. 

// There is also some special generated VFMs,such as Stable Diffusion and Sora, which can generate high-quality real images and videos, it seems that they really understand the physial world.
In addition, generative VFMs such as Stable Diffusion and Sora are capable of producing high-quality photorealistic images and videos, showcasing strong world modeling and physical plausibility.很自然地，我们就想知道这种能力能不能被用于Robotics里面地一些问题，比如Manipulation and navigation。

== definition of VLA
这里定义的目的只是为了帮助我们更好理解和分类现有的工作，以及帮助理解它为什么要这么做，所以稍微有些不严谨的地方。

We define Vision-Language-Action Models (VLAs) as systems that incorporate at least one Vision-Language Model (VLM), take multimodal inputs such as raw observations and task descriptions,etc, and use VLA modules—including perception encoders, reasoning components, action experts, etc.—to generate intermediate representations that are transformed into executable robot actions.

1. *[Input]* Input usually includes below parts:

  1. the state of the robot(joint position, velocity, 6D pose of the robotic arm's end-effector etc.)  
  2. the observation of the environment (image from external camera, head-mounted camera, or wrist-mounted camera, point cloud,etc.)
  3. the task description (language instruction,etc.)
#h(2em) And differnt works may use different input combinations, and do different types of preprocessing on the input to achieve some specific effects. 

2. *[VLA model]* Encoder and Action expert

  1. Encoder: 
    To deal with the raw input to get information that can be used by the action expert. 
  Typically VLMs,VFMs (e.g., CLIP, DINO) or a point-cloud encoder (e.g., PointNet++); in some cases, even simple MLPs are used for environment encoding;or language encoders (e.g., BERT, T5) are used for task encoding.
  2. Action expert: include basic motion planners, 或者一些不可微分的算法单元。For example, Diffusion policy, flow matching, LLM, motion planner(e.g. moveit), etc.
3. Action representation
4. 

== 动作表征
我们先从动作表征@zhongSurveyVisionLanguageActionModels2025 的角度来对现有VLA工作进行分类和综述，因为这是最直观的，能讲清楚现有的所有的VLA模型的发展，然后再从一种整体的角度去从其他方面进行分类和综述。

每种类型的动作标记都以独特的方式编码任务相关指导，具体来说有以下几种：
/ code: 通过LLM输出代码或伪代码，通过预先定义的原子操作来实现任务
/ language instruction: 一般来说是一个模型分解子任务，一个模型作为动作专家执行子任务。
/ Affordance:
/ Trajectory:
/ Raw action:

=== Code
Code 相关的工作应该是最直观的，它对于long-horizon task 有天然的优势，因为它clear logical structures and can leverage rich third-party libraries，弥合自然语言理解、视觉感知与机器人实际操作之间的鸿沟。这种方法利用了代码的结构化、可解释性和组合性，使得VLA能够执行更复杂、更抽象的任务。

将动作的生成看作程序生成任务，利用模型的代码生成能力以生成动作。

我们将这种工作定义为： 至少使用一个VLM模块来处理原始输入，并使用LLM生成代码或伪代码作为中间表示，然后通过一个解释器或执行器将其转换为可执行的机器人动作。这类工作还有一个特点是基本都使用了云端的LLM接口，那这样的话就会价格昂贵。
#figure(
  image("./image/1.png",width:110%),
  // caption: [
  // ]
)

比如Code as policies (Jacky Liang ,2023@liangCodePoliciesLanguage2023)，它使用了recently developed open-vocabulary object detection models like ViLD and MDETR off-the-shelf to obtain object positions and bounding boxes，调用了GPT的codex作为代码生成模型。

同时在上述工作中，只有RobocodeX使用了自己训练的代码生成模型，并且它使用了统一的截断符号距离场 (TSDF)#footnote([关于不同3D信息的表示方式我们将在下一部分给出]) 来表示环境。 它主要的工作也是使用了Agent的思想，比如可以使用AnyGrasp生成抓取姿态，使用PointtNet++ 来分割点云，等等。

=== Affordance
中文翻译叫做可供性，
==  Input 
=== 不同的3D信息的表示方法
/ Point cloud:
   基本我们在VLA中使用的是经过后处理的稀疏点云（下采样之后的点云），常用的下采样方法比如最远点采样（FPS），体素化（Voxelization）等。其对应的常用VLA模块为PointNet@charlesPointNetDeepLearning2017/PointNet++ @NIPS2017_d8bf84be，甚至是几层MLP（used by DP3@ze3DDiffusionPolicy2024）。

/ Depth map:
    直接使用深度图

/ TSDF: 首先将某一3D区域划分为 $L times W times H$ 个体素，我们要计算的SDF值其实就是每个体素到最近的物体表面的距离，每次我们可以计算得到一个这个体素沿相机光心方向到物体的距离，然后就可以去更新它。优点是可以多帧融合补全物体的TSDF地图，增量式的更新。也可以去看TSDF++ 、DeepSDF(用神经网络学习连续的有向距离函数来表示3D形状，通过引入形状编码向量，一个网络就能表示整类物体，实现高质量的形状重建、补全和插值),但是还是TSDF比较成熟和快速。
/ NeRF:

/ 3DGS:

/ Mesh:
   由网格，点和面组成

/ DMTet:

/ Tri-plane:
// 不同的工作使用不同的输入组合，并且对输入做不同类型的预处理以实现某些特定的效果。下面我们从输入组合以及预处理的角度来简单分类和介绍现有的工作。

=== 触觉信息的加入


3. VLA Model
This part show how we take VL to Action.

VLA-Adapter

= 热门方向
== RL +VLA
== Data generalization
== 压缩
== 数据处理/清洗
本来VLA数据就少，更对数据的质量要求更高。
== 从生成的未来帧生成动作
= 我的观点
== 验证任务简单

== 数据稀缺
和数据
== 物体泛化、空间泛化而非任务泛化
== VLA的不合理
试想，人在执行一个任务的时候，会首先思考再去执行，在执行的时候速度很快，而现在的VLA模型每次推理的输入往往只是基于单帧图像或者少量的历史帧，缺乏对任务的整体理解和规划能力，缺乏对场景的观测和记忆能力。

假如说一个简单的Pick-and-place任务，20s左右，30fps下大概有600帧的数据，对于人来说，观测的越久，我们对场景的估计，对位姿的预测就会越准确，动作的规划也会越合理，而现在的VLA模型往往只能看到几帧图像，甚至是单帧图像，这样就很难做到对场景的准确估计和对任务的合理规划。

== Safety
安全性

== 应用前景及市场分析
我们可以将机器人操作主要分为以下两个部分： TO B 和 TO C
TO B 主要是指工业机器人，主要应用于制造业，物流业等领域，主要的客户群体是企业用户，市场规模大，增长潜力大。


TO C 主要是指服务机器人，往往要在诸多任务中切换，需要泛化的场景极多，时序极多，并且加上价格昂贵，调试难度大，没有多少人会有需求。目前看来比较有前景的方向是服务租赁，由一家公司购买各型号诸多机器人，于客户需要的特定场景提供服务：如各种会议，宴会以及家庭任务。
#bibliography(("all.bib"), title: [
参考文献#v(1em)
],style: "nature")
 