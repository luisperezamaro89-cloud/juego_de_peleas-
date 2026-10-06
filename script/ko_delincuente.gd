extends Control

@onready var video = self

func _ready():
	MusicManager.reproducir_musica("ganador_delincuente")
	video.play()
	video.finished.connect(_on_video_finished)

func _on_video_finished():
	get_tree().change_scene_to_file("res://escenas/Resultado.tscn")
