extends Node
# Se pone en un Node vacío (hijo de la raíz "Control") de la escena de gestión de jugadores.
# Decora TODA la escena con la paleta cian de admin: botones, campos, consola,
# lista de sugerencias, desplegable y los dos paneles (Más opciones y Editar).
# Botón de borrar en rojo, botones de volver/cancelar en gris azulado.

# --- Colores ---
@export var color_fondo_pantalla := Color(0.03, 0.06, 0.09)
@export var color_fondo := Color(0.05, 0.09, 0.12, 0.97)
@export var color_borde := Color(0.25, 0.85, 0.95)
@export var color_hover := Color(0.08, 0.30, 0.38)
@export var color_presionado := Color(0.04, 0.15, 0.20)
@export var color_texto := Color(0.85, 0.97, 1.0)
@export var color_consola := Color(0.65, 1.0, 0.85)
@export var color_aviso := Color(1.0, 0.85, 0.3)

# --- Tamaños ---
@export var tamano_texto := 16
@export var tamano_boton := 15
@export var tamano_titulo_panel := 30
@export var tamano_subtitulo := 20
@export var tamano_consola := 15

# --- Opciones ---
@export var crear_fondo := true
@export var animar_entrada := true

# --- Paneles (Más opciones y Editar) ---
@export var usar_iconos := true
@export var ruta_iconos := "res://iconos/"   # carpeta donde copias los PNG
@export var ancho_boton_panel := 280
@export var alto_boton_panel := 48
@export var tamano_boton_panel := 18

var _raiz: Node
var _mono: SystemFont

func _ready():
	_raiz = get_parent()
	_mono = SystemFont.new()
	_mono.font_names = PackedStringArray(["Consolas", "Cascadia Mono", "Courier New", "monospace"])
	if crear_fondo:
		_fondo_pantalla()
	_recorrer(_raiz)
	_acomodar_paneles()
	if animar_entrada:
		_entrada()

func _fondo_pantalla():
	var capa := CanvasLayer.new()
	capa.layer = -10
	add_child(capa)
	var cr := ColorRect.new()
	cr.color = color_fondo_pantalla
	cr.set_anchors_preset(Control.PRESET_FULL_RECT)
	cr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	capa.add_child(cr)

func _recorrer(n: Node):
	if n != self:
		_aplicar(n)
	for h in n.get_children():
		_recorrer(h)

# ------------------------------------------------------------
# CAJAS Y PALETAS
# ------------------------------------------------------------
func _caja(bg: Color, borde: Color, grosor := 2, radio := 4, margen := 8) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = borde
	s.set_border_width_all(grosor)
	s.set_corner_radius_all(radio)
	s.content_margin_left = margen
	s.content_margin_right = margen
	s.content_margin_top = margen * 0.5
	s.content_margin_bottom = margen * 0.5
	s.shadow_color = Color(borde.r, borde.g, borde.b, 0.2)
	s.shadow_size = 6
	return s

# Según el nombre del botón: borrar = rojo, volver/cancelar = gris azulado
func _paleta(nombre: String) -> Dictionary:
	var n := nombre.to_lower()
	if n.contains("borrar"):
		return {"bg": Color(0.14, 0.05, 0.06, 0.97), "borde": Color(1.0, 0.35, 0.3),
			"hover": Color(0.45, 0.10, 0.10), "pres": Color(0.25, 0.05, 0.05)}
	if n.contains("volver") or n.contains("regresar") or n.contains("cancelar"):
		return {"bg": Color(0.07, 0.10, 0.12, 0.97), "borde": Color(0.55, 0.68, 0.74),
			"hover": Color(0.16, 0.24, 0.28), "pres": Color(0.08, 0.13, 0.16)}
	return {"bg": color_fondo, "borde": color_borde, "hover": color_hover, "pres": color_presionado}

