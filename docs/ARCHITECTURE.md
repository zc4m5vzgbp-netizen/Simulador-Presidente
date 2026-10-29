# Arquitectura — Simulador Presidente

Estado: vigente para **UI-01**. Las secciones "Reservado" describen dónde se
integrarán sistemas futuros; **no están implementados**.

## Principios

1. **Separación vista / datos / simulación.** Las escenas solo muestran; los
   datos se cargan por repositorios; la simulación vivirá en sistemas propios.
2. **Navegación centralizada.** Ninguna pantalla carga a otra directamente:
   todas piden a `UIManager.go_to(id)`.
3. **Comunicación por señales.** Los sistemas futuros se conectarán mediante
   `EventBus`, sin referencias directas entre módulos.
4. **Datos DEMO separados** de valores definitivos y siempre etiquetados.
5. **Web primero:** Safari en iPhone horizontal es la plataforma de referencia.

## Estructura actual (UI-01)

```
project.godot                 Configuración (Godot 4.4.1, Compatibility, 1280×540 expand)
export_presets.cfg            Preset "Web": sin hilos, plantilla web/shell.html
assets/theme/base_theme.tres  Tema base provisional (tamaños táctiles)
scenes/boot/Boot.tscn         Pantalla de inicio ("Toca para comenzar")
scenes/menus/MainMenu.tscn    Menú principal
scenes/game/GameShell.tscn    Pantalla principal (vacía en UI-01)
scripts/app/AppState.gd       Autoload: estado de interfaz
scripts/app/UIManager.gd      Autoload: navegación entre pantallas
scripts/app/Boot.gd           Lógica de la pantalla de inicio
scripts/menus/MainMenu.gd     Lógica del menú
scripts/game/GameShell.gd     Lógica de GameShell
scripts/ui/SafeAreaContainer.gd   Márgenes de zona segura del iPhone
scripts/platform/WebBridge.gd     Puente con el navegador (zonas seguras)
web/shell.html                Plantilla HTML para iPhone (giro, zonas seguras, zoom)
web/_headers                  Cabeceras de caché para Cloudflare Pages
tests/smoke/                  Prueba de humo (se ejecuta en CI)
tools/ci/                     Scripts de compilación y verificación
.github/workflows/            GitHub Actions
```

Los archivos `*.gd.uid` y `*.import` los genera Godot 4.4 y deben conservarse
en el repositorio.

### Cambios respecto a la estructura orientativa del plan UI-BASE-001

| Plan | Implementado | Motivo |
|---|---|---|
| `NavigationController.gd` | `UIManager.gd` | Nombre de la orden UI-01; evita dos módulos de navegación. |
| `ResponsiveLayout.gd` | `SafeAreaContainer.gd` + `WebBridge.gd` | Separa el cálculo de márgenes (UI) del acceso al navegador (plataforma). |
| `DataLoader.gd` | Reservado como `CountryRepository.gd` | Nombre de la orden UI-01; llega en UI-02. |
| — | `scripts/app/Boot.gd` | Lógica de la pantalla de inicio. |

## Flujo de navegación (UI-01)

```
Boot (Toca para comenzar) ──► MainMenu ──Nueva partida (demostración)──► GameShell
                                 ▲                                         │
                                 └──────────── Volver al menú ◄────────────┘
MainMenu: "Continuar" y "Ajustes" deshabilitados (sin guardado ni ajustes reales).
```

## Zonas seguras y orientación en la web

- Safari no permite forzar la orientación horizontal. `web/shell.html` muestra
  un aviso "Gira el teléfono" en vertical (CSS), visible incluso durante la carga.
- `viewport-fit=cover` hace que el juego ocupe toda la pantalla. La sonda
  `#sp-safe-probe` mide `env(safe-area-inset-*)` y `window.spSafeArea()` lo
  devuelve como fracción de la ventana.
- `WebBridge.get_safe_area_fractions()` lo lee y `SafeAreaContainer` lo
  convierte a píxeles de viewport (margen base 24 px + zona segura). Se
  recalcula al cambiar el tamaño (rotación, barras de Safari) con una segunda
  lectura a los 0,4 s.
- El fondo de cada pantalla queda fuera del `SafeAreaContainer` para cubrir
  también las zonas de la muesca/isla dinámica.

## Reservado para entregas futuras (NO implementado)

| Módulo | Ruta prevista | Tipo | Entrega |
|---|---|---|---|
| MapController | `scripts/map/MapController.gd` | Script de la escena del mapa | UI-02 |
| CountryRepository | `scripts/data/CountryRepository.gd` | Carga y validación de países, capitales y geometría | UI-02 |
| EventBus | `scripts/core/EventBus.gd` | Autoload de señales globales | UI-04 |
| GameClock | `scripts/core/GameClock.gd` | Autoload: pausa/x1/x2/x4 (solo visual hasta existir simulación) | UI-04 |
| NewsSystem | `scripts/news/NewsSystem.gd` | Escucha `EventBus`; noticias con `event_id` | NOTICIAS-001 (futuro) |

Puntos de integración ya previstos:

- **GameShell** alojará la capa de mapa (UI-02) y el HUD y los paneles (UI-03).
- **AppState** ampliará el estado de interfaz: `selected_country_id`, capa
  activa, zoom/centro de cámara, panel abierto y velocidad visual.
- **NOTICIAS-001** solo podrá generar noticias a partir de eventos reales
  emitidos por `EventBus`; en UI-04 únicamente habrá un marcador de posición
  etiquetado.
