extends Node
## UIManager (autoload): navegación entre pantallas de nivel superior.
##
## Única puerta para cambiar de pantalla. Las pantallas no se cargan entre
## sí directamente; piden a UIManager que navegue por su identificador.
## Así, en UI-02+ se pueden añadir pantallas o paneles sin acoplar escenas.

signal screen_changed(screen_id: StringName)

const SCREENS := {
	&"boot": "res://scenes/boot/Boot.tscn",
	&"main_menu": "res://scenes/menus/MainMenu.tscn",
	&"game_shell": "res://scenes/game/GameShell.tscn",
}


func go_to(screen_id: StringName) -> void:
	if not SCREENS.has(screen_id):
		push_error("UIManager: pantalla desconocida '%s'." % screen_id)
		return
	var err := get_tree().change_scene_to_file(SCREENS[screen_id])
	if err != OK:
		push_error("UIManager: no se pudo abrir '%s' (error %d)." % [screen_id, err])
		return
	AppState.set_screen(screen_id)
	screen_changed.emit(screen_id)
