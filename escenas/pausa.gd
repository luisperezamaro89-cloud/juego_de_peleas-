extends CanvasLayer
# Menú de pausa de la pelea: se abre y se cierra con Esc,
# o se cierra con el botón Reanudar.

@onready var boton_reanudar = $PanelPausa/VBoxContainer/BtnReanudar

# Controles del audio: canal -> [barra, texto del porcentaje, botón de silencio]
@onready var controles_audio = {
	"menu": [
		$PanelPausa/VBoxContainer/FilaMusicaMenu/SliderMusicaMenu,
		$PanelPausa/VBoxContainer/FilaMusicaMenu/ValorMusicaMenu,
		$PanelPausa/VBoxContainer/FilaMusicaMenu/BtnMuteMenu
	],
	"pelea": [
		$PanelPausa/VBoxContainer/FilaMusicaPelea/SliderMusicaPelea,
		$PanelPausa/VBoxContainer/FilaMusicaPelea/ValorMusicaPelea,
		$PanelPausa/VBoxContainer/FilaMusicaPelea/BtnMutePelea
	],
	"efectos": [
		$PanelPausa/VBoxContainer/FilaEfectos/SliderEfectos,
		$PanelPausa/VBoxContainer/FilaEfectos/ValorEfectos,
		$PanelPausa/VBoxContainer/FilaEfectos/BtnMuteEfectos
	]
}

var en_pausa := false


func _ready() -> void:
	# Este menú y la música siguen funcionando aunque el juego esté en pausa
	process_mode = Node.PROCESS_MODE_ALWAYS
	MusicManager.process_mode = Node.PROCESS_MODE_ALWAYS

	hide()

	boton_reanudar.pressed.connect(reanudar)
	_conectar_controles_audio()


func _exit_tree() -> void:
	# Por si se sale de la pelea estando en pausa
	if get_tree() != null:
		get_tree().paused = false


# ==========================================
# PAUSAR Y REANUDAR
# ==========================================

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):   # la tecla Esc
		if en_pausa:
			reanudar()
		else:
			pausar()

		get_viewport().set_input_as_handled()


func pausar() -> void:
	en_pausa = true

	# Las barras muestran lo que está guardado
	for canal in controles_audio.keys():
		_refrescar_canal(canal)

	show()
	get_tree().paused = true


func reanudar() -> void:
	en_pausa = false

	get_tree().paused = false
	hide()


# ==========================================
# AJUSTES DE AUDIO (los mismos del menú)
# ==========================================

# Conecta las 3 barras y los 3 botones ON/OFF
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
