// #import "@preview/diatypst:0.2.0": *
// #show: slides.with(
//   title: "基于大语言模型的机械臂系统", // Required
//   subtitle: "",
//   date: "01.07.2024",
//   authors: (""),
// )

// = 研究背景

// == 背景介绍
// 近年来，以ChatGPT、Claude等为代表的大模型技术在自然语言和多模态领域取得了巨大成功。

// 这些系统在*大规模且多样化的网络图像和文本语料库*上进行预训练,然后使用数据集进行微调(“对齐”),以引导出期望的行为和响应模式。
// 尽管他们已经被证明具有广泛的指令执行和问题解决能力，但他们并不像人类那样真正生活在物理世界当中。


// == 研究现状

#import "@preview/polylux:0.4.0": *

#import themes.simple: *
#set text(font: ("Times New Roman", "Source Han Serif SC"), size: 12pt)
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
#show: simple-theme.with(
  footer: [基于大语言模型的机械臂系统],
)

#title-slide[
  #text(size: 1.5em)[*基于大语言模型的机械臂系统*]
  #v(0em)

  #text(size: 1em)[2021251124 #h(1em) 古翱翔]
  #v(2em)

  // #text(size:0.8em)[2024/12/3]

]
#centered-slide[
  = 背景
]
#slide[
  == 背景介绍
  #set text(font: ("Times New Roman", "Source Han Serif SC"), size: 18pt)

  // LLM的最近流行及其影响
  // 近年来，大语言模型（Large Language Models, LLLMs）在自然语言处理（NLP）领域取得了显著进展，这主要得益于其强大的语言理解和生成能力。这些模型通过在大规模文本数据上进行预训练，能够捕捉复杂的语言模式和语义关系。特别是像GPT-3、BERT和PaLM这样的模型，展示了在各种任务中的卓越性能，包括文本生成、对话系统、代码编写等[1]。

  // 随着这些模型的不断进步，研究人员开始探索将大语言模型应用于其他领域，尤其是机器人学。特别是在机械臂系统中，大语言模型的潜力逐渐被发掘出来。机械臂是自动化和工业应用中的关键组件，能够在多种环境中执行复杂的操作任务。传统的机械臂控制系统通常依赖于预先编程的规则或基于视觉的识别技术，但在处理复杂指令和动态环境时存在局限性[2]。
  #v(-1.8em)
  近年来,以ChatGPT#footnote(numbering: "①")[*GPT:*Generative Pre-trained Transformer]为代表的*大语言模型(LLMs)*#footnote(numbering: "①")[*大模型:*指拥有巨大参数量的机器学习模型]在自然语言处理领域取得了飞速进展,在各类语言任务中表现卓越 @vempralaChatGPTRoboticsDesign2023 @achiam2023gpt 。同时随着*多模态模型*(如CLIP、DALL-E、SORA等)的兴起,研究人员开始探索将视觉等不同模态信息相结合,以更好地理解和解释复杂的真实世界。这也为将LLMs应用于机器人领域奠定了基础@liMMRoAreMultimodal2024 @firooziFoundationModelsRobotics2023。

  传统的机械臂控制系统普遍依赖预编程规则或视觉识别技术,在处理复杂指令和动态环境时存在明显局限@liMMRoAreMultimodal2024。而集成LLMs有望赋予机械臂*诸多增强能力*,如:


  / *1)自然语言理解*: 机械臂能够解析复杂语言指令,通过简单语言控制实现复杂任务@liMMRoAreMultimodal2024。

  / *2)任务规划*: 对高级任务进行分解规划,提高机械臂在多步骤任务中的灵活性和效率@liMMRoAreMultimodal2024。

  / *3)多模态感知与推理*: 结合视觉、语言等信息,机械臂对环境的理解和推理能力将大幅提升,适应性和鲁棒性也随之增强

  / *4)人机交互*: 自然语言界面和对话系统将极大改善人机交互体验,实现高效协作和沟通@lykovLLMBRAInAIdrivenFast2023。

  // 目前,多个团队已开展相关研究,取得了初步进展。
  将这一领域又被称作 *具身智能*@embodied_intelligence_2024，是人工智能下一个风口。

]
#slide[
  == 研究现状
  #v(-2em)
  #set text(font: ("Times New Roman", "Source Han Serif SC"), size: 18pt)

  目前,多个团队已开展相关研究,取得了初步进展。主要来自各大高校和研究机构，包括清华大学、北京大学、麻省理工学院（MIT）、斯坦福、谷歌、字节跳动等。我们根据使用方法的不同，可以分为以下几类
  === LLM+CODE
  使用LLM来完成复杂任务的分解和规划，调用封装好的机器人函数来完成分解后的动作。这部分工作主要有 *Code as Policies* (谷歌，2023) @liangCodePoliciesLanguage2023 ，*SayPlan*(2023，使用3D 场景图)@ranaSayPlanGroundingLarge
  、*ReKep*（2024，斯坦福李飞飞组，关系关键点约束）  @huangReKepSpatioTemporalReasoning2024、*ManipVQA*(2024，北京大学黄思源组，模型微调)@huangManipVQAInjectingRobotic2024 等
  、*Instruct2Act*(2023，北京大学黄思源组，SAM+CLP) @huangInstruct2ActMappingMultimodality2023 , *VoxPoser*(斯坦福李飞飞组，2023) @huangVoxPoserComposable3D2023

  #grid(
    columns: (50%, auto),
    [
      #figure(
        image("./video/1.png", width: 54%),
        caption: [
          Code as Policies example
        ],
        kind: "video",
        supplement: [视频],
        numbering: "a",
      )
    ],
    [
      #figure(
        image("./img/1.png", width: 94%),
        caption: [
          ManipVQA模型统一的 VQA 格式生成预测
        ],
        kind: "image",
        supplement: [图],
        numbering: "a",
      )
    ],
  )
  === 端到端
  端到端最早的代表工作有 ACT(2023，斯坦福大学 Mobile Aloha) @fuMobileALOHALearning2024 @zhaoLearningFineGrainedBimanual2023 和 Diffusion#footnote()[Diffusion是一种生成方法，如今图像生成领域的成就基本都是基于Diffusion方法，比如Stable Diffusion和Midjourney] Policy (2023,MIT,哥伦比亚大学 ) @chiDiffusionPolicyVisuomotor2024。这部分工作没有做过多假设，理论上什么都可以做，但是由于它模型比较小，训练数据少，所以实际上只能用于几个特定的任务，泛化性差。

  一种可能的解决的方案是使用模仿学习/强化学习，将模型训练的大一些，这部分工作主要有

  / Transformer+MSE 直接回归: GR-1(2023,字节跳动)@wuUnleashingLargeScaleVideo2023,GR-2(2024,字节跳动)@cheangGR2GenerativeVideoLanguageAction2024
  / Transformer+Diffusion Head: Octo(2023,伯克利、斯坦福) @teamOctoOpenSourceGeneralist2024  HPT(2024,MIT何恺明组) @wangScalingProprioceptiveVisualLearning2024
  / Transformer+Discretized Token: RT-1,2(2022-2023,谷歌)@liangCodePoliciesLanguage2023  @brohanRT2VisionLanguageActionModels2023 ,OpenVLA(2024,斯坦福、伯克利) @kimOpenVLAOpenSourceVisionLanguageAction2024
  / ELSE: RDT(2024 10.10，清华)@liuRDT1BDiffusionFoundation2024 ，$pi_0$ (2024 10.24 Physical Intelligence($pi$)) @blackP0VisionLanguageActionFlow
  // https://diffusion-policy.cs.columbia.edu/
  #grid(
    columns: (50%, 50%),
    [
      #figure(
        image("./video/1.png", width: 57%),
        caption: [
          $pi_0$ example
        ],
        kind: "video",
        supplement: [视频],
        numbering: "a",
      )
    ],
    [          #figure(
        image("./video/1.png", width: 57%),
        caption: [
          RDT example
        ],
        kind: "video",
        supplement: [视频],
        numbering: "a",
      )
    ],
  )
]
#set text(font: ("Times New Roman", "Source Han Serif SC"), size: 18pt)

