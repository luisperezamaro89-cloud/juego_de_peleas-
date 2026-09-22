extends TextureProgressBar

@export var multiplicador_carga: float = 0.5


func agregar_carga(dano: int):

	var carga = dano * multiplicador_carga

	value += carga
	value = clamp(value, min_value, max_value)

	print("BURST +", carga)
	print("BURST ACTUAL: ", value)


func gastar():

	value = 0
	print("BURST GASTADO")
