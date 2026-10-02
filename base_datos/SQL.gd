# este es el que estamos utilisando en data :v#

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
		"puntaje": {"data_type": "int", "default": 0},
		"victorias": {"data_type": "int", "default": 0},
		"derrotas": {"data_type": "int", "default": 0},
		"Personaje": {"data_type": "text", "default": "Desconocido"}
	}
	baseDatos.create_table("players", esquema_jugadores)
	mostrar_en_consola("=== TABLA 'PLAYERS' COMPLETA LISTA ===", true)

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


func _on_ver_jugadores_button_down():
	baseDatos.query("SELECT * FROM players;")
	mostrar_en_consola("=== LISTA DE JUGADORES ===", true)
	
	for jugador in baseDatos.query_result:
		var victorias = jugador["victorias"] if jugador["victorias"] != null else 0
		var derrotas = jugador["derrotas"] if jugador["derrotas"] != null else 0
		mostrar_en_consola("ID: %d | Nombre: %s | Puntaje: %d | Personaje: %s | Victorias: %s | Derrotas: %s" % [
			jugador["id"], jugador["nombre"], jugador["puntaje"],
			jugador["personaje"], victorias, derrotas
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


# --- BOTÓN: REGRESAR AL MENÚ PRINCIPAL ---
func _on_regresar_menu_pressed():
	baseDatos.close_db()
	get_tree().change_scene_to_file("res://escenas/Menu_Principal/menu_principal.tscn")


# ==========================================
# PANEL "MÁS OPCIONES" Y PANEL DE EDICIÓN
# ==========================================

@onready var panel_mas_opciones = $PanelMasOpciones
@onready var panel_editar = $PanelEditar
@onready var titulo_editar = $PanelEditar/VBoxContainer/TituloEditar
@onready var nombre_buscar = $PanelEditar/VBoxContainer/NombreBuscar
@onready var sugerencias = $PanelEditar/VBoxContainer/SugerenciasNombre
@onready var titulo_actual = $PanelEditar/VBoxContainer/FilaValores/ColumnaActual/TituloActual
@onready var valor_actual = $PanelEditar/VBoxContainer/FilaValores/ColumnaActual/ValorActual
@onready var titulo_nuevo = $PanelEditar/VBoxContainer/FilaValores/ColumnaNueva/TituloNuevo
@onready var valor_nuevo = $PanelEditar/VBoxContainer/FilaValores/ColumnaNueva/ValorNuevo
@onready var opciones_personaje = $PanelEditar/VBoxContainer/FilaValores/ColumnaNueva/OpcionesPersonaje
@onready var mensaje_editar = $PanelEditar/VBoxContainer/MensajeEditar

# Qué dato se está editando: "victorias", "derrotas" o "personaje"
var campo_a_editar := ""

# Último texto del campo de nombre que sí coincide con algún jugador
var ultimo_texto_valido := ""


# --- BOTÓN: MÁS OPCIONES (abre el panel "¿Qué quieres cambiar?") ---
func _on_mas_obciones_pressed() -> void:
	panel_mas_opciones.visible = true


# --- BOTÓN: VOLVER (cierra el panel "¿Qué quieres cambiar?") ---
func _on_btn_volver_pressed() -> void:
	panel_mas_opciones.visible = false


# --- BOTONES DEL PANEL "¿QUÉ QUIERES CAMBIAR?" ---
func _on_btn_victorias_pressed() -> void:
	abrir_editar("victorias")


func _on_btn_derrotas_pressed() -> void:
	abrir_editar("derrotas")


func _on_btn_personaje_pressed() -> void:
	abrir_editar("personaje")


func _on_btn_nombre_pressed() -> void:
	abrir_editar("nombre")


# ==========================================
# ABRIR EL PANEL DE EDICIÓN
# ==========================================

func abrir_editar(campo: String) -> void:
	campo_a_editar = campo
	var es_personaje = campo == "personaje"
	var es_nombre = campo == "nombre"

	titulo_editar.text = "CAMBIAR " + campo.to_upper()

	# Personaje y Nombre van en singular; Victorias y Derrotas en plural
	if es_personaje or es_nombre:
		titulo_actual.text = campo.capitalize() + " actual"
		titulo_nuevo.text = campo.capitalize() + " nuevo"
	else:
		titulo_actual.text = campo.capitalize() + " actuales"
		titulo_nuevo.text = campo.capitalize() + " nuevas"

	# Personaje se elige de una lista; lo demás se escribe
	valor_nuevo.visible = not es_personaje
	opciones_personaje.visible = es_personaje
	if opciones_personaje.item_count > 0:
		opciones_personaje.select(0)

	# Textos de ayuda de los campos
	if es_nombre:
		nombre_buscar.placeholder_text = "Nombre actual del jugador"
		valor_nuevo.placeholder_text = "Nombre nuevo"
	else:
		nombre_buscar.placeholder_text = "Nombre del jugador"
		valor_nuevo.placeholder_text = "Número nuevo"

	valor_actual.text = "—"
	valor_nuevo.text = ""
	nombre_buscar.text = ""
	ultimo_texto_valido = ""
	mensaje_editar.text = ""

	# La lista de sugerencias crece según cuántos nombres tenga
	sugerencias.auto_height = true
	sugerencias.clear()
	sugerencias.visible = false

	panel_mas_opciones.visible = false
	panel_editar.visible = true
	nombre_buscar.grab_focus()


# Dice si el valor guardado es un personaje de verdad
func tiene_personaje(valor) -> bool:
	return valor != null and str(valor) != "" and str(valor) != "Desconocido"


# Muestra a la izquierda el valor que tiene ahora el jugador
func actualizar_valor_actual(nombre: String) -> void:
	valor_actual.text = "—"

	if nombre == "":
		return

	var sql = "SELECT %s FROM players WHERE nombre = ? COLLATE NOCASE;" % campo_a_editar
	baseDatos.query_with_bindings(sql, [nombre])

	if baseDatos.query_result.size() == 0:
		return

	var valor = baseDatos.query_result[0][campo_a_editar]

	if campo_a_editar == "personaje":
		if tiene_personaje(valor):
			valor_actual.text = str(valor)

			# Deja elegido en la lista el personaje que ya tiene
			for i in opciones_personaje.item_count:
				if opciones_personaje.get_item_text(i).to_lower() == str(valor).to_lower():
					opciones_personaje.select(i)
		else:
			valor_actual.text = "No tiene personaje"
	elif campo_a_editar == "nombre":
		valor_actual.text = str(valor)
	else:
		valor_actual.text = str(valor) if valor != null else "0"


# ==========================================
# SUGERENCIAS DE NOMBRES (mientras se escribe)
# ==========================================

func _on_nombre_buscar_text_changed(new_text: String) -> void:
	# Campo vacío: no hay sugerencias y se permite
	if new_text == "":
		ultimo_texto_valido = ""
		mensaje_editar.text = ""
		sugerencias.clear()
		sugerencias.visible = false
		actualizar_valor_actual("")
		return

	# Nombres que empiezan con lo que se escribió (máximo 10)
	baseDatos.query_with_bindings(
		"SELECT DISTINCT nombre FROM players WHERE nombre LIKE ? ORDER BY nombre LIMIT 10;",
		[new_text + "%"])

	# Sin coincidencias: no se deja escribir esa letra y no aparece nada
	if baseDatos.query_result.size() == 0:
		nombre_buscar.text = ultimo_texto_valido
		nombre_buscar.caret_column = ultimo_texto_valido.length()
		mensaje_editar.text = "No hay jugadores que empiecen con eso."
		return

	# Hay coincidencias: se acepta el texto y se muestran las sugerencias
	ultimo_texto_valido = new_text
	mensaje_editar.text = ""

	sugerencias.clear()
	for fila in baseDatos.query_result:
		sugerencias.add_item(str(fila["nombre"]))

	sugerencias.visible = sugerencias.item_count > 0

	# Si el nombre ya está completo, se muestra su valor actual
	actualizar_valor_actual(new_text.strip_edges())


func _on_sugerencias_nombre_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	var elegido = sugerencias.get_item_text(index)

	nombre_buscar.text = elegido
	nombre_buscar.caret_column = elegido.length()
	ultimo_texto_valido = elegido

	sugerencias.clear()
	sugerencias.visible = false

	actualizar_valor_actual(elegido)

	if opciones_personaje.visible:
		opciones_personaje.grab_focus()
	else:
		valor_nuevo.grab_focus()


# ==========================================
# BOTÓN: CAMBIAR
# ==========================================

func _on_btn_guardar_edicion_pressed() -> void:
	sugerencias.visible = false

	var nombre: String = nombre_buscar.text.strip_edges()

	if nombre == "":
		mensaje_editar.text = "Escribe el nombre del jugador."
		return

	# 1. Buscar al jugador (su id, su nombre tal como está guardado y el valor de ahora)
	var columnas = "id, nombre"
	if campo_a_editar != "nombre":
		columnas += ", " + campo_a_editar

	var sql_buscar = "SELECT %s FROM players WHERE nombre = ? COLLATE NOCASE;" % columnas
	baseDatos.query_with_bindings(sql_buscar, [nombre])

	if baseDatos.query_result.size() == 0:
		mensaje_editar.text = "Elige un jugador de la lista."
		return

	var fila = baseDatos.query_result[0]
	var id_jugador = fila["id"]
	var nombre_real = str(fila["nombre"])
	var anterior = fila[campo_a_editar]

	# 2. Preparar el valor nuevo
	var nuevo

	if campo_a_editar == "personaje":
		nuevo = opciones_personaje.get_item_text(opciones_personaje.selected)

	elif campo_a_editar == "nombre":
		nuevo = valor_nuevo.text.strip_edges()

		if nuevo == "":
			mensaje_editar.text = "Escribe el nombre nuevo."
			return

		if nuevo == nombre_real:
			mensaje_editar.text = "El nombre nuevo es igual al actual."
			return

		# El nombre nuevo no puede ser el de OTRO jugador
		baseDatos.query_with_bindings(
			"SELECT id FROM players WHERE nombre = ? COLLATE NOCASE;", [nuevo])

		if baseDatos.query_result.size() > 0 and baseDatos.query_result[0]["id"] != id_jugador:
			mensaje_editar.text = "Ya existe un jugador llamado '%s'." % nuevo
			return

	else:
		var texto: String = valor_nuevo.text.strip_edges()

		if not texto.is_valid_int() or int(texto) < 0:
			mensaje_editar.text = "Escribe un número entero (0 o mayor)."
			return

		nuevo = int(texto)
		anterior = int(anterior) if anterior != null else 0

	# 3. Guardar en la base de datos
	var sql_guardar = "UPDATE players SET %s = ? WHERE id = ?;" % campo_a_editar
	var ok = baseDatos.query_with_bindings(sql_guardar, [nuevo, id_jugador])

	if not ok:
		mensaje_editar.text = "No se pudo guardar: " + str(baseDatos.error_message)
		return

	# 4. Avisar qué se cambió
	if campo_a_editar == "nombre":
		mensaje_editar.text = "Se cambió el nombre de %s a %s." % [nombre_real, nuevo]
		valor_actual.text = nuevo
		nombre_buscar.text = nuevo
		ultimo_texto_valido = nuevo
		valor_nuevo.text = ""

	elif campo_a_editar == "personaje":
		if tiene_personaje(anterior):
			mensaje_editar.text = "Se cambió el personaje de %s de %s a %s." % [
				nombre_real, str(anterior), nuevo]
		else:
			mensaje_editar.text = "Se asignó el personaje %s a %s." % [nuevo, nombre_real]
		valor_actual.text = nuevo

	else:
		mensaje_editar.text = "Se cambiaron las %s de %s de %d a %d." % [
			campo_a_editar, nombre_real, anterior, nuevo]
		valor_actual.text = str(nuevo)
		valor_nuevo.text = ""


# ==========================================
# BOTÓN: CANCELAR
# ==========================================

func _on_btn_cancelar_edicion_pressed() -> void:
	sugerencias.visible = false
	panel_editar.visible = false
	panel_mas_opciones.visible = true
