#let 字体 = (
  仿宋: ("Times New Roman", "FangSong"),
  宋体: ("Times New Roman", "SimSun"),
  思源宋体: ("Times New Roman", "Source Han Serif"),
  黑体: ("Times New Roman", "SimHei"),
  楷体: ("Times New Roman", "KaiTi"),
  代码: ("New Computer Modern Mono", "Times New Roman", "SimSun"),
)
#let 字号 = (
  初号: 42pt,
  小初: 36pt,
  一号: 26pt,
  小一: 24pt,
  二号: 22pt,
  小二: 18pt,
  三号: 16pt,
  小三: 15pt,
  四号: 14pt,
  中四: 13pt,
  小四: 12pt,
  五号: 10.5pt,
  小五: 9pt,
  六号: 7.5pt,
  小六: 6.5pt,
  七号: 5.5pt,
  小七: 5pt,
)
#let heiti(text_)={
  text(font: "SimHei")[#text_]
}
#let lengthceil(len, unit: 字号.小四) = calc.ceil(len / unit) * unit
#let partcounter = counter("part")
#let chaptercounter = counter("chapter")
#let appendixcounter = counter("appendix")
#let footnotecounter = counter(footnote)
#let rawcounter = counter(figure.where(kind: "code"))
#let imagecounter = counter(figure.where(kind: image))
#let tablecounter = counter(figure.where(kind: table))
#let equationcounter = counter(math.equation)

#let appendix() = {
  appendixcounter.update(10)
  chaptercounter.update(0)
  counter(heading).update(0)
}
#let skippedstate = state("skipped", false)

#let chinesenumber(num, standalone: false) = if num < 11 {
  ("零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十").at(num)
} else if num < 100 {
  if calc.rem(num, 10) == 0 {
    chinesenumber(calc.floor(num / 10)) + "十"
  } else if num < 20 and standalone {
    "十" + chinesenumber(calc.rem(num, 10))
  } else {
    chinesenumber(calc.floor(num / 10)) + "十" + chinesenumber(calc.rem(num, 10))
  }
} else if num < 1000 {
  let left = chinesenumber(calc.floor(num / 100)) + "百"
  if calc.rem(num, 100) == 0 {
    left
  } else if calc.rem(num, 100) < 10 {
    left + "零" + chinesenumber(calc.rem(num, 100))
  } else {
    left + chinesenumber(calc.rem(num, 100))
  }
} else {
  let left = chinesenumber(calc.floor(num / 1000)) + "千"
  if calc.rem(num, 1000) == 0 {
    left
  } else if calc.rem(num, 1000) < 10 {
    left + "零" + chinesenumber(calc.rem(num, 1000))
  } else if calc.rem(num, 1000) < 100 {
    left + "零" + chinesenumber(calc.rem(num, 1000))
  } else {
    left + chinesenumber(calc.rem(num, 1000))
  }
}

#let chinesenumbering(..nums, location: none, brackets: false,chinese:true) = locate(loc => {
  let actual_loc = if location == none { loc } else { location }
  if appendixcounter.at(actual_loc).first() < 10 {
    if nums.pos().len() == 1 and chinese {
      "第" + chinesenumber(nums.pos().first(), standalone: true) + "章"
    } else {
      numbering(if brackets { "(1.1)" } else { "1.1" }, ..nums)
    }
  } else {
    if nums.pos().len() == 1 {
      "附录 " + numbering("A.1", ..nums)
    } else {
      numbering(if brackets { "(A.1)" } else { "A.1" }, ..nums)
    }
  }
})

