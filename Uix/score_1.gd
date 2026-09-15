extends Label

var puntaje: int = 0


func _ready():
	text = "PUNTOS: 0"


func sumar_puntos(cantidad: int):
	puntaje += cantidad
	puntaje = max(puntaje, 0)

	text = "PUNTOS: " + str(puntaje)

	print("Puntaje: ", puntaje)


func restar_puntos(cantidad: int):
	puntaje -= cantidad
	puntaje = max(puntaje, 0)

	text = "PUNTOS: " + str(puntaje)

	print("Puntaje: ", puntaje)
