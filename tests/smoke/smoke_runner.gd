extends Node
## Prueba de humo de UI-01: arranque, navegación y zonas seguras.
## Termina el proceso con código 0 si todo pasa y 1 si algo falla.

const BOOT := "res://scenes/boot/Boot.tscn"
const MAIN_MENU := "res://scenes/menus/MainMenu.tscn"
const GAME_SHELL := "res://scenes/game/GameShell.tscn"

## Fotogramas máximos de espera para que cambie la escena.
const MAX_WAIT_FRAMES := 30
## Ciclos menú → GameShell → menú (prueba de "navegación repetida").
const NAV_CYCLES := 10

var _checks := 0
var _failures: PackedStringArray = []


func _ready() -> void:
	_run.call_deferred()


func _run() -> void:
	print("[SMOKE] Inicio de pruebas UI-01")

	# 1. Puente web fuera del navegador.
	var f := WebBridge.get_safe_area_fractions()
	_check(not WebBridge.is_web(), "La prueba se ejecuta fuera de la web")
	_check(f.top == 0.0 and f.right == 0.0 and f.bottom == 0.0 and f.left == 0.0,
		"WebBridge devuelve márgenes cero fuera de la web")

	# 2. Registro de pantallas.
	for screen_id in UIManager.SCREENS:
		_check(ResourceLoader.exists(UIManager.SCREENS[screen_id]),
			"La escena de '%s' existe" % screen_id)

	# 3. Pantalla de inicio → menú principal.
	UIManager.go_to(&"boot")
	_check(await _wait_for_scene(BOOT), "Se abre la pantalla de inicio")
	_check(AppState.current_screen == &"boot", "AppState registra 'boot'")
	var start := _find_button("StartButton")
	_check(start != null and not start.disabled, "Botón 'Toca para comenzar' disponible")
	if start:
		start.pressed.emit()
	_check(await _wait_for_scene(MAIN_MENU), "Inicio → Menú principal")

	# 4. Estado de los botones del menú.
	var new_game := _find_button("NewGameButton")
	var continue_btn := _find_button("ContinueButton")
	var settings := _find_button("SettingsButton")
	_check(new_game != null and not new_game.disabled, "'Nueva partida' habilitado")
	_check(continue_btn != null and continue_btn.disabled, "'Continuar' deshabilitado")
	_check(settings != null and settings.disabled, "'Ajustes' deshabilitado (próximamente)")

	# 5. Navegación repetida.
	var cycles_ok := 0
	for i in NAV_CYCLES:
		var ng := _find_button("NewGameButton")
		if ng == null:
			break
		ng.pressed.emit()
		if not await _wait_for_scene(GAME_SHELL):
			break
		if AppState.current_screen != &"game_shell":
			break
		var back := _find_button("BackButton")
		if back == null:
			break
		back.pressed.emit()
		if not await _wait_for_scene(MAIN_MENU):
			break
		if AppState.current_screen != &"main_menu":
			break
		cycles_ok += 1
	_check(cycles_ok == NAV_CYCLES,
		"%d/%d ciclos Menú → GameShell → Menú" % [cycles_ok, NAV_CYCLES])

	# 6. Cada pantalla usa el contenedor de zona segura.
	for path in [BOOT, MAIN_MENU, GAME_SHELL]:
		var scene: Node = (load(path) as PackedScene).instantiate()
		var safe := scene.get_node_or_null("SafeArea")
		_check(safe is SafeAreaContainer, "%s usa SafeAreaContainer" % path.get_file())
		scene.free()

	# 7. Cálculo de márgenes seguros.
	var container := SafeAreaContainer.new()
	add_child(container)
	container.apply_insets(10.0, 20.0, 30.0, 40.0)
	var b := container.base_margin
	_check(container.get_theme_constant("margin_top") == b + 10
		and container.get_theme_constant("margin_right") == b + 20
		and container.get_theme_constant("margin_bottom") == b + 30
		and container.get_theme_constant("margin_left") == b + 40,
		"SafeAreaContainer suma margen base + zona segura")
	container.queue_free()

	_finish()


func _wait_for_scene(path: String) -> bool:
	for i in MAX_WAIT_FRAMES:
		await get_tree().process_frame
		var current := get_tree().current_scene
		if current != null and current.scene_file_path == path:
			return true
	return false


func _find_button(node_name: String) -> Button:
	var current := get_tree().current_scene
	if current == null:
		return null
	return current.find_child(node_name, true, false) as Button


func _check(condition: bool, description: String) -> void:
	_checks += 1
	if condition:
		print("[SMOKE] OK    %s" % description)
	else:
		_failures.append(description)
		print("[SMOKE] FALLO %s" % description)


func _finish() -> void:
	print("[SMOKE] Resultado: %d comprobaciones, %d fallos" % [_checks, _failures.size()])
	get_tree().quit(0 if _failures.is_empty() else 1)
