extends VideoStreamPlayer

# ============================================================
# VIDEO DE INTRO / VICTORIA
# ============================================================

# --- Tamaño ---
@export var mantener_proporcion := false
# false = ocupa toda la ventana, aunque pueda deformarse
# true  = mantiene proporción y puede dejar franjas

# --- Decoración ---
@export var fundido_entrada := true
@export var duracion_fundido := 0.6

@export var vineta := true
@export_range(0.0, 1.0) var intensidad_vineta := 0.35

@export var zoom_lento := false
@export var cantidad_zoom := 0.04
@export var duracion_zoom := 10.0

# --- Cambio de escena ---
@export_file("*.tscn") var siguiente_escena: String = "res://escenas/Resultado.tscn"

# --- Fade final ---
@export var esperar_antes_del_fade := 0.3
@export var duracion_fade_final := 1.5


# ============================================================
# INICIO
# ============================================================

func _enter_tree():
	if not finished.is_connected(_al_terminar):
		finished.connect(_al_terminar)


func _ready():

	# No permite que el mouse interfiera con el VideoStreamPlayer
	mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Hace que el video pueda ocupar el tamaño del Control
	expand = true

	# Ajustar video a la ventana
	_ajustar()

	if not get_viewport().size_changed.is_connected(_ajustar):
		get_viewport().size_changed.connect(_ajustar)

	# Crear viñeta
	if vineta:
		_crear_vineta()

	# Animaciones de entrada / zoom
	_animar()

	# Música de la escena
	MusicManager.reproducir_musica("ganador_delincuente")

	# Reproducir video
	play()


# ============================================================
# AJUSTAR VIDEO A LA VENTANA
# ============================================================

func _ajustar():

	var vp := get_viewport().get_visible_rect().size

	set_anchors_preset(Control.PRESET_TOP_LEFT, true)

	# --------------------------------------------------------
	# Sin mantener proporción
	# --------------------------------------------------------

	if not mantener_proporcion:

		global_position = Vector2.ZERO
		size = vp

		return

	# --------------------------------------------------------
	# Mantener proporción
	# --------------------------------------------------------

	var tex := get_video_texture()

	if tex == null:
		global_position = Vector2.ZERO
		size = vp
		return

	var tam := Vector2(
		tex.get_width(),
		tex.get_height()
	)

	if tam.x <= 0.0 or tam.y <= 0.0:
		return

	var escala := minf(
		vp.x / tam.x,
		vp.y / tam.y
	)

	size = tam * escala

	global_position = (vp - size) / 2.0


# ============================================================
# VIÑETA
# ============================================================

func _crear_vineta():

	var g := Gradient.new()

	g.offsets = PackedFloat32Array([
		0.5,
		1.0
	])

	g.colors = PackedColorArray([
		Color(0, 0, 0, 0),
		Color(0, 0, 0, intensidad_vineta)
	])

	var tex := GradientTexture2D.new()

	tex.gradient = g
	tex.fill = GradientTexture2D.FILL_RADIAL
	tex.fill_from = Vector2(0.5, 0.5)
	tex.fill_to = Vector2(1.0, 1.0)

	tex.width = 256
	tex.height = 256

	var r := TextureRect.new()

	r.texture = tex

	r.set_anchors_preset(
		Control.PRESET_FULL_RECT
	)

	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE

	r.stretch_mode = TextureRect.STRETCH_SCALE

	r.mouse_filter = Control.MOUSE_FILTER_IGNORE

	add_child(r)


# ============================================================
# ANIMACIONES
# ============================================================

func _animar():

	await get_tree().process_frame

	# --------------------------------------------------------
	# Fundido de entrada
	# --------------------------------------------------------

	if fundido_entrada:

		modulate.a = 0.0

		var t := create_tween()

		t.set_ignore_time_scale(true)

		t.tween_property(
			self,
			"modulate:a",
			1.0,
			duracion_fundido
		)

	# --------------------------------------------------------
	# Zoom lento
	# --------------------------------------------------------

	if zoom_lento:

		pivot_offset = size / 2.0

		var z := create_tween()

		z.set_ignore_time_scale(true)

		z.tween_property(
			self,
			"scale",
			Vector2.ONE * (1.0 + cantidad_zoom),
			duracion_zoom
		).set_trans(
			Tween.TRANS_SINE
		).set_ease(
			Tween.EASE_IN_OUT
		)


# ============================================================
# CUANDO TERMINA EL VIDEO
# ============================================================

func _al_terminar():

	# Esperar un pequeño momento antes de comenzar el fade
	await get_tree().create_timer(
		esperar_antes_del_fade
	).timeout

	# --------------------------------------------------------
	# Crear fondo negro
	# --------------------------------------------------------

	var fade := ColorRect.new()

	fade.color = Color(
		0,
		0,
		0,
		0
	)

	fade.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE

	add_child(fade)

	# Asegurar que el fade quede por encima del video
	move_child(
		fade,
		get_child_count() - 1
	)

	# --------------------------------------------------------
	# Fade progresivo a negro
	# --------------------------------------------------------

	var tween := create_tween()

	tween.set_ignore_time_scale(true)

	tween.tween_property(
		fade,
		"color",
		Color(0, 0, 0, 1),
		duracion_fade_final
	)

	await tween.finished

	# --------------------------------------------------------
	# Cambiar a la escena de resultados
	# --------------------------------------------------------

	if siguiente_escena != "":
		get_tree().change_scene_to_file(
			siguiente_escena
		)
