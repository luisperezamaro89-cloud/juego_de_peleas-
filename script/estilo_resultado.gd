extends ColorRect
# Se pone en el nodo "Fondo" (ColorRect) de Resultado.tscn.
# Decora la pantalla de resultados y anima todo:
# título con golpe, ganador, puntajes que suben contando, nombres, botón con brillo
# y confeti si hubo un ganador. No necesita tocar el script de Resultado.

# --- Colores ---
@export var color_fondo := Color(0.13, 0.04, 0.06)
@export var color_titulo := Color(1.0, 0.55, 0.1)
@export var color_ganador := Color(1.0, 0.85, 0.3)
@export var acento_j1 := Color(1.0, 0.75, 0.2)   # dorado
@export var acento_j2 := Color(0.3, 0.85, 1.0)   # cian
@export var color_texto := Color(0.96, 0.92, 0.85)
@export var color_borde_boton := Color(1.0, 0.55, 0.1)

# --- Tamaños ---
@export var tamano_titulo := 60
@export var tamano_ganador := 34
@export var tamano_puntaje := 30
@export var tamano_nombre := 20
@export var tamano_boton := 26

# --- Animación ---
@export var retraso_inicial := 0.3
@export var paso := 0.35
@export var duracion_conteo := 1.0
@export var confeti := true

var _raiz: Node

func _ready():
	_raiz = get_parent()
	_ajustar_fondo()
	get_viewport().size_changed.connect(_ajustar_fondo)
	_estilos()
	_animar_todo()

# ------------------------------------------------------------
# FONDO
# ------------------------------------------------------------
func _ajustar_fondo():
	color = color_fondo
	set_anchors_preset(Control.PRESET_TOP_LEFT, true)
	global_position = Vector2.ZERO
	size = get_viewport().get_visible_rect().size

# ------------------------------------------------------------
# ESTILOS
# ------------------------------------------------------------
func _nodo(ruta: String) -> Node:
	return _raiz.get_node_or_null(ruta)

func _estilos():
	_label(_nodo("Titulo") as Label, color_titulo, tamano_titulo, 12)
	_label(_nodo("Ganador") as Label, color_ganador, tamano_ganador, 8)
	_label(_nodo("Ganador/NombreYDefinicion") as Label, color_texto, tamano_ganador, 6)
	_label(_nodo("Puntaje_Jugador1") as Label, acento_j1, tamano_puntaje, 8)
	_label(_nodo("Puntaje_Jugador2") as Label, acento_j2, tamano_puntaje, 8)
	_label(_nodo("nombre_J1") as Label, acento_j1, tamano_nombre, 5)
	_label(_nodo("nombre_J2") as Label, acento_j2, tamano_nombre, 5)
	_caja_texto(_nodo("Nombre_J1") as LineEdit, acento_j1)
	_caja_texto(_nodo("Nombre_J2") as LineEdit, acento_j2)
	_boton(_nodo("BotonContinuar") as Button)

func _label(l: Label, color: Color, tam: int, contorno: int):
	if l == null:
		return
	l.add_theme_color_override("font_color", color)
	l.add_theme_font_size_override("font_size", tam)
	l.add_theme_color_override("font_outline_color", Color(0.1, 0.03, 0.03))
	l.add_theme_constant_override("outline_size", contorno)

