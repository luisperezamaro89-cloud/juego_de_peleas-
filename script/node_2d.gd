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
var jugador1
var jugador2
var personaje_j1 = "Estudiante"
var personaje_j2 = "Delincuente"

# Escenas que se usan si abres la pelea directo (sin pasar por la selección)
const RUTA_PELEADOR_1_POR_DEFECTO := "res://peleadores/peleador1.tscn"
const RUTA_PELEADOR_2_POR_DEFECTO := "res://peleadores/peleador_2.tscn"

# Dónde aparece cada peleador
const POSICION_PELEADOR_1 := Vector2(-110.0, 26.0)
const POSICION_PELEADOR_2 := Vector2(103.0, 27.0)

# Tamaño de los peleadores. Si se ven más grandes o pequeños que antes,
# pon aquí el mismo Scale que tenían en la escena.
const ESCALA_PELEADORES := Vector2(0.03, 0.03)


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
	
	await get_tree().create_timer(2.0).timeout
	
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

	await get_tree().create_timer(2.0).timeout

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

	await get_tree().create_timer(2.0).timeout

	if ronda_actual < max_rondas:

		ronda_actual += 1

		print("PASANDO A RONDA ", ronda_actual)

		reiniciar_ronda()

		await iniciar_ronda()

	else:

		terminar_pelea()


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

	if victorias_j1 > victorias_j2:

		ganador_partida = "Jugador 1"
		print("JUGADOR 1 GANA LA PELEA")

	elif victorias_j2 > victorias_j1:

		ganador_partida = "Jugador 2"
		print("JUGADOR 2 GANA LA PELEA")

	else:

		ganador_partida = "Empate"
		print("EMPATE")


	# Guardar los puntajes
	get_tree().set_meta("puntaje_jugador1", jugador1.puntaje)
	get_tree().set_meta("puntaje_jugador2", jugador2.puntaje)

	# Guardar quién ganó la partida
	get_tree().set_meta("ganador_partida", ganador_partida)


	# Ir a resultados
	get_tree().change_scene_to_file("res://escenas/ko_estudiante.tscn")
