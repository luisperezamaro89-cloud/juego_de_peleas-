extends Control

@onready var imagen_j1 = $VBoxContainer/ImagenJ1
@onready var imagen_j2 = $VBoxContainer/ImagenJ2

var asesina = preload("res://assets/Uix/placeholder1.jpg")
var ninja = preload("res://assets/Uix/placeholder2.jpg")


func _ready() -> void:
	pass




func _on_btn_pelear_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/pelea.tscn")
