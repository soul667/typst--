= TASK
// == 核心问题：
// 如何构建一个可扩展（scalable）、低人工成本的 pipeline，能够at scale 生成高质量 sim-ready deformable assets（布料、绳索、软体等），从而支撑大规模柔性物体操作数据合成？
// == 子问题拆解：

// 如何快速生成多样化的 deformable mesh + 物理参数？
// 如何让资产同时具备高视觉保真度和准确物理行为？
// 如何实现从真实世界到仿真的低成本迁移（Real2Sim）？
// 如何支持多类别 deformable（cloth、rope、volumetric soft body）统一建模？

// 目标输出：一个全自动或半自动的 Deformable Asset Generation Pipeline，目标是把人工建模时间从“几天一个物体”降到“几分钟一个物体”，并支持大规模并行生成。

大任务：面向真实落地场景（TOB是商超餐饮，TOC是家务）的可变形物体操作

尤其在家务和商超环境中，涉及的任务普遍具有较高的难度和频繁性。为了有效地研究这些任务，基于这一问题，我们选择了三个具有代表性的任务来研究，覆盖一维、二维和三维形变物体的操作：

- 1D: rope manipulation
  - 线材整理和收纳
- 2D: cloth manipulation（布料操作）
  - 衣物布料折叠、收纳、取出
- 3D: deformable container manipulation（可变形容器操作）
  - 如外卖袋的打包，购物袋的取出、垃圾袋的装填与取出。
并且我们聚焦到真实落地场景，所以对部分任务做了简化，比如1D不考虑打结，2D考虑从平铺状态开始，3D考虑一些比较硬以及结构化的袋子，这些如果批量化生产标准化的部件，成本并不高。

然后我们来看一下现有的相关工作，看看他们在这些任务上都做了什么，以及存在什么样的局限性。 

== FoldNet
== softmimicgen
== ShakingBot
#image("/assets/image-20.png")