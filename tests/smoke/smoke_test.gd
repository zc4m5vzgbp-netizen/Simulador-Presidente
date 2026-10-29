extends Node
## Punto de entrada de la prueba de humo.
##
## Uso:  godot --headless --path . res://tests/smoke/SmokeTest.tscn
##
## La navegación sustituye la escena actual, así que el ejecutor de pruebas
## se cuelga directamente de la raíz para sobrevivir a esos cambios.

const SmokeRunner := preload("res://tests/smoke/smoke_runner.gd")


func _ready() -> void:
	var runner := SmokeRunner.new()
	runner.name = "SmokeRunner"
	get_tree().root.add_child.call_deferred(runner)
