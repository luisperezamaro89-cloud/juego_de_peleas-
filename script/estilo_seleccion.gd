extends Control
# Se pone en el VBoxContainer de seleccion_personajes.tscn (el que está
# debajo del título). Decora la escena y anima las imágenes grandes
# (FondoPersonaje y FondoPersonaje2) cada vez que aparecen o cambian.
# No necesita tocar tu script de selección.

# --- Colores y tamaños ---
@export var color_fondo := Color(0.13, 0.04, 0.06)
@export var acento_j1 := Color(1.0, 0.75, 0.2)   # dorado
@export var acento_j2 := Color(0.3, 0.85, 1.0)   # cian
@export var color_texto := Color(0.96, 0.92, 0.85)
@export var color_titulo := Color(1.0, 0.55, 0.1)
@export var tamano_texto := 18
@export var tamano_titulo := 56
@export var agregar_titulos_jugador := true
@export var tamano_titulo_jugador := 26

# --- Animaciones ---
@export var escala_foco := 1.1
@export var retraso_inicial := 0.2
@export var retraso_entre := 0.08
@export var animar_imagenes := true

# --- Nodos que busca (rutas relativas a este VBoxContainer) ---
@export var nodo_titulo: NodePath = ^"../TituloSeleccion"
@export var nodo_fondo: NodePath = ^"../ColorRect"
@export var imagenes_personaje: Array[NodePath] = [^"../FondoPersonaje", ^"../FondoPersonaje2"]

# --- Relleno de pantalla ---
@export var rellenar_color_fondo := true      # el ColorRect cubre toda la ventana
@export var ajustar_imagenes_fondo := true    # las 2 imágenes se reparten la pantalla (mitad y mitad)

var _estado := {}

func _ready():
	var cr := get_node_or_null(nodo_fondo) as ColorRect
	if cr:
		cr.color = color_fondo

	_ajustar_fondos()
	get_viewport().size_changed.connect(_ajustar_fondos)

	var tl := get_node_or_null(nodo_titulo) as Label
	if tl:
		tl.add_theme_color_override("font_color", color_titulo)
		tl.add_theme_font_size_override("font_size", tamano_titulo)
		tl.add_theme_color_override("font_outline_color", Color(0.1, 0.03, 0.03))
		tl.add_theme_constant_override("outline_size", 12)

	var todos: Array = []
	for c in find_children("Contenedor*", "", true, false):
		var es_j1 := String(c.name).ends_with("1")
		var acento := acento_j1 if es_j1 else acento_j2
		todos.append_array(_preparar(c, acento, 1 if es_j1 else 2))

	_entrada(todos)

func _ajustar_fondos():
	var vp := get_viewport().get_visible_rect().size

	if rellenar_color_fondo:
		var cr := get_node_or_null(nodo_fondo) as ColorRect
		if cr:
			cr.set_anchors_preset(Control.PRESET_TOP_LEFT, true)
			cr.global_position = Vector2.ZERO
			cr.size = vp

	if ajustar_imagenes_fondo:
		var n := imagenes_personaje.size()
		for i in n:
			var r := get_node_or_null(imagenes_personaje[i]) as TextureRect
			if r == null:
				continue
			var ancho := vp.x / n
			r.set_anchors_preset(Control.PRESET_TOP_LEFT, true)
			r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
			r.clip_contents = true
			r.global_position = Vector2(ancho * i, 0)
			r.size = Vector2(ancho, vp.y)

func _preparar(c: Node, acento: Color, num: int) -> Array:
	var elementos: Array = []
	for h in c.get_children():
		var b := h as Button
		var l := h as Label
		if b:
			_boton(b, acento)
		elif l:
			_etiqueta(l, acento, tamano_texto)
		if h is Control:
			elementos.append(h)
	if agregar_titulos_jugador:
		var t := Label.new()
		t.text = "JUGADOR %d" % num
		t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_etiqueta(t, acento, tamano_titulo_jugador)
		c.add_child(t)
		c.move_child(t, 0)
		elementos.insert(0, t)
	return elementos

