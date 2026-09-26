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

	# Mientras siga presionando el botón de bloquear,
	# permanece en este estado
	if Input.is_key_pressed(player.bloquear):
		player.bloqueando = true
		return ""

	# Soltó el botón
	player.bloqueando = false

	return "Idle"
