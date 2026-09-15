class_name Jugador2
extends Node

@export var nombre: String = "Jugador 2"
@export var puntaje: int = 0
@export var victorias: int = 0
@export var derrotas: int = 0

var peleador: CharacterBody2D
var score_label: Label

func asignar_peleador(nuevo_peleador: CharacterBody2D):

	peleador = nuevo_peleador
	peleador.jugador_controlador = self


func sumar_puntos(cantidad: int):
	puntaje += cantidad
	puntaje = max(puntaje, 0)

	print(nombre, " ganó ", cantidad, " puntos")
	print("Puntaje actual: ", puntaje)

	if score_label:
		score_label.text = "PUNTOS: " + str(puntaje)


func ganar():

	victorias += 1
	puntaje += 20

	print(nombre, " ganó")
	print("Victorias: ", victorias)
	print("Derrotas: ", derrotas)
	print("Puntaje: ", puntaje)


func perder():

	derrotas += 1
	puntaje -= 10
	puntaje = max(puntaje, 0)

	print(nombre, " perdió")
	print("Victorias: ", victorias)
	print("Derrotas: ", derrotas)
	print("Puntaje: ", puntaje)


func obtener_estadisticas() -> Dictionary:

	return {
		"nombre": nombre,
		"puntaje": puntaje,
		"victorias": victorias,
		"derrotas": derrotas
	}
