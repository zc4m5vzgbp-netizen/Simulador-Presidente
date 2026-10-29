extends Control
## GameShell: contenedor de la pantalla principal de juego.
##
## En UI-01 está vacío a propósito. Puntos de integración previstos:
##   - MapLayer   → MapView / MapController (UI-02)
##   - HudLayer   → TopBar, panel derecho y minimapa (UI-03)
##   - Noticias   → solo marcador de posición en navegación (UI-04);
##                  NewsSystem (NOTICIAS-001) es una funcionalidad futura.

@onready var _back_button: Button = %BackButton


func _ready() -> void:
	_back_button.pressed.connect(_on_back_pressed)


func _on_back_pressed() -> void:
	UIManager.go_to(&"main_menu")
