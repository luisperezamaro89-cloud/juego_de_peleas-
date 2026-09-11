extends Node2D

@onready var player_1 = $player_1
@onready var healthbar_1 = $Uix/healthbar_1

var jugador1
var peleador1

func _ready():
	var jugador1_scene = preload("res://jugadores/jugador1.tscn")
	var peleador1_scene = preload("res://peleadores/peleador1.tscn")

	jugador1 = jugador1_scene.instantiate()
	peleador1 = peleador1_scene.instantiate()

	add_child(jugador1)
	add_child(peleador1)

	jugador1.asignar_peleador(peleador1)

	
#func comprobar_ganador():

#	if peleador1.vida <= 0:
#		jugador1.perder()
#		jugador2.ganar()
#		finalizar_pelea()

#	elif peleador2.vida <= 0:
#		jugador1.ganar()
#		jugador2.perder()
#		finalizar_pelea()


#func finalizar_pelea():
#	print("PELEA TERMINADA")
