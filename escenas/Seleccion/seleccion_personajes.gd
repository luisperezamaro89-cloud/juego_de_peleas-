extends Control

var nombres_j1 = ["estudiante", "delincuente"]
var nombres_j2 = ["estudiante", "delincuente"]

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


# IMÁGENES DE LOS PERSONAJES
var fondo_estudiante = preload("res://Uix/placeholder1.jpg")
var fondo_delincuente = preload("res://Uix/placeholder2.jpg")


var indice_j1 = 0
var indice_j2 = 0

var personaje_j1 = ""
var personaje_j2 = ""

# 1 = Jugador 1
# 2 = Jugador 2
# 3 = Ambos seleccionados
var turno = 1


func _ready():

	aplicar_estilo_seleccion()

	# =========================
	# JUGADOR 1
	# =========================

	resaltar_boton(botones_j1, indice_j1)

	# Mostrar personaje inicial de J1
	cambiar_fondo_j1(nombres_j1[indice_j1])


	# =========================
	# JUGADOR 2
	# =========================

	# Mostrar personaje inicial de J2
	cambiar_fondo_j2(nombres_j2[indice_j2])


	# J2 empieza bloqueado
	for boton in botones_j2:
		boton.modulate = Color(1, 1, 1, 0.3)


	# Los fondos no deben bloquear los botones
	fondo_personaje.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fondo_personaje2.mouse_filter = Control.MOUSE_FILTER_IGNORE


	print("Escena de selección iniciada")


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


# ==================================================
# CAMBIAR FONDO DEL JUGADOR 1
# ==================================================

func cambiar_fondo_j1(personaje: String):

	print("CAMBIANDO FONDO J1: ", personaje)

	if personaje == "estudiante":
		fondo_personaje.texture = fondo_estudiante

	elif personaje == "delincuente":
		fondo_personaje.texture = fondo_delincuente


# ==================================================
# CAMBIAR FONDO DEL JUGADOR 2
# ==================================================

func cambiar_fondo_j2(personaje: String):

	print("CAMBIANDO FONDO J2: ", personaje)

	if personaje == "estudiante":
		fondo_personaje2.texture = fondo_estudiante

	elif personaje == "delincuente":
		fondo_personaje2.texture = fondo_delincuente


# ==================================================
# CONTROL DE TECLAS
# ==================================================

func _input(event):

	if not (event is InputEventKey) or not event.pressed or event.echo:
		return


	# ==================================================
	# JUGADOR 1
	# ==================================================

	if turno == 1:

		# W = personaje anterior
		if event.keycode == KEY_W:

			indice_j1 = (indice_j1 - 1 + botones_j1.size()) % botones_j1.size()

			resaltar_boton(botones_j1, indice_j1)

			cambiar_fondo_j1(nombres_j1[indice_j1])


		# S = personaje siguiente
		elif event.keycode == KEY_S:

			indice_j1 = (indice_j1 + 1) % botones_j1.size()

			resaltar_boton(botones_j1, indice_j1)

			cambiar_fondo_j1(nombres_j1[indice_j1])


		# ENTER = confirmar J1
		elif event.keycode == KEY_ENTER:

			personaje_j1 = nombres_j1[indice_j1]

			print("================================")
			print("JUGADOR 1 SELECCIONÓ: ", personaje_j1)
			print("================================")

			# Ahora le toca a J2
			turno = 2

			# Activar botones de J2
			for boton in botones_j2:
				boton.modulate = Color(1, 1, 1, 1)

			# Seleccionar el primer personaje de J2
			resaltar_boton(botones_j2, indice_j2)

			print("AHORA ES EL TURNO DEL JUGADOR 2")


	# ==================================================
	# JUGADOR 2
	# ==================================================

	elif turno == 2:

		# FLECHA IZQUIERDA = personaje anterior
		if event.keycode == KEY_LEFT:

			indice_j2 = (indice_j2 - 1 + botones_j2.size()) % botones_j2.size()

			resaltar_boton(botones_j2, indice_j2)

			cambiar_fondo_j2(nombres_j2[indice_j2])


		# FLECHA DERECHA = personaje siguiente
		elif event.keycode == KEY_RIGHT:

			indice_j2 = (indice_j2 + 1) % botones_j2.size()

			resaltar_boton(botones_j2, indice_j2)

			cambiar_fondo_j2(nombres_j2[indice_j2])


		# ENTER = confirmar J2
		elif event.keycode == KEY_ENTER:

			print("================================")
			print("ENTER DE JUGADOR 2 DETECTADO")
			print("================================")

			personaje_j2 = nombres_j2[indice_j2]

			print("JUGADOR 2 SELECCIONÓ: ", personaje_j2)

			turno = 3

			print("AMBOS JUGADORES HAN SELECCIONADO")
			print("J1: ", personaje_j1)
			print("J2: ", personaje_j2)

			# Cambiar directamente a la escena de pelea
			var resultado = get_tree().change_scene_to_file(
				"res://escenas/pelea.tscn"
			)

			print("RESULTADO CAMBIO DE ESCENA: ", resultado)
