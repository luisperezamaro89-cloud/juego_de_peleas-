extends Node

var player
var sprite


func entrar():
	player.velocity.x = 0
	sprite.play("arrodillarse")


func actualizar(_direccion):

	# Si deja de presionar abajo, vuelve a Idle
	if not Input.is_key_pressed(player.abajo):
		return "Idle"

	return ""
