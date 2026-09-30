extends Control

var nombres_j1 = ["estudiante", "delincuente"]
var nombres_j2 = ["estudiante", "delincuente"]

# MAPEO A LAS RUTAS DE TUS ESCENAS
var rutas_j1 = {
	"estudiante": "res://peleadores/peleador1.tscn",
	"delincuente": "res://peleadores/peleador_2.tscn"
}

var rutas_j2 = {
	"estudiante": "res://peleadores/peleador1.tscn",
	"delincuente": "res://peleadores/peleador_2.tscn"
}

const ESCENA_PELEA := "res://escenas/pelea.tscn"

@onready var titulo: Label = $TituloSeleccion

@onready var botones_j1: Array[Button] = [
	$VBoxContainer/HBoxContainer/ContenedorJ1/BtnestudianteJ1,
	$VBoxContainer/HBoxContainer/ContenedorJ1/BtndelincuenteJ1
]

@onready var botones_j2: Array[Button] = [
	$VBoxContainer/HBoxContainer/ContenedorJ2/BtnestudianteJ2,
	$VBoxContainer/HBoxContainer/ContenedorJ2/BtndelincuenteJ2
]

@onready var fondo_personaje: TextureRect = $FondoPersonaje
@onready var fondo_personaje2: TextureRect = $FondoPersonaje2

var fondo_estudiante = preload("res://Uix/placeholder1.png")
var fondo_delincuente = preload("res://Uix/placeholder2.png")

var indice_j1 = 0
var indice_j2 = 0

var personaje_j1 = ""
var personaje_j2 = ""

var turno = 1          # 1 = elige J1, 2 = elige J2
var terminado = false


func _ready():
	aplicar_estilo_seleccion()

	fondo_personaje.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fondo_personaje2.mouse_filter = Control.MOUSE_FILTER_IGNORE

	actualizar_visual()


func aplicar_estilo_seleccion():
	var estilo = StyleBoxFlat.new()
	estilo.border_color = Color(1, 0.8, 0, 1)
	estilo.border_width_left = 4
	estilo.border_width_right = 4
	estilo.border_width_top = 4
	estilo.border_width_bottom = 4
	estilo.bg_color = Color(0, 0, 0, 0)

	for boton in botones_j1 + botones_j2:
		boton.add_theme_stylebox_override("focus", estilo)


# ==========================================
# VISUAL
# ==========================================

func actualizar_visual():
	# Título con el turno
	if terminado:
		titulo.text = "¡LISTOS!"
	elif turno == 1:
		titulo.text = "JUGADOR 1: ELIGE"
	else:
		titulo.text = "JUGADOR 2: ELIGE"

	# Fondos según el personaje al que apunta cada jugador
	cambiar_fondo_j1(nombres_j1[indice_j1])
	cambiar_fondo_j2(nombres_j2[indice_j2])

	# Colores de los botones
	pintar_columna(botones_j1, indice_j1, turno == 1 and not terminado, personaje_j1 != "")
	pintar_columna(botones_j2, indice_j2, turno == 2 and not terminado, personaje_j2 != "")

	# El borde amarillo (foco) lo lleva solo el jugador que tiene el turno
	if terminado:
		get_viewport().gui_release_focus()
	elif turno == 1:
		botones_j1[indice_j1].grab_focus()
	else:
		botones_j2[indice_j2].grab_focus()


# activo = le toca a esa columna, elegido = ya confirmó su personaje
func pintar_columna(botones: Array[Button], indice: int, activo: bool, elegido: bool):
	for i in botones.size():
		if elegido:
			if i == indice:
				botones[i].modulate = Color(0.6, 1.0, 0.6, 1.0)   # verde: elegido
			else:
				botones[i].modulate = Color(1, 1, 1, 0.4)
		elif activo:
			botones[i].modulate = Color(1, 1, 1, 1)
		else:
			botones[i].modulate = Color(1, 1, 1, 0.3)             # esperando turno


func cambiar_fondo_j1(personaje: String):
	if personaje == "estudiante":
		fondo_personaje.texture = fondo_estudiante
	elif personaje == "delincuente":
		fondo_personaje.texture = fondo_delincuente


func cambiar_fondo_j2(personaje: String):
	if personaje == "estudiante":
		fondo_personaje2.texture = fondo_estudiante
	elif personaje == "delincuente":
		fondo_personaje2.texture = fondo_delincuente


# ==========================================
# TECLADO
# ==========================================

func _input(event):
	if terminado:
		return
	if not (event is InputEventKey) or not event.pressed:
		return

	var tecla = event.keycode
	var es_enter = tecla == KEY_ENTER or tecla == KEY_KP_ENTER

	# Estas teclas son de la selección: se consumen siempre para que Godot
	# no mueva el foco ni "presione" botones por su cuenta.
	if tecla in [KEY_W, KEY_S, KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT, KEY_SPACE] or es_enter:
		get_viewport().set_input_as_handled()

	if event.echo:
		return

	if turno == 1:
		# JUGADOR 1: W / S y Enter
		if tecla == KEY_W:
			indice_j1 = posmod(indice_j1 - 1, botones_j1.size())
		elif tecla == KEY_S:
			indice_j1 = posmod(indice_j1 + 1, botones_j1.size())
		elif es_enter:
			confirmar_j1()
		else:
			return

	elif turno == 2:
		# JUGADOR 2: flechas arriba / abajo y Enter
		if tecla == KEY_UP:
			indice_j2 = posmod(indice_j2 - 1, botones_j2.size())
		elif tecla == KEY_DOWN:
			indice_j2 = posmod(indice_j2 + 1, botones_j2.size())
		elif es_enter:
			confirmar_j2()
		else:
			return

	actualizar_visual()

	if terminado:
		await get_tree().create_timer(0.6).timeout
		get_tree().change_scene_to_file(ESCENA_PELEA)


func confirmar_j1():
	personaje_j1 = nombres_j1[indice_j1]

	get_tree().set_meta("pj_jugador1", personaje_j1)                       # nombre en minúsculas
	get_tree().set_meta("personaje_j1", personaje_j1.capitalize())         # para la base de datos (Resultado.gd)
	get_tree().set_meta("ruta_j1", rutas_j1[personaje_j1])                 # escena del peleador para la pelea

	turno = 2


func confirmar_j2():
	personaje_j2 = nombres_j2[indice_j2]

	get_tree().set_meta("pj_jugador2", personaje_j2)
	get_tree().set_meta("personaje_j2", personaje_j2.capitalize())
	get_tree().set_meta("ruta_j2", rutas_j2[personaje_j2])

	terminado = true
