extends Node

var player
var sprite

# Combo
var golpe_actual = 1
var puede_combar = false
var ataque_presionado = false

# Daño de cada golpe
var daño_golpe_1 = 10
var daño_golpe_2 = 15
var daño_golpe_3 = 25


func entrar():

	# Reiniciar el combo
	golpe_actual = 1
	puede_combar = false
	
	# Si F sigue presionada al entrar al estado,
	# esperamos a que la suelte antes de aceptar otra pulsación
	ataque_presionado = Input.is_key_pressed(player.golpear)

	# Apagar todas las HitBox
	player.desactivar_hitboxes()

	# Ejecutar primer golpe
	reproducir_golpe()


func actualizar(_direccion):

	# Mientras golpea, no se mueve
	player.velocity.x = 0


	# ---------------------------------
	# DETECTAR F
	# ---------------------------------

	if Input.is_key_pressed(player.golpear):

		if not ataque_presionado:

			ataque_presionado = true

			# Continuar combo
			if puede_combar and golpe_actual < 3:

				golpe_actual += 1

				puede_combar = false

				player.desactivar_hitboxes()

				reproducir_golpe()

	else:

		ataque_presionado = false


	# ---------------------------------
	# VENTANA PARA CONTINUAR EL COMBO
	# ---------------------------------

	var cantidad_frames = sprite.sprite_frames.get_frame_count(sprite.animation)

	if cantidad_frames > 0:

		# Los últimos 2 frames permiten
		# presionar F para continuar
		if sprite.frame >= cantidad_frames - 2:

			puede_combar = true


	# ---------------------------------
	# TERMINÓ LA ANIMACIÓN
	# ---------------------------------

	if not sprite.is_playing():

		player.desactivar_hitboxes()

		# Termina el ataque y vuelve a Idle
		return "Idle"


	return ""


func reproducir_golpe():

	# Usamos tus animaciones actuales
	# golpear_1 y golpear_2

	match player.direccion_ataque:

		"arriba":

			if golpe_actual == 1:
				sprite.play("golpear_1")

			elif golpe_actual == 2:
				sprite.play("golpear_2")

			elif golpe_actual == 3:
				sprite.play("golpear_1")


		"abajo":

			if golpe_actual == 1:
				sprite.play("golpear_2")

			elif golpe_actual == 2:
				sprite.play("golpear_1")

			elif golpe_actual == 3:
				sprite.play("golpear_2")


		"delante":

			if golpe_actual == 1:
				sprite.play("golpear_1")

			elif golpe_actual == 2:
				sprite.play("golpear_2")

			elif golpe_actual == 3:
				sprite.play("golpear_1")


func obtener_daño():

	match golpe_actual:

		1:
			return daño_golpe_1

		2:
			return daño_golpe_2

		3:
			return daño_golpe_3

	return 0
