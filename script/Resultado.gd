extends Control

# Enlazamos los componentes de la interfaz según tu estructura
@onready var nombre_y_definicion = $Ganador/NombreYDefinicion
@onready var entrada_nombre_j1 = $Nombre_J1  
@onready var entrada_nombre_j2 = $Nombre_J2  
@onready var puntaje_jugador1 = $Puntaje_Jugador1
@onready var puntaje_jugador2 = $Puntaje_Jugador2
@onready var boton_continuar = $BotonContinuar

# Variable para la Base de Datos SQLite
var baseDatos : SQLite

func _ready():
	# 1. Inicializar y abrir la base de datos
		# 1. Inicializar y abrir la base de datos
	baseDatos = SQLite.new()
	baseDatos.path = "res://base_datos/data.db"
	baseDatos.open_db()
	
	# Variables para almacenar los puntos de forma segura
	var puntos_j1 : int = 0
	var puntos_j2 : int = 0
	
	# 2. Obtenemos los puntajes verificando primero si los metadatos existen
	if get_tree().has_meta("puntaje_jugador1"):
		puntos_j1 = int(get_tree().get_meta("puntaje_jugador1"))
		
	if get_tree().has_meta("puntaje_jugador2"):
		puntos_j2 = int(get_tree().get_meta("puntaje_jugador2"))
	
	# Mostrar los puntajes en las etiquetas de los lados
	puntaje_jugador1.text = "Puntaje: " + str(puntos_j1)
	puntaje_jugador2.text = "Puntaje: " + str(puntos_j2)
	
	# 3. Ponemos el texto de quién ganó en el nuevo nodo hijo 'NombreYDefinicion'
	if puntos_j1 > puntos_j2:
		nombre_y_definicion.text = "¡Jugador 1!"
	elif puntos_j2 > puntos_j1:
		nombre_y_definicion.text = "¡Jugador 2!"
	else:
		nombre_y_definicion.text = "¡Empate!"

# Esta función se conecta al botón "continuar"
func _on_boton_continuar_pressed() -> void:
	# Recogemos los nombres personalizados que escribieron en las cajas de texto
	var nombre_final_j1 : String = entrada_nombre_j1.text
	var nombre_final_j2 : String = entrada_nombre_j2.text
	
	# Si lo dejaron en blanco, les asignamos un nombre por defecto
	if nombre_final_j1.strip_edges() == "": nombre_final_j1 = "Jugador 1"
	if nombre_final_j2.strip_edges() == "": nombre_final_j2 = "Jugador 2"
	
	var puntos_j1 = int(get_tree().get_meta("puntaje_jugador1"))
	var puntos_j2 = int(get_tree().get_meta("puntaje_jugador2"))
	
	# 4. Guardamos los nombres personalizados con sus respectivos puntajes en SQLite
	guardar_jugador_en_db(nombre_final_j1, puntos_j1)
	guardar_jugador_en_db(nombre_final_j2, puntos_j2)
	
	# 5. Volver a la pelea
	get_tree().change_scene_to_file("res://escenas/pelea.tscn")

# Función para insertar las filas en tu base de datos SQLite
func guardar_jugador_en_db(nombre_jugador: String, puntaje_partida: int):
	# 1. Verificar si el jugador ya existe en la base de datos
	baseDatos.query("SELECT puntaje FROM players WHERE nombre = '%s'" % nombre_jugador)
	
	if baseDatos.query_result.size() > 0:
		# El jugador ya existe, obtenemos su puntaje acumulado anterior
		var puntaje_viejo = int(baseDatos.query_result[0]["puntaje"])
		
		# 2. SUMAMOS el puntaje viejo con el de esta partida
		var puntaje_total_acumulado = puntaje_viejo + puntaje_partida
		
		# 3. Actualizamos la fila con el nuevo total sumado
		var condicion = "nombre = '%s'" % nombre_jugador
		var nuevos_datos = {"puntaje": puntaje_total_acumulado}
		var resultado = baseDatos.update_rows("players", condicion, nuevos_datos)
		
		print("¡Puntos acumulados! ", nombre_jugador, " sumó +", puntaje_partida, " pts. Total actual: ", puntaje_total_acumulado)
	else:
		# 4. Si el jugador es nuevo, se inserta normalmente desde cero
		var datos_nuevos = {
			"nombre": nombre_jugador,
			"puntaje": puntaje_partida
		}
		var resultado = baseDatos.insert_row("players", datos_nuevos)
		print("Jugador nuevo registrado: ", nombre_jugador, " con ", puntaje_partida, " pts.")
