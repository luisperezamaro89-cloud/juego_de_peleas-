extends Node

var player
var sprite


func entrar():

	# Asegurarnos de que todas las HitBox estén apagadas
	player.desactivar_hitboxes()

	# Elegir animación según la dirección del ataque
	match player.direccion_ataque:

		"arriba":
			sprite.play("golpear_1")

		"abajo":
			sprite.play("golpear_2")

		"delante":
			sprite.play("golpear_1")


func actualizar(_direccion):

	# Mientras golpea, no se mueve
	player.velocity.x = 0

	# Cuando termina la animación
	if not sprite.is_playing():

		# Apagar todas las HitBox
		player.desactivar_hitboxes()

		# Volver a idle
		return "Idle"

	return ""


func obtener_daño():

	match player.direccion_ataque:

		"arriba":
			return 10

		"abajo":
			return 10

		"delante":
			return 10

	return 0
