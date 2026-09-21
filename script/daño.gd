extends Node

var player
var sprite

@export var duracion_hit_stun: float = 0.25

var tiempo_restante: float = 0.0


func entrar():

	# Detener completamente al personaje
	player.velocity.x = 0
	player.velocity.y = 0

	tiempo_restante = duracion_hit_stun

	print("ENTRÓ EN ESTADO DAÑO")

	sprite.play("daño")


func actualizar(_direccion):

	# Mientras está recibiendo el golpe, permanece quieto
	player.velocity.x = 0
	player.velocity.y = 0

	tiempo_restante -= get_process_delta_time()

	if tiempo_restante <= 0:

		# Aplicar el empuje si existe
		if player.empuje_pendiente != 0:
			player.velocity.x = player.empuje_pendiente
			player.empuje_pendiente = 0

		return "Idle"

	return ""
