extends Node

var canciones = {
	"menu": preload("res://audio/musica_fondo/Lights, Camera, Action! - Studiopolis Zone Act 1.wav"),
	"seleccion": preload("res://audio/musica_fondo/Vs. Metal Sonic.wav"),
#	"pelea": preload("res://audio/pelea.ogg"),
#	"resultados": preload("res://audio/resultados.ogg")
}

var cancion_actual = ""
var cambiando = false

@onready var music_player = $MusicPlayer


func reproducir_musica(nombre: String):

	if not canciones.has(nombre):
		print("No existe la canción: ", nombre)
		return

	# Si ya está sonando esa canción, no hacer nada
	if cancion_actual == nombre and music_player.playing:
		return

	cancion_actual = nombre

	# Fade out
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -40.0, 0.5)

	await tween.finished

	# Cambiar canción
	music_player.stream = canciones[nombre]
	music_player.volume_db = -40.0
	music_player.play()

	# Fade in
	var tween_in = create_tween()
	tween_in.tween_property(music_player, "volume_db", 0.0, 0.5)
