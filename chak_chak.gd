extends Area2D

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		get_node("/root/Game/Player").get_food = true
		queue_free()
