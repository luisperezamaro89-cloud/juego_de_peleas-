extends Node

var player
var sprite
var estado_actual


func _ready():

	player = get_parent()

	# Obtener directamente el AnimatedSprite2D
	sprite = player.get_node("AnimatedSprite2D")

	# Estado inicial
	estado_actual = $Idle

	# Pasar referencias al estado
	estado_actual.player = player
	estado_actual.sprite = sprite

	# Entrar en Idle
	estado_actual.entrar()


func actualizar(direccion):

	if estado_actual == null:
		return

	var siguiente_estado = estado_actual.actualizar(direccion)

	if siguiente_estado != "":
		cambiar_estado(siguiente_estado)


func cambiar_estado(nombre_estado):

	var nuevo_estado = get_node(nombre_estado)

	if nuevo_estado == estado_actual:
		return

	if estado_actual.has_method("salir"):
		estado_actual.salir()

	estado_actual = nuevo_estado

	estado_actual.player = player
	estado_actual.sprite = sprite

	estado_actual.entrar()
