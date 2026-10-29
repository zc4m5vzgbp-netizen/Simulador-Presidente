extends Control
## Pantalla de inicio.
##
## Pide un toque antes de entrar al menú. Además de presentar el juego,
## ese primer toque es el gesto del usuario que Safari exige para permitir
## audio en el futuro.

@onready var _start_button: Button = %StartButton


func _ready() -> void:
	_start_button.pressed.connect(_on_start_pressed)


func _on_start_pressed() -> void:
	UIManager.go_to(&"main_menu")
