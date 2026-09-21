extends Node

var player
var sprite
var animation_player

# Combo
var golpe_actual = 1
var puede_combar = false
var ataque_presionado = false

# Daño de cada golpe
var daño_golpe_1 = 30
var daño_golpe_2 = 35
var daño_golpe_3 = 45


func entrar():
	golpe_actual = 1
	puede_combar = false
	ataque_presionado = false

	# Obtener referencias
	sprite = player.get_node("AnimatedSprite2D")
	animation_player = player.get_node("AnimationPlayer")

	# Reiniciar que cada HitBox pueda golpear
	player.hitbox_delante.reiniciar_golpe()
	player.hitbox_arriba.reiniciar_golpe()
	player.hitbox_abajo.reiniciar_golpe()

	# Apagar todas las HitBox
	player.desactivar_hitboxes()

	# Reproducir primer golpe
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

				# Reiniciar HitBoxes para el nuevo golpe
				player.hitbox_delante.reiniciar_golpe()
				player.hitbox_arriba.reiniciar_golpe()
				player.hitbox_abajo.reiniciar_golpe()

				# Reproducir siguiente golpe
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

		# Volver a Idle
		return "Idle"


	return ""


func reproducir_golpe():

	print("PLAYER: ", player)
	print("SPRITE: ", sprite)
	print("ANIMATION PLAYER: ", animation_player)

	# ACTIVAR HITBOX
	player.activar_hitbox()

	match player.direccion_ataque:

		"arriba":

			if golpe_actual == 1:

				sprite.play("golpe_saltando")
				animation_player.play("golpe_saltando")

			elif golpe_actual == 2:

				sprite.play("golpe_saltando")


		"abajo":

			if golpe_actual == 1:

				sprite.play("golpe_bajo")
				animation_player.play("golpe_bajo")

			elif golpe_actual == 2:

				sprite.play("golpear_1")

			elif golpe_actual == 3:

				sprite.play("golpear_2")


		"delante":

			if golpe_actual == 1:

				sprite.play("golpe1")
				animation_player.play("animacion golpe1")

			elif golpe_actual == 2:

				sprite.play("golpear_2")
				animation_player.play("animacion golpe2")


func obtener_daño():

	match golpe_actual:

		1:
			return daño_golpe_1

		2:
			return daño_golpe_2

		3:
			return daño_golpe_3

	return 0
