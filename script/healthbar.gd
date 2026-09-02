extends TextureProgressBar

@export var max_health: float = 100.0
var health: float

func _ready():
	health = max_health
	max_value = max_health
	value = health

func actualizar_vida(vida_actual: int, vida_maxima: int):
	max_value = vida_maxima
	value = vida_actual
	
func take_damage(damage: float):
	health -= damage
	health = max(health, 0)

	value = health

	print("Daño recibido: ", damage)
	print("Vida restante: ", health)

	if health <= 0:
		die()


func die():
	print("¡Jugador derrotado!")
