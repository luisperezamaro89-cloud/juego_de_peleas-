extends Control

var nombres_j1 = ["Asesina", "Ninja"]
var nombres_j2 = ["Asesina", "Ninja"]

@onready var botones_j1: Array[Button] = [$VBoxContainer/HBoxContainer/ContenedorJ1/BtnAsesinaJ1, $VBoxContainer/HBoxContainer/ContenedorJ1/BtnNinjaJ1]
@onready var botones_j2: Array[Button] = [$VBoxContainer/HBoxContainer/ContenedorJ2/BtnAsesinaJ2, $VBoxContainer/HBoxContainer/ContenedorJ2/BtnNinjaJ2]

var indice_j1 = 0
var indice_j2 = 0
var personaje_j1 = ""
var personaje_j2 = ""
var turno = 1

func _ready():
	aplicar_estilo_seleccion()
	resaltar_boton(botones_j1, indice_j1)
	for boton in botones_j2:
		boton.modulate = Color(1, 1, 1, 0.3)

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

func _input(event):
	if not (event is InputEventKey) or not event.pressed:
		return
	if turno == 1:
		if event.keycode == KEY_W:
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
			turno = 3
			iniciar_pelea()

func iniciar_pelea():
	var resultado = get_tree().change_scene_to_file("res://escenas/Seleccion/pelea.tscn")
	print("Resultado del cambio de escena: ", resultado)