#let chineseunderline(s, width: 300pt, bold: false) = {
  let chars = s.clusters()
  let n = chars.len()
  style(styles => {
    let i = 0
    let now = ""
    let ret = ()

    while i < n {
      let c = chars.at(i)
      let nxt = now + c

      if measure(nxt, styles).width > width or c == "\n" {
        if bold {
          ret.push(strong(now))
        } else {
          ret.push(now)
        }
        ret.push(v(-1em))
        ret.push(line(length: 100%))
        if c == "\n" {
          now = ""
        } else {
          now = c
        }
      } else {
        now = nxt
      }

      i = i + 1
    }

    if now.len() > 0 {
      if bold {
        ret.push(strong(now))
      } else {
        ret.push(now)
      }
      ret.push(v(-0.9em))
      ret.push(line(length: 100%))
    }

    ret.join()
  })
}
// 中文目录
#let chineseoutline(title: "目录", depth: none, indent: false) = {
  heading(title, numbering: none, outlined: false)
  locate(it => {
    let elements = query(heading.where(outlined: true).after(it), it)

    for el in elements {
      // Skip list of images and list of tables
      if partcounter.at(el.location()).first() < 20 and el.numbering == none { continue }

      // Skip headings that are too deep
      if depth != none and el.level > depth { continue }

      let maybe_number = if el.numbering != none {
        if el.numbering == chinesenumbering {
          chinesenumbering(..counter(heading).at(el.location()), location: el.location())
        } else {
          numbering(el.numbering, ..counter(heading).at(el.location()))
        }

      }
      if el.level==0{continue};
      let line = {
        if indent {
          
          h(1em * (el.level - 1 ))
        }

        if el.level == 1 {
          v(0.5em, weak: true)
        }

        if maybe_number != none {
          style(styles => {
            let width = measure(maybe_number, styles).width
            box(
              width: lengthceil(width),
              link(el.location(), if el.level == 1 {
                strong(maybe_number)
              } else {
                [ #maybe_number ]
              })
            )
          })
        }
        h(0.3em * (el.level - 1 ))
        link(el.location(), if el.level == 1 {
        strong([
           #el.body 
          ])
        } else {
          el.body 
          // h(-.4em)
        })

        // Filler dots
        if el.level == 1 {
          box(width: 1fr, h(10pt) + box(width: 1fr) + h(10pt)+v(2em))
        } else {
          box(width: 1fr, h(10pt) + box(width: 1fr, repeat[.]) + h(10pt)+v(0.1em))
        }

        // Page number
        let footer = query(selector(<__footer__>).after(el.location()), el.location())
        let page_number = if footer == () {
          2
        } else {
          counter(page).at(footer.first().location()).first()
        }
        
        link(el.location(), if el.level == 1 {
          strong(str(page_number))
        } else {
          str(page_number)
        })

        linebreak()
        v(-0.2em)
      }

      line
    }
  })
}
#let listoffigures(title: "插图", kind: image) = {
  heading(title, numbering: none, outlined: false)
  locate(it => {
    let elements = query(figure.where(kind: kind).after(it), it)

    for el in elements {
      let maybe_number = {
        let el_loc = el.location()
        chinesenumbering(chaptercounter.at(el_loc).first(), counter(figure.where(kind: kind)).at(el_loc).first(), location: el_loc)
        h(0.5em)
      }
      let line = {
        style(styles => {
          let width = measure(maybe_number, styles).width
          box(
            width: lengthceil(width),
            link(el.location(), maybe_number)
          )
        })

        link(el.location(), el.caption.body)

        // Filler dots
        box(width: 1fr, h(10pt) + box(width: 1fr, repeat[.]) + h(10pt))

        // Page number
        let footers = query(selector(<__footer__>).after(el.location()), el.location())
        let page_number = if footers == () {
          0
        } else {
          counter(page).at(footers.first().location()).first()
        }
        link(el.location(), str(page_number))
        linebreak()
        v(-0.2em)
      }

      line
    }
  })
}

#let codeblock(raw, caption: none, outline: false) = {
  figure(
    if outline {
      rect(width: 100%)[
        #set align(left)
        // #ser text(font: 字体.代码,size:)
        #raw
      ]
    } else {
      set align(left)
      raw
    },
    caption: caption, kind: "code", supplement: ""
  )
}

