extends Node

var player
var sprite

var golpe_actual = 1
var puede_combar = false
var ya_golpeo = false

var daño_golpe_1 = 10
var daño_golpe_2 = 15


func entrar():

	player.velocity.x = 0

	golpe_actual = 1
	puede_combar = false
	ya_golpeo = false

	player.hitbox.disabled = false

	sprite.play("golpear_1")


func actualizar(_direccion):

	player.velocity.x = 0

	# Detectar UNA NUEVA pulsación
	if Input.is_action_just_pressed("golpear"):
		puede_combar = true

	# Si la animación terminó
	if not sprite.is_playing():

		# Desactivar HitBox
		player.hitbox.disabled = true

		# Si estamos en el último golpe
		if golpe_actual >= 2:
			golpe_actual = 1
			return "Idle"

		# Si no se hizo otro golpe
		if not puede_combar:
			golpe_actual = 1
			return "Idle"

		# Pasar al siguiente golpe
		golpe_actual += 1
		puede_combar = false
		ya_golpeo = false

		player.hitbox.disabled = false

		sprite.play("golpear_" + str(golpe_actual))

	return ""


func obtener_daño():

	if golpe_actual == 1:
		return daño_golpe_1

	if golpe_actual == 2:
		return daño_golpe_2

	return 0