#grid(
  columns: (50%, 50%),
  [
    #figure(
      image("./video/1.png", width: 90%),
      caption: [
        Diffusion Policy 将积木推到T型框内
      ],
      kind: "video",
      supplement: [视频],
      numbering: "a",
    )
  ],
  [          #figure(
      image("./video/1.png", width: 90%),
      caption: [
        Diffusion Policy 涂抹酱
      ],
      kind: "video",
      supplement: [视频],
      numbering: "a",
    )
  ],
)

#centered-slide[
  = 方案拟定
]

#slide[
  == 系统框架
  #set text(font: ("Times New Roman", "Source Han Serif SC"), size: 18pt)
  #v(-1em)
  我们将调研、综述并分析相关技术发展，最终开发一个基于大语言模型的仿真系统，使机械臂能够在语音指令的控制下自主移动，完成各种指令。

  本课题应完成的工作主要包括*仿真、软件和交互*三大模块的开发。其中
  1. 仿真模块搭建一个支持机械臂的仿真平台。
  2. 软件模块利用大语言模型和视觉模型处理自然语言指令和RGBD图像，生成合理的操作步骤。
  3. 交互模块开发语音指令解析与反馈系统，实时检测和解析用户语音，将其转化为自然语言指令并反馈或进一步询问细节。
]

