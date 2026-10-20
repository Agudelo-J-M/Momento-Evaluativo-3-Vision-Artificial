# Momento Evaluativo 3 – Introducción a Visión Artificial

Solución en MATLAB (requiere Image Processing Toolbox).

## Entrega
- **Documento diligenciado:** [`Momento Evaluativo 3 - Solucion.docx`](Momento%20Evaluativo%203%20-%20Solucion.docx), el enunciado con todos los puntos completos (imágenes, tripleta, prompt, integrantes y enlace al video).
- **Video de sustentación:** [`sustentacion/video_sustentacion.mp4`](sustentacion/video_sustentacion.mp4)
- **Presentación:** [`sustentacion/presentacion.html`](sustentacion/presentacion.html) (abrir en el navegador; flechas para avanzar)

## Uso
1. Guarde la imagen generada con IA como `imagenes/imagen_generada.png` (o `.jpg`).
   Si no existe, se usa `peppers.png` como imagen de prueba. Se redimensiona a 1024x1024x3 si hace falta.
2. (Opcional) Ejecute `validacion.m` para comprobar que RGB → espacio → RGB da SSIM = 1.
3. Ejecute `main.m`. Las figuras se muestran y las imágenes de cada punto se guardan en `resultados/`.

## Estructura
- `main.m` – puntos 1 a 8.
- `validacion.m` – validación de las conversiones de espacio de color y curvas de transformación.
- `funciones/` – negativo, logarítmica, gamma, lineal a trozos, RGB↔CMY, RGB↔CMYK, RGB↔HSI.
- `imagenes/` – `imagen_generada.jpg` (imagen propia) e `imagen_desbalanceada.tiff` / `imagen_objetivo.tiff` del punto 8.
- `resultados/` – imágenes generadas por `main.m` para cada punto.
- `sustentacion/` – `presentacion.html` (usa las imágenes de `resultados/`) y `video_sustentacion.mp4`.
- `enunciado/` – enunciado original del momento evaluativo.
- `PROMPT_IMAGEN.md` – prompt usado para generar la imagen.

## Punto 8 – Resultado
En el espacio CMY, Magenta y Amarillo son idénticos a la imagen objetivo; solo el **Cian** está alterado,
con una curva de potencia `C_d = 255·(C_o/255)^2.5` (déficit de cian → dominante roja).
Se corrige aplicando una transformación gamma inversa (γ = 1/2.5 = 0.4) al Cian: SSIM 0.2818 → **0.9979**.
