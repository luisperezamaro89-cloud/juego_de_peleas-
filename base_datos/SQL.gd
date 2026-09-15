extends Control
var baseDatos : SQLite

func _ready():
	baseDatos = SQLite.new()
	baseDatos.path = "res://base_datos/data.db"
	baseDatos.open_db()

func _on_crear_tabla_button_down():
	var table = {
		"id": {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		"nombre": {"data_type": "text"},
		"puntaje": {"data_type": "int"},
	}
	var resultado = baseDatos.create_table("players", table)
	print("¿Se creó la tabla?: ", resultado)
	print("Error (si hay): ", baseDatos.error_message)

func nombre_existe(nombre: String) -> bool:
	baseDatos.query("SELECT * FROM players WHERE nombre = '%s'" % nombre)
	return baseDatos.query_result.size() > 0

func _on_insertar_jugador_button_down():
	var nombre_ingresado = $Nombre.text
	if nombre_existe(nombre_ingresado):
		print("Este nombre ya está en uso, pruebe con otro o actualícelo")
		return
	var data = {
		"nombre": nombre_ingresado,
		"puntaje": int($Puntuación.text)
	}
	var resultado = baseDatos.insert_row("players", data)
	print("¿Se insertó la fila?: ", resultado)
	print("Error (si hay): ", baseDatos.error_message)

func _on_ver_jugadores_button_down():
	baseDatos.query("SELECT * FROM players")
	print("--- Lista de Jugadores ---")
	for jugador in baseDatos.query_result:
		print("ID: ", jugador["id"], " | Nombre: ", jugador["nombre"], " | Puntaje: ", jugador["puntaje"])
	print("--------------------------")
func _on_actualizar_jugador_button_down() :
	var condicion = "nombre = '%s'" % $Nombre.text
	var datos_nuevos = {
		"puntaje": int($Puntuación.text)
	}
	var resultado = baseDatos.update_rows("players", condicion, datos_nuevos)
	print("¿Se actualizó?: ", resultado)
	print("Error (si hay): ", baseDatos.error_message)

func _on_borrar_jugador_button_down():
	var condicion = "nombre = '%s'" % $Nombre.text
	var resultado = baseDatos.delete_rows("players", condicion)
	print("¿Se borró?: ", resultado)
	print("Error (si hay): ", baseDatos.error_message)

func _on_consulta_personalizada_button_down():
	# Ordena por puntaje de forma descendente (DESC) y toma solo los 3 primeros (LIMIT 3)
	baseDatos.query("SELECT * FROM players ORDER BY puntaje DESC LIMIT 3")
	
	print("--- TOP 3 JUGADORES MÁS ALTOS ---")
	var puesto = 1
	for jugador in baseDatos.query_result:
		print("#", puesto, " | Nombre: ", jugador["nombre"], " | Puntaje Acumulado: ", jugador["puntaje"])
		puesto += 1
	print("---------------------------------")
