class_name SafeAreaContainer
extends MarginContainer
## Contenedor que mantiene su contenido dentro de la zona segura del iPhone.
##
## Margen final de cada lado = base_margin + margen seguro de ese lado.
## Se recalcula al abrir la pantalla y al cambiar el tamaño de la ventana
## (rotación, aparición o desaparición de las barras de Safari).

@export var base_margin: int = 24

## Safari actualiza los márgenes un instante después del cambio de tamaño;
## en la web se hace una segunda lectura tras este retraso (segundos).
const WEB_REREAD_DELAY := 0.4


func _ready() -> void:
	get_viewport().size_changed.connect(_schedule_refresh)
	_schedule_refresh()


func _schedule_refresh() -> void:
	refresh()
	if WebBridge.is_web():
		get_tree().create_timer(WEB_REREAD_DELAY).timeout.connect(refresh)


## Lee los márgenes seguros actuales y los aplica.
func refresh() -> void:
	var f := WebBridge.get_safe_area_fractions()
	var size := get_viewport().get_visible_rect().size
	apply_insets(f.top * size.y, f.right * size.x, f.bottom * size.y, f.left * size.x)


## Aplica márgenes seguros en píxeles de viewport. Público para las pruebas.
func apply_insets(top: float, right: float, bottom: float, left: float) -> void:
	add_theme_constant_override("margin_top", base_margin + roundi(top))
	add_theme_constant_override("margin_right", base_margin + roundi(right))
	add_theme_constant_override("margin_bottom", base_margin + roundi(bottom))
	add_theme_constant_override("margin_left", base_margin + roundi(left))