#let tableblock(raw, caption: none, outline: false) = {
  figure(
    if outline {
      rect(width: 100%)[
        #set align(center)
        // #ser text(font: 字体.代码,size:)
        #raw
      ]
    } else {
      set align(center)
      raw
    },
    caption: caption, kind: "tablex", supplement: ""
  )
}
#let booktab(columns: (), aligns: (), width: auto, caption: none, ..cells) = {
  let headers = cells.pos().slice(0, columns.len())
  let contents = cells.pos().slice(columns.len(), cells.pos().len())
  set align(center)

  if aligns == () {
    for i in range(0, columns.len()) {
      aligns.push(center)
    }
  }

  let content_aligns = ()
  for i in range(0, contents.len()) {
    content_aligns.push(aligns.at(calc.rem(i, aligns.len())))
  }

  return figure(
    block(
      width: width,
      grid(
        columns: (auto),
        row-gutter: 1em,
        line(length: 100%),
        [
          #set align(center)
          #box(
            width: 100% - 1em,
            grid(
              columns: columns,
              ..headers.zip(aligns).map(it => [
                #set align(it.last())
                #strong(it.first())
              ])
            )
          )
        ],
        line(length: 100%),
        [
          #set align(center)
          #box(
            width: 100% - 1em,
            grid(
              columns: columns,
              row-gutter: 1em,
              ..contents.zip(content_aligns).map(it => [
                #set align(it.last())
                #it.first()
              ])
            )
          )
        ],
        line(length: 100%),
      ),
    ),
    caption: caption,
    kind: table
  )
}

#let 行间距转换(正文字体,行间距) = ((行间距)/(正文字体)-0.75)*1em
// ((setting.行间距)/(setting.字体.正文字号)-0.75)*1em
// 基本设置
#let data=yaml("./data.yml");
#let setting=data.模板设置;
#let conf(
  标题: "这里是标题",
  作者: "这里是作者",
  学号:  11111,
  学院:  " ",
  cabstract: [],
  ckeywords: (),
  eabstract: [],
  ekeywords: (),
  acknowledgements: [],
  linespacing: 行间距转换(setting.字体.正文字号,setting.行间距),
  outlinedepth: 3,
  blind: false,
  listofimage: true,
  listoftable: true,
  listofcode: true,
  alwaysstartodd: true,
  doc,
) = {
  let smartpagebreak = () => {
    if alwaysstartodd {
      // skippedstate.update(true)
      // pagebreak(to: "odd", weak: true)
      // skippedstate.update(false)
    // } else {
      pagebreak(weak: true)
    // }
  }}
  import "@preview/cuti:0.2.1": show-cn-fakebold
  show: show-cn-fakebold
  // set text(font: ("Times New Roman", "SimSun"))
  set page("a4",
      margin: (
        top:setting.边距.上*1mm,
        bottom:setting.边距.下*1mm,
        left:setting.边距.左*1mm,
        right:setting.边距.右*1mm
    ),
       header:[
        #if setting.页眉.类型!="none" {
        v(-0.8em)
        line(length:100%,stroke:1pt)
        }
        #set text(10pt)
    ],
    footer: locate(loc => {
      if skippedstate.at(loc) and calc.even(loc.page()) { return }
      [
        #set text(字号.五号)
        #set align(center)
        // 页#str(counter(page).at(loc).first())
        
        #if query(selector(heading).before(loc), loc).len() < 2 or query(selector(heading).after(loc), loc).len() == 0 {
          // Skip cover, copyright and origin pages
          // 跳过封面、版权和起源页面
        } else {
          let headers = query(selector(heading).before(loc), loc)
          let part = partcounter.at(headers.last().location()).first()
          [ 
            #if part < 20 {
              numbering("I", counter(page).at(loc).first())
            } else {
              "页"+str(counter(page).at(loc).first())
            }
          ]
        }
        #label("__footer__")
      ]
    }
    ),
  )

  set text(font:字体.宋体,size: setting.字体.正文字号*1pt)
  // set align(center + horizon)
  if(setting.模板选择=="基本"){
  set heading(numbering: chinesenumbering)}
  if(setting.模板选择=="论文"){
  set heading(numbering: chinesenumbering)}
  set figure(
    numbering: (..nums) => locate(loc => {
      if appendixcounter.at(loc).first() < 10 {
        numbering("1.1", chaptercounter.at(loc).first(), ..nums)
      } else {
        numbering("A.1", chaptercounter.at(loc).first(), ..nums)
      }
    })
  )
  set math.equation(
    numbering: (..nums) => locate(loc => {
      set text(font: 字体.宋体)
        numbering("(1.1)", chaptercounter.at(loc).first(), ..nums)
    })
  )
  set list(indent: 2em)
  set enum(indent: 2em)
  show par: set block(spacing: linespacing)
  show raw: set text(font: 字体.代码)
  // 标题设置 
  show heading: it => [
    // Cancel indentation for headings
    #set par(first-line-indent: 0em)
    // font 0 宋体 1 黑体
    #let sizedheading(it, size,w,font_:true) = [
      
      #set text(size:size,fill:rgb(setting.主题色.R,setting.主题色.G,setting.主题色.B))
      #if it.numbering != none {
        strong(counter(heading).display())
        h(0.5em)
      }
      #strong(it.body+counter(heading).display())
    ]
    #if setting.模板选择=="基本"{
      if it.level == 1{
        if not it.body.text in ("Abstract", "学位论文使用授权说明", "前言")  {
        smartpagebreak()
      }
        locate(loc => {
        if it.body.text == "摘要" {
          partcounter.update(10)
          counter(page).update(1)
        } else if it.numbering != none and partcounter.at(loc).first() < 20 {
          partcounter.update(20)
          counter(page).update(1)
        }
      })
      if it.numbering != none {
        chaptercounter.step()
      }
      footnotecounter.update(())
      imagecounter.update(())
      tablecounter.update(())
      rawcounter.update(())
      equationcounter.update(())
      set align(center)
      sizedheading(it, 字号.三号,setting.标题.下面间距.大标题*1em)

      }else{
        if it.level == 2 {
        sizedheading(it, 字号.四号,setting.标题.下面间距.一级标题*1em)
      } else if it.level == 3 {
        sizedheading(it, 字号.中四,setting.标题.下面间距.二级标题 *1em)
      } else {
        sizedheading(it, 字号.小四,setting.标题.下面间距.三级标题*1em)
      }
      }
    }else{
      if setting.模板选择=="论文"{
        if it.level == 1{
          // 段前空 24 磅，段后空 6 磅
        set text(font: 字体.黑体)
        v(24pt)
        sizedheading(it, 字号.四号,setting.标题.下面间距.一级标题*1em)
        v(6pt)
        }
        else if it.level == 2 {
        set text(font: 字体.黑体)
        
        v(12pt)
        sizedheading(it, 13pt,setting.标题.下面间距.一级标题*1em)
        v(6pt)
      
      } else if it.level == 3 {
        v(12pt)
        sizedheading(it, 字号.中四,setting.标题.下面间距.二级标题 *1em)
        v(6pt)
      
      } else {
        sizedheading(it, 字号.小四,setting.标题.下面间距.三级标题*1em)
      }
      }else{
        
      }
    }
