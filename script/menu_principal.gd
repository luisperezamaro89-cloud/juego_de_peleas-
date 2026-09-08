extends Control

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://node_2d.tscn")


func _on_btn_iniciar_partida_pressed() -> void:
	get_tree().change_scene_to_file("res://node_2d.tscn")
