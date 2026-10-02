extends Control

func _ready():
	$PopUpAdmin.confirmed.connect(_on_pop_up_admin_confirmed)
	


func _on_btn_iniciar_partida_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/Seleccion/seleccion_personajes.tscn")

func _on_administradores_pressed() -> void:
	$PopUpAdmin/InputPassword.text = ""
	$PopUpAdmin/LabelError.text = ""
	$PopUpAdmin.popup_centered()

func _on_pop_up_admin_confirmed():
	var contrasena_ingresada = $PopUpAdmin/InputPassword.text
	if contrasena_ingresada == "admin123":
		get_tree().change_scene_to_file("res://control.tscn")
	else:
		$PopUpAdmin/LabelError.text = "Inténtalo de nuevo"
		$PopUpAdmin/InputPassword.text = ""
		$PopUpAdmin.popup_centered()


func _on_btn_creditos_pressed() -> void:
	$PanelCreditos.show()


func _on_btn_volver_pressed() -> void:
	$PanelCreditos.hide()
