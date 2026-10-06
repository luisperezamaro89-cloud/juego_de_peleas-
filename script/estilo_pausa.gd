extends Node
# Se pone en un Node vacío que sea HIJO de "Pausa" (el CanvasLayer) en pelea.tscn.
# Decora todo lo que haya dentro de Pausa: panel, título, botones, sliders y textos.
# No necesita saber los nombres de tus nodos: lo hace por tipo.
# Estilo naranja, igual que Ajustes y el menú principal.

@export var color_fondo := Color(0.10, 0.06, 0.07, 0.96)
@export var color_borde := Color(1.0, 0.55, 0.1)
@export var color_hover := Color(0.45, 0.10, 0.08)
@export var color_presionado := Color(0.25, 0.05, 0.05)
@export var color_texto := Color(0.96, 0.92, 0.85)
@export var tamano_texto := 24
@export var tamano_titulo := 48
@export var tamano_boton := 24
@export var grosor_borde := 3
@export var redondeo := 10
@export var grosor_slider := 6
@export var animar_aparicion := true

var _raiz: Node
var _panel: Control

func _ready():
	_raiz = get_parent()
	_recorrer(_raiz)
	var capa := _raiz as CanvasLayer
	if capa and animar_aparicion:
		capa.visibility_changed.connect(_al_mostrar)

func _recorrer(n: Node):
	if n != self:
		_aplicar(n)
	for h in n.get_children():
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
		_etiqueta(lab)
		return
	if n is Panel or n is PanelContainer:
		var c := n as Control
		c.add_theme_stylebox_override("panel", _caja(color_fondo, color_borde, grosor_borde, redondeo, 16))
		if _panel == null:
			_panel = c

func _caja(bg: Color, borde: Color, grosor: int, radio: int, margen: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = borde
	s.set_border_width_all(grosor)
	s.set_corner_radius_all(radio)
	s.content_margin_left = margen
	s.content_margin_right = margen
	s.content_margin_top = margen * 0.6
	s.content_margin_bottom = margen * 0.6
	s.shadow_color = Color(0, 0, 0, 0.55)
	s.shadow_size = 8
	return s

func _etiqueta(l: Label):
	var es_titulo := l.text.strip_edges().to_upper() == "PAUSA" \
		or String(l.name).to_lower().begins_with("titulo")
	l.add_theme_color_override("font_color", color_borde if es_titulo else color_texto)
	l.add_theme_font_size_override("font_size", tamano_titulo if es_titulo else tamano_texto)
	l.add_theme_color_override("font_outline_color", Color(0.1, 0.05, 0.05))
	l.add_theme_constant_override("outline_size", 10 if es_titulo else 5)

func _boton(b: Button):
	b.add_theme_stylebox_override("normal", _caja(Color(0.10, 0.06, 0.07, 0.95), color_borde, grosor_borde, 8, 12))
	b.add_theme_stylebox_override("hover", _caja(color_hover, color_borde, grosor_borde, 8, 12))
	b.add_theme_stylebox_override("pressed", _caja(color_presionado, color_borde, grosor_borde, 8, 12))
	b.add_theme_stylebox_override("focus", _caja(Color(0, 0, 0, 0), Color.WHITE, 4, 8, 12))
	b.add_theme_color_override("font_color", color_texto)
	b.add_theme_color_override("font_hover_color", Color.WHITE)
	b.add_theme_color_override("font_pressed_color", color_borde)
	b.add_theme_font_size_override("font_size", tamano_boton)
	b.mouse_entered.connect(func(): _escalar(b, Vector2(1.06, 1.06)))
	b.mouse_exited.connect(func(): _escalar(b, Vector2.ONE))
	b.button_down.connect(func(): _escalar(b, Vector2(0.95, 0.95)))
	b.button_up.connect(func(): _escalar(b, Vector2(1.06, 1.06)))

func _escalar(n: Control, e: Vector2):
	n.pivot_offset = n.size / 2
	if n.has_meta("tw"):
		var viejo = n.get_meta("tw")
		if viejo is Tween:
			viejo.kill()
	var t := n.create_tween()
	t.set_ignore_time_scale(true)  # funciona aunque el juego esté en cámara lenta
	n.set_meta("tw", t)
	t.tween_property(n, "scale", e, 0.12)\
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

# El panel aparece con fade y un pequeño "pop" cada vez que se abre la pausa
func _al_mostrar():
	var capa := _raiz as CanvasLayer
	if capa == null or not capa.visible or _panel == null:
		return
	await get_tree().process_frame
	_panel.pivot_offset = _panel.size / 2
	_panel.modulate.a = 0.0
	_panel.scale = Vector2(0.92, 0.92)
	var t := _panel.create_tween().set_parallel(true)
	t.set_ignore_time_scale(true)
	t.tween_property(_panel, "modulate:a", 1.0, 0.2)
	t.tween_property(_panel, "scale", Vector2.ONE, 0.25)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
