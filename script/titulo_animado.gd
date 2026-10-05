extends Control
# Se pone en el Label o TextureRect del título.
# Cae grande, se asienta con golpe y luego se balancea suave sin parar.

@export var escala_inicial := 2.5
@export var duracion_golpe := 0.5
@export var balanceo_grados := 1.5
@export var balanceo_tiempo := 2.0

func _ready():
	await get_tree().process_frame
	pivot_offset = size / 2
	modulate.a = 0.0
	scale = Vector2(escala_inicial, escala_inicial)
	var t := create_tween().set_parallel(true)
	t.tween_property(self, "modulate:a", 1.0, 0.25)
	t.tween_property(self, "scale", Vector2.ONE, duracion_golpe)\
		.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await t.finished
	var b := create_tween().set_loops()
	b.tween_property(self, "rotation_degrees", balanceo_grados, balanceo_tiempo)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	b.tween_property(self, "rotation_degrees", -balanceo_grados, balanceo_tiempo)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
