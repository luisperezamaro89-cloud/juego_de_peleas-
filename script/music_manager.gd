extends AudioStreamPlayer

var canciones = {
	"menu": preload("res://audio/musica_fondo/Lights, Camera, Action! - Studiopolis Zone Act 1.wav"),
	"seleccion": preload("res://audio/musica_fondo/Vs. Metal Sonic.wav")
	#"pelea": preload("res://audio/musica_fondo/Vs. Metal Sonic.wav")
	#"ganador_estudiante": preload("res://audio/musica_fondo/Vs. Metal Sonic.wav")
}	

var cancion_actual = ""


func reproducir_musica(nombre: String):

	if not canciones.has(nombre):
		print("No existe la canción: ", nombre)
		return

	# Si ya está sonando esa canción, no hacer nada
	if cancion_actual == nombre and playing:
		return

	cancion_actual = nombre

	# Fade out de la música actual
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -40.0, 0.5)

	await tween.finished

	# Cambiar canción
	stream = canciones[nombre]
	volume_db = -40.0
	play()

	# Fade in de la nueva canción
	var tween_in = create_tween()
	tween_in.tween_property(self, "volume_db", 0.0, 0.5)
