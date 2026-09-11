#import "@preview/rubber-article:0.1.0": *
#import "@preview/mitex:0.2.4": *

#show: article.with()

#set text(font:("Times New Roman","Source Han Serif SC"), size: 12pt) 
// #import "@preview/cuti:0.2.1": show-cn-fakebold
// #show: show-cn-fakebold
#let 行间距转换(正文字体,行间距) = ((行间距)/(正文字体)-0.75)*1em
// // #show par: set block(spacing: 行间距转换(12,20))
#set par(leading: 行间距转换(12,20),justify: true,first-line-indent: 2em)
#show heading: it =>  {
    // set text(font: ("Times New Roman","Source Han Serif SC"), size: 12pt)
    it
    par()[
      #if it.level==1{
        v(-0.3em)
      }
      #if it.level==2{
        v(0.2em)
      }
      #if it.level==3{
        v(0.2em)
      }
      #text()[#h(0.0em)]
      #v(-1em)
      ]
      }
       
// #set par(justify: true,first-line-indent: 2em)
// #show: show-cn-fakebold
#maketitle(
  title: "The Title of the Paper",
  authors: (
    "Authors Name",
  ),
  date: "September 1970",
)
= 一级标题
== 二级标题

jiojjoijijoijjojijojijojijojijojijjoijjojijojijjojjjjoijo
你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要你好这是世界上最好的摘要deded迪岑的对接的金额哦i的的死哦的*11我爱你*
#mitex("2222222222")
#mitex("我爱你")
#mitext(`
  \iftypst
    #set math.equation(numbering: "(1)", supplement: "equation")
  \fi

  \section{Title}

  A \textbf{strong} text, a \emph{emph} text and inline equation $x + y$.

  Also block \eqref{eq:pythagoras}.

  \begin{equation}
    a^2 + b^2 = c^2 \label{eq:pythagoras}
  \end{equation}
  \section{知识点详细剖析}
\subsection{恒定磁场}
\subsubsection{结论法求磁场}

`)
edwdeded

#import "@preview/physica:0.9.3":*

#show: super-T-as-transpose // Render "..^T" as transposed matrix

$
A^T, curl vb(E) = - pdv(vb(B), t),
quad
tensor(Lambda,+mu,-nu) = dmat(1,RR),
quad
f(x,y) dd(x,y),
quad
dd(vb(x),y,[3]),
quad
dd(x,y,2,d:Delta,p:and),
quad
dv(phi,t,d:upright(D)) = pdv(phi,t) + vb(u) grad phi \

H(f) = hmat(f;x,y;delim:"[",big:#true),
quad
vb(v^a) = sum_(i=1)^n alpha_i vu(u^i),
quad
Set((x, y), pdv(f,x,y,[2,1]) + pdv(f,x,y,[1,2]) < epsilon) \

-1/c^2 pdv(,t,2)psi + laplacian psi = (m^2c^2) / hbar^2 psi,
quad
ket(n^((1))) = sum_(k in.not D) mel(k^((0)), V, n^((0))) / (E_n^((0)) - E_k^((0))) ket(k^((0))),
quad
integral_V dd(V) (pdv(cal(L), phi) - diff_mu (pdv(cal(L), (diff_mu phi)))) = 0 \

dd(s,2) = -(1-(2G M)/r) dd(t,2) + (1-(2G M)/r)^(-1) dd(r,2) + r^2 dd(Omega,2)
$

$
"clk:" & signals("|1....|0....|1....|0....|1....|0....|1....|0..", step: #0.5em) \
"bus:" & signals(" #.... X=... ..... ..... X=... ..... ..... X#.", step: #0.5em)
$
 
#import "@preview/bob-draw:0.1.0": *
#render(```
         /\_/\
bob ->  ( -.- )
         \   /
  .------/  /
 (        | |
  `====== o o
```)

#render(
    ```
      0       1
       *-------*
    1 /|    2 /| 
     *-+-----* | 
     | |4    | |7
     | *-----|-*
     |/      |/
     *-------*
    5       6
    ```,
    width: 25%,
)

```bob
"cats:"
 /\_/\  /\_/\  /\_/\  /\_/\ 
( o.o )( o.o )( o.o )( o.o )
```