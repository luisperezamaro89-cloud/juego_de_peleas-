extends Node

var player
var sprite


func entrar():

	player.velocity.x = 0
	player.bloqueando = true

	print("ENTRÓ EN BLOQUEAR")

	sprite.play("bloquear")

	print("ANIMACIÓN: ", sprite.animation)


func actualizar(_direccion):

	player.velocity.x = 0

	if Input.is_key_pressed(player.bloquear):
		return ""

	player.bloqueando = false

	return "Idle"
