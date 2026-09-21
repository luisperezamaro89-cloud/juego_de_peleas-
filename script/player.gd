extends CharacterBody2D 


@export var velocidad: float = 200.0
@export var gravedad: float = 1000.0
@export var fuerza_salto: float = 400.0

@export var jugador: int = 1
@export var vida: int = 100

var jugador_controlador

@onready var state_machine = $StateMachine 

@onready var hitbox_delante: HitBox = $"StateMachine/Golpear/HitBox_delante"
@onready var hitbox_arriba: HitBox = $"StateMachine/Golpear/hitbox_arriba"
@onready var hitbox_abajo: HitBox = $"StateMachine/Golpear/hitbox_abajo"

@onready var collision_delante: CollisionShape2D = $"StateMachine/Golpear/HitBox_delante/collision"
@onready var collision_arriba: CollisionShape2D = $"StateMachine/Golpear/hitbox_arriba/collision"
@onready var collision_abajo: CollisionShape2D = $"StateMachine/Golpear/hitbox_abajo/collision"

var bloqueando: bool = false
var bloquear
var health_bar: TextureProgressBar
var score
var sprite

var izquierda 
var derecha 
var arriba 
var abajo 
var golpear

var direccion_ataque = "delante"


# ==========================================
# EMPUJE DEL TERCER GOLPE
# ==========================================

var empuje_fuerza: float = 0.0
var empuje_tiempo: float = 0.0

@export var fuerza_empuje: float = 150.0
@export var duracion_empuje: float = 0.15


func _ready():

	# Sprite
	sprite = $AnimatedSprite2D

	# ------------------------------------------
	# DESACTIVAR HITBOXES AL INICIAR
	# ------------------------------------------

	collision_delante.disabled = true
	collision_arriba.disabled = true
	collision_abajo.disabled = true

	# ------------------------------------------
	# ASIGNAR PLAYER A LAS HITBOXES
	# ------------------------------------------

	hitbox_delante.player = self
	hitbox_arriba.player = self
	hitbox_abajo.player = self

	hitbox_delante.sprite = sprite
	hitbox_arriba.sprite = sprite
	hitbox_abajo.sprite = sprite

	# ------------------------------------------
	# CONTROLES
	# ------------------------------------------

	if jugador == 1:

		izquierda = KEY_A
		derecha = KEY_D
		arriba = KEY_W
		abajo = KEY_S

		golpear = KEY_F
		bloquear = KEY_G

	else:

		izquierda = KEY_LEFT
		derecha = KEY_RIGHT
		arriba = KEY_UP
		abajo = KEY_DOWN

		golpear = KEY_M
		bloquear = KEY_N


func _physics_process(delta): 
	
	# ==========================================
	# GRAVEDAD
	# ==========================================

	if not is_on_floor(): 
		velocity.y += gravedad * delta 
	else: 
		velocity.y = 0 


	# ==========================================
	# DIRECCIÓN DEL JUGADOR
	# ==========================================

	var direccion = 0 
 
	if Input.is_key_pressed(izquierda): 
		direccion -= 1
		
	if Input.is_key_pressed(derecha): 
		direccion += 1


	# ==========================================
	# MOVIMIENTO NORMAL
	# ==========================================

	velocity.x = direccion * velocidad


	# ==========================================
	# STATE MACHINE
	# ==========================================

	state_machine.actualizar(direccion)


	# ==========================================
	# HIT STUN
	# ==========================================

	# Mientras está en "Daño",
	# el personaje permanece completamente quieto.

	if state_machine.estado_actual.name == "Daño":

		velocity.x = 0


	# ==========================================
	# EMPUJE DEL TERCER GOLPE
	# ==========================================

	elif empuje_tiempo > 0:

		empuje_tiempo -= delta

		velocity.x = empuje_fuerza

		# Reducir poco a poco el empuje
		empuje_fuerza = move_toward(
			empuje_fuerza,
			0.0,
			1000.0 * delta
		)

	# Si todavía tenemos un empuje pendiente,
	# significa que acabamos de salir del estado Daño.

	elif empuje_fuerza != 0:

		empuje_tiempo = duracion_empuje


	move_and_slide()


func _input(event):

	if event is InputEventKey and event.pressed and not event.echo:

		if event.keycode == golpear:

			# ----------------------------------
			# ATAQUE HACIA ARRIBA
			# ----------------------------------

			if Input.is_key_pressed(arriba):

				direccion_ataque = "arriba"


			# ----------------------------------
			# ATAQUE HACIA ABAJO
			# ----------------------------------

			elif Input.is_key_pressed(abajo):

				direccion_ataque = "abajo"


			# ----------------------------------
			# ATAQUE HACIA DELANTE
			# ----------------------------------

			else:

				direccion_ataque = "delante"


			state_machine.cambiar_estado("Golpear")

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD

func activar_hitbox():
<<<<<<< HEAD

	# ------------------------------------------
	# APAGAR TODAS
	# ------------------------------------------