func _caja(bg: Color, borde: Color, grosor: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = borde
	s.set_border_width_all(grosor)
	s.set_corner_radius_all(8)
	s.content_margin_left = 14
	s.content_margin_right = 14
	s.content_margin_top = 8
	s.content_margin_bottom = 8
	s.shadow_color = Color(0, 0, 0, 0.55)
	s.shadow_size = 6
	return s

func _caja_texto(le: LineEdit, acento: Color):
	if le == null:
		return
	var c := _caja(Color(0.08, 0.04, 0.05, 0.9), acento, 2)
	le.add_theme_stylebox_override("normal", c)
	le.add_theme_stylebox_override("read_only", c)
	le.add_theme_stylebox_override("focus", _caja(Color(0.2, 0.08, 0.08, 0.95), acento, 3))
	le.add_theme_color_override("font_color", color_texto)
	le.add_theme_color_override("font_uneditable_color", color_texto)
	le.add_theme_color_override("caret_color", acento)
	le.add_theme_font_size_override("font_size", tamano_nombre)

func _boton(b: Button):
	if b == null:
		return
	b.add_theme_stylebox_override("normal", _caja(Color(0.10, 0.06, 0.07, 0.95), color_borde_boton, 3))
	b.add_theme_stylebox_override("hover", _caja(Color(0.45, 0.10, 0.08), color_borde_boton, 3))
	b.add_theme_stylebox_override("pressed", _caja(Color(0.25, 0.05, 0.05), color_borde_boton, 3))
	b.add_theme_stylebox_override("focus", _caja(Color(0, 0, 0, 0), Color.WHITE, 4))
	b.add_theme_color_override("font_color", color_texto)
	b.add_theme_color_override("font_hover_color", Color.WHITE)
	b.add_theme_color_override("font_pressed_color", color_borde_boton)
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
# ANIMACIÓN
# ------------------------------------------------------------
func _animar_todo():
	# Se espera a que el script de Resultado escriba los textos
	await get_tree().process_frame
	await get_tree().process_frame

	var ganador := ""
	if get_tree().has_meta("ganador_partida"):
		ganador = String(get_tree().get_meta("ganador_partida"))
	var gana_j1 := ganador == "Jugador 1"
	var gana_j2 := ganador == "Jugador 2"

	var titulo := _nodo("Titulo") as Control
	var gan := _nodo("Ganador") as Control
	var p1 := _nodo("Puntaje_Jugador1") as Label
	var p2 := _nodo("Puntaje_Jugador2") as Label
	var n1 := _nodo("nombre_J1") as Control
	var n2 := _nodo("nombre_J2") as Control
	var e1 := _nodo("Nombre_J1") as Control
	var e2 := _nodo("Nombre_J2") as Control
	var btn := _nodo("BotonContinuar") as Button

	var d := retraso_inicial
	_entrar(titulo, d, Vector2(1.6, 1.6))
	d += paso
	_entrar(gan, d)
	d += paso

	# El ganador resalta, el perdedor se apaga un poco
	var a1 := 0.6 if gana_j2 else 1.0
	var a2 := 0.6 if gana_j1 else 1.0
	var s1 := Vector2(1.12, 1.12) if gana_j1 else Vector2.ONE
	var s2 := Vector2(1.12, 1.12) if gana_j2 else Vector2.ONE

	_entrar(p1, d, Vector2(0.7, 0.7), s1, a1)
	_entrar(n1, d + 0.1, Vector2(0.7, 0.7), Vector2.ONE, a1)
	_entrar(e1, d + 0.15, Vector2(0.7, 0.7), Vector2.ONE, a1)
	_contar(p1, d)
	d += paso
	_entrar(p2, d, Vector2(0.7, 0.7), s2, a2)
	_entrar(n2, d + 0.1, Vector2(0.7, 0.7), Vector2.ONE, a2)
	_entrar(e2, d + 0.15, Vector2(0.7, 0.7), Vector2.ONE, a2)
	_contar(p2, d)
	d += paso + 0.3

	_entrar(btn, d, Vector2(0.7, 0.7))
	_brillo_boton(btn, d + 0.6)

	if confeti and (gana_j1 or gana_j2):
		await get_tree().create_timer(retraso_inicial + paso).timeout
		_lluvia_confeti()

# El nodo aparece con fade y "pop" hasta su escala final
func _entrar(n: Control, retraso: float, escala_desde := Vector2(0.7, 0.7), escala_final := Vector2.ONE, alfa_final := 1.0):
	if n == null:
		return
	n.pivot_offset = n.size / 2
	n.modulate.a = 0.0
	n.scale = escala_desde
	var t := n.create_tween().set_parallel(true)
	n.set_meta("tw", t)
	t.tween_property(n, "modulate:a", alfa_final, 0.4).set_delay(retraso)
	t.tween_property(n, "scale", escala_final, 0.45).set_delay(retraso)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

# Si el puntaje tiene un número, sube contando desde 0
func _contar(l: Label, retraso: float):
	if l == null:
		return
	var rx := RegEx.new()
	rx.compile("\\d+")
	var m := rx.search(l.text)
	if m == null:
		return
	var meta := int(m.get_string())
	if meta <= 0:
		return
	var prefijo := l.text.substr(0, m.get_start())
	var sufijo := l.text.substr(m.get_end())
	l.text = prefijo + "0" + sufijo
	var t := create_tween()
	t.tween_interval(retraso)
	t.tween_method(func(v: float): l.text = prefijo + str(int(v)) + sufijo, 0.0, float(meta), duracion_conteo)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

# El botón "respira" con un brillo suave para llamar la atención
func _brillo_boton(b: Button, retraso: float):
	if b == null:
		return
	await get_tree().create_timer(retraso).timeout
	var t := b.create_tween().set_loops()
	t.tween_property(b, "modulate", Color(1.3, 1.15, 1.0, 1.0), 0.8)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	t.tween_property(b, "modulate", Color.WHITE, 0.8)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

# Confeti de colores cayendo desde arriba
func _lluvia_confeti():
	var vp := get_viewport().get_visible_rect().size
	var capa := CanvasLayer.new()
	capa.layer = 5
	add_child(capa)
	var p := CPUParticles2D.new()
	p.position = Vector2(vp.x / 2, -20)
	p.amount = 70
	p.lifetime = 6.0
	p.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	p.emission_rect_extents = Vector2(vp.x / 2, 5)
	p.direction = Vector2(0, 1)
	p.spread = 25.0
	p.gravity = Vector2(0, 120)
	p.initial_velocity_min = 80.0
	p.initial_velocity_max = 200.0
	p.angular_velocity_min = -180.0
	p.angular_velocity_max = 180.0
	p.scale_amount_min = 4.0
	p.scale_amount_max = 8.0
	var g := Gradient.new()
	g.offsets = PackedFloat32Array([0.0, 0.25, 0.5, 0.75, 1.0])
	g.colors = PackedColorArray([
		Color(1.0, 0.55, 0.1), Color(1.0, 0.85, 0.3), Color(0.3, 0.85, 1.0),
		Color(0.95, 0.25, 0.2), Color(1.0, 1.0, 1.0)])
	p.color_initial_ramp = g
	capa.add_child(p)
	p.emitting = true
