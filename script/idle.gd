extends Node

var player
var sprite


func entrar():

	player.velocity.x = 0
	sprite.play("idle")


func actualizar(direccion):
	# Golpear
	if Input.is_key_pressed(player.golpear):
		return "Golpear"

	# Bloquear
	if Input.is_key_pressed(player.bloquear):
		return "Bloquear"

#caminar
	if direccion != 0:
		return "Caminar"

# Saltar
	if Input.is_key_pressed(player.arriba) and player.is_on_floor():
		player.velocity.y = -player.fuerza_salto
		return "Salto"
		
	# Arrodillarse
	if Input.is_key_pressed(player.abajo):
		return "Arrodillarse"
	
	
	return ""
