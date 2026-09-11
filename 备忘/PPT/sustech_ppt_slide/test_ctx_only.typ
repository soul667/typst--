#import "lib.typ": slides

#show: slides.with(
  title: [Test],
  authors: ("Test",),
  ratio: 16 / 9,
)

== Slide with context only

#rect(width: 80%, height: 45%)[Test]
#context { metadata((x: repr(here().position()))) }

== Normal Slide
- Bullet