// 
    // }
    // #if(setting.模板选择=="基本"){
    // if it.level == 1 {
    //   if not it.body.text in ("Abstract", "学位论文使用授权说明", "前言")  {
    //     smartpagebreak()
    //   }
    //   locate(loc => {
    //     if it.body.text == "摘要" {
    //       partcounter.update(10)
    //       counter(page).update(1)
    //     } else if it.numbering != none and partcounter.at(loc).first() < 20 {
    //       partcounter.update(20)
    //       counter(page).update(1)
    //     }
    //   })
    //   if it.numbering != none {
    //     chaptercounter.step()
    //   }
    //   footnotecounter.update(())
    //   imagecounter.update(())
    //   tablecounter.update(())
    //   rawcounter.update(())
    //   equationcounter.update(())
    //   set align(center)
    //   sizedheading(it, 字号.三号,setting.标题.下面间距.大标题*1em)
      
    // } else {
    //   if it.level == 2 {
    //     sizedheading(it, 字号.四号,setting.标题.下面间距.一级标题*1em)
    //   } else if it.level == 3 {
    //     sizedheading(it, 字号.中四,setting.标题.下面间距.二级标题 *1em)
    //   } else {
    //     sizedheading(it, 字号.小四,setting.标题.下面间距.三级标题*1em)
    //   }
    // }
    // }
    // #if(setting.模板选择=="论文"){
      
    //   locate(loc => {
    //     if it.body.text == "摘要" {
    //       partcounter.update(10)
    //       counter(page).update(1)
    //     } else if it.numbering != none and partcounter.at(loc).first() < 20 {
    //       partcounter.update(20)
    //       counter(page).update(1)
    //     }
    //   })
    //   if it.numbering != none {
    //     chaptercounter.step()
    //   }
    //   footnotecounter.update(())
    //   imagecounter.update(())
    //   tablecounter.update(())
    //   rawcounter.update(())
    //   equationcounter.update(())
      
    //     //  set align(center)
    //   sizedheading(it, 字号.三号,setting.标题.下面间距.大标题*1em)

      
    // } 
    
    
  ]

  show figure.where(kind:image): set figure(supplement: [图])
  show figure.where(kind:"tablex"): set figure(supplement: [表])
  show figure.where(kind:"code"): set block(breakable: true)
  show figure: it => [
    #set align(center)
    #if not it.has("kind") {
      it
    } else if it.kind == image {
      it.body
      [
        #set text(字号.小四)
        #it.caption
      ]
    } else if it.kind == table {
      [
        #set text(字号.小四)
        #it.caption
      ]
      it.body
    } else if it.kind == "code" {
      [
        #set text(字号.小四)
        代码#it.caption
      ]
      it.body
    } else if it.kind == "tablex" {
      [
        #set text(字号.小四)
        #it.caption
      ]
      it.body
    } else{
      it.body
    }
  ]

  show ref: it => {
    if it.element == none {
      // Keep citations as is
      it
    } else {
      // Remove prefix spacing
      h(0em, weak: true)

      let el = it.element
      let el_loc = el.location()
      if el.func() == math.equation {
        // Handle equations
        link(el_loc, [
          式
          #chinesenumbering(chaptercounter.at(el_loc).first(), equationcounter.at(el_loc).first(), location: el_loc, brackets: true)
        ])
      } else if el.func() == figure {
        // Handle figures
        if el.kind == image {
          link(el_loc, [
            图
            #chinesenumbering(chaptercounter.at(el_loc).first(), imagecounter.at(el_loc).first(), location: el_loc)
          ])
        } else if el.kind == table {
          link(el_loc, [
            表
            #chinesenumbering(chaptercounter.at(el_loc).first(), tablecounter.at(el_loc).first(), location: el_loc)
          ])
        } else if el.kind == "code" {
          link(el_loc, [
            代码
            #chinesenumbering(chaptercounter.at(el_loc).first(), rawcounter.at(el_loc).first(), location: el_loc)
          ])
        }
      } else if el.func() == heading {
        // Handle headings
        if el.level == 1 {
          link(el_loc, chinesenumbering(..counter(heading).at(el_loc), location: el_loc))
        } else {
          link(el_loc, [
            节
            #chinesenumbering(..counter(heading).at(el_loc), location: el_loc)
          ])
        }
      }

      // Remove suffix spacing
      h(0em, weak: true)
    }
  }

  let fieldname(name) = [
    #set align(right + top)
    #strong(name)
  ]

  let fieldvalue(value) = [
    #set align(center + horizon)
    #set text(font: 字体.仿宋)
    #grid(
      rows: (auto, auto),
      row-gutter: 0.2em,
      value,
      line(length: 100%)
    )
  ]


  // set align(left + top)
  // set text(字号.小四)

  
  // Table of contents
  if(setting.目录.开启目录==1){
    chineseoutline(
      title: "目录",
      depth: outlinedepth,
      indent: true,
    )
    // smartpagebreak()
    pagebreak()
  }
    if(setting.目录.开启目录==2){
    chineseoutline(
      title: "CONTENT",
      depth: outlinedepth,
      indent: true,
    )
  }
  if setting.目录.开启图表代码目录!=0 {
if listofimage {
    listoffigures()
  }

  if listoftable {
    listoffigures(title: "表格", kind: "tablex")
  }

  if listofcode {
    listoffigures(title: "代码", kind: "code")
  }
  }
  

  set align(left + top)
  par(justify: true, first-line-indent: 2em, leading: linespacing)[
    #doc
    // 中国人不会骗中国人，快跑。这个软件真的不好用，真的，我说真的。
  ]


}