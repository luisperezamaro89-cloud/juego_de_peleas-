extends Area2D
class_name  hurtbox

func recibir_dano(dano: int):
	var personaje = get_parent()

	if personaje.has_method("recibir_dano"):
		personaje.recibir_dano(dano)
