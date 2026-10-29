# Trazabilidad de decisiones

Estado: **plantilla**. Las fuentes de las decisiones originales y de las
aclaraciones de auditoría **no están disponibles** en este repositorio.
Este documento no afirma haber cotejado ninguna de ellas.

## Incidencia abierta: número de decisiones originales

- El plan UI-BASE-001 menciona **400 decisiones originales** y **200 aclaraciones AUD-Q001–AUD-Q200**.
- En el trabajo previo del proyecto, el registro de decisiones originales se fijó en **81** (y en otro momento se mencionaron **91**).
- Pendiente: que el Director del Producto y ChatGPT confirmen la cifra y aporten las fuentes.
- Norma: no derogar ni modificar decisiones originales sin autorización.

## Decisiones aplicadas en UI-01

| ID | Decisión | Origen | Aplicación en UI-01 |
|---|---|---|---|
| UIB-01 | Reconstruir el proyecto desde cero | Plan UI-BASE-001 §1.1 | Repositorio nuevo |
| UIB-03 | Primera entrega: interfaz navegable sin simulación | Plan UI-BASE-001 §1.3 | Pantallas DEMO etiquetadas |
| UIB-06 | No fusionar a main ni publicar sin aprobación | Plan UI-BASE-001 §1.6 | PR en borrador; despliegue desactivado |
| UI01-01 | Repositorio público temporalmente | Orden UI-01 (aprobación) | Sin secretos ni datos privados |
| UI01-02 | Godot 4.4.1 + GDScript | Orden UI-01 | `project.godot`, CI |
| UI01-03 | Compilación con GitHub Actions | Orden UI-01 | `.github/workflows/build-web.yml` |
| UI01-04 | Vista previa en Cloudflare Pages | Orden UI-01 | Trabajo `deploy-preview` (desactivado) |
| UI01-05 | Rama `feat/ui-01` | Orden UI-01 | Rama de trabajo |
| UI01-06 | Solo un commit inicial mínimo en main | Orden UI-01 | README, .gitignore, .gitattributes |
| UI01-07 | PR en borrador, sin fusionar | Orden UI-01 | PR en borrador |
| UI01-08 | Sin vista previa pública sin autorización | Orden UI-01 | Variable `PREVIEW_DEPLOY_ENABLED` + aprobación |
| UI01-09 | Menú: "Continuar" y "Ajustes" deshabilitados; sin "Créditos" | Propuesta aprobada | `MainMenu.tscn` |
| UI01-10 | Fuente predeterminada de Godot; base 1280×540 provisional | Propuesta aprobada | `project.godot`, tema |

## Decisiones pendientes que afectan a entregas futuras

- Catálogo definitivo de los 33 países (UI-02).
- Fuente cartográfica y postura sobre las fronteras en disputa (UI-02).
- Referencias visuales del diseño "atlas de mando" (UI-03).
- Licencia del código del proyecto.
