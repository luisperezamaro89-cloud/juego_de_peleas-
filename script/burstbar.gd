extends TextureProgressBar

@export var multiplicador_carga: float = 0.2


func agregar_carga(dano: int):

	var carga = dano * multiplicador_carga

	value += carga
	value = clamp(value, min_value, max_value)

	print("BURST +", carga)
	print("BURST ACTUAL: ", value)
