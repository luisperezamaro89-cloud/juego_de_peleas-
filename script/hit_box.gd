extends Area2D
class_name HitBox

var player
var sprite

var ya_golpeo = false


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
	print("HITBOX detectó: ", area.name)
	print("SCRIPT DEL AREA: ", area.get_script())

	if area.has_method("recibir_daño"):
		print("¡¡TIENE recibir_daño!!")

		if ya_golpeo:
			print("Este ataque ya golpeó")
			return

		ya_golpeo = true

		var golpe = player.get_node("StateMachine/Golpear")
		var daño = golpe.obtener_daño()

		print("DAÑO APLICADO: ", daño)

		area.recibir_daño(daño, player)

	else:
		print("NO TIENE recibir_daño")


func _on_hitbox_arriba_area_entered(area: Area2D) -> void:
	print("HITBOX detectó: ", area.name)
	print("SCRIPT DEL AREA: ", area.get_script())

	if area.has_method("recibir_daño"):
		print("¡¡TIENE recibir_daño!!")

		if ya_golpeo:
			print("Este ataque ya golpeó")
			return

		ya_golpeo = true

		var golpe = player.get_node("StateMachine/Golpear")
		var daño = golpe.obtener_daño()

		print("DAÑO APLICADO: ", daño)

		area.recibir_daño(daño, player)

	else:
		print("NO TIENE recibir_daño")


func _on_hitbox_abajo_area_entered(area: Area2D) -> void:
	print("HITBOX detectó: ", area.name)
	print("SCRIPT DEL AREA: ", area.get_script())

	if area.has_method("recibir_daño"):
		print("¡¡TIENE recibir_daño!!")

		if ya_golpeo:
			print("Este ataque ya golpeó")
			return

		ya_golpeo = true

		var golpe = player.get_node("StateMachine/Golpear")
		var daño = golpe.obtener_daño()

		print("DAÑO APLICADO: ", daño)

		area.recibir_daño(daño, player)

	else:
		print("NO TIENE recibir_daño")
