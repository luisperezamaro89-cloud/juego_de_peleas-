class_name Jugador
extends Node

@export var nombre: String = "Jugador 1"
@export var puntaje: int = 0
@export var victorias: int = 0
@export var derrotas: int = 0

# Referencia al peleador que utiliza este jugador
var peleador: CharacterBody2D


func asignar_peleador(nuevo_peleador: CharacterBody2D):
	peleador = nuevo_peleador


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
