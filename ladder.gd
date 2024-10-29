extends Area2D

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		get_node("/root/Game/Player").on_ladder = true

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		get_node("/root/Game/Player").on_ladder = false
