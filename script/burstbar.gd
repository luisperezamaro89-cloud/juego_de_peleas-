extends TextureProgressBar

@export var multiplicador_carga: float = 0.4


func agregar_carga(daño: int):

	var carga = daño * multiplicador_carga

	value += carga
	value = clamp(value, min_value, max_value)

	print("BURST +", carga)
	print("BURST ACTUAL: ", value)