# ------------------------------------------------------------
# APLICAR ESTILO SEGÚN EL TIPO DE NODO
# ------------------------------------------------------------
func _aplicar(n: Node):
	var ob := n as OptionButton
	if ob:
		_boton(ob)
		_menu_emergente(ob.get_popup())
		return
	var b := n as Button
	if b:
		_boton(b)
		return
	var le := n as LineEdit
	if le:
		_campo(le)
		return
	var te := n as TextEdit
	if te:
		_consola_texto(te)
		return
	var rt := n as RichTextLabel
	if rt:
		rt.add_theme_stylebox_override("normal", _caja(Color(0.03, 0.06, 0.08, 0.97), color_borde.darkened(0.2), 2, 6, 10))
		rt.add_theme_color_override("default_color", color_consola)
		rt.add_theme_font_size_override("normal_font_size", tamano_consola)
		rt.add_theme_font_override("normal_font", _mono)
		return
	var tree := n as Tree
	if tree:
		_estilo_tree(tree)
		return
	var il := n as ItemList
	if il:
		_estilo_itemlist(il)
		return
	var lab := n as Label
	if lab:
		_etiqueta(lab)
		return
	if n is Panel or n is PanelContainer:
		var c := n as Control
		c.add_theme_stylebox_override("panel", _caja(color_fondo, color_borde, 3, 10, 14))
		c.visibility_changed.connect(func(): _pop(c))

func _etiqueta(l: Label):
	var nombre := String(l.name)
	var color := color_texto
	var tam := tamano_texto
	var contorno := 4
	if nombre == "TituloMasOpciones" or nombre == "TituloEditar":
		color = color_borde
		tam = tamano_titulo_panel
		contorno = 8
	elif nombre.begins_with("Titulo"):
		color = color_borde
		tam = tamano_subtitulo
		contorno = 5
	elif nombre == "MensajeEditar":
		color = color_aviso
	l.add_theme_color_override("font_color", color)
	l.add_theme_font_size_override("font_size", tam)
	l.add_theme_color_override("font_outline_color", Color(0.02, 0.05, 0.07))
	l.add_theme_constant_override("outline_size", contorno)

func _boton(b: Button):
	var p := _paleta(String(b.name))
	b.add_theme_stylebox_override("normal", _caja(p["bg"], p["borde"], 2, 4, 8))
	b.add_theme_stylebox_override("hover", _caja(p["hover"], p["borde"], 2, 4, 8))
	b.add_theme_stylebox_override("pressed", _caja(p["pres"], p["borde"], 2, 4, 8))
	b.add_theme_stylebox_override("focus", _caja(Color(0, 0, 0, 0), Color.WHITE, 2, 4, 8))
	b.add_theme_color_override("font_color", color_texto)
	b.add_theme_color_override("font_hover_color", Color.WHITE)
	b.add_theme_color_override("font_pressed_color", p["borde"])
	b.add_theme_font_size_override("font_size", tamano_boton)
	b.mouse_entered.connect(func(): _escalar(b, Vector2(1.06, 1.06)))
	b.mouse_exited.connect(func(): _escalar(b, Vector2.ONE))
	b.button_down.connect(func(): _escalar(b, Vector2(0.95, 0.95)))
	b.button_up.connect(func(): _escalar(b, Vector2(1.06, 1.06)))

func _campo(le: LineEdit):
	le.add_theme_stylebox_override("normal", _caja(Color(0.03, 0.06, 0.08, 0.97), color_borde.darkened(0.35), 2, 4, 8))
	le.add_theme_stylebox_override("read_only", _caja(Color(0.03, 0.06, 0.08, 0.97), color_borde.darkened(0.35), 2, 4, 8))
	le.add_theme_stylebox_override("focus", _caja(color_presionado, color_borde, 2, 4, 8))
	le.add_theme_color_override("font_color", color_texto)
	le.add_theme_color_override("font_uneditable_color", color_texto)
	le.add_theme_color_override("font_placeholder_color", Color(color_texto.r, color_texto.g, color_texto.b, 0.4))
	le.add_theme_color_override("caret_color", color_borde)
	le.add_theme_color_override("selection_color", Color(color_borde.r, color_borde.g, color_borde.b, 0.35))
	le.add_theme_font_size_override("font_size", tamano_texto)

