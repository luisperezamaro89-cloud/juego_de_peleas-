extends Label

func mostrar_ganador(jugador: int):
	if jugador == 1:
		text = "¡JUGADOR 1 GANA!"
	else:
		text = "¡JUGADOR 2 GANA!"
