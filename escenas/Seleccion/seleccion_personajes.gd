extends Control

func _ready() -> void:
	pass


func _on_btn_pelear_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/pelea.tscn")
