extends Control

var nombres = ["Asesina", "Ninja"]

@onready var botones: Array[Button] = [
	$VBoxContainer/HBoxContainer/ListaPersonajes/BtnAsesinaJ1,
	$VBoxContainer/HBoxContainer/ListaPersonajes/BtnNinjaJ1
]

@onready var imagen_grande_j1: TextureRect = $ImagenGrandeJ1
@onready var imagen_grande_j2: TextureRect = $ImagenGrandeJ2

var indice_j1 = 0
var indice_j2 = 0
var personaje_j1 = ""
var personaje_j2 = ""
var turno = 1

func _ready():
	resaltar_boton(indice_j1, Color(1, 0.8, 0, 1))
	actualizar_imagen_grande(imagen_grande_j1, indice_j1)
	actualizar_imagen_grande(imagen_grande_j2, indice_j2)

func resaltar_boton(indice: int, color: Color):
	var estilo = StyleBoxFlat.new()
	estilo.border_color = color
	estilo.border_width_left = 4
	estilo.border_width_right = 4
	estilo.border_width_top = 4
	estilo.border_width_bottom = 4
	estilo.bg_color = Color(0, 0, 0, 0)
	botones[indice].add_theme_stylebox_override("focus", estilo)
	botones[indice].grab_focus()

func actualizar_imagen_grande(imagen: TextureRect, indice: int):
	imagen.texture = botones[indice].icon

func _input(event):
	if not (event is InputEventKey) or not event.pressed:
		return

	if turno == 1:
		if event.keycode == KEY_W:
			indice_j1 = (indice_j1 - 1 + botones.size()) % botones.size()
			resaltar_boton(indice_j1, Color(1, 0.8, 0, 1))
			actualizar_imagen_grande(imagen_grande_j1, indice_j1)
		elif event.keycode == KEY_S:
			indice_j1 = (indice_j1 + 1) % botones.size()
			resaltar_boton(indice_j1, Color(1, 0.8, 0, 1))
			actualizar_imagen_grande(imagen_grande_j1, indice_j1)
		elif event.keycode == KEY_ENTER:
			personaje_j1 = nombres[indice_j1]
			turno = 2
			resaltar_boton(indice_j2, Color(0.2, 0.6, 1, 1))
			actualizar_imagen_grande(imagen_grande_j2, indice_j2)

	elif turno == 2:
		if event.keycode == KEY_UP:
			indice_j2 = (indice_j2 - 1 + botones.size()) % botones.size()
			resaltar_boton(indice_j2, Color(0.2, 0.6, 1, 1))
			actualizar_imagen_grande(imagen_grande_j2, indice_j2)
		elif event.keycode == KEY_DOWN:
			indice_j2 = (indice_j2 + 1) % botones.size()
			resaltar_boton(indice_j2, Color(0.2, 0.6, 1, 1))
			actualizar_imagen_grande(imagen_grande_j2, indice_j2)
		elif event.keycode == KEY_ENTER:
			personaje_j2 = nombres[indice_j2]
			turno = 3
			iniciar_pelea()

func iniciar_pelea():
	print("J1 eligió: ", personaje_j1, " | J2 eligió: ", personaje_j2)
	get_tree().change_scene_to_file("res://escenas/Seleccion/pelea.tscn")
