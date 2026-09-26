extends Area2D
class_name Hurtbox

func recibir_daño(daño: int, atacante = null):
	print("HURTBOX recibió daño: ", daño)

	var personaje = get_parent()

	print("PERSONAJE: ", personaje.name)

	if personaje.has_method("recibir_daño"):
		print("El personaje TIENE recibir_daño")
		personaje.recibir_daño(daño, atacante)
	else:
		print("ERROR: el personaje NO tiene recibir_daño")
