extends Control
# Se pone en el nodo "Panel" de top_5.tscn.
# Decora el Top 5: fondo, panel, título, lista con medallas (oro, plata, bronce),
# "estás en el puesto", botón de menú, y anima la entrada de todo.
# Funciona si ListaTop5 es un Tree, un ItemList o un contenedor con etiquetas.

# --- Colores ---
@export var color_fondo := Color(0.13, 0.04, 0.06)
@export var color_panel := Color(0.10, 0.06, 0.07, 0.94)
@export var color_borde := Color(1.0, 0.55, 0.1)
@export var color_hover := Color(0.45, 0.10, 0.08)
@export var color_presionado := Color(0.25, 0.05, 0.05)
@export var color_texto := Color(0.96, 0.92, 0.85)
@export var color_oro := Color(1.0, 0.85, 0.3)
@export var color_plata := Color(0.85, 0.88, 0.92)
@export var color_bronce := Color(0.85, 0.55, 0.3)

# --- Tamaños ---
@export var tamano_titulo := 40
@export var tamano_filas := 24
@export var tamano_puesto := 26
@export var tamano_boton := 24

# --- Opciones ---
@export var crear_fondo := true       # fondo oscuro propio que cubre toda la ventana
@export var retraso_inicial := 0.2
@export var paso := 0.2

func _ready():
	if crear_fondo:
		_fondo_pantalla()
	_estilos()
	_animar_todo()
	_decorar_filas_con_reintentos()

# ------------------------------------------------------------
# FONDO
# ------------------------------------------------------------
func _fondo_pantalla():
	var capa := CanvasLayer.new()
	capa.layer = -10
	add_child(capa)
	var cr := ColorRect.new()
	cr.color = color_fondo
	cr.set_anchors_preset(Control.PRESET_FULL_RECT)
	cr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	capa.add_child(cr)

# ------------------------------------------------------------
# ESTILOS
# ------------------------------------------------------------
func _caja(bg: Color, borde: Color, grosor: int, radio := 8, margen := 12) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = borde
	s.set_border_width_all(grosor)
	s.set_corner_radius_all(radio)
	s.set_content_margin_all(margen)
	s.shadow_color = Color(0, 0, 0, 0.55)
	s.shadow_size = 8
	return s

func _label(l: Label, color: Color, tam: int, contorno: int):
	if l == null:
		return
	l.add_theme_color_override("font_color", color)
	l.add_theme_font_size_override("font_size", tam)
	l.add_theme_color_override("font_outline_color", Color(0.1, 0.03, 0.03))
	l.add_theme_constant_override("outline_size", contorno)

func _estilos():
	# El propio Panel
	add_theme_stylebox_override("panel", _caja(color_panel, color_borde, 3, 12, 0))

	_label(get_node_or_null("TituloTop") as Label, color_borde, tamano_titulo, 10)
	_label(get_node_or_null("PuestoJugador") as Label, color_texto, tamano_puesto, 6)
	_label(get_node_or_null("TopJugador") as Label, color_oro, tamano_puesto + 8, 8)

	var lista := get_node_or_null("ListaTop5")
	if lista:
		_estilo_lista(lista)

	_boton(get_parent().get_node_or_null("BtnMenu") as Button)

func _estilo_lista(n: Node):
	var tree := n as Tree
	if tree:
		tree.add_theme_stylebox_override("panel", _caja(Color(0.06, 0.03, 0.04, 0.9), color_borde.darkened(0.3), 2, 8, 6))
		tree.add_theme_stylebox_override("focus", _caja(Color(0, 0, 0, 0), color_borde, 2, 8, 6))
		tree.add_theme_stylebox_override("selected", _caja(color_hover, color_borde, 1, 4, 4))
		tree.add_theme_stylebox_override("selected_focus", _caja(color_hover, color_borde, 1, 4, 4))
		tree.add_theme_stylebox_override("cursor", _caja(Color(0, 0, 0, 0), color_borde, 1, 4, 4))
		tree.add_theme_stylebox_override("cursor_unfocused", _caja(Color(0, 0, 0, 0), color_borde, 1, 4, 4))
		tree.add_theme_stylebox_override("title_button_normal", _caja(color_presionado, color_borde, 2, 4, 6))
		tree.add_theme_stylebox_override("title_button_hover", _caja(color_hover, color_borde, 2, 4, 6))
		tree.add_theme_stylebox_override("title_button_pressed", _caja(color_presionado, color_borde, 2, 4, 6))
		tree.add_theme_color_override("font_color", color_texto)
		tree.add_theme_color_override("font_selected_color", Color.WHITE)
		tree.add_theme_color_override("title_button_color", color_borde)
		tree.add_theme_color_override("guide_color", Color(0, 0, 0, 0))
		tree.add_theme_font_size_override("font_size", tamano_filas)
		tree.add_theme_font_size_override("title_button_font_size", tamano_filas - 4)
		tree.add_theme_constant_override("v_separation", 10)
		return

	var il := n as ItemList
	if il:
		il.add_theme_stylebox_override("panel", _caja(Color(0.06, 0.03, 0.04, 0.9), color_borde.darkened(0.3), 2, 8, 6))
		il.add_theme_stylebox_override("focus", _caja(Color(0, 0, 0, 0), color_borde, 2, 8, 6))
		il.add_theme_stylebox_override("selected", _caja(color_hover, color_borde, 1, 4, 4))
		il.add_theme_stylebox_override("selected_focus", _caja(color_hover, color_borde, 1, 4, 4))
		il.add_theme_stylebox_override("cursor", _caja(Color(0, 0, 0, 0), color_borde, 1, 4, 4))
		il.add_theme_stylebox_override("cursor_unfocused", _caja(Color(0, 0, 0, 0), color_borde, 1, 4, 4))
		il.add_theme_color_override("font_color", color_texto)
		il.add_theme_color_override("font_selected_color", Color.WHITE)
		il.add_theme_font_size_override("font_size", tamano_filas)
		il.add_theme_constant_override("v_separation", 10)
		return

	# Cualquier otro contenedor: se estilizan las etiquetas de adentro
	for h in n.get_children():
		var l := h as Label
		if l:
			_label(l, color_texto, tamano_filas, 4)
		else:
			_estilo_lista(h)

