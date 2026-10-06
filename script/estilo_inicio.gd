extends Control
# Pantalla de inicio:
# Fondo + logo central + brasas + viñeta + texto inferior.

# ==========================================
# IMÁGENES
# ==========================================

@export var imagen_fondo: Texture2D

# Logo
var imagen_logo: Texture2D = preload(
	"res://assets/fondos/logo-removebg-preview.png"
)

@export var ancho_logo := 2000.0


# ==========================================
# TEXTO INFERIOR
# ==========================================

@export var texto_inicio := "Presiona cualquier tecla"

@export var color_texto := Color(0.96, 0.92, 0.85)

@export var fuente: Font

@export var tamano_texto := 28

@export var duracion_parpadeo := 1.1


# ==========================================
# COLORES DEL FONDO
# ==========================================

@export var degradado_arriba := Color(0.04, 0.03, 0.04)

@export var degradado_abajo := Color(0.22, 0.09, 0.03)


# ==========================================
# DECORACIÓN
# ==========================================

@export var zoom_lento := true

@export var cantidad_zoom := 0.05

@export var duracion_zoom := 25.0

@export var brasas := true

@export var cantidad_brasas := 35

@export var color_brasas := Color(1.0, 0.55, 0.1, 0.8)

@export var vineta := true

@export_range(0.0, 1.0)
var intensidad_vineta := 0.5


# ==========================================
# ESCENA SIGUIENTE
# ==========================================

@export_file("*.tscn")
var escena_siguiente := \
	"res://escenas/Menu_Principal/menu_principal.tscn"

@export var duracion_fundido := 0.8


# ==========================================
# VARIABLES
# ==========================================

var _fondo: Control

var _logo: TextureRect

var _texto: Label

var _particulas: CPUParticles2D

var _negro: ColorRect

var _listo := false

var _saliendo := false


# ==========================================
# INICIO
# ==========================================

func _ready():

	clip_contents = true

	set_anchors_preset(
		Control.PRESET_FULL_RECT
	)

	mouse_filter = Control.MOUSE_FILTER_STOP


	_crear_fondo()


	if brasas:
		_crear_brasas()


	if vineta:
		_crear_vineta()


	_crear_logo()

	_crear_texto()

	_crear_negro()


	get_viewport().size_changed.connect(
		_ajustar
	)


	_ajustar()


	await get_tree().process_frame


	_ajustar()


	_animar_entrada()


# ==========================================
# FONDO
# ==========================================

func _crear_fondo():

	if imagen_fondo:

		var r := TextureRect.new()

		r.texture = imagen_fondo

		r.expand_mode = \
			TextureRect.EXPAND_IGNORE_SIZE

		r.stretch_mode = \
			TextureRect.STRETCH_KEEP_ASPECT_COVERED

		_fondo = r

	else:

		var g := Gradient.new()

		g.offsets = PackedFloat32Array([
			0.0,
			1.0
		])

		g.colors = PackedColorArray([
			degradado_arriba,
			degradado_abajo
		])


		var tex := GradientTexture2D.new()

		tex.gradient = g

		tex.fill_from = Vector2(
			0.5,
			0.0
		)

		tex.fill_to = Vector2(
			0.5,
			1.0
		)

		tex.width = 8

		tex.height = 256


		var r := TextureRect.new()

		r.texture = tex

		r.expand_mode = \
			TextureRect.EXPAND_IGNORE_SIZE

		r.stretch_mode = \
			TextureRect.STRETCH_SCALE

		_fondo = r


	_fondo.mouse_filter = \
		Control.MOUSE_FILTER_IGNORE

	add_child(_fondo)


# ==========================================
# BRASAS
# ==========================================

func _crear_brasas():

	_particulas = CPUParticles2D.new()

	_particulas.amount = cantidad_brasas

	_particulas.lifetime = 9.0

	_particulas.preprocess = 9.0

	_particulas.emission_shape = \
		CPUParticles2D.EMISSION_SHAPE_RECTANGLE

	_particulas.direction = Vector2(
		0,
		-1
	)

	_particulas.spread = 20.0

	_particulas.gravity = Vector2.ZERO

	_particulas.initial_velocity_min = 15.0

	_particulas.initial_velocity_max = 50.0

	_particulas.scale_amount_min = 2.0

	_particulas.scale_amount_max = 4.0


	var rampa := Gradient.new()

	rampa.offsets = PackedFloat32Array([
		0.0,
		0.2,
		1.0
	])

	rampa.colors = PackedColorArray([
		Color(color_brasas, 0.0),
		color_brasas,
		Color(color_brasas, 0.0)
	])


	_particulas.color_ramp = rampa

	add_child(_particulas)