func _consola_texto(te: TextEdit):
	var normal := _caja(Color(0.03, 0.06, 0.08, 0.97), color_borde.darkened(0.2), 2, 6, 10)
	te.add_theme_stylebox_override("normal", normal)
	te.add_theme_stylebox_override("read_only", normal)
	te.add_theme_stylebox_override("focus", _caja(Color(0.03, 0.06, 0.08, 0.97), color_borde, 2, 6, 10))
	te.add_theme_color_override("font_color", color_consola)
	te.add_theme_color_override("font_readonly_color", color_consola)
	te.add_theme_color_override("caret_color", color_borde)
	te.add_theme_color_override("selection_color", Color(color_borde.r, color_borde.g, color_borde.b, 0.3))
	te.add_theme_color_override("current_line_color", Color(1, 1, 1, 0.04))
	te.add_theme_font_size_override("font_size", tamano_consola)
	te.add_theme_font_override("font", _mono)

func _estilo_tree(t: Tree):
	t.add_theme_stylebox_override("panel", _caja(Color(0.03, 0.06, 0.08, 0.97), color_borde.darkened(0.2), 2, 6, 6))
	t.add_theme_stylebox_override("focus", _caja(Color(0, 0, 0, 0), color_borde, 2, 6, 6))
	t.add_theme_stylebox_override("selected", _caja(color_hover, color_borde, 1, 3, 4))
	t.add_theme_stylebox_override("selected_focus", _caja(color_hover, color_borde, 1, 3, 4))
	t.add_theme_stylebox_override("cursor", _caja(Color(0, 0, 0, 0), color_borde, 1, 3, 4))
	t.add_theme_stylebox_override("cursor_unfocused", _caja(Color(0, 0, 0, 0), color_borde, 1, 3, 4))
	t.add_theme_color_override("font_color", color_texto)
	t.add_theme_color_override("font_selected_color", Color.WHITE)
	t.add_theme_color_override("guide_color", Color(0, 0, 0, 0))
	t.add_theme_font_size_override("font_size", tamano_texto)

func _estilo_itemlist(il: ItemList):
	il.add_theme_stylebox_override("panel", _caja(Color(0.03, 0.06, 0.08, 0.97), color_borde.darkened(0.2), 2, 6, 6))
	il.add_theme_stylebox_override("focus", _caja(Color(0, 0, 0, 0), color_borde, 2, 6, 6))
	il.add_theme_stylebox_override("selected", _caja(color_hover, color_borde, 1, 3, 4))
	il.add_theme_stylebox_override("selected_focus", _caja(color_hover, color_borde, 1, 3, 4))
	il.add_theme_stylebox_override("hovered", _caja(color_presionado, color_borde.darkened(0.3), 1, 3, 4))
	il.add_theme_stylebox_override("cursor", _caja(Color(0, 0, 0, 0), color_borde, 1, 3, 4))
	il.add_theme_stylebox_override("cursor_unfocused", _caja(Color(0, 0, 0, 0), color_borde, 1, 3, 4))
	il.add_theme_color_override("font_color", color_texto)
	il.add_theme_color_override("font_selected_color", Color.WHITE)
	il.add_theme_font_size_override("font_size", tamano_texto)

# Lista que se abre en el desplegable de personaje
func _menu_emergente(p: PopupMenu):
	p.add_theme_stylebox_override("panel", _caja(color_fondo, color_borde, 2, 6, 6))
	p.add_theme_stylebox_override("hover", _caja(color_hover, color_borde, 1, 3, 4))
	p.add_theme_color_override("font_color", color_texto)
	p.add_theme_color_override("font_hover_color", Color.WHITE)
	p.add_theme_font_size_override("font_size", tamano_texto + 2)

# ------------------------------------------------------------
# ANIMACIONES
# ------------------------------------------------------------
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

# Los paneles (Más opciones, Editar) aparecen con fade y "pop" cada vez que se abren
func _pop(c: Control):
	if not c.is_visible_in_tree():
		return
	await get_tree().process_frame
	c.pivot_offset = c.size / 2
	c.modulate.a = 0.0
	c.scale = Vector2(0.92, 0.92)
	var t := c.create_tween().set_parallel(true)
	t.tween_property(c, "modulate:a", 1.0, 0.25)
	t.tween_property(c, "scale", Vector2.ONE, 0.3)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

