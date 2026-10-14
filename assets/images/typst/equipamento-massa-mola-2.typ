// Bibliotecas importadas
#import "@preview/cetz:0.4.2" // Desenho vetorial
#import "@preview/cetz-plot:0.1.3": plot, chart
#import "@preview/inknertia:0.1.0": newtonian
#import newtonian: *

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

  let suporte-funcao = (
    x0, y0, dx, n, 
    suporte: true, 
    regua: true, 
    marcacao: true
  ) => {

    // =========================
    // Escala e Dimensões
    // =========================

    let s = 2
    let h = 3.5 * s
    let e = 0.13 * s

    // (x0, y0) agora é o ponto superior da mola (x_mola, y_mola_ini)
    let x_mola = x0
    let y_mola_ini = y0

    // Coordenadas derivadas para alinhar a estrutura ao topo da mola
    let y_braco = y_mola_ini + e/2
    let x_haste = x0 - 0.3 * h
    let y_base = y_braco - 0.85 * h

    // =========================
    // Suporte (Base, Haste, Braço, Presilha)
    // =========================

    if suporte {
      let base_largura = 1 * s
      let base_y_superior = 0.4 * s
      let base_y_inferior = 0.6 * s
      let base_profundidade = e

      let v1 = (x_haste - base_largura, y_base + base_y_superior)
      let v2 = (x_haste + base_largura, y_base + base_y_superior)
      let v3 = (x_haste, y_base - base_y_inferior)

      // Base 3D
      line(
        v1, v2, v3,
        close: true,
        stroke: none,
        fill: uft-gray.lighten(50%)
      )

      line(
        v1,
        v3,
        (v3.at(0), v3.at(1)),
        (v3.at(0), v3.at(1) - base_profundidade),
        (v1.at(0), v1.at(1) - base_profundidade),
        close: true,
        stroke: none,
        fill: uft-gray.lighten(60%)
      )

      line(
        v2,
        v3,
        (v3.at(0), v3.at(1)),
        (v3.at(0), v3.at(1) - base_profundidade),
        (v2.at(0), v2.at(1) - base_profundidade),
        close: true,
        stroke: none,
        fill: uft-gray.lighten(30%)
      )

      // Haste vertical
      rect(
        (x_haste - e/2, y_base),
        (x_haste + e/2, y_base + h),
        stroke: none,
        fill: uft-gray.lighten(30%)
      )

      // Braço horizontal
      rect(
        (x_haste - 0.15*h, y_braco - e/2),
        (x_haste + 0.35*h, y_braco + e/2),
        stroke: none,
        fill: uft-gray.lighten(30%)
      )

      // Presilha
      polygon(
        (x_haste, y_braco),
        6,
        radius: 0.18 * s,
        stroke: none,
        fill: uft-gray
      )

      polygon(
        (x_haste, y_braco),
        6,
        radius: 0.1 * s,
        stroke: none,
        fill: uft-gray.lighten(40%)
      )
    }

    // =========================
    // Mola
    // =========================

    let l = 0.25 * (1 + dx) * h
    let mola_amplitude = 0.6 * e
    let mola_voltas = 10

    let y_mola_fim = y_mola_ini - l

    spring(
      (x_mola, y_mola_ini),
      (x_mola, y_mola_fim),
      mola_amplitude,
      mola_voltas,
      starthook: 0.05,
      endhook: 0.05,
      color: uft-blue
    )

    // =========================
    // Porta-massas
    // =========================

    let porta_raio = e/3
    let y_porta = y_mola_fim - porta_raio

    circle(
      (x_mola, y_porta),
      radius: porta_raio,
      stroke: uft-blue
    )

    line(
      (x_mola + e/2, y_porta - e/2),
      (x_mola, y_porta),
      (x_mola - e/2, y_porta - e/2),
      (x_mola, y_porta - e),
      (x_mola, y_porta - 1.7*e),
      (x_mola - 1.2*e, y_porta - 1.7*e),
      (x_mola - 1.2*e, y_porta - 6*e),
      (x_mola + 1.2*e, y_porta - 6*e),
      (x_mola + 1.2*e, y_porta - 4*e)
    )

    arc(
      (x_mola, y_porta - 2*e/3),
      start: -90deg,
      delta: 180deg,
      radius: porta_raio,
      stroke: uft-blue
    )

    // =========================
    // Massas
    // =========================

    let massa_x = x_mola + 1.2*e
    let massa_y = y_porta - 6*e
    let massa_largura = 2*e
    let massa_altura = e/4
    let massa_passo = e/3

    for i in range(n) {
      rect(
        (
          massa_x - e,
          massa_y + i*massa_passo
        ),
        (
          massa_x + e,
          massa_y + i*massa_passo + massa_altura
        ),
        stroke: none,
        fill: uft-gray.lighten(20%)
      )
    }

    // =========================
    // Variáveis auxiliares para Régua e Marcação
    // =========================

    let regua_x = x_haste + 0.1*h
    let regua_largura = 1.5*e
    let regua_altura = 20*e
    let regua_y = y_base + 0.9*h
    let y_leitura = y_porta + 0.5*e

    // =========================
    // Régua e Divisões
    // =========================

    if regua {
      rect(
        (regua_x, regua_y),
        (regua_x + regua_largura, regua_y - regua_altura),
        stroke: uft-gray + 0.6pt,
        fill: uft-gray.lighten(80%)
      )

      circle(
        (
          regua_x + regua_largura/2,
          y_braco
        ),
        radius: e/5,
        stroke: none,
        fill: uft-gray
      )

      let regua_divisoes = 25
      let regua_passo = 0.7*e

      for i in range(regua_divisoes) {
        line(
          (
            regua_x + e/2,
            y_base + 0.84*h - e/2 - i*regua_passo
          ),
          (
            regua_x + regua_largura,
            y_base + 0.84*h - e/2 - i*regua_passo
          ),
          stroke: uft-gray + 0.8pt,
        )
      }
    }

    // =========================
    // Marcações e Indicações de Medida
    // =========================

    if marcacao {
      line(
        (
          regua_x + regua_largura,
          y_leitura
        ),
        (
          regua_x + 3.7*e,
          y_leitura
        ),
        stroke: 2pt,
        mark: (
          start: "stealth",
          fill: black
        ),
        name: "marcacao"
      )

      line(
        (
          regua_x + 3.4*e,
          y_braco - e/2
        ),
        (
          regua_x + 3.4*e,
          y_leitura
        ),
        mark: (
          start: "|",
          end: "|",
          fill: black
        ),
        name: "medida"
      )

      if (n == 0) {
        content(
          "medida.mid",
          box(
            fill: white,
            inset: 5pt,
            [$l_0$]
          )
        )
      } else {
        content(
          "medida.mid",
          box(
            fill: white,
            inset: 5pt,
            [$l_i$]
          )
        )
      }
    }
  }

 

  // Figura Final

  line(
    (3, 0.5), (11.4, 0.5),
    mark: (
      start: "stealth",
      end: "stealth",
      fill: black
    ),
    name: "periodo"
  )
  content("periodo.mid",
  
  box(
      fill: white,
      inset: 5pt,
      [$T$]
    )
  )

  line(
    (0,-3.07), (12, -3.07),
    stroke: (
      dash: "dashed",
      paint: uft-gray.lighten(40%)
    )
  )
  

  line(
    (0,-3.92), (12, -3.92),
    stroke: (
      dash: "dashed",
      paint: uft-gray.lighten(40%)
    )
  )

  line(
    (0,-4.77), (12, -4.77),
    stroke: (
      dash: "dashed",
      paint: uft-gray.lighten(40%)
    )
  )

  // line(
  //   (2,-3.07),
  //   (2,-4.77),
  //   mark: (
  //     start: "stealth",
  //     end: "stealth",
  //     fill: black
  //   ),
  //   name: "amplitude"
  // )
  // content("amplitude.mid",
  
  // box(
  //     fill: white,
  //     inset: 5pt,
  //     [$A$]
  //   )
  // )

  let n = 7
  for i in range(n) {
    let x = 3 + 1.2*i
    // Varia o ângulo de 0 até 2*pi ao longo dos 5 passos
    let angulo = i * (2 * calc.pi / (n - 1))
    // Amplitude de oscilação (ajuste o 0.3 conforme a variação desejada)
    let dx = 0.3 + 0.5 * calc.sin(angulo)

    suporte-funcao(x, 0, dx, 5, suporte: false, regua: false, marcacao: false)
  }

  suporte-funcao(0.6, 0, 0.3, 5, regua: false, marcacao: false)
  


  // line((-2, 0), (2, 0), (0,-2), close: true, fill: uft-gray.lighten(50%), stroke:none)
  // line((-2, 0), (0, -2), (0, -2.2), (-2, -0.2), close: true, fill: gray.lighten(20%), stroke:none)

  // line((0, -2), (2, 0), (2, -0.2), (0, -2.2), close: true, fill: uft-gray.lighten(10%), stroke: none)

  // rect((-.15, -.6), (.15, 7), fill: uft-gray.lighten(30%), stroke: none)

  // rect((-1, 6.15), (2.75, 5.85), fill: uft-gray.lighten(30%), stroke: none)

  // polygon((0, 6), 6, radius: 0.35, angle: 30deg, fill: uft-gray, stroke: none)
  // polygon((0, 6), 6, radius: 0.20, angle: 30deg, fill: uft-gray.lighten(20%), stroke: none)

  // spring((2.4, 5.85), (2.4, 3.5), 0.2, 10, starthook: 0.05, endhook: 0.05, color: uft-blue)

  // circle((2.4, 3.4), radius: 0.1, stroke: uft-blue+1pt)

  // line((2.6, 3.2), (2.4, 3.4), (2.2, 3.2), (2.4, 3), (2.4, 2.8), (2.1, 2.8), (2.1, 1.6), (2.7, 1.6), (2.7, 2.25))

  // for i in range(5) {
  //   rect((2.3, 1.62 + i*.12), (3, 1.72 + i*.12), fill: uft-gray, stroke: none)
  // }

  // line((1.5, 3.4), (2.2, 3.4), mark: (end: "stealth", fill: black), stroke: 3pt)

  // rect((1, 6.13), (1.5, 0.5), fill: uft-gray.lighten(80%), stroke: uft-gray+1pt)

  // for i in range(24) {
  //   line((1.3, 5.4 - i/5), (1.5, 5.4 - i/5), stroke: uft-gray+1pt)
  // }

})