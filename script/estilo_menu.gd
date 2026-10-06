extends Control
# Se pone en el VBoxContainer de los botones del menú.
# Da estilo a todos los Button hijos, hace la entrada animada
# y crea un fondo decorativo (degradado + brasas + viñeta) detrás del menú.

@export var color_fondo := Color(0.10, 0.06, 0.07, 0.92)
@export var color_borde := Color(1.0, 0.55, 0.1)
@export var color_hover := Color(0.45, 0.10, 0.08)
@export var color_presionado := Color(0.25, 0.05, 0.05)
@export var color_texto := Color(0.96, 0.92, 0.85)
@export var tamano_fuente := 26
@export var grosor_borde := 3
@export var redondeo := 6
@export var fuente: Font  # opcional: arrastra aquí tu fuente

@export var retraso_inicial := 0.2
@export var retraso_entre := 0.12
@export var duracion := 0.45
@export var escala_inicial := 0.8

# --- Fondo decorativo ---
@export var fondo_decorado := true
@export var degradado_arriba := Color(0.04, 0.03, 0.04)
@export var degradado_abajo := Color(0.22, 0.09, 0.03)
@export var brasas := true
@export var cantidad_brasas := 35
@export var color_brasas := Color(1.0, 0.55, 0.1, 0.8)
@export var vineta := true
@export_range(0.0, 1.0) var intensidad_vineta := 0.5

var _particulas: CPUParticles2D

func _ready():
	for b in get_children():
		if b is Button:
			_estilizar(b)

	if fondo_decorado:
		_crear_fondo()

	await get_tree().process_frame

	var i := 0
	for n in get_children():
		if n is Control:
			n.pivot_offset = n.size / 2
			n.modulate.a = 0.0
			n.scale = Vector2(escala_inicial, escala_inicial)
			var d := retraso_inicial + i * retraso_entre
			var t := create_tween().set_parallel(true)
			t.tween_property(n, "modulate:a", 1.0, duracion).set_delay(d)
			t.tween_property(n, "scale", Vector2.ONE, duracion).set_delay(d)\
				.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			i += 1

func _caja(color: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = color
	s.set_border_width_all(grosor_borde)
	s.border_color = color_borde
	s.set_corner_radius_all(redondeo)
	s.content_margin_left = 24
	s.content_margin_right = 24
	s.content_margin_top = 10
	s.content_margin_bottom = 10
	s.shadow_color = Color(0, 0, 0, 0.5)
	s.shadow_size = 6
	return s

func _estilizar(b: Button):
	b.add_theme_stylebox_override("normal", _caja(color_fondo))
	b.add_theme_stylebox_override("hover", _caja(color_hover))
	b.add_theme_stylebox_override("pressed", _caja(color_presionado))
	b.add_theme_stylebox_override("focus", _caja(color_hover))
	b.add_theme_color_override("font_color", color_texto)
	b.add_theme_color_override("font_hover_color", Color.WHITE)
	b.add_theme_color_override("font_pressed_color", color_borde)
	b.add_theme_font_size_override("font_size", tamano_fuente)
	if fuente:
		b.add_theme_font_override("font", fuente)

# ==========================================
# FONDO DECORATIVO
# ==========================================

func _crear_fondo():
	var capa := CanvasLayer.new()
	capa.layer = -1   # detrás de todo el menú
	add_child(capa)

	capa.add_child(_rect_degradado())
	if brasas:
		_crear_brasas(capa)
	if vineta:
		capa.add_child(_rect_vineta())

	get_viewport().size_changed.connect(_ajustar_brasas)
	_ajustar_brasas()

func _rect_degradado() -> TextureRect:
	var g := Gradient.new()
	g.offsets = PackedFloat32Array([0.0, 1.0])
	g.colors = PackedColorArray([degradado_arriba, degradado_abajo])
	var tex := GradientTexture2D.new()
	tex.gradient = g
	tex.fill_from = Vector2(0.5, 0.0)
	tex.fill_to = Vector2(0.5, 1.0)
	tex.width = 8
	tex.height = 256
	return _rect_pantalla(tex)

func _rect_vineta() -> TextureRect:
	var g := Gradient.new()
	g.offsets = PackedFloat32Array([0.5, 1.0])
	g.colors = PackedColorArray([Color(0, 0, 0, 0), Color(0, 0, 0, intensidad_vineta)])
	var tex := GradientTexture2D.new()
	tex.gradient = g
	tex.fill = GradientTexture2D.FILL_RADIAL
	tex.fill_from = Vector2(0.5, 0.5)
	tex.fill_to = Vector2(1.0, 1.0)
	tex.width = 256
	tex.height = 256
	return _rect_pantalla(tex)

func _rect_pantalla(tex: Texture2D) -> TextureRect:
	var r := TextureRect.new()
	r.texture = tex
	r.set_anchors_preset(Control.PRESET_FULL_RECT)
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_SCALE
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r

func _crear_brasas(capa: CanvasLayer):
	_particulas = CPUParticles2D.new()
	_particulas.amount = cantidad_brasas
	_particulas.lifetime = 9.0
	_particulas.preprocess = 9.0
	_particulas.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	_particulas.direction = Vector2(0, -1)
	_particulas.spread = 20.0
	_particulas.gravity = Vector2.ZERO
	_particulas.initial_velocity_min = 15.0
	_particulas.initial_velocity_max = 50.0
	_particulas.scale_amount_min = 2.0
	_particulas.scale_amount_max = 4.0
	var rampa := Gradient.new()
	rampa.offsets = PackedFloat32Array([0.0, 0.2, 1.0])
	rampa.colors = PackedColorArray([
		Color(color_brasas, 0.0),
		color_brasas,
		Color(color_brasas, 0.0)
	])
	_particulas.color_ramp = rampa
	capa.add_child(_particulas)

func _ajustar_brasas():
	if _particulas == null:
		return
	var vp := get_viewport().get_visible_rect().size
	_particulas.position = Vector2(vp.x / 2.0, vp.y + 10.0)
	_particulas.emission_rect_extents = Vector2(vp.x / 2.0, 5.0)
