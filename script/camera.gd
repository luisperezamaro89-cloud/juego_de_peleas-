extends Camera2D

@onready var peleador1 = get_node("../peleador1")
@onready var peleador2 = get_node("../peleador2")


# ==========================================
# SEGUIMIENTO
# ==========================================

@export var velocidad_seguimiento: float = 8.0

# Cuánto queremos que la cámara esté por encima
@export var altura_camara: float = -10.0


# ==========================================
# ZOOM
# ==========================================

# Zoom cuando los personajes están cerca
@export var zoom_normal: float = 4.0

# Zoom máximo alejándose
@export var zoom_minimo: float = 1.3

# Distancia a partir de la cual empieza a alejarse
@export var distancia_zoom: float = 200.0

# ==========================================
# CAMERA SHAKE
# ==========================================

var shake_fuerza: float = 0.0
var shake_duracion: float = 0.0


func _ready():

	zoom = Vector2(zoom_normal, zoom_normal)

func _process(delta):

	# ======================================
	# SEGUIR A LOS DOS PERSONAJES
	# ======================================

	var punto_medio = (
		peleador1.global_position +
		peleador2.global_position
	) / 2.0


	# ======================================
	# AJUSTE VERTICAL
	# ======================================

	var ajuste_vertical = altura_camara

	# Si la cámara está haciendo zoom out,
	# la subimos para mostrar menos piso.
	if zoom.x < zoom_normal:

		var porcentaje_zoom = 1.0 - (zoom.x / zoom_normal)

		ajuste_vertical -= porcentaje_zoom * 150.0


	punto_medio.y += ajuste_vertical


	# Seguimiento suave
	global_position = global_position.lerp(
		punto_medio,
		velocidad_seguimiento * delta
	)


	# ======================================
	# ZOOM SEGÚN DISTANCIA
	# ======================================

	var distancia = peleador1.global_position.distance_to(
		peleador2.global_position
	)

	var zoom_objetivo = zoom_normal


	if distancia > distancia_zoom:

		zoom_objetivo = clamp(
			distancia_zoom / distancia * zoom_normal,
			zoom_minimo,
			zoom_normal
		)


	# Zoom suave
	zoom = zoom.lerp(
		Vector2(zoom_objetivo, zoom_objetivo),
		velocidad_seguimiento * delta
	)


	# ======================================
	# CAMERA SHAKE
	# ======================================

	if shake_duracion > 0:

		shake_duracion -= delta

		var porcentaje = shake_duracion / 0.15

		var offset_x = randf_range(
			-shake_fuerza * porcentaje,
			shake_fuerza * porcentaje
		)

		var offset_y = randf_range(
			-shake_fuerza * porcentaje,
			shake_fuerza * porcentaje
		)

		offset = Vector2(offset_x, offset_y)

	else:

		offset = offset.lerp(
			Vector2.ZERO,
			20.0 * delta
		)


# ==========================================
# ACTIVAR CAMERA SHAKE
# ==========================================

func shake(fuerza: float = 8.0):

	shake_fuerza = fuerza
	shake_duracion = 0.10
