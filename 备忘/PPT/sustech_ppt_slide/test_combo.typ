#import "lib.typ": slides

#show: slides.with(
  title: [Test],
  authors: ("Test",),
  ratio: 16 / 9,
)

== Slide with layout + context

#layout(avail => {
  rect(width: 80%, height: avail.width * 0.45)[Test]
})
#context { metadata((y: repr(here().position().y))) }

== Normal Slide
- Bullet
