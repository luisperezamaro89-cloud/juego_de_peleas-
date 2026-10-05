extends Node
# Autoload "Ajustes": guarda y aplica el volumen de todo el juego.
#
# Crea dos canales de audio por código:
#   "Musica"  -> todo lo que reproduce MusicManager
#   "Efectos" -> cualquier otro sonido del juego (golpes, etc.)
# Y manda cada AudioStreamPlayer al canal que le toca automáticamente.

const ARCHIVO := "user://ajustes.cfg"

# Volumen de 0 a 100 y si está silenciado, por cada barra del panel
var volumen := {"menu": 70, "pelea": 80, "efectos": 60}
var silenciado := {"menu": false, "pelea": false, "efectos": false}

# De cuál música es la escena actual: "menu" o "pelea"
var contexto := "menu"


func _ready() -> void:
	# El fundido entre escenas debe seguir funcionando siempre
	process_mode = Node.PROCESS_MODE_ALWAYS

	_crear_bus("Musica")
	_crear_bus("Efectos")

	cargar()
	aplicar()

	# Todo reproductor de sonido que aparezca se manda a su canal
	get_tree().node_added.connect(_nodo_agregado)

	# Y los que ya existían
	for nodo in get_tree().root.find_children("*", "", true, false):
		_nodo_agregado(nodo)


# ==========================================
# CANALES DE AUDIO
# ==========================================

func _crear_bus(nombre: String) -> void:
	if AudioServer.get_bus_index(nombre) != -1:
		return

	AudioServer.add_bus()
	var indice = AudioServer.bus_count - 1
	AudioServer.set_bus_name(indice, nombre)
	AudioServer.set_bus_send(indice, "Master")


func _nodo_agregado(nodo: Node) -> void:
	if nodo is AudioStreamPlayer or nodo is AudioStreamPlayer2D:
		if _es_musica(nodo):
			nodo.bus = "Musica"
		else:
			nodo.bus = "Efectos"


# Es música si cuelga del MusicManager
func _es_musica(nodo: Node) -> bool:
	var manager = get_node_or_null("/root/MusicManager")
	return manager != null and (nodo == manager or manager.is_ancestor_of(nodo))


# ==========================================
# CAMBIAR AJUSTES (los usa el panel de Ajustes)
# ==========================================

func cambiar_volumen(canal: String, valor: float) -> void:
	volumen[canal] = valor

	# Si se mueve la barra estando silenciado, se desilencia solo
	silenciado[canal] = false

	aplicar()
	guardar()


func alternar_silencio(canal: String) -> void:
	silenciado[canal] = not silenciado[canal]

	aplicar()
	guardar()


# Cada escena dice si suena la música del menú o la de la pelea
func poner_contexto(nuevo: String) -> void:
	contexto = nuevo
	aplicar()


# ==========================================
# APLICAR AL SONIDO
# ==========================================

func aplicar() -> void:
	_aplicar_bus("Musica", volumen[contexto], silenciado[contexto])
	_aplicar_bus("Efectos", volumen["efectos"], silenciado["efectos"])


func _aplicar_bus(nombre: String, vol: float, mute: bool) -> void:
	var indice = AudioServer.get_bus_index(nombre)

	if indice == -1:
		return

	# 0 % queda casi en silencio total (-80 dB)
	AudioServer.set_bus_volume_db(indice, linear_to_db(max(vol / 100.0, 0.0001)))
	AudioServer.set_bus_mute(indice, mute)


# ==========================================
# GUARDAR Y CARGAR (para que se recuerde al abrir el juego)
# ==========================================

func guardar() -> void:
	var cfg = ConfigFile.new()

	for canal in volumen.keys():
		cfg.set_value("audio", canal + "_volumen", volumen[canal])
		cfg.set_value("audio", canal + "_silenciado", silenciado[canal])

	cfg.save(ARCHIVO)


func cargar() -> void:
	var cfg = ConfigFile.new()

	if cfg.load(ARCHIVO) != OK:
		return

	for canal in volumen.keys():
		volumen[canal] = cfg.get_value("audio", canal + "_volumen", volumen[canal])
		silenciado[canal] = cfg.get_value("audio", canal + "_silenciado", silenciado[canal])


# ==========================================
# CAMBIO DE ESCENA CON FUNDIDO A NEGRO
# ==========================================
# (Está aquí para no tener que registrar otro autoload.)

var _capa_fundido: CanvasLayer
var _rect_fundido: ColorRect


func _crear_capa_fundido() -> void:
	if _capa_fundido != null:
		return

	_capa_fundido = CanvasLayer.new()
	_capa_fundido.layer = 100
	add_child(_capa_fundido)

	_rect_fundido = ColorRect.new()
	_rect_fundido.color = Color.BLACK
	_rect_fundido.modulate.a = 0.0
	_rect_fundido.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_capa_fundido.add_child(_rect_fundido)
	_rect_fundido.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


# La pantalla se va a negro, se cambia de escena y aparece poco a poco
func cambiar_escena_con_fundido(ruta: String, duracion: float = 0.8) -> void:
	_crear_capa_fundido()

	# Mientras dura el fundido no se puede hacer clic en nada
	_rect_fundido.mouse_filter = Control.MOUSE_FILTER_STOP

	var salida = create_tween()
	salida.set_ignore_time_scale(true)
	salida.tween_property(_rect_fundido, "modulate:a", 1.0, duracion)
	await salida.finished

	get_tree().change_scene_to_file(ruta)

	# Se espera a que la escena nueva esté lista
	await get_tree().process_frame
	await get_tree().process_frame

	var entrada = create_tween()
	entrada.set_ignore_time_scale(true)
	entrada.tween_property(_rect_fundido, "modulate:a", 0.0, duracion)
	await entrada.finished

	_rect_fundido.mouse_filter = Control.MOUSE_FILTER_IGNORE
