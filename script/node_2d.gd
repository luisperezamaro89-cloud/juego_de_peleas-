extends Node2D

@onready var peleador1 = $peleador1
@onready var peleador2 = $peleador2

@onready var healthbar_1 = $Uix/healthbar_1
@onready var healthbar_2 = $Uix/healthbar_2

@onready var score_1 = $Uix/score_1
@onready var score_2 = $Uix/score_2

@onready var burstbar_1 = $Uix/burstbar_1
@onready var burstbar_2 = $Uix/burstbar_2

var jugador1
var jugador2


func _ready():

	var jugador_scene = preload("res://jugadores/jugador1.tscn")

	jugador1 = jugador_scene.instantiate()
	jugador2 = jugador_scene.instantiate()

	add_child(jugador1)
	add_child(jugador2)

	jugador1.nombre = "Jugador 1"
	jugador2.nombre = "Jugador 2"

	jugador1.asignar_peleador(peleador1)
	jugador2.asignar_peleador(peleador2)

	jugador1.score_label = score_1
	jugador2.score_label = score_2

	peleador1.health_bar = healthbar_1
	peleador2.health_bar = healthbar_2

	peleador1.burst_bar = burstbar_1
	peleador2.burst_bar = burstbar_2

	print("================================")
	print("JUGADOR 1: ", jugador1)
	print("JUGADOR 1 SCORE LABEL: ", jugador1.score_label)
	print("PELEADOR 1 CONTROLADOR: ", peleador1.jugador_controlador)

	print("JUGADOR 2: ", jugador2)
	print("JUGADOR 2 SCORE LABEL: ", jugador2.score_label)
	print("PELEADOR 2 CONTROLADOR: ", peleador2.jugador_controlador)
	print("================================")
