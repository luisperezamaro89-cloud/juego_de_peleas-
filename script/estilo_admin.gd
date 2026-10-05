extends Node
# Se pone en BtnAdmin y en PopUpAdmin (el mismo script en los dos).
# Estiliza el nodo y todos sus hijos, incluidos los internos de un diálogo
# (barra de título, botones OK/Cancelar, caja de texto, textos y paneles).
# Paleta cian/azul oscuro para diferenciarlo del menú principal.

@export var color_fondo := Color(0.05, 0.09, 0.12, 0.96)
@export var color_borde := Color(0.25, 0.85, 0.95)
@export var color_hover := Color(0.08, 0.30, 0.38)
@export var color_presionado := Color(0.04, 0.15, 0.20)
@export var color_texto := Color(0.85, 0.97, 1.0)
@export var tamano_fuente := 20
@export var grosor_borde := 2
@export var redondeo := 3
@export var animar_botones := true
@export var fuente: Font  # opcional

# Solo para el diálogo de acceso
@export var texto_ok := "ENTRAR"
@export var texto_cancelar := "CANCELAR"
@export var ancho_minimo := 380

@export var nodo_extra: NodePath = ^"../PopUpAdmin"  # otro nodo a decorar (hermano)
@export var color_error := Color(1.0, 0.35, 0.3)

func _ready():
	_recorrer(self)
	var extra := get_node_or_null(nodo_extra)
	if extra and extra != self:
		_recorrer(extra)

func _recorrer(n: Node):
	_aplicar(n)
	for h in n.get_children(true):  # true = incluye nodos internos
		_recorrer(h)

func _aplicar(n: Node):
	var b := n as Button
	if b:
		_boton(b)
		return
	var le := n as LineEdit
	if le:
		le.add_theme_stylebox_override("normal", _caja(color_presionado, false))
		le.add_theme_stylebox_override("focus", _caja(color_hover, false))
		le.add_theme_color_override("font_color", color_texto)
		le.add_theme_color_override("caret_color", color_borde)
		le.add_theme_font_size_override("font_size", tamano_fuente)
		return
	var lab := n as Label
	if lab:
		var es_error := String(lab.name).to_lower().contains("error")
		lab.add_theme_color_override("font_color", color_error if es_error else color_texto)
		lab.add_theme_font_size_override("font_size", tamano_fuente)
		if fuente:
			lab.add_theme_font_override("font", fuente)
		return
	var w := n as Window
	if w:
		_ventana(w)
		return
	if n is Panel or n is PanelContainer:
		n.call("add_theme_stylebox_override", "panel", _caja(color_fondo, true))

func _ventana(w: Window):
	w.add_theme_stylebox_override("panel", _caja(color_fondo, true))
	# Barra de título y borde: se copia el estilo original y solo se cambian colores
	var eb := w.get_theme_stylebox("embedded_border") as StyleBoxFlat
	if eb:
		var c := eb.duplicate() as StyleBoxFlat
		c.bg_color = color_hover
		c.border_color = color_borde
		w.add_theme_stylebox_override("embedded_border", c)
		w.add_theme_stylebox_override("embedded_unfocused_border", c)
	w.add_theme_color_override("title_color", color_texto)
	w.add_theme_font_size_override("title_font_size", tamano_fuente)
	var d := w as AcceptDialog
	if d:
		d.ok_button_text = texto_ok
		d.min_size = Vector2i(ancho_minimo, 0)
	var cd := w as ConfirmationDialog
	if cd:
		cd.cancel_button_text = texto_cancelar

func _caja(color: Color, es_panel: bool) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = color
	s.set_border_width_all(grosor_borde + (1 if es_panel else 0))
	s.border_color = color_borde
	s.set_corner_radius_all(redondeo)
	var m := 18 if es_panel else 12
	s.content_margin_left = m
	s.content_margin_right = m
	s.content_margin_top = m * 0.6
	s.content_margin_bottom = m * 0.6
	s.shadow_color = Color(color_borde.r, color_borde.g, color_borde.b, 0.25)
	s.shadow_size = 8
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
	if animar_botones:
		b.mouse_entered.connect(func(): _escalar(b, Vector2(1.06, 1.06)))
		b.mouse_exited.connect(func(): _escalar(b, Vector2.ONE))
		b.button_down.connect(func(): _escalar(b, Vector2(0.95, 0.95)))
		b.button_up.connect(func(): _escalar(b, Vector2(1.06, 1.06)))

func _escalar(b: Button, e: Vector2):
	b.pivot_offset = b.size / 2
	var t := b.create_tween()
	t.tween_property(b, "scale", e, 0.12)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
