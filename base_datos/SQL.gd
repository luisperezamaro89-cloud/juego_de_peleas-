extends Control
var baseDatos : SQLite

# Called when the node enters the scene tree for the first time.
func _ready() :
	baseDatos = SQLite.new()
	baseDatos.path="res//data.db"
	baseDatos.open_db()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_crear_tabla_button_down():
	var table ={
		"id" :{"data_type":"int","primary_key": true ,"not_null" :true ,"avo_increment": true },
		"nombre":{"data_type" : "text"},
		"scores": {"data_type" : "int"},
		}
	baseDatos.create_table("players",table)
	
	pass # Replace with function body.


func _on_insertar_jugador_button_down() -> void:
	pass # Replace with function body.


func _on_ver_jugadores_button_down() -> void:
	pass # Replace with function body.


func _on_actualizar_jugador_button_down() -> void:
	pass # Replace with function body.


func _on_borrar_jugador_button_down() -> void:
	pass # Replace with function body.


func _on_consulta_personalizada_button_down() -> void:
	pass # Replace with function body.
