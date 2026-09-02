extends Node

var player
var sprite

@export var duracion_hit_stun: float = 0.25

var tiempo_restante: float = 0.0


func entrar():

	player.velocity.x = 0
	tiempo_restante = duracion_hit_stun

	print("ENTRÓ EN ESTADO DAÑO")
	print("ANIMACIÓN ACTUAL: ", sprite.animation)

	sprite.play("daño")

	print("ANIMACIÓN DESPUÉS DE PLAY: ", sprite.animation)


func actualizar(_direccion):

	player.velocity.x = 0

	tiempo_restante -= get_process_delta_time()

	if tiempo_restante <= 0:
		return "Idle"

	return ""
