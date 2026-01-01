#import "../utils/fonts.typ": 字体, 字号
#import "../utils/datetime-display.typ": datetime-display
#import "../utils/twoside.typ": *


#let undergraduate-cover(
  info: (:),
  // 其他参数
  stoke-width: 0.5pt,
  row-gutter: 11.5pt,
  anonymous-info-keys: ("grade", "student-id", "author", "supervisor"),
) = {
  info = (
    (
      title: ("毕业论文/设计", "题目"),
      grade: "20XX",
      student-id: "1234567890",
      author: "张三",
      department: "某学院",
      major: "某专业",
      supervisor: ("李四", "教授"),
      submit-date: datetime.today(),
    )
      + info
  )


  if type(info.submit-date) == datetime {
    info.submit-date = datetime-display(info.submit-date)
  }

  context {
    twoside-pagebreak
    counter(page).update(0)

    set text(weight: "bold", font: 字体.仿宋)


    set align(center)


    v(22pt)
    image("../assets/zju-emblem.svg", width: page.width * 0.25)

    image("../assets/zju-name.svg", width: page.width * 0.5)
    v(25pt)

    let numspacing = if info.title.len() <= 2 {
      2
    } else if info.title.len() == 3 {
      1
    } else {
      0
    }

    block(
      [
        #set text(size: 14pt)
        #grid(
          columns: (5.5em, 23em),
          align: (start, center),
          rows: 1.2em,
          stroke: (x, y) => (
            bottom: if x == 1 {
              stoke-width
            } else {
              none
            },
          ),
          row-gutter: row-gutter,
          text[题目<mzt:no-header-footer>], info.title.first(),
          ..info.title.slice(1).map(v => (none, v)).flatten(),
          ..range(0, numspacing)
            .map(_ => (
              grid.cell(stroke: none)[],
              grid.cell(stroke: none)[],
            ))
            .flatten(),
          ..info.author,
          "指导教师", info.supervisor,
          grid.cell(stroke: none)[], grid.cell(stroke: none)[],
          "递交日期", info.submit-date,
        )
      ],
    )
  }
  twoside-emptypage
}
