extends CanvasLayer
# Controles de cada jugador, abajo en las esquinas, semitransparentes.

@export var capa := 5                       # menor que la capa de Pausa
@export_range(0.1, 1.0) var transparencia := 0.65
@export var margen := 16
@export var tam_fuente := 18
@export var fundido_entrada := true

# --- Colores (cámbialos a los de tu estilo) ---
@export var color_fondo := Color(0.05, 0.05, 0.08, 0.75)
@export var color_j1 := Color(0.35, 0.7, 1.0)
@export var color_j2 := Color(1.0, 0.45, 0.4)

var controles_j1 := [["F", "Atacar"], ["G", "Bloquear"]]
var controles_j2 := [["M", "Atacar"], ["N", "Bloquear"]]

func _ready():
	layer = capa

	# Contenedor que ocupa toda la pantalla, con margen
	var raiz := MarginContainer.new()
	raiz.set_anchors_preset(Control.PRESET_FULL_RECT)
	raiz.mouse_filter = Control.MOUSE_FILTER_IGNORE
	raiz.add_theme_constant_override("margin_left", margen)
	raiz.add_theme_constant_override("margin_right", margen)
	raiz.add_theme_constant_override("margin_top", margen)
	raiz.add_theme_constant_override("margin_bottom", margen)
	add_child(raiz)

	var fila := HBoxContainer.new()
	fila.mouse_filter = Control.MOUSE_FILTER_IGNORE
	raiz.add_child(fila)

	# Jugador 1 a la izquierda, espacio en medio, Jugador 2 a la derecha
	fila.add_child(_crear_panel("Jugador 1", controles_j1, color_j1))

	var espacio := Control.new()
	espacio.mouse_filter = Control.MOUSE_FILTER_IGNORE
	espacio.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fila.add_child(espacio)

	fila.add_child(_crear_panel("Jugador 2", controles_j2, color_j2))

func _crear_panel(titulo: String, filas: Array, acento: Color) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.size_flags_vertical = Control.SIZE_SHRINK_END   # pegado abajo

	var estilo := StyleBoxFlat.new()
	estilo.bg_color = color_fondo
	estilo.border_color = acento
	estilo.set_border_width_all(2)
	estilo.set_corner_radius_all(10)
	estilo.content_margin_left = 14
	estilo.content_margin_right = 14
	estilo.content_margin_top = 8
	estilo.content_margin_bottom = 10
	estilo.shadow_color = Color(0, 0, 0, 0.4)
	estilo.shadow_size = 6
	panel.add_theme_stylebox_override("panel", estilo)

	var caja := VBoxContainer.new()
	caja.mouse_filter = Control.MOUSE_FILTER_IGNORE
	caja.add_theme_constant_override("separation", 6)
	panel.add_child(caja)

	var t := Label.new()
	t.text = titulo
	t.add_theme_font_size_override("font_size", tam_fuente - 5)
	t.add_theme_color_override("font_color", acento)
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	caja.add_child(t)

	for f in filas:
		caja.add_child(_crear_fila(f[0], f[1], acento))

	if fundido_entrada:
		panel.modulate.a = 0.0
		var tw := create_tween()
		tw.tween_property(panel, "modulate:a", transparencia, 0.6)
	else:
		panel.modulate.a = transparencia

	return panel

func _crear_fila(tecla: String, accion: String, acento: Color) -> HBoxContainer:
	var fila := HBoxContainer.new()
	fila.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fila.add_theme_constant_override("separation", 10)

	var cap := PanelContainer.new()
	cap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cap.custom_minimum_size = Vector2(tam_fuente + 14, tam_fuente + 10)
	var e := StyleBoxFlat.new()
	e.bg_color = acento.darkened(0.55)
	e.border_color = acento
	e.set_border_width_all(2)
	e.set_corner_radius_all(6)
	cap.add_theme_stylebox_override("panel", e)

	var lt := Label.new()
	lt.text = tecla
	lt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lt.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lt.add_theme_font_size_override("font_size", tam_fuente)
	lt.add_theme_color_override("font_color", Color.WHITE)
	lt.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cap.add_child(lt)
	fila.add_child(cap)

	var la := Label.new()
	la.text = accion
	la.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	la.add_theme_font_size_override("font_size", tam_fuente)
	la.add_theme_color_override("font_color", Color(1, 1, 1, 0.9))
	la.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fila.add_child(la)

	return fila
