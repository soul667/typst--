== SoftMimicGen
核心贡献：把 MimicGen 的轨迹变换机制从 SE(3) 升级到非刚性形变场，解决"可变形物体无法用刚性坐标系描述"导致的轨迹迁移失效问题。是 MimicGen 的严格泛化（刚体可视为点云的特例）。

=== 非刚性配准与轨迹变换（Sec. IV-A/B）
物体表示：每个可变形物体用一组 3D 节点位置表示
$ O = {n_i}_(i=1)^(N_O), quad n_i = (x_i, y_i, z_i) in RR^3 $
节点来自仿真器软体求解器提供的 ground-truth nodal information，等价于点云表示。

配准过程：给定两个配置 $O_1$ 和 $O_2$（如同一条毛巾两种揉皱方式），求解光滑函数 $f: RR^3 -> RR^3$，最小化
- 点对点距离 $norm(f(a_i) - b_i)$
- 平滑性正则项

方法不要求两配置点数相等，也不需要事先点对点对应（TPS-RPM，Chui & Rangarajan）。

轨迹变换：源轨迹中每个末端位姿 $T_t = (p_t, R_t)$ 按下式变换
$ p_t -> f(p_t), quad R_t -> "orth"(J_f (p_t) dot R_t) $
其中 $J_f (p_t)$ 是 $f$ 在 $p_t$ 处的雅可比，$"orth"(dot)$ 正交化保证得到合法旋转矩阵。雅可比捕获局部线性形变，使末端相对可变形物体的局部空间关系在变换后得以保持。

源 demo 选择也用配准代价：对每个 subtask，把当前场景配置与每个源段起始配置各跑一次配准，选代价最低的（类比 MimicGen 的最近邻位姿选择）。

=== Sim-to-Real 两阶段解耦（Sec. V-D/E）
避开了"在真实世界里做非刚性配准"这件事——以往基于 replay 的方法（Schulman 等）把配准当 policy，真机点云噪声大、配准精度差。SoftMimicGen 改为：

- *阶段 1（仿真内，数据生成）*：用 ground-truth 节点做精确配准，生成高成功率大规模数据集
- *阶段 2（部署）*：在生成数据上用 BC-RNN-GMM / Diffusion Policy 训练，推理时不再做任何显式配准
- *桥梁*：Point Bridge 提供统一的、领域无关的基于点的表示，弥合 domain gap
- *观测模态*：仿真评测用 raw RGB 图像（Table I/II）；真机部署用 Point Bridge 提取的点云（Table III）。真机换点云是因为 sim 的视觉外观（纹理、光照、渲染）和真实差距大，RGB 会严重 OOD；点云 (x,y,z) 几何先验显式，PointNet 架构在 1000 条小数据量下比图像 policy 占优
- *Co-training 最优*：YAM Bag Loading 从 real-only 33.3% → sim-real co-train (1000 sim + 30 real) 93.3%

=== 任务套件（Sec. V-B）
10 个任务、4 种机器人形态：
- *GR1 humanoid*：Towel Unfold、Teddy
- *Franka*：Rope、Jenga、Towel、Rigid Cube
- *手术机器人 dVRK*：Tissue、Threading
- *双臂 YAM*：Towel、Bag Loading

可变形物体涉及毛绒玩具、绳子、软组织、毛巾；外加刚体 Jenga 块、立方体、香蕉、袋子。仿真平台为 Isaac Lab，软体求解器具体类型（FEM / PBD / XPBD / MPM）与参数论文未公开。每任务生成 1000 条 demo，成功率 70%--100%。

=== 关键局限（= 我们的切入点）
+ *资产多样性缺口*：没有自动化资产生成，每任务固定资产。没做材料参数（杨氏模量、泊松比、阻尼、摩擦）domain randomization；没有物体实例 / 尺寸 / 形状多样性；无场景 / 背景 / 光照随机化。
+ *任务结构简化*：多样性几乎只来自初始位置 / 构型随机化。GR1-Towel-Dist 视频显示 1000 条 demo 里毛巾*初始褶皱模式基本固定*，变化的是桌面上平移 / 旋转位置，而非褶皱拓扑本身。衣服（衬衫、裤子、领口 / 袖口对齐）完全没做；绳子只做 U 形塑形，打结 / 解结 / 编织没做；subtask 序列人工定义且固定，无法处理需要多次尝试或条件跳转的任务（作者在 Conclusion 中承认）。
+ *袋子任务做得一般*：YAM Bag Loading 仿真里 BC-RNN-GMM 仅 14.7%（需靠真实数据 co-training 提到 93.3%），反映袋子软体仿真本身的难度与多样性覆盖不足。

=== 一句话总结
SoftMimicGen 解决的是"deformable 数据生成"，而非"at-scale deformable asset generation"——它在*已有仿真任务和已有资产*上提升了轨迹级数据扩展性，但*没有*提出大规模、多样化 deformable 资产（含材料物性、实例、场景）的自动生成方法。这正是我们工作要填补的空缺：从 trajectory-level scalability 推进到 asset-level scalability。
