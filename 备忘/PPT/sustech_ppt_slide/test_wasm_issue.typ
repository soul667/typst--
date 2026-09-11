#import "lib.typ": slides, _get-video-dims

#show: slides.with(
  title: [Test],
  authors: ("Test",),
  ratio: 16 / 9,
)

== Slide with wasm

#let (vw, vh) = _get-video-dims("点云预处理组件.mp4")
Width: #vw, Height: #vh

== Normal Slide
- Bullet
