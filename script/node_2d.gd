extends Node2D

# Los peleadores ya no están puestos a mano en la escena:
# se crean por código según lo que se eligió en la selección.
var peleador1
var peleador2

@onready var healthbar_1 = $Uix/healthbar_1
@onready var healthbar_2 = $Uix/healthbar_2

@onready var score_1 = $Uix/score_1
@onready var score_2 = $Uix/score_2

@onready var ronda_label = $Uix/ronda_label
@onready var texto_anuncio = $Anuncio/TextoAnuncio
var jugador1
var jugador2
var personaje_j1 = "Estudiante"
var personaje_j2 = "Delincuente"

# Escenas que se usan si abres la pelea directo (sin pasar por la selección)
const RUTA_PELEADOR_1_POR_DEFECTO := "res://peleadores/peleador1.tscn"
const RUTA_PELEADOR_2_POR_DEFECTO := "res://peleadores/peleador_2.tscn"

# Dónde aparece cada peleador
const POSICION_PELEADOR_1 := Vector2(250.0, 550.0)
const POSICION_PELEADOR_2 := Vector2(400.0, 550.0)

# Tamaño de los peleadores. En sus escenas son enormes y en la pelea se
# usan muy reducidos. Si se ven más grandes o pequeños, cambia este número.
const ESCALA_PELEADORES := Vector2(0.03, 0.03)

# --- K.O. y final de la pelea ---
const TIEMPO_LENTO = 0.3            # velocidad del juego en cámara lenta (1.0 = normal)
const TAMANO_TEXTO_KO = 120         # tamaño de las letras del K.O.
const TAMANO_TEXTO_GANADOR = 64     # tamaño del texto del ganador
const FUERZA_TEMBLOR = 3.0          # qué tanto tiembla la cámara

# Cada paso: qué texto se muestra y cuántos segundos espera antes del siguiente
const PASOS_KO = [
	{"texto": "K", "espera": 0.6},
	{"texto": "K.", "espera": 0.4},
	{"texto": "K.O", "espera": 0.6},
	{"texto": "K.O.", "espera": 0.4},
]


# ==========================================
# RONDAS
# ==========================================

var ronda_actual = 1
var max_rondas = 3
var victorias_j1 = 0
var victorias_j2 = 0
var ronda_terminada = false
var comprobacion_pendiente = false

func mostrar_ronda():
	ronda_label.text = "RONDA " + str(ronda_actual)
	ronda_label.visible = true
	
	await get_tree().create_timer(2.0, false).timeout
	
	ronda_label.visible = false


# ==========================================
# CREAR LOS PELEADORES ELEGIDOS
# ==========================================

func crear_peleadores():

	# Si quedó algún peleador de prueba puesto en la escena, se quita
	for nombre in ["peleador1", "peleador2"]:
		var viejo = get_node_or_null(nombre)
		if viejo:
			remove_child(viejo)
			viejo.queue_free()

	var ruta1 = RUTA_PELEADOR_1_POR_DEFECTO
	var ruta2 = RUTA_PELEADOR_2_POR_DEFECTO

	if get_tree().has_meta("ruta_j1"):
		ruta1 = get_tree().get_meta("ruta_j1")

	if get_tree().has_meta("ruta_j2"):
		ruta2 = get_tree().get_meta("ruta_j2")

	peleador1 = crear_peleador(ruta1, "peleador1", POSICION_PELEADOR_1)
	peleador2 = crear_peleador(ruta2, "peleador2", POSICION_PELEADOR_2)

	# La cámara sigue a los peleadores: se le pasan los nuevos
	for hijo in get_children():
		if hijo is Camera2D:
			hijo.peleador1 = peleador1
			hijo.peleador2 = peleador2
			
	if get_tree().has_meta("personaje_j1"):
		personaje_j1 = get_tree().get_meta("personaje_j1")

	if get_tree().has_meta("personaje_j2"):
		personaje_j2 = get_tree().get_meta("personaje_j2")

	peleador1.nombre_personaje = personaje_j1
	peleador2.nombre_personaje = personaje_j2

	peleador1.configurar_sonidos()
	peleador2.configurar_sonidos()

