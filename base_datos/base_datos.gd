extends Node

var db = SQLite.new()

func _ready():
	print("=== INICIANDO BASE DE DATOS ===")
	db.path = "res://base_datos/partidas.db"
	var abierto = db.open_db()
	print("¿Se abrió la base de datos?: ", abierto)
	crear_tabla_jugadores()
	print("=== TABLA CREADA (o intento realizado) ===")

func crear_tabla_jugadores():
	var estructura = {
		"id_jugador": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"nombre": {"data_type": "text", "not_null": true},
		"victorias": {"data_type": "int"},
		"derrotas": {"data_type": "int"},
		"puntaje": {"data_type": "int"}
	}
	db.create_table("jugadores", estructura)
	
func guardar_jugador(nombre: String, puntaje: int):
	var fila = {
		"nombre": nombre,
		"victorias": 1,
		"derrotas": 0,
		"puntaje": puntaje
	}
	db.insert_row("jugadores", fila)
	print("Jugador guardado: ", nombre)
