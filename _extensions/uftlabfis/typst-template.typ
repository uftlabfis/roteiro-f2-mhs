// Bibliotecas importadas
#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.3": plot, chart
#import "@preview/subpar:0.2.2"

// 🎨 Cores Institucionais
#let uft-green = rgb("#008577")
#let uft-blue = rgb("#004A80")
#let uft-yellow = rgb("#FDB913")
#let uft-gray = rgb("#666666")
#let primary-color = uft-blue
#let secondary-color = uft-green

// Remove a numeração automática de equações
#let nonum(eq) = math.equation(block: true, numbering: none, eq)

// 📦 Caixa de destaque (ex: definições)
#let info-box(title, content) = {
  set text(size: 10pt)
  block(
    fill: primary-color.transparentize(80%), inset: 8pt, radius: 2pt, width: 100%,
    stroke: (left: (thickness: 4pt, paint: primary-color))
  )[
    #set align(center)
    #text(fill: primary-color, weight: "semibold", size: 10pt)[*#title*]
    
    #set align(left)
    #set par(first-line-indent: (amount: 0em))
    #content
  ]
}

// 🏛️ Função do Cabeçalho de Título Principal
#let main-title(title, authors) = {
  rect(height: 1.5pt, fill: primary-color, width: 100%)
  
  let authors-text = if type(authors) == array {
    authors.map(a => a.name).join(", ")
  } else {
    authors
  }

  grid(
    columns: (8fr, 2fr),
    align: (right + horizon, right),
    [
      #text(size: 12pt)[
        UNIVERSIDADE FEDERAL DO *TOCANTINS*\
        Câmpus Universitário de *Palmas*\
        #if authors-text != none [ #authors-text ]
      ]
    ],
    [
      #image("assets/images/labfis-logo-transparente.png", width: 2.5cm)
    ]
  )
  rect(height: 1.5pt, fill: primary-color, width: 100%)
  v(0.3cm)
  block(
    below: 0.5em, 
    fill: primary-color, 
    inset: (x: 8pt, y: 8pt), 
    width: 100%, 
    radius: 4pt
  )[
    #align(center + horizon)[
      #upper(text(weight: "bold", fill: white, size: 15pt)[#title])
    ]
  ]
  v(0.3cm)
}

// ⚙️ Função Principal (Article)
#let article(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: "Resumo",
  cols: 2,
  margin: (top: 2cm, bottom: 2cm, left: 1.25cm, right: 1.25cm),
  paper: "a4",
  lang: "pt",
  region: "BR",
  font: "Arial",
  fontsize: 12pt,
  sectionnumbering: "1.1.",
  pagenumbering: "1",
  url: "https://github.com",
  doc,
) = {
  // 📄 Configuração da página
  set page(
    paper: paper, 
    margin: margin,
    columns: cols, 
    numbering: pagenumbering,
    
    // 🔝 Cabeçalho condicional (páginas > 1)
    header: context {
      let current-page = counter(page).get().at(0)
      if current-page > 1 {
        set par(first-line-indent: 0pt)
        set text(size: 9pt, fill: uft-gray)
        let author-name = if type(authors) == array and authors.len() > 0 { authors.at(0).name } else { "" }
        
        if calc.odd(current-page) {
          align(left)[#title #h(1fr) #counter(page).display("1")]
        } else {
          align(left)[#counter(page).display("1") #h(1fr) #author-name / UFT]
        }
        v(-0.3em)
        line(length: 100%, stroke: 0.5pt + primary-color)
      }
    },
    
    // 🔚 Rodapé com link
    footer: context {
      let current-page = counter(page).get().at(0)
      set text(size: 9pt, fill: secondary-color)
      set par(first-line-indent: 0pt)
      line(length: 100%, stroke: 0.5pt + primary-color)
      
      if calc.odd(current-page) {
        align(right)[#link(url)[#url.replace("\\/", "/")]]
      } else {
        align(left)[#link(url)[#url.replace("\\/", "/")]]
      }
    }
  )

  // ✍️ Estilo geral de texto e parágrafos
  set text(lang: lang, region: region, size: fontsize, font: font)
  set par(
    first-line-indent: (all: true, amount: 1.25cm),
    justify: true,
    leading: 0.65em
  )

// 🧭 Títulos (Headings) alinhados à esquerda sem recuo de parágrafo
  set heading(numbering: sectionnumbering)
  show heading: it => {
    // ❌ Anula o recuo de parágrafo configurado globalmente para o título
    set par(first-line-indent: 0pt)
    
    set text(size: 12pt, fill: primary-color, weight: "semibold")
    
    // Recupera a numeração formatada
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
    } else {
      none
    }

    if it.level == 1 {
      // Exibe numeração + título sem recuo inicial
      if number != none [#number #upper(it.body)] else [#upper(it.body)]
      v(-0.3cm)
      rect(height: 1pt, fill: primary-color, width: 100%)
      v(0.25cm)
    } else {
      // Exibe numeração + título das subseções sem recuo inicial
      if number != none [#number #it.body] else [#it.body]
      v(0.25cm)
    }
  }

  // ∑ Equações numeradas
  set math.equation(numbering: "(1)", number-align: bottom)

  // 📌 Marcadores de Listas
  set list(marker: text(primary-color)[•])
  set enum(
    numbering: it => context {
      let headings = counter(heading).get()
      let sec = headings.at(0)
      if headings.len() > 1 {
        let subsec = headings.at(1)
        text(primary-color)[#sec.#subsec.#it.]
      } else {
        text(primary-color)[#sec.#it.]
      }
  })

  // 🖼️ Figuras e tabelas
  set figure.caption(position: top)
  show figure.caption: set text(size: 10pt)

  // 🖼️ Tabelas personalizadas UFT
  set table(
    stroke: (x, y) => if y == 0 {
      (top: 0.7pt + primary-color)
      (bottom: 0.7pt + primary-color)
      if x > 0 {
        (left: 0.7pt + primary-color)
      }
    } else {
      (bottom: 0.7pt + primary-color)
      if x > 0 {
        (left: 0.7pt + primary-color)
      }
    },
    fill: (x, y) => if y == 0 {
      primary-color.transparentize(60%)
    } else {
      if calc.even(y) {
        primary-color.transparentize(80%)
      }
    }
  )
  show table: set text(size: 10pt)
  show table.cell.where(y: 0): strong

  // 📌 Banner superior no topo da primeira página (Flutuante cobrindo as colunas)
  place(
    top + center,
    float: true,
    scope: "parent"
  )[
    #main-title(title, authors)
    
    #if abstract != none [
      #block(
        width: 100%,
        fill: rgb("#f9f9f9"),
        inset: 10pt,
        radius: 2pt,
        stroke: (left: 2pt + primary-color)
      )[
        #set par(first-line-indent: 0pt)
        #text(weight: "bold", fill: primary-color)[#abstract-title:] #abstract
      ]
      #v(0.4cm)
    ]
  ]

  // Corpo do documento
  doc
}