func crear_peleador(ruta: String, nombre: String, posicion: Vector2):

	var nuevo = load(ruta).instantiate()

	nuevo.name = nombre
	nuevo.position = posicion
	nuevo.scale = ESCALA_PELEADORES

	add_child(nuevo)

	# Se coloca antes de la interfaz para que la interfaz quede encima
	if has_node("Uix"):
		move_child(nuevo, $Uix.get_index())

	return nuevo
		
	
func _ready():

	# Audio: en esta escena suena la música de pelea
	Ajustes.poner_contexto("pelea")

	# Primero se crean los peleadores que eligieron en la selección
	crear_peleadores()
	
	var jugador_scene_1 = preload("res://jugadores/jugador1.tscn")
	var jugador_scene_2 = preload("res://jugadores/jugador_2.tscn")

	jugador1 = jugador_scene_1.instantiate()
	jugador2 = jugador_scene_2.instantiate()

	add_child(jugador1)
	add_child(jugador2)

	jugador1.nombre = "Jugador 1"
	jugador2.nombre = "Jugador 2"
	
	jugador1.asignar_peleador(peleador1)
	jugador2.asignar_peleador(peleador2)
	
	peleador1.jugador = 1
	peleador2.jugador = 2

	peleador1.configurar_controles()
	peleador2.configurar_controles()
	
	peleador1.scale.x = abs(peleador1.scale.x)
	peleador2.scale.x = -abs(peleador2.scale.x)

	peleador1.escena_pelea = self
	peleador2.escena_pelea = self

	jugador1.score_label = score_1
	jugador2.score_label = score_2

	peleador1.health_bar = healthbar_1
	peleador2.health_bar = healthbar_2
	
	iniciar_ronda()
	
	
func solicitar_comprobar_ganador():

	if comprobacion_pendiente:
		return

	comprobacion_pendiente = true

	call_deferred("_ejecutar_comprobacion_ganador")


func _ejecutar_comprobacion_ganador():

	comprobacion_pendiente = false

	comprobar_ganador()
	
	
# ==========================================
# INICIAR RONDA
# ==========================================

func iniciar_ronda():

	ronda_terminada = false

	ronda_label.text = "RONDA " + str(ronda_actual)
	ronda_label.visible = true

	print("COMIENZA RONDA ", ronda_actual)

	await get_tree().create_timer(2.0, false).timeout

	ronda_label.visible = false

# ==========================================
# COMPROBAR GANADOR DE LA RONDA
# ==========================================

func comprobar_ganador():

	print("================================")
	print("COMPROBANDO GANADOR")
	print("RONDA ACTUAL: ", ronda_actual)
	print("VIDA J1: ", peleador1.vida)
	print("VIDA J2: ", peleador2.vida)

	if ronda_terminada:
		print("LA RONDA YA TERMINÓ")
		return

	if peleador1.vida <= 0:

		ronda_terminada = true

		print(">>> JUGADOR 2 GANA LA RONDA <<<")

		victorias_j2 += 1
		jugador2.ganar()

		print("VICTORIAS ACTUALES: J1=", victorias_j1, " J2=", victorias_j2)

		terminar_ronda()

	elif peleador2.vida <= 0:

		ronda_terminada = true

		print(">>> JUGADOR 1 GANA LA RONDA <<<")

		victorias_j1 += 1
		jugador1.ganar()

		print("VICTORIAS ACTUALES: J1=", victorias_j1, " J2=", victorias_j2)

		terminar_ronda()


# ==========================================
# TERMINAR RONDA
# ==========================================

