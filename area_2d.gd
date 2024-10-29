extends Area2D

var checkpoint: Vector2

func _ready() -> void:
	checkpoint = $Marker2D.global_position

func _on_body_entered(body):
	if body.name == "Player":
		var player = get_node("/root/Game/Player")  # Замените путь на актуальный путь к игроку
		player.set_checkpoint(checkpoint)
		player.abyss_die()
	#print(checkpoint)
