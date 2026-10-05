extends Button
# Se pone en cualquier Button. Crece al pasar el mouse y se hunde al presionar.

@export var escala_hover := Vector2(1.08, 1.08)
@export var escala_presionado := Vector2(0.94, 0.94)
@export var duracion := 0.12
@export var sonido_hover: AudioStream  # opcional
@export var sonido_clic: AudioStream   # opcional

var _tween: Tween
var _audio: AudioStreamPlayer

func _ready():
	_audio = AudioStreamPlayer.new()
	add_child(_audio)
	await get_tree().process_frame
	pivot_offset = size / 2
	resized.connect(func(): pivot_offset = size / 2)
	mouse_entered.connect(func():
		_animar(escala_hover)
		_sonar(sonido_hover))
	mouse_exited.connect(func(): _animar(Vector2.ONE))
	button_down.connect(func():
		_animar(escala_presionado)
		_sonar(sonido_clic))
	button_up.connect(func(): _animar(escala_hover))

func _animar(escala: Vector2):
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "scale", escala, duracion)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _sonar(s: AudioStream):
	if s:
		_audio.stream = s
		_audio.play()