func terminar_ronda():

	print("================================")
	print("RONDA ", ronda_actual, " TERMINADA")
	print("VICTORIAS J1: ", victorias_j1)
	print("VICTORIAS J2: ", victorias_j2)
	print("================================")

	var es_ultima_ronda = ronda_actual >= max_rondas

	if not es_ultima_ronda:

		# Rondas 1 y 2: sin K.O., una pausa corta y sigue la siguiente
		await get_tree().create_timer(2.0, false).timeout

		ronda_actual += 1

		print("PASANDO A RONDA ", ronda_actual)

		reiniciar_ronda()

		await iniciar_ronda()

	else:

		# Ronda 3: aquí sí sale el K.O., luego el ganador y Resultados
		await secuencia_ko()
		await terminar_pelea()


# ==========================================
# REINICIAR RONDA
# ==========================================

func reiniciar_ronda():

	# Restaurar vida
	peleador1.vida = 500
	peleador2.vida = 500


	# Restaurar barras de vida
	healthbar_1.value = 500
	healthbar_2.value = 500


	# Quitar bloqueo
	peleador1.bloqueando = false
	peleador2.bloqueando = false


	# Desactivar hitboxes
	peleador1.desactivar_hitboxes()
	peleador2.desactivar_hitboxes()


	# Volver al estado Idle
	peleador1.state_machine.cambiar_estado("Idle")
	peleador2.state_machine.cambiar_estado("Idle")


	# Volver a las posiciones iniciales
	peleador1.position = POSICION_PELEADOR_1
	peleador2.position = POSICION_PELEADOR_2

	print("VIDA J1 DESPUÉS: ", peleador1.vida)
	print("VIDA J2 DESPUÉS: ", peleador2.vida)


# ==========================================
# TERMINAR PELEA
# ==========================================

func terminar_pelea():

	print("================================")
	print("PELEA TERMINADA")
	print("VICTORIAS J1: ", victorias_j1)
	print("VICTORIAS J2: ", victorias_j2)
	print("JUGADOR 1 VICTORIAS: ", jugador1.victorias)
	print("JUGADOR 2 VICTORIAS: ", jugador2.victorias)
	print("PUNTAJE J1: ", jugador1.puntaje)
	print("PUNTAJE J2: ", jugador2.puntaje)
	print("================================")

	var ganador_partida = ""
	var personaje_ganador = ""

	# ==========================================
	# DETERMINAR QUIÉN GANÓ
	# ==========================================

	if victorias_j1 > victorias_j2:

		ganador_partida = "Jugador 1"

		# Obtener el personaje que eligió J1
		personaje_ganador = get_tree().get_meta("pj_jugador1", "")

		print("JUGADOR 1 GANA LA PELEA")
		print("PERSONAJE GANADOR: ", personaje_ganador)

	elif victorias_j2 > victorias_j1:

		ganador_partida = "Jugador 2"

		# Obtener el personaje que eligió J2
		personaje_ganador = get_tree().get_meta("pj_jugador2", "")

		print("JUGADOR 2 GANA LA PELEA")
		print("PERSONAJE GANADOR: ", personaje_ganador)

	else:

		ganador_partida = "Empate"

		print("EMPATE")


	# ==========================================
	# GUARDAR INFORMACIÓN
	# ==========================================

	get_tree().set_meta("puntaje_jugador1", jugador1.puntaje)
	get_tree().set_meta("puntaje_jugador2", jugador2.puntaje)

	get_tree().set_meta("ganador_partida", ganador_partida)

	get_tree().set_meta("personaje_ganador", personaje_ganador)


	# ==========================================
	# ESCENA SEGÚN EL PERSONAJE GANADOR
	# ==========================================

	if personaje_ganador == "estudiante":

		print("CARGANDO PANTALLA DE GANADOR: ESTUDIANTE")

		get_tree().change_scene_to_file(
			"res://escenas/ko_estudiante.tscn"
		)

	elif personaje_ganador == "delincuente":

		print("CARGANDO PANTALLA DE GANADOR: DELINCUENTE")

		get_tree().change_scene_to_file(
			"res://escenas/ko_delincuente.tscn"
		)

	else:

		print("ERROR: NO SE ENCONTRÓ EL PERSONAJE GANADOR")
		print("PERSONAJE: ", personaje_ganador)


# ==========================================
# K.O. EN CÁMARA LENTA
# ==========================================