#slide[
  == 交互模块
  #v(-1.5em)
  #set text(font: ("Times New Roman", "Source Han Serif SC"), size: 18pt)
  交互模块的核心功能包括自动语音识别（ASR）、大语言模型（LLM）和文本转语音（TTS） @cuiRecentAdvancesSpeech2024。
  这部分我们也将综述现有的技术，着重关注于其实时性和准确性。

  / ASR: Whisper（OpenAI）@radfordRobustSpeechRecognition2022、DeepSpeech@hannunDeepSpeechScaling2014 等。
  / TTS: ChatTTS等。


  #grid(
    columns: (50%, auto),
    [
      #figure(
        [#v(6em)],
        caption: [
          使用Chattts生成的语音
        ],
        kind: "audio",
        supplement: [音频],
        numbering: "a",
      )
    ],
    [
      #figure(
        image("./img/3.png", width: 85%),
        caption: [
          生成语音代码示例
        ],
      )
    ],
  )
]

#slide[
  == 仿真模块
  #v(-1.5em)
  #set text(font: ("Times New Roman", "Source Han Serif SC"), size: 18pt)
  #grid(
    columns: (auto, auto),
    [#h(2em)而Sim-to-Real的研究更是方兴未艾。我们计划初步使用Webots与ROS搭建仿真环境，以UR5机械臂及其夹爪为主体，构建用于模拟机械臂运动与操作的仿真平台。

      与此同时，我们希望收集并整理Sim-to-Real领域的高质量综述文章，深入了解其最新进展与挑战。同时，将尝试文中提到的开源仿真环境和方法，为后续工作提供实践支持与改进方向。],
    [
      #align(center, [
        #figure(
          image("./img/2.png", width: 90%),
          caption: [
            Webots UR5机械臂仿真环境测试
          ],
        )
      ])

    ],
  )
]
#slide[
  == 软件模块
  #v(-1.5em)
  #set text(font: ("Times New Roman", "Source Han Serif SC"), size: 18pt)

  在本部分工作中，我们计划对一些端到端的大模型（如RDT、GT-2、Octo等）进行微调，并将其部署在仿真环境中进行效果测试。

  同时，我们将复现基于LLM与API的相关代码，例如Code as Policies和Instruct2Act等，进一步探索这些方法在我们的场景中的应用。最终，我们将基于这些实验结果，确定软件部分的系统框架，并进行优化。

  // 现在只

]
// Whisper是一个基于Transformer的语音转文字模型，由OpenAI开源。

