extends Control
var baseDatos : SQLite

func _ready():
	baseDatos = SQLite.new()
	baseDatos.path = "res://data.db"
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

func _on_insertar_jugador_button_down():
	var data = {
		"nombre": $Nombre.text,
		"puntaje": int($Puntuación.text)
	}
	var resultado = baseDatos.insert_row("players", data)
	print("¿Se insertó la fila?: ", resultado)
	print("Error (si hay): ", baseDatos.error_message)

func _on_ver_jugadores_button_down() -> void:
	baseDatos.query("SELECT * FROM players")
	print("Jugadores encontrados: ", baseDatos.query_result)

func _on_actualizar_jugador_button_down() -> void:
	var condicion = "nombre = '%s'" % $Nombre.text
	var datos_nuevos = {
		"puntaje": int($Puntuación.text)
	}
	var resultado = baseDatos.update_rows("players", condicion, datos_nuevos)
	print("¿Se actualizó?: ", resultado)
	print("Error (si hay): ", baseDatos.error_message)

func _on_borrar_jugador_button_down() -> void:
	var condicion = "nombre = '%s'" % $Nombre.text
	var resultado = baseDatos.delete_rows("players", condicion)
	print("¿Se borró?: ", resultado)
	print("Error (si hay): ", baseDatos.error_message)

func _on_consulta_personalizada_button_down() -> void:
	baseDatos.query("SELECT * FROM players WHERE puntaje > 50")
	print("Resultado consulta personalizada: ", baseDatos.query_result)
