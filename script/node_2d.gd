extends Node2D

@onready var player_1 = $player_1
@onready var healthbar_1 = $Uix/healthbar_1


func _ready():
	player_1.health_bar = healthbar_1
