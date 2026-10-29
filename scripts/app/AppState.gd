extends Node
## AppState (autoload): estado global de la INTERFAZ, no de la simulación.
##
## UI-01 solo registra qué pantalla está activa. En entregas posteriores
## guardará selected_country_id, capa activa, zoom/centro de cámara, panel
## abierto y velocidad visual (contrato "Estado de interfaz" del plan).
## Los datos de simulación vivirán en sistemas separados (GameClock, etc.).

## UI-01 no tiene motor de simulación: todo lo visible es demostración.
const IS_DEMO := true

var current_screen: StringName = &""


func set_screen(screen_id: StringName) -> void:
	current_screen = screen_id
