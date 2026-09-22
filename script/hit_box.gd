extends Area2D
class_name HitBox

var player
var sprite

var ya_golpeo = false


func _ready():
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)


func reiniciar_golpe():
	ya_golpeo = false


func entrar():
	player.velocity.x = 0
	sprite.play("golpear_1")
	ya_golpeo = false


func actualizar(_direccion):
	player.velocity.x = 0

	if not sprite.is_playing():
		return "Idle"

	return ""


func _on_area_entered(area: Area2D):

	print("================================")
	print("HITBOX QUE DETECTÓ: ", name)
	print("AREA DETECTADA: ", area.name)
	print("SCRIPT DEL AREA: ", area.get_script())

	print("¿ES HURTBOX?: ", area is Hurtbox)
	print("¿TIENE recibir_daño?: ", area.has_method("recibir_daño"))

	if area is Hurtbox:

		print("¡¡ES UN HURTBOX!!")

		if ya_golpeo:
			print("ESTA HITBOX YA GOLPEÓ")
			print("================================")
			return

		ya_golpeo = true

		var golpe = player.get_node("StateMachine/Golpear")
		var daño = golpe.obtener_daño()

		print("DAÑO APLICADO: ", daño)
		print("ATACANTE: ", player.name)

		area.recibir_daño(daño, player)

	else:

		print("NO ES UN HURTBOX")

	print("================================")
