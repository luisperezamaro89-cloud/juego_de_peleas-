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

var indice_j1 = 0
var indice_j2 = 0

var personaje_j1 = ""
var personaje_j2 = ""

var turno = 1


func _ready():

	aplicar_estilo_seleccion()

	# JUGADOR 1 empieza en Asesina
	resaltar_boton(botones_j1, indice_j1)
	cambiar_fondo_j1(nombres_j1[indice_j1])

	# JUGADOR 2 también empieza mostrando Asesina
	cambiar_fondo_j2(nombres_j2[indice_j2])

	# J2 está bloqueado hasta que J1 seleccione
	for boton in botones_j2:
		boton.modulate = Color(1, 1, 1, 0.3)

	# Los fondos no deben bloquear los botones
	fondo_personaje.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fondo_personaje2.mouse_filter = Control.MOUSE_FILTER_IGNORE

	print("FONDO J1: ", fondo_personaje)
	print("FONDO J2: ", fondo_personaje2)


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


# ==========================================
# FONDO JUGADOR 1
# ==========================================

func cambiar_fondo_j1(personaje: String):

	print("CAMBIANDO FONDO J1: ", personaje)

	if personaje == "Asesina":
		fondo_personaje.texture = fondo_asesina

	elif personaje == "Ninja":
		fondo_personaje.texture = fondo_ninja


# ==========================================
# FONDO JUGADOR 2
# ==========================================

func cambiar_fondo_j2(personaje: String):

	print("CAMBIANDO FONDO J2: ", personaje)

	if personaje == "Asesina":
		fondo_personaje2.texture = fondo_asesina

	elif personaje == "Ninja":
		fondo_personaje2.texture = fondo_ninja


# ==========================================
# CONTROL DE LOS JUGADORES
# ==========================================

func _input(event):

	if not (event is InputEventKey) or not event.pressed or event.echo:
		return


	# ==========================================
	# JUGADOR 1
	# ==========================================

	if turno == 1:

		if event.keycode == KEY_W:

			indice_j1 = (indice_j1 - 1 + botones_j1.size()) % botones_j1.size()

			resaltar_boton(botones_j1, indice_j1)

			cambiar_fondo_j1(nombres_j1[indice_j1])


		elif event.keycode == KEY_S:

			indice_j1 = (indice_j1 + 1) % botones_j1.size()

			resaltar_boton(botones_j1, indice_j1)

			cambiar_fondo_j1(nombres_j1[indice_j1])


		elif event.keycode == KEY_ENTER:

			personaje_j1 = nombres_j1[indice_j1]

			print("================================")
			print("JUGADOR 1 SELECCIONÓ: ", personaje_j1)
			print("================================")

			turno = 2

			# Activar botones de J2
			for boton in botones_j2:
				boton.modulate = Color(1, 1, 1, 1)

			resaltar_boton(botones_j2, indice_j2)


	# ==========================================
	# JUGADOR 2
	# ==========================================

	elif turno == 2:

		if event.keycode == KEY_LEFT:

			indice_j2 = (indice_j2 - 1 + botones_j2.size()) % botones_j2.size()

			resaltar_boton(botones_j2, indice_j2)

			cambiar_fondo_j2(nombres_j2[indice_j2])


		elif event.keycode == KEY_RIGHT:

			indice_j2 = (indice_j2 + 1) % botones_j2.size()

			resaltar_boton(botones_j2, indice_j2)

			cambiar_fondo_j2(nombres_j2[indice_j2])


		elif event.keycode == KEY_ENTER:

			personaje_j2 = nombres_j2[indice_j2]

			print("================================")
			print("JUGADOR 2 SELECCIONÓ: ", personaje_j2)
			print("================================")

			turno = 3

			iniciar_pelea()


func iniciar_pelea():

	var resultado = get_tree().change_scene_to_file(
		"res://escenas/pelea.tscn"
	)

	print("Resultado del cambio de escena: ", resultado)
