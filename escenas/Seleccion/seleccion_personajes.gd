extends Control

var nombres_j1 = ["Asesina", "Ninja"]
var nombres_j2 = ["Asesina", "Ninja"]

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

@onready var botones: Array[Button] = [
	$VBoxContainer/HBoxContainer/ListaPersonajes/BtnAsesinaJ1,
	$VBoxContainer/HBoxContainer/ListaPersonajes/BtnNinjaJ1
]

@onready var imagen_grande_j1: TextureRect = $ImagenGrandeJ1
@onready var imagen_grande_j2: TextureRect = $ImagenGrandeJ2

@onready var botones_j1: Array[Button] = [$VBoxContainer/HBoxContainer/ContenedorJ1/BtnAsesinaJ1, $VBoxContainer/HBoxContainer/ContenedorJ1/BtnNinjaJ1]
@onready var botones_j2: Array[Button] = [$VBoxContainer/HBoxContainer/ContenedorJ2/BtnAsesinaJ2, $VBoxContainer/HBoxContainer/ContenedorJ2/BtnNinjaJ2]

@onready var botones_j1: Array[Button] = [$VBoxContainer/HBoxContainer/ContenedorJ1/BtnAsesinaJ1, $VBoxContainer/HBoxContainer/ContenedorJ1/BtnNinjaJ1]
@onready var botones_j2: Array[Button] = [$VBoxContainer/HBoxContainer/ContenedorJ2/BtnAsesinaJ2, $VBoxContainer/HBoxContainer/ContenedorJ2/BtnNinjaJ2]

@onready var botones_j1: Array[Button] = [$VBoxContainer/HBoxContainer/ContenedorJ1/BtnAsesinaJ1, $VBoxContainer/HBoxContainer/ContenedorJ1/BtnNinjaJ1]
@onready var botones_j2: Array[Button] = [$VBoxContainer/HBoxContainer/ContenedorJ2/BtnAsesinaJ2, $VBoxContainer/HBoxContainer/ContenedorJ2/BtnNinjaJ2]
>>>>>>> parent of 334ba5f (seleciona personaje funciona pero bueado las imagenes)

var indice_j1 = 0
var indice_j2 = 0
var personaje_j1 = ""
var personaje_j2 = ""
var turno = 1

func _ready():
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD

=======
>>>>>>> parent of 1050dbe (cambio de seleccion de personaje, aun falta arreglar)
=======
>>>>>>> parent of 1050dbe (cambio de seleccion de personaje, aun falta arreglar)
=======
>>>>>>> parent of 334ba5f (seleciona personaje funciona pero bueado las imagenes)
	aplicar_estilo_seleccion()
	resaltar_boton(botones_j1, indice_j1)
	for boton in botones_j2:
		boton.modulate = Color(1, 1, 1, 0.3)
<<<<<<< HEAD

func aplicar_estilo_seleccion():
	var estilo = StyleBoxFlat.new()
	estilo.border_color = Color(1, 0.8, 0, 1)
<<<<<<< HEAD
<<<<<<< HEAD

=======
	resaltar_boton(indice_j1, Color(1, 0.8, 0, 1))
	actualizar_imagen_grande(imagen_grande_j1, indice_j1)
	actualizar_imagen_grande(imagen_grande_j2, indice_j2)
=======
>>>>>>> parent of 334ba5f (seleciona personaje funciona pero bueado las imagenes)

func aplicar_estilo_seleccion():
	var estilo = StyleBoxFlat.new()
<<<<<<< HEAD
	estilo.border_color = color
>>>>>>> 334ba5f4d05296f2bfd784b5f45bcad49dc7b572
=======
>>>>>>> parent of 1050dbe (cambio de seleccion de personaje, aun falta arreglar)
=======
>>>>>>> parent of 1050dbe (cambio de seleccion de personaje, aun falta arreglar)
=======
	estilo.border_color = Color(1, 0.8, 0, 1)
