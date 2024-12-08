extends CanvasLayer
signal fade_completed

func fade_out() -> void:
	$AnimationPlayer.play("fade_out")
func fade_in() -> void:
	$AnimationPlayer.play("fade_in")
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_out":
		emit_signal("fade_completed")
		
