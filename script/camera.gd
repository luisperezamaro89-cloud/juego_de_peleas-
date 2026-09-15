extends Camera2D

@onready var peleador1 = get_node("../peleador1")
@onready var peleador2 = get_node("../peleador2")

# Qué tan rápido sigue a los jugadores
@export var velocidad_seguimiento: float = 5.0

# Zoom normal
@export var zoom_normal: float = 2.0

# Qué tan lejos puede alejarse
@export var zoom_minimo: float = 0.9

# Distancia a partir de la cual empieza a alejarse
@export var distancia_zoom: float = 500.0


# -----------------------------
# CAMERA SHAKE
# -----------------------------

var shake_fuerza: float = 0.0
var shake_duracion: float = 0.0


func _ready():

	zoom = Vector2(zoom_normal, zoom_normal)


func _process(delta):

	# --------------------------------
	# SEGUIR A LOS DOS PERSONAJES
	# --------------------------------

	var punto_medio = (peleador1.global_position + peleador2.global_position) / 2.0

	global_position = global_position.lerp(
		punto_medio,
		velocidad_seguimiento * delta
	)


	# --------------------------------
	# ZOOM SEGÚN DISTANCIA
	# --------------------------------

	var distancia = peleador1.global_position.distance_to(
		peleador2.global_position
	)

	var zoom_objetivo = zoom_normal

	if distancia > distancia_zoom:

		zoom_objetivo = clamp(
			distancia_zoom / distancia,
			zoom_minimo,
			zoom_normal
		)

	zoom = zoom.lerp(
		Vector2(zoom_objetivo, zoom_objetivo),
		velocidad_seguimiento * delta
	)


	# --------------------------------
	# CAMERA SHAKE
	# --------------------------------

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


# --------------------------------
# ACTIVAR SHAKE
# --------------------------------

func shake(fuerza: float = 8.0):

	shake_fuerza = fuerza
	shake_duracion = 0.15