>>>>>>> parent of 334ba5f (seleciona personaje funciona pero bueado las imagenes)
	estilo.border_width_left = 4
	estilo.border_width_right = 4
	estilo.border_width_top = 4
	estilo.border_width_bottom = 4
	estilo.bg_color = Color(0, 0, 0, 0)
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD

=======
>>>>>>> parent of 1050dbe (cambio de seleccion de personaje, aun falta arreglar)
=======
>>>>>>> parent of 1050dbe (cambio de seleccion de personaje, aun falta arreglar)
	for boton in botones_j1 + botones_j2:
		boton.add_theme_stylebox_override("focus", estilo)

func resaltar_boton(lista_botones: Array[Button], indice: int):
	lista_botones[indice].grab_focus()
=======
	botones[indice].add_theme_stylebox_override("focus", estilo)
	botones[indice].grab_focus()

<<<<<<< HEAD
func actualizar_imagen_grande(imagen: TextureRect, indice: int):
	imagen.texture = botones[indice].icon
>>>>>>> 334ba5f4d05296f2bfd784b5f45bcad49dc7b572
=======
	for boton in botones_j1 + botones_j2:
		boton.add_theme_stylebox_override("focus", estilo)

func resaltar_boton(lista_botones: Array[Button], indice: int):
	lista_botones[indice].grab_focus()
>>>>>>> parent of 334ba5f (seleciona personaje funciona pero bueado las imagenes)

func _input(event):
	if not (event is InputEventKey) or not event.pressed:
		return
<<<<<<< HEAD
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
=======
func _input(event):
	if not (event is InputEventKey) or not event.pressed:
		return
	if turno == 1:
		if event.keycode == KEY_W:
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
<<<<<<< HEAD

			print("================================")
			print("JUGADOR 2 SELECCIONÓ: ", personaje_j2)
			print("================================")

=======
			indice_j1 = (indice_j1 - 1 + botones.size()) % botones.size()
			resaltar_boton(indice_j1, Color(1, 0.8, 0, 1))
			actualizar_imagen_grande(imagen_grande_j1, indice_j1)
=======
	if turno == 1:
		if event.keycode == KEY_W:
			indice_j1 = (indice_j1 - 1 + botones_j1.size()) % botones_j1.size()
			resaltar_boton(botones_j1, indice_j1)
>>>>>>> parent of 334ba5f (seleciona personaje funciona pero bueado las imagenes)
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
<<<<<<< HEAD
			personaje_j2 = nombres[indice_j2]
>>>>>>> 334ba5f4d05296f2bfd784b5f45bcad49dc7b572
=======
>>>>>>> parent of 1050dbe (cambio de seleccion de personaje, aun falta arreglar)
=======
>>>>>>> parent of 1050dbe (cambio de seleccion de personaje, aun falta arreglar)
=======
			personaje_j2 = nombres_j2[indice_j2]
>>>>>>> parent of 334ba5f (seleciona personaje funciona pero bueado las imagenes)
			turno = 3
			iniciar_pelea()

func iniciar_pelea():
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD

	var resultado = get_tree().change_scene_to_file(
		"res://escenas/pelea.tscn"
	)

=======
	var resultado = get_tree().change_scene_to_file("res://escenas/Seleccion/pelea.tscn")
>>>>>>> parent of 1050dbe (cambio de seleccion de personaje, aun falta arreglar)
=======
	var resultado = get_tree().change_scene_to_file("res://escenas/Seleccion/pelea.tscn")
>>>>>>> parent of 1050dbe (cambio de seleccion de personaje, aun falta arreglar)
	print("Resultado del cambio de escena: ", resultado)
=======
	print("J1 eligió: ", personaje_j1, " | J2 eligió: ", personaje_j2)
	get_tree().change_scene_to_file("res://escenas/Seleccion/pelea.tscn")
>>>>>>> 334ba5f4d05296f2bfd784b5f45bcad49dc7b572
=======
	var resultado = get_tree().change_scene_to_file("res://escenas/Seleccion/pelea.tscn")
	print("Resultado del cambio de escena: ", resultado)
>>>>>>> parent of 334ba5f (seleciona personaje funciona pero bueado las imagenes)
