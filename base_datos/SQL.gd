extends Control
# Referencias a la ventana emergente y al campo de texto
@onready var pop_up_admin = $PopUpAdmin
@onready var input_password = $PopUpAdmin/InputPassword

# Define aquí la clave de acceso que desees
const CLAVE_CORRECTA = "Admin123" # Contraseña no olvidar

# 1. Al presionar el botón "ADMINISTRADORES"
func _on_administradores_pressed():
	input_password.text = "" # Limpia el texto previo
	pop_up_admin.popup_centered(Vector2i(300, 100)) # Muestra la ventana emergente centrada

# 2. Al hacer clic en "Aceptar" en la ventana emergente
func _on_pop_up_admin_confirmed():
	if input_password.text == CLAVE_CORRECTA:
		# Si la clave es correcta, redirige a la escena control.tscn
		get_tree().change_scene_to_file("res://base_datos/control.tscn")
	else:
		print("Contraseña incorrecta")
		
		
var baseDatos : SQLite

# Referencia directa al TextEdit que acabas de acomodar
@onready var consola = $ConsolaSalida

func _ready():
	baseDatos = SQLite.new()
	baseDatos.path = "res://base_datos/data.db"
	baseDatos.open_db()

# Función central para escribir mensajes en el TextEdit
func mostrar_en_consola(texto: String, limpiar: bool = false):
	if limpiar:
		consola.text = ""
	consola.text += texto + "\n"

# --- BOTÓN 1: CREAR TABLA ---
func _on_crear_tabla_button_down():
	var esquema_jugadores = {
		"id": {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		"nombre": {"data_type": "text", "not_null": true},
		"puntaje": {"data_type": "int", "default": 0}
	}
	baseDatos.create_table("players", esquema_jugadores)
	mostrar_en_consola("=== TABLA 'PLAYERS' LISTA ===", true)

# --- BOTÓN 2: INSERTAR JUGADOR ---
func _on_insertar_jugador_button_down():
	var nombre_ingresado = $Nombre.text.strip_edges()
	
	if nombre_ingresado == "":
		mostrar_en_consola("Error: Escribe un nombre en el campo.", true)
		return

	var data_jugador = {
		"nombre": nombre_ingresado,
		"puntaje": int($Puntuación.text) if $Puntuación.text != "" else 0
	}
	
	var res = baseDatos.insert_row("players", data_jugador)
	if res:
		mostrar_en_consola("Jugador '%s' guardado con exito." % nombre_ingresado, true)
	else:
		mostrar_en_consola("Error al guardar: " + str(baseDatos.error_message), true)

# --- BOTÓN 3: VER JUGADORES ---
func _on_ver_jugadores_button_down():
	baseDatos.query("SELECT * FROM players;")
	mostrar_en_consola("=== LISTA DE JUGADORES ===", true)
	
	for jugador in baseDatos.query_result:
		mostrar_en_consola("ID: %d | Nombre: %s | Puntaje: %d" % [
			jugador["id"], jugador["nombre"], jugador["puntaje"]
		])

# --- BOTÓN 4: ACTUALIZAR JUGADOR ---
func _on_actualizar_jugador_button_down():
	var condicion = "nombre = '%s'" % $Nombre.text
	var datos_nuevos = {"puntaje": int($Puntuación.text)}
	var res = baseDatos.update_rows("players", condicion, datos_nuevos)
	
	if res:
		mostrar_en_consola("Puntaje de '%s' actualizado." % $Nombre.text, true)
	else:
		mostrar_en_consola("No se pudo actualizar el jugador.", true)

# --- BOTÓN 5: BORRAR JUGADOR ---
func _on_borrar_jugador_button_down():
	var condicion = "nombre = '%s'" % $Nombre.text
	var res = baseDatos.delete_rows("players", condicion)
	if res:
		mostrar_en_consola("Jugador '%s' eliminado." % $Nombre.text, true)
	else:
		mostrar_en_consola("No se encontró al jugador.", true)

# --- BOTÓN 6: CONSULTA PERSONALIZADA (TOP 5 EN EL CUADRO) ---
func _on_consulta_personalizada_button_down():
	baseDatos.query("SELECT * FROM players ORDER BY puntaje DESC LIMIT 5;")
	
	mostrar_en_consola("=== TOP 5 MEJORES PUNTAJES ===", true)
	var puesto = 1
	for jugador in baseDatos.query_result:
		mostrar_en_consola("#%d | %s - %d pts" % [
			puesto, jugador["nombre"], jugador["puntaje"]
		])
		puesto += 1