# ==========================================
# VIÑETA
# ==========================================

func _crear_vineta():

	var g := Gradient.new()

	g.offsets = PackedFloat32Array([
		0.5,
		1.0
	])

	g.colors = PackedColorArray([
		Color(0, 0, 0, 0),
		Color(
			0,
			0,
			0,
			intensidad_vineta
		)
	])


	var tex := GradientTexture2D.new()

	tex.gradient = g

	tex.fill = \
		GradientTexture2D.FILL_RADIAL

	tex.fill_from = Vector2(
		0.5,
		0.5
	)

	tex.fill_to = Vector2(
		1.0,
		1.0
	)

	tex.width = 256

	tex.height = 256


	var r := TextureRect.new()

	r.texture = tex

	r.set_anchors_preset(
		Control.PRESET_FULL_RECT
	)

	r.expand_mode = \
		TextureRect.EXPAND_IGNORE_SIZE

	r.stretch_mode = \
		TextureRect.STRETCH_SCALE

	r.mouse_filter = \
		Control.MOUSE_FILTER_IGNORE

	add_child(r)


# ==========================================
# LOGO
# ==========================================

func _crear_logo():

	_logo = TextureRect.new()

	_logo.texture = imagen_logo

	_logo.expand_mode = \
		TextureRect.EXPAND_IGNORE_SIZE

	_logo.stretch_mode = \
		TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	_logo.mouse_filter = \
		Control.MOUSE_FILTER_IGNORE

	_logo.modulate.a = 0.0

	add_child(_logo)


# ==========================================
# TEXTO INFERIOR
# ==========================================

func _crear_texto():

	_texto = Label.new()

	_texto.text = texto_inicio

	_texto.horizontal_alignment = \
		HORIZONTAL_ALIGNMENT_CENTER

	_texto.vertical_alignment = \
		VERTICAL_ALIGNMENT_CENTER


	_texto.add_theme_font_size_override(
		"font_size",
		tamano_texto
	)


	_texto.add_theme_color_override(
		"font_color",
		color_texto
	)


	_texto.add_theme_color_override(
		"font_outline_color",
		Color(
			0,
			0,
			0,
			0.9
		)
	)


	_texto.add_theme_constant_override(
		"outline_size",
		6
	)


	if fuente:

		_texto.add_theme_font_override(
			"font",
			fuente
		)


	_texto.mouse_filter = \
		Control.MOUSE_FILTER_IGNORE

	_texto.modulate.a = 0.0

	add_child(_texto)


# ==========================================
# NEGRO
# ==========================================

func _crear_negro():

	_negro = ColorRect.new()

	_negro.color = Color.BLACK

	_negro.set_anchors_preset(
		Control.PRESET_FULL_RECT
	)

	_negro.mouse_filter = \
		Control.MOUSE_FILTER_IGNORE

	add_child(_negro)


# ==========================================
# POSICIÓN
# ==========================================

func _ajustar():

	var vp := get_viewport().get_visible_rect().size

	size = vp

	position = Vector2.ZERO


	# --------------------------------------
	# FONDO
	# --------------------------------------

	_fondo.position = Vector2.ZERO

	_fondo.size = vp

	_fondo.pivot_offset = \
		vp / 2.0


	# --------------------------------------
	# LOGO GRANDE Y CENTRADO
	# --------------------------------------

	var logo_w: float = minf(
		ancho_logo,
		vp.x * 1.0
	)

	var logo_h: float = vp.y * 1.0


	_logo.size = Vector2(
		logo_w,
		logo_h
	)


	_logo.position = Vector2(
		(vp.x - logo_w) / 2.0,
		(vp.y - logo_h) / 2.0 - 20.0
	)


	_logo.pivot_offset = \
		_logo.size / 2.0


	# --------------------------------------
	# TEXTO INFERIOR
	# --------------------------------------

	_texto.size = Vector2(
		vp.x,
		60
	)

	_texto.position = Vector2(
		0,
		vp.y * 0.84
	)


	# --------------------------------------
	# BRASAS
	# --------------------------------------

	if _particulas:

		_particulas.position = Vector2(
			vp.x / 2.0,
			vp.y + 10.0
		)

		_particulas.emission_rect_extents = \
			Vector2(
				vp.x / 2.0,
				5.0
			)


