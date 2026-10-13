// Bibliotecas importadas
#import "@preview/cetz:0.4.2" // Desenho vetorial
#import "@preview/cetz-plot:0.1.3": plot, chart

#set page(width: auto, height: auto, margin: 5pt) 
#set text(lang: "pt", region: "BR", size: 12pt, font: "Arial")
// Use margin para dar um respiro, se desejar

// 🎨 Definição de Cores
#let uft-green = rgb("#008577")
#let uft-blue = rgb("#004A80")
#let uft-yellow = rgb("#FDB913")
#let uft-gray = rgb("#666666")
#let primary-color = uft-blue
#let secondary-color = uft-green

#cetz.canvas({
  import cetz.draw: *
  // Suporte
  line((-1, 6.5), (1, 6.5))
  line((0, 6), (0, 6.5))
  for i in range(9) {
    let d = 0.25
    let x = -1 + d * i
    line((x, 6.5), (x+d, 6.5+d))
  }
  // Dinamômetro
  rect((-0.25, 3.75), (0.25, 6), fill: uft-blue, stroke: uft-blue)
  rect((-0.2, 3), (0.2, 3.75), fill: white)
  for i in range(5) {
    let h = 3.2 + i/10
    line((0, h), (0.2, h))
  }
  content(
    (-0.75, 4.5), 
    angle: 90deg,
    [Dinamômetro]
  )
  // Fio
  line((0, 1.3), (0, 3))
  // Corpo de Prova
  rect((-.5,-1.3), (0.5,1.3), fill: uft-yellow.transparentize(50%), stroke: uft-yellow)
  // Fluido
  line((-1.5, 1.5), (-1.5, -3), (1.5, -3), (1.5, 1.5), fill: uft-blue.transparentize(80%), stroke: none)
  // Proveta
  line((-1.5, 2), (-1.5, -3), (1.5, -3), (1.5, 2), stroke: (thickness: 1.5pt))
  for i in range(9) {
    let h = -2.5 + i/2
    line((1.3, h), (1.5, h))
  }
  content(
    (0, -2.75),
    [Proveta]
  )
  // Forças
  circle((0,0), radius: 2pt, fill: black)
  line((0, 0), (0, -2), stroke: (thickness: 1.5pt), mark: (end: "stealth", fill: black), name: "peso")
  content(
    ("peso.end"),
    anchor: "west",
    padding: 0.1, 
    [$arrow(P)$]
  )
  line((0, 0), (0, 1), stroke: (thickness: 1.5pt), mark: (end: "stealth", fill: black), name: "empuxo")
  content(
    ("empuxo.end"),
    anchor: "west",
    padding: 0.1,
    [$arrow(E)$]
  )
  line((0, 1.3), (0, 2.3), stroke: (thickness: 1.5pt), mark: (end: "stealth", fill: black), name: "tensao")
  content(
    ("tensao.end"),
    anchor: "west",
    padding: 0.1,
    [$arrow(T)$]
  )
})
