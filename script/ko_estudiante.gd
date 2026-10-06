extends Control

@onready var video = self

func _ready():
	MusicManager.reproducir_musica("ganador_estudiante")

	video.play()
	video.finished.connect(_on_video_finished)


func _on_video_finished():

	# El último frame del video permanece visible
	# durante unos segundos.
	await get_tree().create_timer(0.3).timeout

	# Crear el fondo negro para el fade
	var fade = ColorRect.new()

	fade.color = Color(0, 0, 0, 0)

	fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE

	add_child(fade)

	# Asegurar que quede encima del video
	move_child(fade, get_child_count() - 1)

	# Difuminar progresivamente a negro
	var tween = create_tween()

	tween.tween_property(
		fade,
		"color",
		Color(0, 0, 0, 1),
		1.5
	)

	await tween.finished

	# Cambiar a resultados
	get_tree().change_scene_to_file("res://escenas/Resultado.tscn")
