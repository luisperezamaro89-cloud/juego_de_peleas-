extends VideoStreamPlayer
# Se pone directamente en el nodo VideoStreamPlayer que quieres agrandar y decorar.
# - Lo estira para cubrir TODA la ventana, sin franjas a los lados
#   (se reajusta solo si cambias el tamaño de la ventana).
# - Decoración sutil, que puedes prender o apagar en el Inspector.
# - Al terminar el video, puede pasar solo a otra escena.

# --- Tamaño ---
@export var mantener_proporcion := false   # true = no se deforma, pero puede dejar franjas

# --- Decoración sutil ---
@export var fundido_entrada := true        # el video aparece suave
@export var duracion_fundido := 0.6
@export var vineta := true                 # bordes oscuros muy suaves
@export_range(0.0, 1.0) var intensidad_vineta := 0.35
@export var zoom_lento := false            # se acerca despacio mientras se ve
@export var cantidad_zoom := 0.04          # 0.04 = 4 % más grande al final
@export var duracion_zoom := 10.0

# --- Cambio de escena al terminar ---
@export_file("*.tscn") var siguiente_escena: String = "res://escenas/Resultado.tscn"

func _enter_tree():
	if not finished.is_connected(_al_terminar):
		finished.connect(_al_terminar)

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	expand = true
	_ajustar()
	get_viewport().size_changed.connect(_ajustar)
	if vineta:
		_crear_vineta()
	_animar()

func _al_terminar():
	if siguiente_escena != "":
		get_tree().change_scene_to_file(siguiente_escena)

func _ajustar():
	var vp := get_viewport().get_visible_rect().size
	set_anchors_preset(Control.PRESET_TOP_LEFT, true)

	if not mantener_proporcion:
		global_position = Vector2.ZERO
		size = vp
		return

	# Con proporción: se agranda lo más posible y se centra
	var tex := get_video_texture()
	if tex == null:
		global_position = Vector2.ZERO
		size = vp
		return
	var tam := Vector2(tex.get_width(), tex.get_height())
	if tam.x <= 0.0 or tam.y <= 0.0:
		return
	var escala := minf(vp.x / tam.x, vp.y / tam.y)
	size = tam * escala
	global_position = (vp - size) / 2.0

func _crear_vineta():
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
	var r := TextureRect.new()
	r.texture = tex
	r.set_anchors_preset(Control.PRESET_FULL_RECT)
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_SCALE
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(r)

func _animar():
	await get_tree().process_frame
	if fundido_entrada:
		modulate.a = 0.0
		var t := create_tween()
		t.set_ignore_time_scale(true)
		t.tween_property(self, "modulate:a", 1.0, duracion_fundido)
	if zoom_lento:
		pivot_offset = size / 2.0
		var z := create_tween()
		z.set_ignore_time_scale(true)
		z.tween_property(self, "scale", Vector2.ONE * (1.0 + cantidad_zoom), duracion_zoom)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
