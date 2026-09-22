extends Control

var nombres = ["Asesina", "Ninja"]

<<<<<<< HEAD
<<<<<<< HEAD
@onready var botones_j1: Array[Button] = [
	$VBoxContainer/HBoxContainer/ContenedorJ1/BtnAsesinaJ1,
	$VBoxContainer/HBoxContainer/ContenedorJ1/BtnNinjaJ1
]

@onready var botones_j2: Array[Button] = [
	$VBoxContainer/HBoxContainer/ContenedorJ2/BtnAsesinaJ2,
	$VBoxContainer/HBoxContainer/ContenedorJ2/BtnNinjaJ2
]

@onready var fondo_personaje: TextureRect = $FondoPersonaje
@onready var fondo_personaje2: TextureRect = $FondoPersonaje2

var fondo_asesina = preload("res://images seccion personajes/placeholder1.jpg")
var fondo_ninja = preload("res://images seccion personajes/placeholder2.jpg")
=======
@onready var botones: Array[Button] = [
	$VBoxContainer/HBoxContainer/ListaPersonajes/BtnAsesinaJ1,
	$VBoxContainer/HBoxContainer/ListaPersonajes/BtnNinjaJ1
]

@onready var imagen_grande_j1: TextureRect = $ImagenGrandeJ1
@onready var imagen_grande_j2: TextureRect = $ImagenGrandeJ2
>>>>>>> 334ba5f4d05296f2bfd784b5f45bcad49dc7b572
=======
@onready var botones_j1: Array[Button] = [$VBoxContainer/HBoxContainer/ContenedorJ1/BtnAsesinaJ1, $VBoxContainer/HBoxContainer/ContenedorJ1/BtnNinjaJ1]
@onready var botones_j2: Array[Button] = [$VBoxContainer/HBoxContainer/ContenedorJ2/BtnAsesinaJ2, $VBoxContainer/HBoxContainer/ContenedorJ2/BtnNinjaJ2]
>>>>>>> parent of 1050dbe (cambio de seleccion de personaje, aun falta arreglar)

var indice_j1 = 0
var indice_j2 = 0
var personaje_j1 = ""
var personaje_j2 = ""
var turno = 1

func _ready():
<<<<<<< HEAD
<<<<<<< HEAD

=======
>>>>>>> parent of 1050dbe (cambio de seleccion de personaje, aun falta arreglar)
	aplicar_estilo_seleccion()
	resaltar_boton(botones_j1, indice_j1)
	for boton in botones_j2:
		boton.modulate = Color(1, 1, 1, 0.3)

func aplicar_estilo_seleccion():
	var estilo = StyleBoxFlat.new()
	estilo.border_color = Color(1, 0.8, 0, 1)
<<<<<<< HEAD

=======
	resaltar_boton(indice_j1, Color(1, 0.8, 0, 1))
	actualizar_imagen_grande(imagen_grande_j1, indice_j1)
	actualizar_imagen_grande(imagen_grande_j2, indice_j2)

func resaltar_boton(indice: int, color: Color):
	var estilo = StyleBoxFlat.new()
	estilo.border_color = color
>>>>>>> 334ba5f4d05296f2bfd784b5f45bcad49dc7b572
=======
>>>>>>> parent of 1050dbe (cambio de seleccion de personaje, aun falta arreglar)
	estilo.border_width_left = 4
	estilo.border_width_right = 4
	estilo.border_width_top = 4
	estilo.border_width_bottom = 4
	estilo.bg_color = Color(0, 0, 0, 0)
<<<<<<< HEAD
<<<<<<< HEAD

=======
>>>>>>> parent of 1050dbe (cambio de seleccion de personaje, aun falta arreglar)
	for boton in botones_j1 + botones_j2:
		boton.add_theme_stylebox_override("focus", estilo)

func resaltar_boton(lista_botones: Array[Button], indice: int):
	lista_botones[indice].grab_focus()
=======
	botones[indice].add_theme_stylebox_override("focus", estilo)
	botones[indice].grab_focus()

func actualizar_imagen_grande(imagen: TextureRect, indice: int):
	imagen.texture = botones[indice].icon
>>>>>>> 334ba5f4d05296f2bfd784b5f45bcad49dc7b572

func _input(event):
	if not (event is InputEventKey) or not event.pressed:
		return
<<<<<<< HEAD

<<<<<<< HEAD

	# ==========================================
	# JUGADOR 1
	# ==========================================

=======
>>>>>>> 334ba5f4d05296f2bfd784b5f45bcad49dc7b572
=======
>>>>>>> parent of 1050dbe (cambio de seleccion de personaje, aun falta arreglar)
	if turno == 1:
		if event.keycode == KEY_W:
<<<<<<< HEAD
<<<<<<< HEAD

=======
>>>>>>> parent of 1050dbe (cambio de seleccion de personaje, aun falta arreglar)
			indice_j1 = (indice_j1 - 1 + botones_j1.size()) % botones_j1.size()
			resaltar_boton(botones_j1, indice_j1)
		elif event.keycode == KEY_S:
			indice_j1 = (indice_j1 + 1) % botones_j1.size()
			resaltar_boton(botones_j1, indice_j1)
		elif event.keycode == KEY_ENTER:
			personaje_j1 = nombres_j1[indice_j1]
			turno = 2
			for boton in botones_j2:
				boton.modulate = Color(1, 1, 1, 1)
			resaltar_boton(botones_j2, indice_j2)
	elif turno == 2:
		if event.keycode == KEY_LEFT:
			indice_j2 = (indice_j2 - 1 + botones_j2.size()) % botones_j2.size()
			resaltar_boton(botones_j2, indice_j2)
		elif event.keycode == KEY_RIGHT:
			indice_j2 = (indice_j2 + 1) % botones_j2.size()
			resaltar_boton(botones_j2, indice_j2)
		elif event.keycode == KEY_ENTER:
			personaje_j2 = nombres_j2[indice_j2]
<<<<<<< HEAD

			print("================================")
			print("JUGADOR 2 SELECCIONÓ: ", personaje_j2)
			print("================================")

=======
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
>>>>>>> 334ba5f4d05296f2bfd784b5f45bcad49dc7b572
=======
>>>>>>> parent of 1050dbe (cambio de seleccion de personaje, aun falta arreglar)
			turno = 3
			iniciar_pelea()

func iniciar_pelea():
<<<<<<< HEAD
<<<<<<< HEAD

	var resultado = get_tree().change_scene_to_file(
		"res://escenas/pelea.tscn"
	)

=======
	var resultado = get_tree().change_scene_to_file("res://escenas/Seleccion/pelea.tscn")
>>>>>>> parent of 1050dbe (cambio de seleccion de personaje, aun falta arreglar)
	print("Resultado del cambio de escena: ", resultado)
=======
	print("J1 eligió: ", personaje_j1, " | J2 eligió: ", personaje_j2)
	get_tree().change_scene_to_file("res://escenas/Seleccion/pelea.tscn")
>>>>>>> 334ba5f4d05296f2bfd784b5f45bcad49dc7b572