func secuencia_ko() -> void:

	# Cámara lenta y temblor al golpe final
	Engine.time_scale = TIEMPO_LENTO
	temblor_de_camara()

	texto_anuncio.add_theme_font_size_override("font_size", TAMANO_TEXTO_KO)
	texto_anuncio.modulate.a = 1.0
	texto_anuncio.visible = true

	# El K.O. aparece letra por letra, despacio
	for paso in PASOS_KO:
		texto_anuncio.text = paso["texto"]
		golpe_de_texto()
		await esperar_real(paso["espera"])

	# Se queda un momento en pantalla
	await esperar_real(0.5)

	# Vuelve a la velocidad normal y el texto se desvanece
	var tween = create_tween()
	tween.set_ignore_time_scale(true)
	tween.set_parallel(true)
	tween.tween_property(Engine, "time_scale", 1.0, 0.5)
	tween.tween_property(texto_anuncio, "modulate:a", 0.0, 0.5)
	await tween.finished

	Engine.time_scale = 1.0
	texto_anuncio.visible = false
	texto_anuncio.modulate.a = 1.0


# La letra aparece grande y se asienta, como si cayera
func golpe_de_texto() -> void:

	texto_anuncio.pivot_offset = texto_anuncio.size / 2.0
	texto_anuncio.scale = Vector2(1.6, 1.6)

	var tween = create_tween()
	tween.set_ignore_time_scale(true)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(texto_anuncio, "scale", Vector2.ONE, 0.25)


# Un temblor corto de la cámara
func temblor_de_camara() -> void:

	var camara = get_node_or_null("Camera2D")

	if camara == null:
		return

	var tween = create_tween()
	tween.set_ignore_time_scale(true)

	for i in 6:
		var desplazamiento = Vector2(
			randf_range(-FUERZA_TEMBLOR, FUERZA_TEMBLOR),
			randf_range(-FUERZA_TEMBLOR, FUERZA_TEMBLOR))
		tween.tween_property(camara, "offset", desplazamiento, 0.04)

	tween.tween_property(camara, "offset", Vector2.ZERO, 0.04)


# Espera en tiempo real, sin que la cámara lenta la alargue
func esperar_real(segundos: float) -> void:
	await get_tree().create_timer(segundos, false, false, true).timeout


# ==========================================
# TEXTO DEL GANADOR
# ==========================================

func mostrar_ganador(texto: String) -> void:

	texto_anuncio.add_theme_font_size_override("font_size", TAMANO_TEXTO_GANADOR)
	texto_anuncio.text = texto
	texto_anuncio.visible = true
	texto_anuncio.modulate.a = 0.0
	texto_anuncio.pivot_offset = texto_anuncio.size / 2.0
	texto_anuncio.scale = Vector2(0.8, 0.8)

	# Aparece suavemente
	var tween = create_tween()
	tween.set_ignore_time_scale(true)
	tween.set_parallel(true)
	tween.tween_property(texto_anuncio, "modulate:a", 1.0, 0.6)
	tween.tween_property(texto_anuncio, "scale", Vector2.ONE, 0.6) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tween.finished

	# Se queda un momento para que se lea
	await esperar_real(1.2)


func _exit_tree() -> void:
	# Por si se sale de la pelea en plena cámara lenta
	Engine.time_scale = 1.0

	# ==========================================
	# CAMBIAR ESCENA SEGÚN EL GANADOR
	# ==========================================

	if victorias_j1 > victorias_j2:

		print("CARGANDO ESCENA DEL GANADOR: JUGADOR 1")
		get_tree().change_scene_to_file("res://escenas/ko_estudiante.tscn")

	elif victorias_j2 > victorias_j1:

		print("CARGANDO ESCENA DEL GANADOR: JUGADOR 2")
		get_tree().change_scene_to_file("res://escenas/ko_delincuente.tscn")

	else:

		print("CARGANDO ESCENA DE EMPATE")
		get_tree().change_scene_to_file("res://escenas/empate.tscn")
