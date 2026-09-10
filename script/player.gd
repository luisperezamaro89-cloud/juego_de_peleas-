extends CharacterBody2D 

@export var velocidad: float = 200.0 
@export var gravedad: float = 1000.0 
@export var fuerza_salto: float = 400.0 

@export var jugador: int = 1 
@export var vida: int = 100  

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D 
@onready var state_machine = $StateMachine 
@onready var hitbox_delante = $"StateMachine/Golpear/HitBox_delante/collision"
@onready var hitbox_arriba = $"StateMachine/Golpear/hitbox_arriba/collision"
@onready var hitbox_abajo = $"StateMachine/Golpear/hitbox_abajo/collision"


var bloqueando: bool = false
var health_bar: TextureProgressBar

var izquierda 
var derecha 
var arriba 
var abajo 
var golpear
var direccion_ataque = "delante"
 
func _ready(): 
	
	hitbox_delante.disabled = true
	hitbox_arriba.disabled = true
	hitbox_abajo.disabled = true
	
	if jugador == 1: 
		izquierda = KEY_A 
		derecha = KEY_D 
		arriba = KEY_W 
		abajo = KEY_S 
		golpear = KEY_F 
		bloqueando = KEY_G
 
	else: 
		izquierda = KEY_LEFT 
		derecha = KEY_RIGHT 
		arriba = KEY_UP 
		abajo = KEY_DOWN 
		golpear = KEY_N 
		bloqueando = KEY_M


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

	hitbox_arriba.disabled = true
	hitbox_abajo.disabled = true
	hitbox_delante.disabled = true

	match direccion_ataque:

		"arriba":
			hitbox_arriba.disabled = false

		"abajo":
			hitbox_abajo.disabled = false

		"delante":
			hitbox_delante.disabled = false
			
func desactivar_hitboxes():

	hitbox_arriba.disabled = true
	hitbox_abajo.disabled = true
	hitbox_delante.disabled = true
	
	

func recibir_daño(cantidad: int):

	if bloqueando:
		print("¡ATAQUE BLOQUEADO!")
		return

	vida -= cantidad
	vida = max(vida, 0)

	print("VIDA ACTUAL: ", vida)

	if health_bar:
		health_bar.value = vida

	if vida <= 0:
		morir()
		return

	# Entrar en hit stun
	state_machine.cambiar_estado("daño")


func morir():
	print("Jugador ", jugador, " derrotado")
# get_tree().change_scene_to_file("res://resultado.tscn")
