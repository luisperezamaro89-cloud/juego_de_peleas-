extends Control
# Se pone en PanelCreditos y en PanelAjustes (el mismo script en los dos).
# Estiliza el panel y todo lo que tiene dentro: títulos, textos, botones y sliders.
# Además, el panel aparece con un fade y un pequeño "pop" cada vez que se abre.

@export var color_fondo := Color(0.10, 0.06, 0.07, 0.96)
@export var color_borde := Color(1.0, 0.55, 0.1)
@export var color_hover := Color(0.45, 0.10, 0.08)
@export var color_presionado := Color(0.25, 0.05, 0.05)
@export var color_texto := Color(0.96, 0.92, 0.85)
@export var tamano_fuente := 22
@export var tamano_titulo := 40
@export var grosor_borde := 3
@export var redondeo := 8
@export var grosor_slider := 6
@export var animar_aparicion := true
@export var fuente: Font  # opcional

func _ready():
	_recorrer(self)
	if animar_aparicion:
		visibility_changed.connect(_al_cambiar_visibilidad)

func _recorrer(n: Node):
	_aplicar(n)
	for h in n.get_children(true):
		_recorrer(h)

func _aplicar(n: Node):
	var b := n as Button
	if b:
		_boton(b)
		return
	var sl := n as HSlider
	if sl:
		_slider(sl)
		return
	var lab := n as Label
	if lab:
		var es_titulo := String(lab.name).to_lower().begins_with("titulo")
		lab.add_theme_color_override("font_color", color_borde if es_titulo else color_texto)
		lab.add_theme_font_size_override("font_size", tamano_titulo if es_titulo else tamano_fuente)
		if es_titulo:
			lab.add_theme_color_override("font_outline_color", Color(0.1, 0.05, 0.05))
			lab.add_theme_constant_override("outline_size", 8)
		if fuente:
			lab.add_theme_font_override("font", fuente)
		return
	if n is Panel or n is PanelContainer:
		n.call("add_theme_stylebox_override", "panel", _caja(color_fondo, true))

func _caja(color: Color, es_panel: bool) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = color
	s.set_border_width_all(grosor_borde)
	s.border_color = color_borde
	s.set_corner_radius_all(redondeo)
	var mx := 18 if es_panel else 14
	var my := 14 if es_panel else 8
	s.content_margin_left = mx
	s.content_margin_right = mx
	s.content_margin_top = my
	s.content_margin_bottom = my
	s.shadow_color = Color(0, 0, 0, 0.55)
	s.shadow_size = 10 if es_panel else 5
	return s

func _boton(b: Button):
	b.add_theme_stylebox_override("normal", _caja(color_fondo, false))
	b.add_theme_stylebox_override("hover", _caja(color_hover, false))
	b.add_theme_stylebox_override("pressed", _caja(color_presionado, false))
	b.add_theme_stylebox_override("focus", _caja(color_hover, false))
	b.add_theme_color_override("font_color", color_texto)
	b.add_theme_color_override("font_hover_color", Color.WHITE)
	b.add_theme_color_override("font_pressed_color", color_borde)
	b.add_theme_font_size_override("font_size", tamano_fuente)
	if fuente:
		b.add_theme_font_override("font", fuente)
	b.mouse_entered.connect(func(): _escalar(b, Vector2(1.06, 1.06)))
	b.mouse_exited.connect(func(): _escalar(b, Vector2.ONE))
	b.button_down.connect(func(): _escalar(b, Vector2(0.95, 0.95)))
	b.button_up.connect(func(): _escalar(b, Vector2(1.06, 1.06)))

func _escalar(b: Button, e: Vector2):
	b.pivot_offset = b.size / 2
	var t := b.create_tween()
	t.tween_property(b, "scale", e, 0.12)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _slider(sl: HSlider):
	var pista := StyleBoxFlat.new()
	pista.bg_color = Color(0.22, 0.13, 0.13)
	pista.set_corner_radius_all(4)
	pista.content_margin_top = grosor_slider
	pista.content_margin_bottom = grosor_slider

	var relleno := StyleBoxFlat.new()
	relleno.bg_color = color_borde
	relleno.set_corner_radius_all(4)
	relleno.content_margin_top = grosor_slider
	relleno.content_margin_bottom = grosor_slider

	var relleno_hl := relleno.duplicate() as StyleBoxFlat
	relleno_hl.bg_color = color_borde.lightened(0.3)

	sl.add_theme_stylebox_override("slider", pista)
	sl.add_theme_stylebox_override("grabber_area", relleno)
	sl.add_theme_stylebox_override("grabber_area_highlight", relleno_hl)
	sl.add_theme_icon_override("grabber", _perilla(color_borde))
	sl.add_theme_icon_override("grabber_highlight", _perilla(Color.WHITE))
	sl.add_theme_icon_override("grabber_disabled", _perilla(Color(0.4, 0.4, 0.4)))

# Círculo de color para la perilla del slider
func _perilla(color: Color) -> GradientTexture2D:
	var g := Gradient.new()
	g.offsets = PackedFloat32Array([0.0, 0.88, 1.0])
	g.colors = PackedColorArray([color, color, Color(color.r, color.g, color.b, 0.0)])
	var t := GradientTexture2D.new()
	t.gradient = g
	t.fill = GradientTexture2D.FILL_RADIAL
	t.fill_from = Vector2(0.5, 0.5)
	t.fill_to = Vector2(1.0, 0.5)
	t.width = 28
	t.height = 28
	return t

func _al_cambiar_visibilidad():
	if not visible:
		return
	await get_tree().process_frame
	pivot_offset = size / 2
	modulate.a = 0.0
	scale = Vector2(0.92, 0.92)
	var t := create_tween().set_parallel(true)
	t.tween_property(self, "modulate:a", 1.0, 0.25)
	t.tween_property(self, "scale", Vector2.ONE, 0.3)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
