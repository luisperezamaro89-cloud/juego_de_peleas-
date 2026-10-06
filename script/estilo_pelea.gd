extends Node
# Se pone en un Node vacío (hijo del nodo raíz "Node2D") de pelea.tscn.
# 1) Arregla el video de fondo: lo saca del mundo y lo deja fijo detrás de todo,
#    cubriendo TODA la pantalla (sin borde negro aunque la cámara se mueva).
# 2) Decora los puntos y el texto de "RONDA" (centrado y que no se salga).

# --- Video ---
@export var arreglar_video := true
@export var nodo_video: NodePath = ^"../FondoVideo"

# --- Puntos ---
@export var color_j1 := Color(1.0, 0.75, 0.2)   # dorado
@export var color_j2 := Color(0.3, 0.85, 1.0)   # cian
@export var tamano_score := 22
@export var contorno_score := 6
# Mueve los puntos para que no tapen la barra de vida (negativo en Y = más arriba)
@export var desplazamiento_score := Vector2(0, -16)
# Alinear los dos puntajes con su barra de vida (misma altura y mismo margen)
@export var alinear_scores := true
@export var margen_x_score := 70.0       # distancia desde el borde izquierdo de la barra
@export var separacion_y_score := 4.0    # espacio entre el texto y la barra

# --- Texto de ronda ---
@export var color_ronda := Color(1.0, 0.55, 0.1)
@export var tamano_ronda := 52
@export var contorno_ronda := 10
# Negativo = más arriba del centro de la pantalla, positivo = más abajo
@export var desplazamiento_ronda_y := -60.0
# Qué parte del ancho de la pantalla puede ocupar como máximo "RONDA 3" (0.5 = la mitad)
@export var ancho_max_ronda := 0.5

func _ready():
	if arreglar_video:
		_arreglar_video.call_deferred()
	_estilo_score(get_node_or_null("../Uix/score_1"), color_j1)
	_estilo_score(get_node_or_null("../Uix/score_2"), color_j2)
	if alinear_scores:
		_alinear_scores()
	var r := get_node_or_null("../Uix/ronda_label") as Label
	if r:
		_estilo_texto(r, color_ronda, tamano_ronda, contorno_ronda)
		_centrar_ronda(r)

func _arreglar_video():
	var v := get_node_or_null(nodo_video) as VideoStreamPlayer
	if v == null:
		return
	var capa := CanvasLayer.new()
	capa.name = "CapaVideo"
	capa.layer = -10  # número negativo = detrás del mundo y de los peleadores
	get_parent().add_child(capa)
	v.reparent(capa, false)
	v.expand = true
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

# score_1 y score_2 pueden ser un Label o una escena con Labels adentro
func _estilo_score(n: Node, color: Color):
	if n == null:
		return
	var etiquetas: Array = []
	if n is Label:
		etiquetas.append(n)
	else:
		etiquetas = n.find_children("*", "Label", true, false)
	for l in etiquetas:
		_estilo_texto(l as Label, color, tamano_score, contorno_score)
	var c := n as Control
	if c and not alinear_scores:
		c.position += desplazamiento_score

# Pone cada puntaje justo encima de su barra de vida, alineado a la izquierda,
# a la misma altura y con el mismo margen en los dos lados
func _alinear_scores():
	await get_tree().process_frame
	await get_tree().process_frame
	_alinear_uno("../Uix/score_1", "../Uix/healthbar_1")
	_alinear_uno("../Uix/score_2", "../Uix/healthbar_2")

func _alinear_uno(ruta_score: String, ruta_barra: String):
	var n := get_node_or_null(ruta_score) as Control
	var barra := get_node_or_null(ruta_barra) as Control
	if n == null or barra == null:
		return
	var etiquetas: Array = []
	if n is Label:
		etiquetas.append(n)
	else:
		etiquetas = n.find_children("*", "Label", true, false)
	var alto := n.size.y
	for l in etiquetas:
		var lab := l as Label
		lab.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		alto = maxf(alto, lab.get_minimum_size().y)
	var r := barra.get_global_rect()
	n.global_position = Vector2(r.position.x + margen_x_score, r.position.y - alto - separacion_y_score)

func _estilo_texto(l: Label, color: Color, tam: int, contorno: int):
	if l == null:
		return
	# Si el Label usa "Label Settings", esos valores pisan los del tema:
	# se copia ese recurso y se cambia ahí
	if l.label_settings != null:
		var ls := l.label_settings.duplicate() as LabelSettings
		ls.font_color = color
		ls.font_size = tam
		ls.outline_color = Color(0.08, 0.03, 0.03)
		ls.outline_size = contorno
		l.label_settings = ls
	l.add_theme_color_override("font_color", color)
	l.add_theme_font_size_override("font_size", tam)
	l.add_theme_color_override("font_outline_color", Color(0.08, 0.03, 0.03))
	l.add_theme_constant_override("outline_size", contorno)

# "RONDA 1" centrado en la pantalla, crece hacia los dos lados y no se corta
func _centrar_ronda(l: Label):
	# Si el nodo tenía la escala agrandada (por eso se veía enorme y borroso), se quita
	l.scale = Vector2.ONE
	l.rotation = 0.0
	l.pivot_offset = Vector2.ZERO

	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.autowrap_mode = TextServer.AUTOWRAP_OFF
	l.clip_text = false

	# El tamaño de letra se limita para que "RONDA 3" siempre quepa en la pantalla
	var vp := get_viewport().get_visible_rect().size
	var fuente: Font = l.get_theme_font("font")
	if l.label_settings != null and l.label_settings.font != null:
		fuente = l.label_settings.font
	if fuente != null:
		var ancho100 := fuente.get_string_size("RONDA 3", HORIZONTAL_ALIGNMENT_LEFT, -1, 100).x
		if ancho100 > 0.0:
			var tam_max := int(vp.x * ancho_max_ronda / ancho100 * 100.0)
			_estilo_texto(l, color_ronda, mini(tamano_ronda, tam_max), contorno_ronda)

	l.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_MINSIZE)
	l.grow_horizontal = Control.GROW_DIRECTION_BOTH
	l.grow_vertical = Control.GROW_DIRECTION_BOTH
	l.offset_top += desplazamiento_ronda_y
	l.offset_bottom += desplazamiento_ronda_y