#centered-slide[
  = 进度安排
]


// #centered-slide[
//   = 展望
// ]
#import "@preview/tablex:0.0.9": * // 表格
#slide[
  == 进度安排
  #v(-1em)
  #set text(font: ("Times New Roman", "Source Han Serif SC"), size: 18pt)
  #align(center, [
    #tablex(
      columns: 3,
      align: left + horizon,
      auto-vlines: false,
      repeat-header: false,

      /* --- header --- */
      // [*时间*],
      // [*内容安排1*],  [*内容安排2*],[第1-2周],[查阅文献并综述，确定研究中使用的具体方案(包含交互模块，软件模块模型选用以及仿真环境选择)],[运行开源项目，尝试微调],
      // [第3-4周],[搭建所有所需环境的Docker，使用Git管理代码],[开发语音交互模块],
      // [第5-6周],[完成机械臂模型的搭建和仿真环境开发],[初步搭建软件模块框架],
      // [第7-8周],[完善软件模块],[不断测试修改软件框架],
      // [第9-10周],[整合系统，调试模块，测试不同指令并优化代码],[预留时间进行代码清理],
      // [第11-12周],[全面测试和优化，与现有算法对比，依据导师反馈进一步调整性能],[如进度健康，进行实物实验],
      // [第13-14周],[整理数据，撰写论文],[准备答辩材料并进行预演],
      [*时间*],
      [*内容安排1*],
      [*内容安排2*],
      [第1-2周],
      [查阅文献，明确研究目标与技术方案],
      [搭建开发环境],
      [第3-4周],
      [完成仿真环境和机械臂模型的搭建与测试],
      [实现开源项目微调及环境验证],
      [第5-6周],
      [开发语音交互模块并初步整合],
      [搭建并测试软件模块框架],
      [第7-8周],
      [完善软件模块并整合全系统],
      [运行全流程测试并优化关键问题],
      [第9-10周],
      [全面优化系统和代码，生成开发文档],
      [测试多种指令场景并记录实验结果],
      [第11-12周],
      [撰写实验报告并对比现有算法],
      [根据进度决定是否进行实物实验],
      [第13-14周],
      [整理实验数据并撰写论文],
      [准备答辩材料并进行预演],


      // 第9-10周：，预留时间进行代码清理。

      // 第7-8周：实现软件模块对大模型的调用和分析，完善软件模块。
      // ，测试并不断改进框架和现有框架对比

      // 第1-2周：查阅文献，明确研究目的和方案；运行几个开源项目，熟悉研究流程；简要回顾C++和ROS；开发语音交互模块。
      // 第3-4周：完成机械臂模型的搭建和仿真环境开发。
      // 第5-6周：完善仿真环境；搭建软件模块框架，实现基本操作；实现模块间通信，确保执行不同操作。
      // 第7-8周：实现软件模块对大模型的调用和分析，完善软件模块。
      // 第9-10周：整合系统，调试模块，测试不同指令并优化代码，预留时间进行代码清理。
      // 第11-12周：全面测试和优化，与现有算法对比，依据导师反馈进一步调整性能。
      // 第13-14周：整理数据，撰写论文，准备答辩材料并进行预演。
    )
  ])
]


#slide[
  // == 参考文献
  #set text(font: ("Times New Roman", "Source Han Serif SC"), size: 14pt)

  #bibliography(
    ("my.bib", "other.bib"),
    title: [
      参考文献#v(1em)
    ],
    style: "nature",
  )

]
#centered-slide[
  感谢聆听，请老师批评指正！

]
