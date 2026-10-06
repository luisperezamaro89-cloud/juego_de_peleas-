extends Node

var player
var sprite

var cooldown_golpe := 0.5


func entrar():

	sprite.play("caminata")


func puede_golpear() -> bool:
	var ultimo = player.get_meta("fin_golpe", -100000)
	return (Time.get_ticks_msec() - ultimo) >= cooldown_golpe * 1000.0


func actualizar(direccion):

	# Bloquear
	if Input.is_key_pressed(player.bloquear):
		return "Bloquear"

	# Saltar
	if Input.is_key_pressed(player.arriba) and player.is_on_floor():
		player.velocity.y = -player.fuerza_salto
		return "Salto"

	# Dejar de caminar
	if direccion == 0:
		return "Idle"

	# Girar personaje
	if direccion < 0:
		sprite.play("caminata")
	else:
		sprite.flip_h = false

	# Golpear (solo si ya pasó el cooldown)
	if Input.is_key_pressed(player.golpear) and puede_golpear():
		return "Golpear"

	return ""
