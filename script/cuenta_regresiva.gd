extends CanvasLayer
# Se pone en un CanvasLayer vacío dentro de pelea.tscn (o en un Node nuevo).
# Crea su propio Label. Uso:
#   await $CuentaRegresiva.iniciar(1)   # muestra RONDA 1, 3, 2, 1, ¡PELEA!

signal terminado

@export var tamano := 140
@export var color_texto := Color(1.0, 0.6, 0.1)
@export var color_borde := Color(0.1, 0.05, 0.05)
@export var pausa := 0.5  # cuánto se queda cada texto

var _label: Label

func _ready():
	layer = 20
	_label = Label.new()
	_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label.add_theme_font_size_override("font_size", tamano)
	_label.add_theme_color_override("font_color", color_texto)
	_label.add_theme_color_override("font_outline_color", color_borde)
	_label.add_theme_constant_override("outline_size", 24)
	_label.modulate.a = 0.0
	add_child(_label)

func iniciar(ronda: int = 1):
	await get_tree().process_frame
	for txt in ["RONDA %d" % ronda, "3", "2", "1", "¡PELEA!"]:
		await _golpe(txt)
	terminado.emit()

func _golpe(txt: String):
	_label.text = txt
	_label.pivot_offset = _label.size / 2
	_label.scale = Vector2(2.2, 2.2)
	_label.modulate.a = 1.0
	var t := create_tween()
	t.tween_property(_label, "scale", Vector2.ONE, 0.25)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_interval(pausa)
	t.tween_property(_label, "modulate:a", 0.0, 0.15)
	await t.finished
