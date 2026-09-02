extends Node

var player
var sprite


func entrar():

	sprite.play("salto")


func actualizar(_direccion):

	# Cuando vuelva al suelo
	if player.is_on_floor():
		return "Idle"

	return ""
