extends Control

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://escenas/Seleccion/seleccion_personajes.tscn")


func _on_btn_iniciar_partida_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/Seleccion/seleccion_personajes.tscn")


func _on_administradores_pressed() -> void:
	$PopUpAdmin/InputPassword.text = "" 
	$PopUpAdmin.popup_centered(Vector2i(300, 100)) 
	
func _on_pop_up_admin_confirmed() -> void:
	# Cambia "1234" por la contraseña que quieras usar
		if $PopUpAdmin/InputPassword.text == "Admin123":
			get_tree().change_scene_to_file("res://base_datos/control.tscn")
		else:
			print("Contraseña incorrecta")
