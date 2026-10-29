# Simulador Presidente

Videojuego de gran estrategia geopolítica (América Latina y el Caribe).
**Godot 4.4.1 · GDScript · exportación web para Safari en iPhone (horizontal).**

> Estado: **UI-01 en desarrollo** (arranque, menú principal y pantalla principal vacía).
> Prototipo de interfaz DEMO: todavía no existe motor de simulación.

## Roles

- **Director del Producto:** aprueba diseños y entregas, prueba en iPhone y decide la publicación.
- **ChatGPT:** arquitectura, requisitos, auditoría y criterios de aceptación.
- **Claude:** implementación en ramas `feat/*` con PR en borrador.

Nada se fusiona a `main` ni se publica sin autorización del Director del Producto.

## Cómo se compila

No hace falta instalar nada: GitHub Actions compila cada push a una rama `feat/**`.
Detalles en [`docs/UI-01.md`](docs/UI-01.md).

## Documentación

- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md): estructura, módulos y puntos de integración futuros.
- [`docs/UI-01.md`](docs/UI-01.md): alcance de UI-01, compilación, pruebas y vista previa.
- [`docs/QA_IPHONE.md`](docs/QA_IPHONE.md): lista de pruebas manuales en iPhone.
- [`docs/DECISION_TRACEABILITY.md`](docs/DECISION_TRACEABILITY.md): trazabilidad de decisiones.

## Licencias

- Código del proyecto: pendiente de decisión del Director del Producto.
- Godot Engine: MIT. La plantilla `web/shell.html` deriva de la plantilla web oficial de Godot (MIT).
