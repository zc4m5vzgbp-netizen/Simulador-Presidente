extends Control
## Menú principal (UI-01).
##
## - "Nueva partida (demostración)": abre GameShell. No inicia simulación.
## - "Continuar": deshabilitado hasta que exista un sistema de guardado.
## - "Ajustes": deshabilitado ("próximamente"); aún no hay ajustes reales.
## Ningún botón ejecuta acciones engañosas.

@onready var _new_game_button: Button = %NewGameButton
@onready var _continue_button: Button = %ContinueButton
@onready var _settings_button: Button = %SettingsButton


func _ready() -> void:
	_continue_button.disabled = true
	_settings_button.disabled = true
	_new_game_button.pressed.connect(_on_new_game_pressed)


func _on_new_game_pressed() -> void:
	UIManager.go_to(&"game_shell")
