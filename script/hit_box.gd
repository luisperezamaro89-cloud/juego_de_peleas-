extends Node

var player
var sprite


func entrar():

	player.velocity.x = 0

	sprite.play("golpear_1")


func actualizar(_direccion):

	# No puede moverse durante el golpe
	player.velocity.x = 0

	# Aquí después activaremos el Hitbox

	if not sprite.is_playing():
		return "Idle"

	return ""