=======
>>>>>>> parent of f26bc04 (hitbox arreglado)
=======
func activar_hitbox():
>>>>>>> parent of f26bc04 (hitbox arreglado)
=======
func activar_hitbox():
>>>>>>> parent of f26bc04 (hitbox arreglado)
=======
func activar_hitbox():
>>>>>>> parent of f26bc04 (hitbox arreglado)
	collision_arriba.disabled = true
	collision_abajo.disabled = true
	collision_delante.disabled = true

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
	print("================================")
	print("DIRECCION DEL ATAQUE: ", direccion_ataque)


=======
>>>>>>> parent of f26bc04 (hitbox arreglado)
=======
>>>>>>> parent of f26bc04 (hitbox arreglado)
=======
>>>>>>> parent of f26bc04 (hitbox arreglado)
=======
>>>>>>> parent of f26bc04 (hitbox arreglado)
	match direccion_ataque:
		"arriba":

			collision_arriba.disabled = false
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD

			print("HITBOX ARRIBA ACTIVADA")
			print("ARRIBA disabled: ", collision_arriba.disabled)
=======
>>>>>>> parent of f26bc04 (hitbox arreglado)

=======
>>>>>>> parent of f26bc04 (hitbox arreglado)
=======
>>>>>>> parent of f26bc04 (hitbox arreglado)
=======
>>>>>>> parent of f26bc04 (hitbox arreglado)

		"abajo":

			collision_abajo.disabled = false
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD

			print("HITBOX ABAJO ACTIVADA")
			print("ABAJO disabled: ", collision_abajo.disabled)
=======
>>>>>>> parent of f26bc04 (hitbox arreglado)

=======
>>>>>>> parent of f26bc04 (hitbox arreglado)
=======
>>>>>>> parent of f26bc04 (hitbox arreglado)
=======
>>>>>>> parent of f26bc04 (hitbox arreglado)

		"delante":

			collision_delante.disabled = false
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD

			print("HITBOX DELANTE ACTIVADA")
			print("DELANTE disabled: ", collision_delante.disabled)


	print("================================")


=======
=======
>>>>>>> parent of f26bc04 (hitbox arreglado)
=======
>>>>>>> parent of f26bc04 (hitbox arreglado)
=======
>>>>>>> parent of f26bc04 (hitbox arreglado)
			
>>>>>>> parent of f26bc04 (hitbox arreglado)
func desactivar_hitboxes():

	collision_arriba.disabled = true
	collision_abajo.disabled = true
	collision_delante.disabled = true


func recibir_daño(
	cantidad: int,
	atacante = null,
	es_tercer_golpe: bool = false
):

	print("PLAYER recibió daño: ", cantidad)
	print("VIDA ANTES: ", vida)


	# ==========================================
	# BLOQUEO
	# ==========================================

	if bloqueando:

		print("¡ATAQUE BLOQUEADO!")

		return


	# ==========================================
	# DAÑO
	# ==========================================

	vida -= cantidad
	vida = max(vida, 0)

	print("VIDA DESPUÉS: ", vida)


	# ==========================================
	# ACTUALIZAR HEALTH BAR
	# ==========================================

	if health_bar:

		health_bar.value = vida

		print("HEALTHBAR ACTUALIZADA: ", health_bar.value)

	else:

		print("ERROR: health_bar está vacío")


	# ==========================================
	# DAR PUNTOS AL ATACANTE
	# ==========================================

	if atacante and atacante.jugador_controlador:

		atacante.jugador_controlador.sumar_puntos(cantidad)


	# ==========================================
	# TERCER GOLPE
	# ==========================================

	if es_tercer_golpe and atacante:

		var direccion_empuje = sign(
			global_position.x - atacante.global_position.x
		)

		empuje_fuerza = direccion_empuje * fuerza_empuje

		print("================================")
		print("¡¡TERCER GOLPE!!")
		print("DIRECCIÓN EMPUJE: ", direccion_empuje)
		print("FUERZA EMPUJE: ", empuje_fuerza)
		print("================================")


	# ==========================================
	# MUERTE
	# ==========================================

	if vida <= 0:

		morir()

		return


	# ==========================================
	# HIT STUN
	# ==========================================

	state_machine.cambiar_estado("Daño")


func morir():

	print("Jugador ", jugador, " derrotado")


	var jugador1 = get_parent().peleador1.jugador_controlador
	var jugador2 = get_parent().peleador2.jugador_controlador

	var ganador


	if jugador == 1:

		ganador = jugador2

	else:

		ganador = jugador1


	get_tree().set_meta("ganador", ganador.nombre)

	get_tree().set_meta(
		"puntaje_jugador1",
		jugador1.puntaje
	)

	get_tree().set_meta(
		"puntaje_jugador2",
		jugador2.puntaje
	)


	get_tree().change_scene_to_file(
		"res://escenas/Resultado.tscn"
	)
