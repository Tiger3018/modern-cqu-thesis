#import "../utils/datetime-display.typ": datetime-display
#import "../utils/style.typ": 字号, 字体

// 本科生封面
#let bachelor-cover(
  // documentclass 传入的参数
  anonymous: false,
  twoside: false,
  fonts: (:),
  info: (:),
  // 其他参数
  stoke-width: 0.5pt,
  min-title-lines: 2,
  info-inset: (x: 0pt, bottom: 1pt),
  info-key-width: 120pt,
  info-key-font: "黑体",
  info-value-font: "黑体",
  column-gutter: -3pt,
  row-gutter: 11.5pt,
  anonymous-info-keys: ("grade", "student-id", "author", "supervisor", "supervisor-ii"),
  bold-info-keys: ("title",),
  bold-level: "bold",
  datetime-display: datetime-display,
) = {
  // 1.  默认参数
  fonts = 字体 + fonts
  info = (
    title: ("基于 Typst 的", "现代大学学位论文"),
    grade: "20XX",
    student-id: "1234567890",
    author: "张三",
    department: "某学院",
    major: "某专业",
    supervisor: ("李四", "教授"),
    submit-date: datetime.today(),
  ) + info

  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if type(info.title) == str {
    info.title = info.title.split("\n")
  }
  // 2.2 根据 min-title-lines 填充标题
  info.title = info.title + range(min-title-lines - info.title.len()).map((it) => "　")
  // 2.3 处理提交日期
  if type(info.submit-date) == datetime {
    info.submit-date = datetime-display(info.submit-date)
  }

  // 3.  内置辅助函数
  let info-key(body) = {
    rect(
      width: 100%,
      inset: info-inset,
      stroke: none,
      text(
        font: fonts.at(info-key-font, default: "楷体"),
        size: 字号.三号,
        {if body.len() > 3 {body+"："} else {}}
      ),
    )
  }

  let info-value(key, body) = {
    set align(left)
    rect(
      width: 100%,
      inset: info-inset,
      stroke: none,
      text(
        font: fonts.at(info-value-font, default: "宋体"),
        size: 字号.三号,
        weight: if (key in bold-info-keys) { bold-level } else { "regular" },
        bottom-edge: "descender",
        body,
      ),
    )
  }

  let info-long-value(key, body) = {
    grid.cell(colspan: 3,
      info-value(
        key,
        if anonymous and (key in anonymous-info-keys) {
          "██████████"
        } else {
          body
        }
      )
    )
  }

  let info-short-value(key, body) = {
    info-value(
      key,
      if anonymous and (key in anonymous-info-keys) {
        "█████"
      } else {
        body
      }
    )
  }
  

  // 4.  正式渲染
  
  pagebreak(weak: true, to: if twoside { "odd" })

  // 居中对齐
  set align(center)

  v(10pt)
  text(size: 字号.小二, font: fonts.黑体, weight: "bold")[
    重庆大学本科学生毕业论文（设计）
  ]
  v(60pt)
  {
    set text(size: 字号.二号, font: fonts.黑体, weight: "bold");
    info.title.join("\n")
  }

  // 匿名化处理去掉封面标识
  if anonymous {
    v(150pt)
  } else {
    // 封面图标
    v(60pt)
    image("cqu-thesis/assets/vi/cqu-emblem-blue.svg", width: 3.5cm)
  }

  if anonymous {
    v(40pt)
  } else {
    v(40pt)
  }

  block(width: 9cm, grid(
    columns: (80pt-2*column-gutter, 1fr, info-key-width, 1fr),
    column-gutter: column-gutter,
    row-gutter: row-gutter,
    info-key("学　　生"),
    info-long-value("author", info.author),
    info-key("学　　号"),
    info-long-value("student-id", info.student-id),
    info-key("指导教师"),
    info-long-value("supervisor", info.supervisor.at(0)),
    ..(if info.supervisor-ii != () {(
      info-key("助理指导教师"), // TODO
      info-long-value("supervisor-ii", info.supervisor-ii.at(0)),
    )} else {()}),
    info-key("专　　业"),
    info-long-value("major", info.major)
  ))

  v(20pt)
  {
    set text(size: 字号.小二, font: fonts.黑体, weight: "bold");
    if(type(info.department) == array){
      info.department.at(0)
      if(info.department.len() != 1){
        linebreak()
        info.department.at(1)
      }
    } else {
      info.department
    }
    v(10pt)
    set text(size: 字号.三号, font: fonts.黑体, weight: "bold");
    info.submit-date
  }

}