func _etiqueta(l: Label, acento: Color, tam: int):
	l.add_theme_color_override("font_color", acento if tam > tamano_texto else color_texto)
	l.add_theme_font_size_override("font_size", tam)
	l.add_theme_color_override("font_outline_color", Color(0.1, 0.03, 0.03))
	l.add_theme_constant_override("outline_size", 5)

func _caja(bg: Color, borde: Color, grosor: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = borde
	s.set_border_width_all(grosor)
	s.set_corner_radius_all(8)
	s.set_content_margin_all(6)
	s.shadow_color = Color(0, 0, 0, 0.55)
	s.shadow_size = 6
	return s

func _boton(b: Button, acento: Color):
	b.add_theme_stylebox_override("normal", _caja(Color(0.08, 0.04, 0.05, 0.9), acento.darkened(0.35), 3))
	b.add_theme_stylebox_override("hover", _caja(Color(0.2, 0.08, 0.08, 0.95), acento, 4))
	b.add_theme_stylebox_override("pressed", _caja(Color(0.3, 0.1, 0.1, 1.0), Color.WHITE, 4))
	# El "focus" se dibuja encima, por eso su fondo es transparente
	b.add_theme_stylebox_override("focus", _caja(Color(0, 0, 0, 0), Color.WHITE, 5))
	b.mouse_entered.connect(func(): _escalar(b, Vector2(1.06, 1.06)))
	b.mouse_exited.connect(func(): _escalar(b, Vector2.ONE))
	b.focus_entered.connect(func(): _escalar(b, Vector2(escala_foco, escala_foco)))
	b.focus_exited.connect(func(): _escalar(b, Vector2.ONE))
	b.button_down.connect(func(): _escalar(b, Vector2(0.95, 0.95)))
	b.button_up.connect(func(): _escalar(b, Vector2(escala_foco, escala_foco)))

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

# Los elementos entran uno tras otro con fade y pop
func _entrada(elementos: Array):
	await get_tree().process_frame
	var i := 0
	for n in elementos:
		var c := n as Control
		c.pivot_offset = c.size / 2
		c.modulate.a = 0.0
		c.scale = Vector2(0.8, 0.8)
		var d := retraso_inicial + i * retraso_entre
		var t := c.create_tween().set_parallel(true)
		c.set_meta("tw", t)
		t.tween_property(c, "modulate:a", 1.0, 0.4).set_delay(d)
		t.tween_property(c, "scale", Vector2.ONE, 0.4).set_delay(d)\
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		i += 1

# Vigila las imágenes grandes: si aparecen o cambian de imagen, se animan
func _process(_delta):
	if not animar_imagenes:
		return
	for ruta in imagenes_personaje:
		var r := get_node_or_null(ruta) as TextureRect
		if r == null:
			continue
		var vis := r.is_visible_in_tree() and r.texture != null
		var prev: Array = _estado.get(r, [null, false])
		if vis and (not prev[1] or prev[0] != r.texture):
			_aparecer(r)
		_estado[r] = [r.texture, vis]

func _aparecer(r: TextureRect):
	if r.has_meta("tw_img"):
		var viejo = r.get_meta("tw_img")
		if viejo is Tween:
			viejo.kill()
	var alfa: float = r.get_meta("alfa", r.modulate.a)
	if alfa < 0.05:
		alfa = 1.0
	r.set_meta("alfa", alfa)
	r.pivot_offset = r.size / 2
	r.modulate.a = 0.0
	r.scale = Vector2(1.1, 1.1)
	var t := r.create_tween().set_parallel(true)
	r.set_meta("tw_img", t)
	t.tween_property(r, "modulate:a", alfa, 0.3)
	t.tween_property(r, "scale", Vector2.ONE, 0.35)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
