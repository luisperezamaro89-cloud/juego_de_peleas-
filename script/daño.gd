extends Node

var player
var sprite

@export var duracion_hit_stun: float = 0.25
@export var invulnerabilidad_extra: float = 0.3

var tiempo_restante: float = 0.0


func entrar():

	player.velocity.x = 0
	tiempo_restante = duracion_hit_stun

	var total = (duracion_hit_stun + invulnerabilidad_extra) * 1000.0
	player.set_meta("invulnerable_hasta", Time.get_ticks_msec() + total)

	sprite.play("daño")


func actualizar(_direccion):

	player.velocity.x = 0

	tiempo_restante -= get_process_delta_time()

	if tiempo_restante <= 0:
		return "Idle"

	return ""