# ==========================================
# ANIMACIÓN DE ENTRADA
# ==========================================

func _animar_entrada():

	# --------------------------------------
	# FUNDIDO
	# --------------------------------------

	var t := create_tween()

	t.tween_property(
		_negro,
		"color:a",
		0.0,
		duracion_fundido
	)


	# --------------------------------------
	# ZOOM DEL FONDO
	# --------------------------------------

	if zoom_lento:

		var z := create_tween()

		z.tween_property(
			_fondo,
			"scale",
			Vector2.ONE * (
				1.0 + cantidad_zoom
			),
			duracion_zoom
		).set_trans(
			Tween.TRANS_SINE
		).set_ease(
			Tween.EASE_IN_OUT
		)


	# --------------------------------------
	# ENTRADA DEL LOGO
	# --------------------------------------

	_logo.scale = Vector2(
		0.80,
		0.80
	)


	var logo_tween := \
		create_tween().set_parallel(true)


	logo_tween.tween_property(
		_logo,
		"modulate:a",
		1.0,
		1.0
	).set_delay(0.5)


	logo_tween.tween_property(
		_logo,
		"scale",
		Vector2.ONE,
		1.2
	).set_delay(0.5).set_trans(
		Tween.TRANS_BACK
	).set_ease(
		Tween.EASE_OUT
	)


	# --------------------------------------
	# ESPERAR
	# --------------------------------------

	await get_tree().create_timer(
		1.6
	).timeout


	_flotar_logo()

	_parpadear_texto()


	_listo = true


# ==========================================
# MOVIMIENTO DEL LOGO
# ==========================================

func _flotar_logo():

	var f := create_tween().set_loops()


	f.tween_property(
		_logo,
		"position:y",
		_logo.position.y - 8.0,
		2.5
	).set_trans(
		Tween.TRANS_SINE
	).set_ease(
		Tween.EASE_IN_OUT
	)


	f.tween_property(
		_logo,
		"position:y",
		_logo.position.y,
		2.5
	).set_trans(
		Tween.TRANS_SINE
	).set_ease(
		Tween.EASE_IN_OUT
	)


# ==========================================
# PARPADEO DEL TEXTO
# ==========================================

func _parpadear_texto():

	_texto.modulate.a = 1.0


	var p := create_tween().set_loops()


	p.tween_property(
		_texto,
		"modulate:a",
		0.25,
		duracion_parpadeo
	).set_trans(
		Tween.TRANS_SINE
	).set_ease(
		Tween.EASE_IN_OUT
	)


	p.tween_property(
		_texto,
		"modulate:a",
		1.0,
		duracion_parpadeo
	).set_trans(
		Tween.TRANS_SINE
	).set_ease(
		Tween.EASE_IN_OUT
	)


# ==========================================
# CONTINUAR
# ==========================================

func _input(event):

	if not _listo or _saliendo:
		return


	var presionado := false


	if event is InputEventKey \
	and event.pressed \
	and not event.echo:

		presionado = true


	elif event is InputEventMouseButton \
	and event.pressed:

		presionado = true


	elif event is InputEventJoypadButton \
	and event.pressed:

		presionado = true


	if presionado:

		_continuar()


# ==========================================
# CAMBIAR DE ESCENA
# ==========================================

func _continuar():

	if escena_siguiente == "":

		push_warning(
			"Falta elegir 'Escena Siguiente' en el Inspector."
		)

		return


	_saliendo = true


	var t := create_tween()


	t.tween_property(
		_negro,
		"color:a",
		1.0,
		duracion_fundido
	)


	await t.finished


	get_tree().change_scene_to_file(
		escena_siguiente
	)
