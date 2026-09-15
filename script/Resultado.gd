extends Control


@onready var ganador_label = $Ganador
@onready var puntaje_jugador1 = $PuntajeJugador1
@onready var puntaje_jugador2 = $PuntajeJugador2
@onready var boton_continuar = $BotonContinuar


func _ready():

	ganador_label.text = "¡GANADOR: " + str(get_tree().get_meta("ganador"))

	puntaje_jugador1.text = "Jugador 1: " + str(get_tree().get_meta("puntaje_jugador1"))

	puntaje_jugador2.text = "Jugador 2: " + str(get_tree().get_meta("puntaje_jugador2"))

func _on_boton_continuar_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/pelea.tscn")
