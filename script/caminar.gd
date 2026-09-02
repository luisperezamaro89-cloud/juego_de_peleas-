extends Node

var player
var sprite


func entrar():

	sprite.play("caminata")


func actualizar(direccion):

	# Saltar
	if Input.is_key_pressed(player.arriba) and player.is_on_floor():
		player.velocity.y = -player.fuerza_salto
		return "Salto"

	# Dejar de caminar
	if direccion == 0:
		return "Idle"

	# Girar personaje
	if direccion < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

	# Golpear
	if Input.is_key_pressed(player.golpear):
		return "Golpear"

	if direccion == 0:
		return "Idle"

	return ""
