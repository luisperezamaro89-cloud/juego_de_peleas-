extends Node2D

@onready var peleador1 = $peleador1
@onready var peleador2 = $peleador2

@onready var healthbar_1 = $Uix/healthbar_1
@onready var healthbar_2 = $Uix/healthbar_2

@onready var score_1 = $Uix/score_1
@onready var score_2 = $Uix/score_2

@onready var ronda_label = $Uix/ronda_label
var jugador1
var jugador2
var personaje_j1 = "Estudiante"
var personaje_j2 = "Delincuente"


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
		
	
func _ready():
	
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

	print("================================")
	print("JUGADOR 1: ", jugador1)
	print("JUGADOR 1 SCORE LABEL: ", jugador1.score_label)
	print("PELEADOR 1 CONTROLADOR: ", peleador1.jugador_controlador)

	print("JUGADOR 2: ", jugador2)
	print("JUGADOR 2 SCORE LABEL: ", jugador2.score_label)
	print("PELEADOR 2 CONTROLADOR: ", peleador2.jugador_controlador)
	print("================================")
	
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

	print("REINICIANDO RONDA")

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
	peleador1.position = Vector2(-110.0, 26.0)
	peleador2.position = Vector2(103.0, 27.0)

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

	if victorias_j1 > victorias_j2:
		print("JUGADOR 1 GANA LA PELEA")
	elif victorias_j2 > victorias_j1:
		print("JUGADOR 2 GANA LA PELEA")
	else:
		print("EMPATE")

	# Guardar los puntajes para la escena de resultados
	get_tree().set_meta("puntaje_jugador1", jugador1.puntaje)
	get_tree().set_meta("puntaje_jugador2", jugador2.puntaje)

	get_tree().change_scene_to_file("res://escenas/resultado.tscn")
