= 任务确定
== 任务
1. 将袋子从一个规整的状态打开以方便放置物体
2. 将物体放入袋子中
3. 将袋子进行封口
4. 将袋子从一个地方移动到另一个地方
5. 将袋子挂到某个地方
// - opening a deformable bag from an unstructured initial state and placing objects inside
// - 将袋子分层以方便后续操作
#image("/assets/image-17.png",height: 20em)
#image("/assets/image-19.png",height: 20em)


== 相关的操作文献
主要是可以帮助我们确定哪些任务是重要的帮助我们确定资产合成的重心
=== AutoBag: Learning to Open Plastic Bags and Insert Objects

#image("/assets/image-16.png")
使用 ultraviolet (UV) labels 来标记袋子帮助识别
#image("/assets/image-18.png")

在 30 次实体测试中，成功向袋内放入至少 1 个物体的成功率达到 53.3%.
=== DextAIRity

DextAIRity方法利用气流高效撑开袋子，该方案采用三台 UR5 机器人，其中两台夹持袋子，第三台在自由空间操控鼓风机。
