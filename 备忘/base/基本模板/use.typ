#import "@preview/codly:1.3.0": *
#show: codly-init.with()

```rust
pub fn main() {
    println!("Hello, world!");
}
```

wwwwwww
```cpp
int main() {
    std::cout << "Hello, world!" << std::endl;
    return 0;
}
```

// #import "@preview/fletcher:0.5.1" as fletcher: diagram, node, edge
// #diagram($
//   e^- edge("rd", "-<|-") & & & edge("ld", "-|>-") e^+ \
//   & edge(gamma, "wave") \
//   e^+ edge("ru", "-|>-") & & & edge("lu", "-<|-") e^- \
// $)
// #set text(white, font: "Fira Sans")
// #let colors = (maroon, olive, eastern)
// #diagram(
// 	edge-stroke: 1pt,
// 	node-corner-radius: 5pt,
// 	edge-corner-radius: 8pt,
// 	mark-scale: 80%,

// 	node((0,0), [input], fill: colors.at(0)),
// 	node((2,+1), [memory unit (MU)], fill: colors.at(1)),
// 	node((2, 0), align(center)[arithmetic & logic \ unit (ALU)], fill: colors.at(1)),
// 	node((2,-1), [control unit (CU)], fill: colors.at(1)),
// 	node((4,0), [output], fill: colors.at(2), shape: fletcher.shapes.hexagon),

// 	edge((0,0), "r,u,r", "-}>"),
// 	edge((2,-1), "r,d,r", "-}>"),
// 	edge((2,-1), "r,dd,l", "--}>"),
// 	edge((2,1), "l", (1,-.5), marks: ((inherit: "}>", pos: 0.65, rev: false),)),

// 	for i in range(-1, 2) {
// 		edge((2,0), (2,1), "<{-}>", shift: i*5mm, bend: i*20deg)
// 	},

// 	edge((2,-1), (2,0), "<{-}>"),
// )



// #diagram(
// 	node-defocus: 0,
// 	spacing: (1cm, 2cm),
// 	edge-stroke: 1pt,
// 	crossing-thickness: 5,
// 	mark-scale: 70%,
// 	node-fill: luma(0%),
// 	node-outset: 3pt,
// 	node((0,0), "magma"),

// 	node((-1,1), "semigroup"),
// 	node(( 0,1), "unital magma"),
// 	node((+1,1), "quasigroup"),

// 	node((-1,2), "monoid"),
// 	node(( 0,2), "inverse semigroup"),
// 	node((+1,2), "loop"),

// 	node(( 0,3), "group"),

// 	{
// 		let quad(a, b, label, paint, ..args) = {
// 			paint = paint.darken(25%)
// 			edge(a, b, text(paint, label), "-|>", stroke: paint, label-side: center, ..args)
// 		}

// 		quad((0,0), (-1,1), "Assoc", blue)
// 		quad((0,1), (-1,2), "Assoc", blue, label-pos: 0.3)
// 		quad((1,2), (0,3), "Assoc", blue)

// 		quad((0,0), (0,1), "Id", red)
// 		quad((-1,1), (-1,2), "Id", red, label-pos: 0.3)
// 		quad((+1,1), (+1,2), "Id", red, label-pos: 0.3)
// 		quad((0,2), (0,3), "Id", red)

// 		quad((0,0), (1,1), "Div", yellow)
// 		quad((-1,1), (0,2), "Div", yellow, label-pos: 0.3, "crossing")

// 		quad((-1,2), (0,3), "Inv", green)
// 		quad((0,1), (+1,2), "Inv", green, label-pos: 0.3)

// 		quad((1,1), (0,2), "Assoc", blue, label-pos: 0.3, "crossing")
// 	},
// )



#import "@preview/gentle-clues:1.0.0": *

// add an info clue
#info[ This is the info clue ... ]

// or a tip with custom title
#tip(title: "Best tip ever")[Check out this cool package]


#import "@preview/physica:0.9.3": *

#show: super-T-as-transpose // Render "..^T" as transposed matrix

$
  A^T, curl vb(E) = - pdv(vb(B), t),
  quad
  tensor(Lambda, +mu, -nu) = dmat(1, RR),
  quad
  f(x,y) dd(x, y),
  quad
  dd(vb(x), y, [3]),
  quad
  dd(x, y, 2, d: Delta, p: and),
  quad
  dv(phi, t, d: upright(D)) = pdv(phi, t) + vb(u) grad phi \
  H(f) = hmat(f; x, y; delim: "[", big: #true),
  quad
  vb(v^a) = sum_(i=1)^n alpha_i vu(u^i),
  quad
  Set((x, y), pdv(f, x, y, [2,1]) + pdv(f, x, y, [1,2]) < epsilon) \
  -1/c^2 pdv(, t, 2)psi + laplacian psi = (m^2c^2) / hbar^2 psi,
  quad
  ket(n^((1))) = sum_(k in.not D) mel(k^((0)), V, n^((0))) / (E_n^((0)) - E_k^((0))) ket(k^((0))),
  quad
  integral_V dd(V) (pdv(cal(L), phi) - diff_mu (pdv(cal(L), (diff_mu phi)))) = 0 \
  dd(s, 2) = -(1-(2G M)/r) dd(t, 2) + (1-(2G M)/r)^(-1) dd(r, 2) + r^2 dd(Omega, 2)
$

$
  "clk:" & signals("|1....|0....|1....|0....|1....|0....|1....|0..", step: #0.5em) \
  "bus:" & signals(" #.... X=... ..... ..... X=... ..... ..... X#.", step: #0.5em)
$


$curl$

#import "@preview/lasaveur:0.1.3": *
$fh(x) + ka + g8 + ar.r +1_2 alpha beta gamma$
