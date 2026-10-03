extends Node
var player
var sprite
var animation_player


var audio_golpe
var golpe_defrente1
var golpe_defrente2
var sonido_golpe_3
# ==========================================
# COMBO
# ==========================================

var golpe_actual = 1
var puede_combar = false
var ataque_presionado = false
var animacion_iniciada = false

# ==========================================
# DAÑO
# ==========================================

var daño_golpe_1 = 30
var daño_golpe_2 = 35
var daño_golpe_3 = 45
	
	
# ==========================================
# ENTRAR AL ESTADO GOLPEAR
# ==========================================

func entrar():

	golpe_actual = 1
	puede_combar = false
	ataque_presionado = false
	animacion_iniciada = false

	sprite = player.get_node("AnimatedSprite2D")
	animation_player = player.get_node("AnimationPlayer")
	audio_golpe = player.get_node("AudioStreamPlayer")

	cargar_sonidos()
	player.hitbox_delante.reiniciar_golpe()
	player.hitbox_arriba.reiniciar_golpe()
	player.hitbox_abajo.reiniciar_golpe()

	player.desactivar_hitboxes()

	reproducir_golpe()

# ==========================================
# CONFIGURAR SONIDO
# ==========================================

func cargar_sonidos():

	print("================================")
	print("CARGANDO SONIDOS")
	print("PERSONAJE: ", player.nombre_personaje)

	if player.nombre_personaje == "Estudiante":

		golpe_defrente1 = preload("res://audio/estudiante/golpe_bajop01.wav")

		print("SONIDO ESTUDIANTE 1: ", golpe_defrente1)

	elif player.nombre_personaje == "Delincuente":

		golpe_defrente1 = preload("res://audio/delincuente/primer_golpep2.wav")
		golpe_defrente2 = preload("res://audio/delincuente/segundo_golpep2.wav")

		print("SONIDO DELINCUENTE 1: ", golpe_defrente1)
		print("SONIDO DELINCUENTE 2: ", golpe_defrente2)

	print("================================")
		
func reproducir_sonido_golpe():

	print("================================")
	print("INTENTANDO REPRODUCIR SONIDO")
	print("GOLPE ACTUAL: ", golpe_actual)
	print("PERSONAJE: ", player.nombre_personaje)
	print("AUDIO: ", audio_golpe)

	if audio_golpe == null:
		print("ERROR: AudioStreamPlayer NO ENCONTRADO")
		return

	match golpe_actual:

		1:
			print("SELECCIONANDO GOLPE 1")
			audio_golpe.stream = golpe_defrente1

		2:
			print("SELECCIONANDO GOLPE 2")
			audio_golpe.stream = golpe_defrente2

		3:
			print("SELECCIONANDO GOLPE 3")
			audio_golpe.stream = sonido_golpe_3

	print("STREAM ACTUAL: ", audio_golpe.stream)

	audio_golpe.play()

	print("REPRODUCIENDO: ", audio_golpe.playing)
	print("================================")
	
	
	
# ==========================================
# ACTUALIZAR
# ==========================================

func actualizar(_direccion):

	# Mientras golpea no se mueve
	player.velocity.x = 0


	# ==========================================
	# DETECTAR TECLA DE ATAQUE
	# ==========================================

	if Input.is_key_pressed(player.golpear):

		if not ataque_presionado:

			ataque_presionado = true

			# Continuar combo
			if puede_combar and golpe_actual < 3:

				golpe_actual += 1
				puede_combar = false

				player.desactivar_hitboxes()

				player.hitbox_delante.reiniciar_golpe()
				player.hitbox_arriba.reiniciar_golpe()
				player.hitbox_abajo.reiniciar_golpe()

				reproducir_golpe()

	else:
		ataque_presionado = false


	# ==========================================
	# VENTANA DEL COMBO
	# ==========================================

	var cantidad_frames = sprite.sprite_frames.get_frame_count(
		sprite.animation
	)

	if cantidad_frames > 0:

		if sprite.frame >= cantidad_frames - 2:
			puede_combar = true


	# ==========================================
	# TERMINÓ LA ANIMACIÓN
	# ==========================================

	if animacion_iniciada and not sprite.is_playing():

		player.desactivar_hitboxes()

		return "Idle"

	return ""


# ==========================================
# REPRODUCIR GOLPE
# ==========================================

func reproducir_golpe():

	# Apagar todas las HitBox
	player.desactivar_hitboxes()

	# Reiniciar todas
	player.hitbox_delante.reiniciar_golpe()
	player.hitbox_arriba.reiniciar_golpe()
	player.hitbox_abajo.reiniciar_golpe()

	reproducir_sonido_golpe()
	# ==========================================
	# GOLPE HACIA ARRIBA
	# ==========================================

	if player.direccion_ataque == "arriba":

		player.collision_arriba.disabled = false

		# Las otras apagadas
		player.collision_delante.disabled = true
		player.collision_abajo.disabled = true

		if golpe_actual == 1:

			sprite.play("golpe_saltando")
			animacion_iniciada = true

			if animation_player.has_animation("golpe_saltando"):
				animation_player.play("golpe_saltando")


		elif golpe_actual == 2:

			sprite.play("golpe_saltando")
			animacion_iniciada = true

			if animation_player.has_animation("golpe_saltando"):
				animation_player.play("golpe_saltando")


	# ==========================================
	# GOLPE HACIA ABAJO
	# ==========================================

	elif player.direccion_ataque == "abajo":


		player.collision_abajo.disabled = false

		# Las otras apagadas
		player.collision_delante.disabled = true
		player.collision_arriba.disabled = true

		if golpe_actual == 1:

			sprite.play("golpe_bajo")
			animacion_iniciada = true

			if animation_player.has_animation("golpe_bajo"):
				animation_player.play("golpe_bajo")


		elif golpe_actual == 2:

			sprite.play("golpear_1")
			animacion_iniciada = true

			if animation_player.has_animation("animacion golpe1"):
				animation_player.play("animacion golpe1")


		elif golpe_actual == 3:

			sprite.play("golpear_2")
			animacion_iniciada = true

			if animation_player.has_animation("animacion golpe2"):
				animation_player.play("animacion golpe2")


	# ==========================================
	# GOLPE HACIA DELANTE
	# ==========================================

	elif player.direccion_ataque == "delante":


		player.collision_delante.disabled = false

		# Las otras apagadas
		player.collision_arriba.disabled = true
		player.collision_abajo.disabled = true

		if golpe_actual == 1:

			sprite.play("golpe1")
			animacion_iniciada = true

			if animation_player.has_animation("animacion golpe1"):
				animation_player.play("animacion golpe1")


		elif golpe_actual == 2:

			sprite.play("golpear_2")
			animacion_iniciada = true

			if animation_player.has_animation("animacion golpe2"):
				animation_player.play("animacion golpe2")


		elif golpe_actual == 3:

			sprite.play("golpear_2")
			animacion_iniciada = true

			if animation_player.has_animation("animacion golpe2"):
				animation_player.play("animacion golpe2")


# ==========================================
# OBTENER DAÑO
# ==========================================

func obtener_daño():

	match golpe_actual:

		1:
			return daño_golpe_1

		2:
			return daño_golpe_2

		3:
			return daño_golpe_3

	return 0
