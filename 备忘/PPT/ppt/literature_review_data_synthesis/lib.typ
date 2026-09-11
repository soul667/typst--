#let layouts = (
  "small": ("height": 9cm, "space": 1.4cm),
  "medium": ("height": 10.5cm, "space": 1.6cm),
  "large": ("height": 12cm, "space": 1.8cm),
)

// Shared theme color that must be visible in included section files.
#let sustech-orange = color.rgb(237, 108, 0)

// Column layout helpers
#let two-col(col-left, col-right, ratio: (1fr, 1fr), gutter: 1em) = {
  grid(
    columns: ratio,
    column-gutter: gutter,
    align: (start + horizon, start + horizon),
    col-left, col-right,
  )
}

#let three-col(a, b, c, ratio: (1fr, 1fr, 1fr), gutter: 1em) = {
  grid(
    columns: ratio,
    column-gutter: gutter,
    a, b, c,
  )
}

// ── Video probe WASM plugin ─────────────────────────────────────────
// Reads video file headers (MP4/MOV/AVI/MKV/WebM) to extract dimensions.
#let _video_probe = plugin("video_probe.wasm")

/// Get video dimensions as (width, height) from the file.
/// Falls back to (1920, 1080) if the format is unsupported.
#let _get-video-dims(path) = {
  let data = read(path, encoding: none)
  let result = _video_probe.get_dimensions(data)
  let parts = str(result).split(",")
  (int(parts.at(0)), int(parts.at(1)))
}

// Video placeholder function for typst2pptx converter.
// In Typst/PDF: renders a placeholder rect sized to the video's aspect ratio.
// The converter extracts metadata via `typst query` for exact position + size.
//
// Parameters:
//   path: video file path (relative to the .typ file)
//   width: placeholder width (default: 100%)
//   ratio: override aspect ratio (auto = read from file via WASM plugin)
//   poster: optional poster image path
//   use_gif: if set true, when convert to pptx, convert videos to gifs
//   composed: if set true, 自动压缩视频
#let video(path, width: 100%, ratio: auto, poster: none, use_gif: false, composed: false) = {
  // Get actual aspect ratio from the video file
  let aspect = if ratio == auto {
    let (vw, vh) = _get-video-dims(path)
    vw / vh
  } else {
    ratio
  }

  let (vid_w, vid_h) = _get-video-dims(path)
  let width_pct = if str(type(width)) == "ratio" { width / 1% } else { 100.0 }

  let placeholder = layout(avail => {
    let abs_w = avail.width * (width_pct / 100)
    let abs_h = abs_w / aspect
    // No state.update() here — causes extra layout passes → extra pages

    if poster != none {
      image(poster, width: width)
    } else {
      rect(
        width: width,
        height: abs_h,
        fill: luma(230),
        stroke: 1pt + luma(180),
        radius: 4pt,
      )[
        #align(center + horizon)[
          #text(size: 2em, fill: luma(120))[▶]
          #v(0.3em)
          #text(size: 0.7em, fill: luma(150))[#path]
        ]
      ]
    }
  })

  // context is OUTSIDE layout — no re-layout triggered, no page split
  [
    #placeholder
    #context {
      let bot  = here().position()
      // Recompute abs_h using page.width (same formula as layout() above — no state needed)
      let abs_h = page.width * (width_pct / 100) / aspect
      metadata((
        type:       "video",
        path:       path,
        page:       bot.page,
        x:          repr(bot.x),
        y_top:      repr(bot.y - abs_h),
        y_bottom:   repr(bot.y),
        width_pct:  width_pct,
        vid_w:      vid_w,
        vid_h:      vid_h,
        use_gif:    use_gif,
        composed:   composed,
      ))
    }
  ]
}