func _boton(b: Button):
	if b == null:
		return
	b.add_theme_stylebox_override("normal", _caja(Color(0.10, 0.06, 0.07, 0.95), color_borde, 3, 8, 12))
	b.add_theme_stylebox_override("hover", _caja(color_hover, color_borde, 3, 8, 12))
	b.add_theme_stylebox_override("pressed", _caja(color_presionado, color_borde, 3, 8, 12))
	b.add_theme_stylebox_override("focus", _caja(Color(0, 0, 0, 0), Color.WHITE, 4, 8, 12))
	b.add_theme_color_override("font_color", color_texto)
	b.add_theme_color_override("font_hover_color", Color.WHITE)
	b.add_theme_color_override("font_pressed_color", color_borde)
	b.add_theme_font_size_override("font_size", tamano_boton)
	b.mouse_entered.connect(func(): _escalar(b, Vector2(1.08, 1.08)))
	b.mouse_exited.connect(func(): _escalar(b, Vector2.ONE))
	b.button_down.connect(func(): _escalar(b, Vector2(0.94, 0.94)))
	b.button_up.connect(func(): _escalar(b, Vector2(1.08, 1.08)))

func _escalar(n: Control, e: Vector2):
	n.pivot_offset = n.size / 2
	if n.has_meta("tw"):
		var viejo = n.get_meta("tw")
		if viejo is Tween:
			viejo.kill()
	var t := n.create_tween()
	n.set_meta("tw", t)
	t.tween_property(n, "scale", e, 0.12)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

# ------------------------------------------------------------
# MEDALLAS EN LA LISTA (oro, plata, bronce + filas alternadas)
# ------------------------------------------------------------
func _color_puesto(i: int) -> Color:
	match i:
		0: return color_oro
		1: return color_plata
		2: return color_bronce
	return color_texto

# Tu script llena la lista después de que este arranca, por eso se reintenta
func _decorar_filas_con_reintentos():
	for espera in [0.1, 0.4, 1.0]:
		await get_tree().create_timer(espera).timeout
		_decorar_filas()

func _decorar_filas():
	var lista := get_node_or_null("ListaTop5")
	if lista == null:
		return

	var tree := lista as Tree
	if tree and tree.get_root():
		var i := 0
		for item in tree.get_root().get_children():
			for col in tree.columns:
				item.set_custom_color(col, _color_puesto(i))
				item.set_custom_font_size(col, tamano_filas)
				if i % 2 == 0:
					item.set_custom_bg_color(col, Color(1, 1, 1, 0.05))
				else:
					item.set_custom_bg_color(col, Color(0, 0, 0, 0.2))
			i += 1
		return

	var il := lista as ItemList
	if il:
		for idx in il.item_count:
			il.set_item_custom_fg_color(idx, _color_puesto(idx))
			il.set_item_custom_bg_color(idx, Color(1, 1, 1, 0.05) if idx % 2 == 0 else Color(0, 0, 0, 0.2))
		return

	# Contenedor con etiquetas: se colorean por orden
	var i := 0
	for h in lista.get_children():
		var l := h as Label
		if l:
			l.add_theme_color_override("font_color", _color_puesto(i))
		i += 1

# ------------------------------------------------------------
# ANIMACIÓN
# ------------------------------------------------------------
func _animar_todo():
	await get_tree().process_frame
	var d := retraso_inicial
	_entrar(self, 0.0, Vector2(0.94, 0.94))
	_entrar(get_node_or_null("TituloTop") as Control, d, Vector2(1.5, 1.5))
	d += paso
	_entrar(get_node_or_null("ListaTop5") as Control, d)
	d += paso
	_entrar(get_node_or_null("PuestoJugador") as Control, d)
	d += paso
	_entrar(get_node_or_null("TopJugador") as Control, d, Vector2(1.6, 1.6))
	d += paso
	var btn := get_parent().get_node_or_null("BtnMenu") as Button
	_entrar(btn, d)
	_brillo(btn, d + 0.6)

func _entrar(n: Control, retraso: float, escala_desde := Vector2(0.8, 0.8)):
	if n == null:
		return
	n.pivot_offset = n.size / 2
	n.modulate.a = 0.0
	n.scale = escala_desde
	var t := n.create_tween().set_parallel(true)
	n.set_meta("tw", t)
	t.tween_property(n, "modulate:a", 1.0, 0.4).set_delay(retraso)
	t.tween_property(n, "scale", Vector2.ONE, 0.45).set_delay(retraso)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _brillo(b: Button, retraso: float):
	if b == null:
		return
	await get_tree().create_timer(retraso).timeout
	var t := b.create_tween().set_loops()
	t.tween_property(b, "modulate", Color(1.3, 1.15, 1.0, 1.0), 0.8)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	t.tween_property(b, "modulate", Color.WHITE, 0.8)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
