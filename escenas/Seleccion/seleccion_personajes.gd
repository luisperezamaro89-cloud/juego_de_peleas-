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

var fondo_estudiante = preload("res://Uix/placeholder1.jpg")
var fondo_delincuente = preload("res://Uix/placeholder2.jpg")

var indice_j1 = 0
var indice_j2 = 0

var personaje_j1 = ""
var personaje_j2 = ""

var turno = 1


func _ready():
	aplicar_estilo_seleccion()

	resaltar_boton(botones_j1, indice_j1)
	cambiar_fondo_j1(nombres_j1[indice_j1])

	cambiar_fondo_j2(nombres_j2[indice_j2])

	for boton in botones_j2:
		boton.modulate = Color(1, 1, 1, 0.3)

	fondo_personaje.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fondo_personaje2.mouse_filter = Control.MOUSE_FILTER_IGNORE


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


func resaltar_boton(lista_botones: Array[Button], indice: int):
	lista_botones[indice].grab_focus()


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


func _input(event):
	if event is InputEventKey and event.is_pressed():
		if turno == 1:
			if event.keycode == KEY_LEFT:
				# Aquí va tu código de mover a la izquierda J1
				pass
			elif event.keycode == KEY_RIGHT:
				# Aquí va tu código de mover a la derecha J1
				pass
			elif event.keycode == KEY_ENTER:
				personaje_j1 = nombres_j1[indice_j1]
				get_tree().set_meta("pj_jugador1", personaje_j1)
				turno = 2

		elif turno == 2:
			if event.keycode == KEY_LEFT:
				# Aquí va tu código de mover a la izquierda J2
				pass
			elif event.keycode == KEY_RIGHT:
				# Aquí va tu código de mover a la derecha J2
				pass
			elif event.keycode == KEY_ENTER:
				personaje_j2 = nombres_j2[indice_j2]
				get_tree().set_meta("pj_jugador2", personaje_j2)
				turno = 3
				get_tree().change_scene_to_file("res://escenas/pelea.tscn")