#let slides(
  content,
  title: none,
  subtitle: none,
  footer-title: none,
  footer-subtitle: none,
  date: none,
  authors: (),
  layout: "medium",
  ratio: 4 / 3,
  title-color: none,
  first-slide: true,
  bg-color: white,
  count: none,
  footer: true,
  toc: true,
  theme: "normal",
  logo: "img/SUSTech LOGO CN.svg",
  section-image: "img/页面 1.png",
) = {
  // Parsing
  if layout not in layouts {
    panic("Unknown layout " + layout)
  }
  let (height, space) = layouts.at(layout)
  let width = ratio * height

  if count not in (none, "dot", "number", "dot-section") {
    panic("Unknown Count, valid counts are 'dot', 'dot-section', 'number', or none")
  }

  if theme not in ("normal", "full") {
    panic("Unknown Theme, valid themes are 'full' and 'normal'")
  }

  // Colors
  if title-color == none {
    title-color = color.rgb(237, 108, 0) // SUSTech Orange
  }
  let block-color = title-color.lighten(90%)
  let body-color = title-color.lighten(80%)
  let header-color = title-color.lighten(65%)
  let fill-color = title-color.lighten(50%)

  // Setup
  set document(
    title: title,
    author: if type(authors) == array { authors } else { () },
  )
  set heading(numbering: "1.a")

  // PAGE ----------------------------------------------
  set page(
    fill: bg-color,
    width: width,
    height: height,
    margin: (x: 0.5 * space, top: space, bottom: 0.6 * space),

    // HEADER
    header: [
      #context {
        let page = here().page()
        let headings = query(selector(heading.where(level: 2)))
        let heading = headings.rev().find(x => x.location().page() <= page)

        if heading != none {
          set align(top)
          if theme == "full" {
            block(
              width: 100%,
              fill: title-color,
              height: space * 0.85,
              outset: (x: 0.5 * space),
            )[
              #set text(1.4em, weight: "bold", fill: bg-color)
              #v(space / 2)
              #heading.body
              #if not heading.location().page() == page [
                #{ numbering("(i)", page - heading.location().page() + 1) }
              ]
            ]
          } else if theme == "normal" {
            v(space / 8)
            grid(
              columns: (3fr, 1fr),
              align: (left + top, right + top),
              block(width: 100%, height: 100%)[
                #set text(1.4em, weight: "bold", fill: title-color)
                #v(space / 4)
                #heading.body
                #if not heading.location().page() == page [
                  #{ numbering("(i)", page - heading.location().page() + 1) }
                ]
              ],
              block(width: 120%, height: 80%)[
                #v(-0.1em)
                #image(logo, height: 95%)
              ],
            )
          }
        }
      }

      // COUNTER ============================================================
      #if count == "dot" {
        // DOT COUNTER
        set align(right + top)
        context {
          let last = counter(page).final().first()
          let current = here().page()
          let limit = calc.ceil(last / 2)

          if last > 20 {
            // Two rows for 20+ pages
            v(-space / 1.3)
            for i in range(1, limit + 1) {
              if i <= current {
                link((page: i, x: 0pt, y: 0pt))[
                  #box(circle(radius: 0.06cm, fill: fill-color, stroke: 1pt + fill-color))
                ]
              } else {
                link((page: i, x: 0pt, y: 0pt))[
                  #box(circle(radius: 0.06cm, stroke: 1pt + fill-color))
                ]
              }
            }
            v(-space / 1.6)
            linebreak()
            for i in range(limit + 1, last + 1) {
              if i <= current {
                link((page: i, x: 0pt, y: 0pt))[
                  #box(circle(radius: 0.06cm, fill: fill-color, stroke: 1pt + fill-color))
                ]
              } else {
                link((page: i, x: 0pt, y: 0pt))[
                  #box(circle(radius: 0.06cm, stroke: 1pt + fill-color))
                ]
              }
            }
          } else {
            // Normal counter for < 20 pages
            v(-space / 1.5)
            for i in range(1, last + 1) {
              if i <= current {
                link((page: i, x: 0pt, y: 0pt))[
                  #box(circle(radius: 0.08cm, fill: fill-color, stroke: 1pt + fill-color))
                ]
              } else {
                link((page: i, x: 0pt, y: 0pt))[
                  #box(circle(radius: 0.08cm, stroke: 1pt + fill-color))
                ]
              }
            }
          }
        }
      } else if count == "dot-section" {
        // DOT SECTION COUNTER
        v(-space / 1.5)
        set align(right + top)
        context {
          let last = counter(page).final().first()
          let current = here().page()

          let sections = query(heading.where(level: 1))
          let current_section_nr = counter(heading).get().at(0)
          let current_section_page = {
            if current_section_nr > 0 {
              sections.at(int(current_section_nr - 1)).location().page()
            } else { 1 }
          }

          let next_section_page = {
            if current_section_nr < int(sections.len()) {
              sections.at(int(current_section_nr)).location().page()
            } else { last }
          }

          if next_section_page - current_section_page < 3 {
            // Skip counter for single-page sections
          } else if current_section_nr < int(sections.len()) {
            // Section start marker
            link((page: current_section_page, x: 0pt, y: 0pt))[
              #box(rotate(-90deg)[#polygon.regular(stroke: 1pt + fill-color, size: 0.2cm, vertices: 3)]) #h(0.1cm)
            ]
            // Page dots
            for i in range(current_section_page + 1, next_section_page) {
              if i <= current {
                link((page: i, x: 0pt, y: 0pt))[
                  #box(circle(radius: 0.08cm, fill: fill-color, stroke: 1pt + fill-color))
                ]
              } else {
                link((page: i, x: 0pt, y: 0pt))[
                  #box(circle(radius: 0.08cm, stroke: 1pt + fill-color))
                ]
              }
            }
            // Section end marker
            link((page: next_section_page, x: 0pt, y: 0pt))[
              #h(0.1cm) #box(rotate(90deg)[#polygon.regular(stroke: 1pt + fill-color, size: 0.2cm, vertices: 3)])
            ]
          } else {
            // Last section
            link((page: current_section_page, x: 0pt, y: 0pt))[
              #box(rotate(-90deg)[#polygon.regular(stroke: 1pt + fill-color, size: 0.2cm, vertices: 3)]) #h(0.1cm)
            ]
            for i in range(current_section_page + 1, next_section_page + 1) {
              if i <= current {
                link((page: i, x: 0pt, y: 0pt))[
                  #box(circle(radius: 0.08cm, fill: fill-color, stroke: 1pt + fill-color))
                ]
              } else {
                link((page: i, x: 0pt, y: 0pt))[
                  #box(circle(radius: 0.08cm, stroke: 1pt + fill-color))
                ]
              }
            }
          }
        }
      }
    ],
    header-ascent: 0%,

    // FOOTER
    footer: [
      #if footer == true {
        set text(0.7em)
        if theme == "full" {
          columns(2, gutter: 0cm)[
            #align(left)[#block(
              width: 100%,
              outset: (left: 0.5 * space, bottom: 0cm),
              height: 0.3 * space,
              fill: fill-color,
              inset: (right: 3pt),
            )[
              #v(0.1 * space)
              #set align(right)
              #smallcaps()[#if footer-title != none { footer-title } else { title }]
            ]]
            #align(right)[#block(
              width: 100%,
              outset: (right: 0.5 * space, bottom: 0cm),
              height: 0.3 * space,
              fill: body-color,
              inset: (left: 3pt),
            )[
              #v(0.1 * space)
              #set align(left)
              #if footer-subtitle != none {
                footer-subtitle
              } else if subtitle != none {
                subtitle
              } else if authors != none {
                if type(authors) != array { authors = (authors,) }
                authors.join(", ", last: " and ")
              } else [#date]
            ]]
          ]
        } else if theme == "normal" {
          stack(
            dir: ttb,
            spacing: 4pt,
            grid(
              columns: (1fr, 1fr),
              column-gutter: 0pt,
              line(length: 100%, stroke: 2pt + fill-color), line(length: 100%, stroke: 2pt + body-color),
            ),
            grid(
              columns: (1fr, 1fr, auto),
              align: (right, left, right),
              inset: 3pt,
              [#smallcaps()[
                #if footer-title != none { footer-title } else { title }]],
              [#if footer-subtitle != none {
                footer-subtitle
              } else if subtitle != none {
                subtitle
              } else if authors != none {
                if type(authors) != array { authors = (authors,) }
                authors.join(", ", last: " and ")
              } else [#date]],
              context [#here().page() / #counter(page).final().first()],
            ),
          )
        }
      }
    ],
    footer-descent: 0.15 * space,
  )


  // SLIDES STYLING --------------------------------------------------
  // Section Slides
  show heading.where(level: 1): x => {
    set page(header: none, footer: none, margin: 0cm)
    set align(horizon)
    grid(
      columns: (1fr, 3fr),
      inset: 10pt,
      align: (horizon, left),
      fill: (title-color, bg-color),
      [#block(height: 100%)[
        #place(
          horizon + right,
          image(section-image, height: 90%),
          dx: 107pt,
          dy: 70pt,
        )
      ]],
      [#text(1.2em, weight: "bold", fill: title-color)[#x]],
    )
  }
  show heading.where(level: 2): pagebreak(weak: true)
  show heading: set text(1.1em, weight: "bold", fill: title-color)


  // ADDITIONAL STYLING --------------------------------------------------
  // Terms
  show terms.item: it => {
    set block(width: 100%, inset: 5pt)
    stack(
      block(fill: header-color, radius: (top: 0.2em, bottom: 0cm), strong(it.term)),
      block(fill: block-color, radius: (top: 0cm, bottom: 0.2em), it.description),
    )
  }

  // Code
  show raw.where(block: false): it => {
    box(fill: block-color, inset: 1pt, radius: 1pt, baseline: 1pt)[#text(it)]
  }

  show raw.where(block: true): it => {
    block(radius: 0.5em, fill: block-color, width: 100%, inset: 1em, it)
  }

  // Bullet List
  show list: set list(marker: (
    text(fill: title-color)[•],
    text(fill: title-color)[‣],
    text(fill: title-color)[-],
  ))

  // Enum
  let color_number(nrs) = text(fill: title-color)[*#nrs.*]
  set enum(numbering: color_number)

  // Table
  show table: set table(
    stroke: (x, y) => (
      x: none,
      bottom: 0.8pt + black,
      top: if y == 0 { 0.8pt + black } else if y == 1 { 0.4pt + black } else { 0pt },
    ),
  )

  show table.cell.where(y: 0): set text(style: "normal", weight: "bold")

  set table.hline(stroke: 0.4pt + black)
  set table.vline(stroke: 0.4pt)

  // Quote
  set quote(block: true)
  show quote.where(block: true): it => {
    v(-5pt)
    block(
      fill: block-color,
      inset: 5pt,
      radius: 1pt,
      stroke: (left: 3pt + fill-color),
      width: 100%,
      outset: (left: -5pt, right: -5pt, top: 5pt, bottom: 5pt),
    )[#it]
    v(-5pt)
  }

  // Footnote
  set footnote(numbering: "①")
  set footnote.entry(separator: line(length: 30%, stroke: 0.5pt + fill-color))
  show footnote.entry: it => {
    let loc = it.note.location()
    let num = numbering("①", ..counter(footnote).at(loc))
    set text(size: 0.8em, fill: luma(80))
    [#text(fill: title-color)[#num] #it.note.body]
  }
  show footnote: set text(fill: title-color)

  // Figure Caption
  show figure.caption: it => {
    set text(size: 0.8em)
    strong([
      #text(fill: title-color)[#it.supplement #context it.counter.display(it.numbering)]#text(fill: title-color)[:]
    ])
    [ #it.body]
  }

  // Link
  show link: it => {
    if type(it.dest) != str {
      it // Local Links
    } else {
      underline(stroke: 0.5pt + title-color)[#it] // Web Links
    }
  }

  // References (pill-shaped links to headings, figures, etc.)
  show ref: it => {
    if it.element != none {
      let el = it.element
      set text(size: 0.7em, fill: white)
      box(
        fill: fill-color,
        outset: (x: 0.0em, y: 0.2em),
        radius: 0.8em,
        height: 0.8em,
        inset: (x: 0.5em),
      )[
        #if el.func() == heading and it.supplement == auto {
          link(el.location(), el.body)
        } else if el.func() == heading {
          link(el.location(), it.supplement.text)
        } else {
          it
        }
      ]
    } else {
      return it // citations
    }
  }

  // Outline
  set outline(
    target: heading.where(level: 1),
    indent: auto,
  )
  show outline: set heading(level: 2)

  // Bibliography
  set bibliography(title: none, style: "ieee")
  show bibliography: set text(size: 0.7em)
  show bibliography: set block(spacing: 0.5em)


  // CONTENT ---------------------------------------------
  // Title Slide
  if title == none {
    panic("A title is required")
  } else if first-slide == false {
    // Skip built-in title slide for custom arrangements
  } else {
    if type(authors) != array {
      authors = (authors,)
    }
    set page(footer: none, header: none, margin: 0cm)
    // Title block
    block(
      inset: (x: 0.5 * space, y: 1em),
      fill: title-color,
      width: 100%,
      height: 60%,
      align(bottom)[#text(2.0em, weight: "bold", fill: bg-color, title)],
    )
    // Subtitle block
    block(
      above: 0%,
      height: 20%,
      width: 100%,
      inset: (x: 0.5 * space, top: 1em, bottom: 1em),
      if subtitle != none {
        [#text(1.4em, fill: title-color, weight: "bold", subtitle)]
      },
    )
    // Authors + logo block
    block(
      above: 0%,
      height: 20%,
      width: 100%,
      inset: 0em,
      grid(
        columns: (2fr, 1fr),
        align: (left + bottom, right + bottom),
        inset: 0em,
        gutter: 0em,
        block(
          width: 100%,
          height: 100%,
          inset: (x: 0.6 * space, y: 0.35 * space),
        )[#align(left + bottom)[
          #if date != none [#date \ ]
          #authors.join(", ", last: " & ")
        ]],
        block(
          width: 120%,
          height: 120%,
          inset: (x: 0.3 * space, y: 0.35 * space),
        )[#image(logo)],
      ),
    )
  }

  // Outline
  if toc == true {
    outline()
  }

  // The body of the slides
  content
}
