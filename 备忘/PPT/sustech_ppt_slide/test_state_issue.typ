#import "lib.typ": slides

#show: slides.with(
  title: [Test],
  authors: ("Test",),
  ratio: 16 / 9,
)

== Slide with state + layout

#let _s = state("test", 0pt)
#layout(avail => {
  _s.update(avail.width * 0.45)
  rect(width: 80%, height: avail.width * 0.45)[Test]
})
#context { let v = _s.get(); [val: #v] }

== Normal Slide
- Bullet
