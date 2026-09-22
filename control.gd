extends Control

var baseDatos : SQLite

@onready var lista_top = $Panel/ListaTop5
@onready var label_top_jugador = $Panel/TopJugador

func _ready():
	baseDatos = SQLite.new()
	baseDatos.path = "res://base_datos/data.db"
	baseDatos.open_db()
	
	cargar_top_5()
	mostrar_puesto_ganador()

func cargar_top_5():
	lista_top.clear()
	lista_top.max_columns = 3
	lista_top.same_column_width = true
	
	# Encabezados de la tabla
	lista_top.add_item("ID")
	lista_top.add_item("JUGADOR")
	lista_top.add_item("PUNTAJE")

	# Consultar los 5 mejores puntajes (de mayor a menor)
	baseDatos.query("SELECT * FROM players ORDER BY puntaje DESC LIMIT 5;")
	for jugador in baseDatos.query_result:
		lista_top.add_item(str(jugador["id"]))
		lista_top.add_item(str(jugador["nombre"]))
		lista_top.add_item(str(jugador["puntaje"]))

func mostrar_puesto_ganador():
	# Busca el último jugador registrado en la base de datos (el que acaba de terminar)
	baseDatos.query("SELECT * FROM players ORDER BY id DESC LIMIT 1;")
	
	if baseDatos.query_result.size() > 0:
		var ultimo_jugador = baseDatos.query_result[0]
		var nombre = ultimo_jugador["nombre"]
		var puntaje = ultimo_jugador["puntaje"]
		
		# Calcula cuántos jugadores tienen más puntaje para determinar la posición
		var query_puesto = "SELECT COUNT(*) + 1 AS puesto FROM players WHERE puntaje > %d" % puntaje
		baseDatos.query(query_puesto)
		
		var puesto = baseDatos.query_result[0]["puesto"]
		
		# Muestra el nombre y el puesto en la etiqueta Label
		label_top_jugador.text = "%s\n¡PUESTO #%d!" % [nombre.to_upper(), puesto]
	else:
		label_top_jugador.text = "Sin registros."
