// Bibliotecas importadas
#import "@preview/cetz:0.4.2" // Desenho vetorial
#import "@preview/cetz-plot:0.1.3": plot, chart
#import "@preview/inknertia:0.1.0": newtonian
#import newtonian: *

#set page(width: auto, height: auto, margin: 10pt) 
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

  line((-5, -4), (5, -4), stroke: (dash: "dashed", paint: black), name:"nivel-negativo")
  content("nivel-negativo.start", [$x < 0$], anchor: "south-west", padding: 0.1)
  line((-5, -6), (5, -6), stroke: (dash: "dashed", paint: black), name:"nivel-0")
  content("nivel-0.start", [$x = 0$], anchor: "south-west", padding: 0.1)
  line((-5, -8), (5, -8), stroke: (dash: "dashed", paint: black), name: "nivel-positivo")
  content("nivel-positivo.start", [$x > 0$], anchor: "south-west", padding: 0.1)

  vector((-4.5, 0), (-4.5, -2))
  content((-4.5, -2.25), [$+$])
  


  wall(((-4, 0), (-2, 0), (-2, 0.5), (-4, 0.5)), stroke-style: 1pt + black, sides: (0, ))
  spring((-3, 0), (-3, -4), 0.6, 10, starthook: 0.15, endhook: 0.2, endcircle: false, color: gray.darken(40%))
  circle((-3, -4), radius: .4, fill: uft-blue.lighten(50%))
  vector((-3, -4), (-3, -5.5), stroke-style: 2pt + uft-blue, fill-paint: uft-blue)
  content((-3.3, -4.75), [$arrow(F)$])


  wall(((-1, 0), (1, 0), (1, 0.5), (-1, 0.5)), stroke-style: 1pt + black, sides: (0, ))
  spring((0, 0), (0, -6), 0.6, 10, starthook: 0.1, endhook: 0.14, endcircle: false, color: gray.darken(40%))
  circle((0, -6), radius: .4, fill: uft-blue.lighten(50%))

  wall(((2, 0), (4, 0), (4, 0.5), (2, 0.5)), stroke-style: 1pt + black, sides: (0, ))
  spring((3, 0), (3, -8), 0.6, 10, starthook: 0.06, endhook: 0.1, endcircle: false, color: gray.darken(40%))
  circle((3, -8), radius: .4, fill: uft-blue.lighten(50%))
  vector((3, -8), (3, -6.5), stroke-style: 2pt + uft-blue, fill-paint: uft-blue)
  content((3.3, -7.25), [$arrow(F)$])
  
})