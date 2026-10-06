extends Node

var player
var sprite

var cooldown_golpe := 0.5


func entrar():

	player.velocity.x = 0
	sprite.play("idle")


func puede_golpear() -> bool:
	var ultimo = player.get_meta("fin_golpe", -100000)
	return (Time.get_ticks_msec() - ultimo) >= cooldown_golpe * 1000.0


func actualizar(direccion):

	# Golpear (solo si ya pasó el cooldown)
	if Input.is_key_pressed(player.golpear) and puede_golpear():
		return "Golpear"

	# Bloquear
	if Input.is_key_pressed(player.bloquear):
		return "Bloquear"


	# Caminar
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
