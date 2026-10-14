// Bibliotecas importadas
#import "@preview/cetz:0.4.2" // Desenho vetorial
#import "@preview/cetz-plot:0.1.3": plot, chart
#import "@preview/inknertia:0.1.0": newtonian
#import newtonian: *

#set page(width: auto, height: auto, margin: 5pt) 
#set text(lang: "pt", region: "BR", size: 13pt, font: "Arial")

// 🎨 Definição de Cores
#let uft-green = rgb("#008577")
#let uft-blue = rgb("#004A80")
#let uft-yellow = rgb("#FDB913")
#let uft-gray = rgb("#666666")
#let primary-color = uft-blue
#let secondary-color = uft-green

#cetz.canvas({
  import cetz.draw: *

  // ====================
  // Função que desenha um sistema massa-mola em MHS
  // ====================
  let draw-mhs = (
    x0: 0, y0: 0, t: 0,
    m0: 0.01,
    l0: 3,
    n: 5,
    k: 1,
    A: 0,
    suporte: false,
    regua: false,
    marcacao: false,
    forca: false
  ) => {
    // Parâmetros físicos
    let g = 10
    let w = if n > 0 { calc.sqrt(k / (n * m0)) } else { 0 }
    let e = l0 / 10
    
    // Deformação de equilíbrio estático (dx0 = m_total * g / k)
    let dx0 = if n > 0 { n * m0 * g / k } else { 0 }

    // Posição da extremidade inferior no MHS:
    // u(t) = y_eq + A * cos(w * t)
    // Onde y_eq = y0 - l0 - dx0
    let u = if n == 0 {
      y0 - l0
    } else if A == 0 {
      y0 - l0 - dx0
    } else {
      (y0 - l0 - dx0) - A * calc.cos(w * t)
    }

    

    // Mola
    spring(
      (x0, y0), (x0, u),
      e, 10,
      starthook: 5%,
      endhook: 6%,
      endcircle: true,
      color: uft-blue
    )

    // Suporte porta-pesos
    let d = 0.5 * e
    line(
      (x0 + d, u - d),
      (x0, u), 
      (x0 - d, u - d),
      (x0, u - 2*d),
      (x0, u - 3*d),
      (x0 - 1.5*d, u - 3*d),
      (x0 - 1.5*d, u - 10*d),
      (x0 + 1.5*d, u - 10*d),
      (x0 + 1.5*d, u - 7*d),
      stroke: uft-gray
    )

    // Massas Acopláveis
    for i in range(n) {
      rect(
        (x0, u - 9.8*d + 0.5 * d * i),
        (x0 + 3 * d, u - 9.9*d + 0.5 * d * (i + 1)),
        stroke: none,
        fill: uft-gray.lighten(50%)

      )
    }

    if suporte {
      let haste-horizontal = 1.5 * l0
      let haste-vertical = 3.5 * l0


      line(
        (x0 + 4.5 * e - 1.5*haste-horizontal, y0 - haste-vertical + 5 * e),
        (x0 + 4.5 * e - 0.5*haste-horizontal, y0 - haste-vertical + 5 * e),
        (x0 + 4.5 * e - haste-horizontal, y0 - haste-vertical),
        close: true,
        stroke: none, fill: uft-gray.lighten(60%)
      )

      line(
        (x0 + 4.5 * e - 1.5*haste-horizontal, y0 - haste-vertical + 5 * e),
        (x0 + 4.5 * e - haste-horizontal, y0 - haste-vertical),
        (x0 + 4.5 * e - haste-horizontal, y0 - haste-vertical - e),
        (x0 + 4.5 * e - 1.5*haste-horizontal, y0 - haste-vertical + 4 * e),
        close: true,
        stroke: none, fill: uft-gray.lighten(70%)
      )


      line(
        (x0 + 4.5 * e - 0.5*haste-horizontal, y0 - haste-vertical + 5 * e),
        (x0 + 4.5 * e - haste-horizontal, y0 - haste-vertical),
        (x0 + 4.5 * e - haste-horizontal, y0 - haste-vertical - e),
        (x0 + 4.5 * e - 0.5*haste-horizontal, y0 - haste-vertical + 4 * e),
        close: true,
        stroke: none, fill: uft-gray.lighten(40%)
      )


      rect(
        (x0 + 2 * e, y0),
        (x0 + 2 * e - haste-horizontal, y0 + e),
        stroke: none, fill: uft-gray.lighten(40%)
      )

      rect(
        (x0 + 4.0 * e - haste-horizontal, y0 + 3.5 * e),
        (x0 + 5.0 * e - haste-horizontal, y0 + 3.5 * e - haste-vertical),
        stroke: none, fill: uft-gray.lighten(40%)
      )

      polygon(
        (x0 + 4.5 * e - haste-horizontal, y0 + 0.5 * e),
        6,
        radius: 1.5*e,
        stroke: none, fill: uft-gray
      )

      polygon(
        (x0 + 4.5 * e - haste-horizontal, y0 + 0.5 * e),
        6,
        radius: e,
        stroke: none, fill: uft-gray.lighten(40%)
      )
      
    }

    if regua {
      rect(
        (x0 - 0.7*l0 - 0.8*e, y0 + 2*e),
        (x0 - 0.7*l0 + 0.8*e, y0 + 2*e - 3*l0),
        stroke: uft-gray,
        fill: uft-gray.lighten(90%)
      )

      circle(
        (x0 - 0.7*l0, y0 + e/2),
        radius: 0.2
         * e,
        stroke: none, fill: uft-gray
      )

      for i in range(20) {
        line(
          (x0 - 0.7*l0, y0 - (3 * l0 - 4*e) * i/20),
          (x0 - 0.7*l0 + 0.8*e, y0 - (3 * l0 - 4*e) * i/20),
          stroke: uft-gray
        )
      }

      line(
        (x0 - 0.3 * l0, u), (x0 - 0.7 * l0 + 0.8*e, u), 
        stroke: uft-gray + 2pt,
        mark: (end: "stealth", fill: uft-gray),
      )

      line(
        (x0 - 0.3 * l0, y0), (x0 - 0.3 * l0, u),
        mark: (start: "|", end: "|"),
        name: "comprimento"
      )

      let l-content = if n == 0 {$l_0$} else {$l$}
      content("comprimento.mid", box(fill: white, inset: 5pt)[#l-content])
    }




    // Força resultante sobre a massa
    if forca {
      let f = - k * A * calc.cos(w * t)
      if f != 0 {
        line(
          (x0 + 1.5 * d, u - 10*d),
          (x0 + 1.5 * d, u - 10*d - 0.6*f),
          stroke: uft-blue+ 1.5pt,
          mark: (
            end: "stealth",
            fill: uft-blue,
          ),


          name: "forca-elastica"
        )

        let content-anchor = "south-west"
        if f > 0 {
          content-anchor = "north-west"
        }

        content("forca-elastica.end", [$arrow(F)$], anchor: content-anchor, padding: 0.1)
      }
    }

  }

  // Parâmetros do sistema
  let m0 = 0.02
  let n = 5
  let k = 1
  let l0 = 3
  let g = 10
  let du = n * m0 * g / k
  let A = 2 * du
  let w = calc.sqrt(k / (n * m0))
  let T = 2 * calc.pi / w // Período fundamental de oscilação
                          // 
  line(
    (0.5, 0.5), (0.5 + 5*T, 0.5), 
    stroke: uft-blue + 1pt,
    mark: (
      start: "stealth", end: "stealth",
      fill: uft-blue
    ), name: "periodo"
  )

  content("periodo.mid", box(fill: white, inset: 5pt)[$T$])

  line(
    (-2, -l0 - du), (0.5 + 5*T, -l0 - du),
    stroke: (
      dash: "dashed",
      paint: uft-gray.lighten(30%)
    )
  )

  line(
    (-.5 ,-l0 - du - A), (0.5+ 5*T, -l0 - du - A),
    stroke: (
      dash: "dashed",
      paint: uft-gray.lighten(30%)
    )
  )

  line(
    (-.5, -l0 - du + A), (0.5 + 5*T, -l0 - du + A),
    stroke: (
      dash: "dashed",
      paint: uft-gray.lighten(30%)
    )
  )

  line(
    (-.5, -l0 - du), (-.5, -l0 - du + A),
    stroke: uft-gray,
    mark: (
      start: "stealth", end: "stealth",
      fill: uft-gray
    ),
    name: "amplitude"
  )

  content("amplitude.mid", box(fill: white, inset: 5pt)[$A
  $])

  // Mola de referência em equilíbrio estático com massas (A = 0)
  draw-mhs(
    x0: -2, y0: 0,
    n: n, k: k, m0: m0, l0:l0,
    t: 0,
    A: 0,
    suporte: true,
    regua: false, 
    marcacao: true
  )

  // Sequência temporal do MHS cobrindo 2 períodos completos (0 a 2T)
  let num-passos = 6
  for i in range(num-passos + 1) {
    let t = (T) * (i / (num-passos))

    draw-mhs(
      x0: 0.5 + 5*t, y0: 0,
      n: n, k: k, m0: m0, l0:l0,
      t: t, A: A,
      forca: true
    )
  }

  
})