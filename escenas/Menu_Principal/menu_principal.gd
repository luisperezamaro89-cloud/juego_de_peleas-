extends Control

# Lo que se mueve con la animación al iniciar partida
@onready var contenedor_botones = $VBoxContainer   # los 5 botones
@onready var boton_admin = $BtnAdmin               # botón ADMINISTRADORES

# Controles del panel de ajustes de audio:
# canal -> [barra, texto del porcentaje, botón de silencio]
@onready var controles_audio = {
	"menu": [
		$PanelAjustes/VBoxContainer/FilaMusicaMenu/SliderMusicaMenu,
		$PanelAjustes/VBoxContainer/FilaMusicaMenu/ValorMusicaMenu,
		$PanelAjustes/VBoxContainer/FilaMusicaMenu/BtnMuteMenu
	],
	"pelea": [
		$PanelAjustes/VBoxContainer/FilaMusicaPelea/SliderMusicaPelea,
		$PanelAjustes/VBoxContainer/FilaMusicaPelea/ValorMusicaPelea,
		$PanelAjustes/VBoxContainer/FilaMusicaPelea/BtnMutePelea
	],
	"efectos": [
		$PanelAjustes/VBoxContainer/FilaEfectos/SliderEfectos,
		$PanelAjustes/VBoxContainer/FilaEfectos/ValorEfectos,
		$PanelAjustes/VBoxContainer/FilaEfectos/BtnMuteEfectos
	]
}

# Cuánto dura la animación de salida (en segundos)
const DURACION_SALIDA := 0.6

var animando := false


func _ready():
	# Por si se volvió al menú desde otra escena con la entrada bloqueada
	get_viewport().gui_disable_input = false

	$PopUpAdmin.confirmed.connect(_on_pop_up_admin_confirmed)
	MusicManager.reproducir_musica("menu")

	# Audio: esta escena es la del menú
	Ajustes.poner_contexto("menu")
	_conectar_controles_audio()

	for canal in controles_audio.keys():
		_refrescar_canal(canal)


# ==========================================
# INICIAR PARTIDA (con animación)
# ==========================================

func _on_btn_iniciar_partida_pressed() -> void:
	if animando:
		return

	animando = true

	# Mientras sale la animación no se puede presionar nada más
	get_viewport().gui_disable_input = true

	var tamano_pantalla = get_viewport_rect().size

	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)   # empieza despacio y va acelerando

	# Los botones salen por la derecha
	tween.tween_property(contenedor_botones, "position:x",
		contenedor_botones.position.x + tamano_pantalla.x, DURACION_SALIDA)

	# El botón de administrador sale por abajo
	tween.tween_property(boton_admin, "position:y",
		boton_admin.position.y + tamano_pantalla.y, DURACION_SALIDA)

	await tween.finished

	get_viewport().gui_disable_input = false
	get_tree().change_scene_to_file("res://escenas/Seleccion/seleccion_personajes.tscn")


# ==========================================
# ADMINISTRADORES
# ==========================================

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


# ==========================================
# CRÉDITOS
# ==========================================

func _on_btn_creditos_pressed() -> void:
	$PanelCreditos.show()


func _on_btn_volver_pressed() -> void:
	$PanelCreditos.hide()


# ==========================================
# AJUSTES DE AUDIO
# ==========================================

func _on_btn_ajustes_pressed() -> void:
	$PanelAjustes.show()


func _on_btn_volver_ajustes_pressed() -> void:
	$PanelAjustes.hide()


# Conecta las 3 barras y los 3 botones ON/OFF (no hace falta hacerlo en el editor)
func _conectar_controles_audio() -> void:
	for canal in controles_audio.keys():
		var slider = controles_audio[canal][0]
		var boton = controles_audio[canal][2]

		slider.value_changed.connect(_on_slider_cambio.bind(canal))
		boton.pressed.connect(_on_mute_presionado.bind(canal))


func _on_slider_cambio(valor: float, canal: String) -> void:
	Ajustes.cambiar_volumen(canal, valor)
	_refrescar_canal(canal)


func _on_mute_presionado(canal: String) -> void:
	Ajustes.alternar_silencio(canal)
	_refrescar_canal(canal)


# Pone la barra, el porcentaje y el botón como están guardados
func _refrescar_canal(canal: String) -> void:
	var slider = controles_audio[canal][0]
	var texto = controles_audio[canal][1]
	var boton = controles_audio[canal][2]
	var esta_silenciado = Ajustes.silenciado[canal]

	slider.set_value_no_signal(Ajustes.volumen[canal])
	texto.text = str(int(Ajustes.volumen[canal])) + "%"
	boton.text = "OFF" if esta_silenciado else "ON"

	# La barra se ve apagada mientras está silenciado
	slider.modulate = Color(1, 1, 1, 0.5) if esta_silenciado else Color(1, 1, 1, 1)


func _on_btn_top_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Top_jugadores/top_5.tscn")
