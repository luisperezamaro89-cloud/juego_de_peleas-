extends Node2D

@onready var peleador1 = $peleador1
@onready var peleador2 = $peleador2

@onready var healthbar_1 = $Uix/healthbar_1
@onready var healthbar_2 = $Uix/healthbar_2


var jugador1
var jugador2

var pelea_terminada = false


func _ready():

	# Escena del controlador Jugador
	var jugador_scene = preload("res://jugadores/jugador1.tscn")

	# Crear controlador del Jugador 1
	jugador1 = jugador_scene.instantiate()
	add_child(jugador1)

	# Crear controlador del Jugador 2
	jugador2 = jugador_scene.instantiate()
	add_child(jugador2)


	# -------------------------
	# JUGADOR 1
	# -------------------------

	jugador1.nombre = "Jugador 1"

	jugador1.asignar_peleador(peleador1)

	peleador1.health_bar = healthbar_1



	# -------------------------
	# JUGADOR 2
	# -------------------------

	jugador2.nombre = "Jugador 2"

	jugador2.asignar_peleador(peleador2)

	peleador2.health_bar = healthbar_2
