extends Control

@onready var nombre_y_definicion = $Ganador/NombreYDefinicion
@onready var entrada_nombre_j1 = $Nombre_J1
@onready var entrada_nombre_j2 = $Nombre_J2
@onready var puntaje_jugador1 = $Puntaje_Jugador1
@onready var puntaje_jugador2 = $Puntaje_Jugador2
@onready var boton_continuar = $BotonContinuar

var baseDatos: SQLite
var puntos_j1: int = 0
var puntos_j2: int = 0

func _ready():
	baseDatos = SQLite.new()
	baseDatos.path = "res://base_datos/data.db"
	baseDatos.open_db()

	if get_tree().has_meta("puntaje_jugador1"):
		puntos_j1 = int(get_tree().get_meta("puntaje_jugador1"))
	if get_tree().has_meta("puntaje_jugador2"):
		puntos_j2 = int(get_tree().get_meta("puntaje_jugador2"))

	puntaje_jugador1.text = "Puntaje: " + str(puntos_j1)
	puntaje_jugador2.text = "Puntaje: " + str(puntos_j2)

	if puntos_j1 > puntos_j2:
		nombre_y_definicion.text = "¡Jugador 1!"
	elif puntos_j2 > puntos_j1:
		nombre_y_definicion.text = "¡Jugador 2!"
	else:
		nombre_y_definicion.text = "¡Empate!"

func _on_boton_continuar_pressed() -> void:
	var nombre_final_j1: String = entrada_nombre_j1.text
	var nombre_final_j2: String = entrada_nombre_j2.text

	if nombre_final_j1.strip_edges() == "": nombre_final_j1 = "Jugador 1"
	if nombre_final_j2.strip_edges() == "": nombre_final_j2 = "Jugador 2"

	if puntos_j1 > puntos_j2:
		registrar_victoria(nombre_final_j1, puntos_j1)
		registrar_derrota(nombre_final_j2)
	elif puntos_j2 > puntos_j1:
		registrar_victoria(nombre_final_j2, puntos_j2)
		registrar_derrota(nombre_final_j1)
	else:
		print("Empate, no se registra victoria ni derrota")

	get_tree().change_scene_to_file("res://Top_jugadores/top_5.tscn")

func jugador_existe(nombre: String) -> bool:
	baseDatos.query("SELECT * FROM players WHERE nombre = '%s'" % nombre)
	return baseDatos.query_result.size() > 0

func obtener_jugador_por_nombre(nombre: String) -> Dictionary:
	baseDatos.query("SELECT * FROM players WHERE nombre = '%s'" % nombre)
	if baseDatos.query_result.size() > 0:
		return baseDatos.query_result[0]
	return {}

func registrar_victoria(nombre: String, puntaje: int):
	if jugador_existe(nombre):
		var jugador = obtener_jugador_por_nombre(nombre)
		var victorias_actuales = 0
		if jugador["victorias"] != null:
			victorias_actuales = int(jugador["victorias"])
		var datos = {
			"victorias": victorias_actuales + 1,
			"puntaje": puntaje
		}
		baseDatos.update_rows("players", "nombre = '%s'" % nombre, datos)
		print(nombre, " ganó. Victorias totales: ", victorias_actuales + 1)
	else:
		var fila = {
			"nombre": nombre,
			"puntaje": puntaje,
			"victorias": 1,
			"derrotas": 0
		}
		baseDatos.insert_row("players", fila)
		print("Jugador nuevo registrado con 1 victoria: ", nombre)
		
		

func registrar_derrota(nombre: String):
	if jugador_existe(nombre):
		var jugador = obtener_jugador_por_nombre(nombre)
		var derrotas_actuales = 0
		if jugador["derrotas"] != null:
			derrotas_actuales = int(jugador["derrotas"])
		var datos = {
			"derrotas": derrotas_actuales + 1
		}
		baseDatos.update_rows("players", "nombre = '%s'" % nombre, datos)
		print(nombre, " perdió. Derrotas totales: ", derrotas_actuales + 1)
	else:
		var fila = {
			"nombre": nombre,
			"puntaje": 0,
			"victorias": 0,
			"derrotas": 1
		}
		baseDatos.insert_row("players", fila)
		print("Jugador nuevo registrado con 1 derrota: ", nombre)
