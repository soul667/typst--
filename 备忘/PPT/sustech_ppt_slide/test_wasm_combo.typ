#import "lib.typ": slides, _get-video-dims

#show: slides.with(
  title: [Test],
  authors: ("Test",),
  ratio: 16 / 9,
)

== Slide 

#{
  let (vw, vh) = _get-video-dims("点云预处理组件.mp4")
  let aspect = vw / vh
  let width_pct = 80.0  
  layout(avail => {
    let abs_w = avail.width * (width_pct / 100)
    let abs_h = abs_w / aspect
    rect(width: 80%, height: abs_h)[Test]
  })
  context { metadata((y: repr(here().position().y))) }
}

== Normal Slide
- Bullet
