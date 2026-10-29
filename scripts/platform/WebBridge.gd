class_name WebBridge
extends RefCounted
## Puente con el navegador (solo exportación web).
##
## Safari no comunica a Godot las zonas seguras del iPhone (muesca, isla
## dinámica, barra de inicio). La plantilla web/shell.html las mide con
## CSS env(safe-area-inset-*) y las expone en window.spSafeArea().
## Fuera de la web todo devuelve cero, sin llamar a JavaScript.

## Límite de seguridad: ningún margen puede superar el 25 % de la pantalla.
const MAX_FRACTION := 0.25


static func is_web() -> bool:
	return OS.has_feature("web")


## Márgenes seguros como fracción del ancho (left/right) o alto (top/bottom)
## de la ventana. Independiente de la resolución y del zoom de Safari.
static func get_safe_area_fractions() -> Dictionary:
	var result := {"top": 0.0, "right": 0.0, "bottom": 0.0, "left": 0.0}
	if not is_web():
		return result
	var raw: Variant = JavaScriptBridge.eval(
		"(window.spSafeArea ? window.spSafeArea() : '')", true)
	if typeof(raw) != TYPE_STRING or (raw as String).is_empty():
		return result
	var parsed: Variant = JSON.parse_string(raw)
	if typeof(parsed) != TYPE_DICTIONARY:
		return result
	for side in result.keys():
		result[side] = clampf(float(parsed.get(side, 0.0)), 0.0, MAX_FRACTION)
	return result