# Al abrir la escena, los botones entran deslizándose y el resto con fade
func _entrada():
	await get_tree().process_frame
	var i := 0
	for h in _raiz.get_children():
		var c := h as Control
		if c == null or c is Panel or c is PanelContainer:
			continue
		var d := 0.1 + i * 0.05
		var destino := c.position
		c.modulate.a = 0.0
		var t := c.create_tween().set_parallel(true)
		t.tween_property(c, "modulate:a", 1.0, 0.35).set_delay(d)
		if c is Button:
			c.position.x = destino.x - 40
			t.tween_property(c, "position:x", destino.x, 0.35).set_delay(d)\
				.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		i += 1

# ------------------------------------------------------------
# ACOMODAR LOS PANELES (centrado, tamaños parejos e iconos)
# ------------------------------------------------------------
func _acomodar_paneles():
	_acomodar_opciones()
	_acomodar_editar()

func _acomodar_opciones():
	var v := _raiz.get_node_or_null("PanelMasOpciones/VBoxContainer") as VBoxContainer
	if v == null:
		return
	# La caja ocupa todo el panel y su contenido queda centrado
	v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, 24)
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.add_theme_constant_override("separation", 12)

	var titulo := v.get_node_or_null("TituloMasOpciones") as Label
	if titulo:
		titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		titulo.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		# Línea decorativa debajo del título
		var linea := ColorRect.new()
		linea.color = color_borde
		linea.custom_minimum_size = Vector2(240, 3)
		linea.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		v.add_child(linea)
		v.move_child(linea, titulo.get_index() + 1)

	var iconos := {
		"BtnVictorias": "trofeo.png",
		"BtnDerrotas": "craneo.png",
		"BtnPersonaje": "persona.png",
		"BtnNombre": "etiqueta.png",
		"BtnVolver": "flecha.png",
	}
	for nombre in iconos:
		var b := v.get_node_or_null(nombre) as Button
		if b:
			_boton_panel(b, iconos[nombre], ancho_boton_panel, alto_boton_panel)

	# Un pequeño espacio antes de "Volver"
	var volver := v.get_node_or_null("BtnVolver")
	if volver:
		var esp := Control.new()
		esp.custom_minimum_size = Vector2(0, 8)
		v.add_child(esp)
		v.move_child(esp, volver.get_index())

func _acomodar_editar():
	var v := _raiz.get_node_or_null("PanelEditar/VBoxContainer")
	if v == null:
		return
	var msg := v.get_node_or_null("MensajeEditar") as Label
	if msg:
		msg.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var titulo := v.get_node_or_null("TituloEditar") as Label
	if titulo:
		titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var fila := v.get_node_or_null("FilaBotones") as HBoxContainer
	if fila:
		fila.alignment = BoxContainer.ALIGNMENT_CENTER
		fila.add_theme_constant_override("separation", 24)
		var iconos := {"BtnGuardarEdicion": "check.png", "BtnCancelarEdicion": "cruz.png"}
		for nombre in iconos:
			var b := fila.get_node_or_null(nombre) as Button
			if b:
				_boton_panel(b, iconos[nombre], 220, alto_boton_panel)

func _boton_panel(b: Button, icono: String, ancho: int, alto: int):
	b.custom_minimum_size = Vector2(ancho, alto)
	b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	b.add_theme_font_size_override("font_size", tamano_boton_panel)
	if not usar_iconos or icono == "":
		return
	var ruta := ruta_iconos + icono
	if not ResourceLoader.exists(ruta):
		return
	var col: Color = _paleta(String(b.name))["borde"]
	b.icon = load(ruta)
	b.expand_icon = true
	b.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
	b.add_theme_constant_override("icon_max_width", 28)
	b.add_theme_constant_override("h_separation", 12)
	b.add_theme_color_override("icon_normal_color", col)
	b.add_theme_color_override("icon_hover_color", Color.WHITE)
	b.add_theme_color_override("icon_pressed_color", col)
	b.add_theme_color_override("icon_focus_color", col)
