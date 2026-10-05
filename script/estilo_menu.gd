extends Control
# Se pone en el VBoxContainer de los botones del menú.
# Da estilo a todos los Button hijos y hace la entrada animada.

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

func _ready():
	for b in get_children():
		if b is Button:
			_estilizar(b)

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
