extends Node
# Se pone en un Node vacío dentro de cualquier escena.
# Crea por código: viñeta oscura en los bordes + brasas que suben.

@export var vineta := true
@export var intensidad_vineta := 0.65
@export var particulas := true
@export var cantidad := 40
@export var color_particula := Color(1.0, 0.55, 0.15, 0.9)

func _ready():
	var capa := CanvasLayer.new()
	capa.layer = 10
	add_child(capa)
	if vineta:
		_crear_vineta(capa)
	if particulas:
		_crear_particulas(capa)

func _crear_vineta(capa: CanvasLayer):
	var g := Gradient.new()
	g.offsets = PackedFloat32Array([0.55, 1.0])
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
	capa.add_child(r)

func _crear_particulas(capa: CanvasLayer):
	var tam := get_viewport().get_visible_rect().size
	var p := CPUParticles2D.new()
	p.position = Vector2(tam.x / 2, tam.y + 10)
	p.amount = cantidad
	p.lifetime = tam.y / 50.0
	p.preprocess = p.lifetime
	p.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	p.emission_rect_extents = Vector2(tam.x / 2, 5)
	p.direction = Vector2(0, -1)
	p.spread = 20.0
	p.gravity = Vector2.ZERO
	p.initial_velocity_min = 30.0
	p.initial_velocity_max = 80.0
	p.scale_amount_min = 1.5
	p.scale_amount_max = 4.0
	p.color = color_particula
	var rampa := Gradient.new()
	rampa.offsets = PackedFloat32Array([0.0, 0.8, 1.0])
	rampa.colors = PackedColorArray([Color(1, 1, 1, 0), Color(1, 1, 1, 1), Color(1, 1, 1, 0)])
	p.color_ramp = rampa
	capa.add_child(p)
