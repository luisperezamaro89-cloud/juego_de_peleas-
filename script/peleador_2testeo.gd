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

var izquierda 
var derecha 
var arriba 
var abajo 
var golpear
var direccion_ataque = "delante"

 
func _ready():
 	
	collision_delante.disabled = true
	collision_arriba.disabled = true
	collision_abajo.disabled = true

	hitbox_delante.player = self
	hitbox_arriba.player = self
	hitbox_abajo.player = self

	if jugador == 1:
		
		izquierda = KEY_LEFT
		derecha = KEY_RIGHT
		arriba = KEY_UP
		abajo = KEY_DOWN
		golpear = KEY_N
		bloquear = KEY_M
		
		scale.x = -abs(scale.x)


func _physics_process(delta): 
	
	# Gravedad
	if not is_on_floor(): 
		velocity.y += gravedad * delta 
	else: 
		velocity.y = 0 
 
	# Dirección
	var direccion = 0 
 
	if Input.is_key_pressed(izquierda): 
		direccion -= 1 
		
	if Input.is_key_pressed(derecha): 
		direccion += 1 
 
	velocity.x = direccion * velocidad 
	
 
	# State Machine
	state_machine.actualizar(direccion) 
 
	move_and_slide()


func _input(event):

	if event is InputEventKey and event.pressed and not event.echo:

		if event.keycode == golpear:

			if Input.is_key_pressed(arriba):
				direccion_ataque = "arriba"

			elif Input.is_key_pressed(abajo):
				direccion_ataque = "abajo"

			else:
				direccion_ataque = "delante"

			state_machine.cambiar_estado("Golpear")

func activar_hitbox():
	collision_arriba.disabled = true
	collision_abajo.disabled = true
	collision_delante.disabled = true

	match direccion_ataque:
		"arriba":
			collision_arriba.disabled = false
		"abajo":
			collision_abajo.disabled = false
		"delante":
			collision_delante.disabled = false
			
func desactivar_hitboxes():
	collision_arriba.disabled = true
	collision_abajo.disabled = true
	collision_delante.disabled = true
	
	

func recibir_daño(cantidad: int, atacante = null):
	print("PLAYER recibió daño: ", cantidad)
	print("VIDA ANTES: ", vida)
	
	# Camera shake
	var camara = get_node("../Camera2D")

	if camara:
		camara.shake(cantidad * 0.4)

	if bloqueando:
		print("¡ATAQUE BLOQUEADO!")
		return

	vida -= cantidad
	vida = max(vida, 0)

	print("VIDA DESPUÉS: ", vida)

	if health_bar:
		health_bar.value = vida
		print("HEALTHBAR ACTUALIZADA: ", health_bar.value)
	else:
		print("ERROR: health_bar está vacío")

	if atacante and atacante.jugador_controlador:
		atacante.jugador_controlador.sumar_puntos(cantidad)

	if vida <= 0:
		morir()
		return

	state_machine.cambiar_estado("Daño")


func morir():
	print("Jugador ", jugador, " derrotado")
# get_tree().change_scene_to_file("res://resultado.tscn")
