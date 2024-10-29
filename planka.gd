extends StaticBody2D

# Флаг для отслеживания состояния коллизии
var is_collision_enabled = true

func _process(delta):
	# Проверка нажатия кнопки вниз
	if Input.is_action_pressed("ui_down") and is_collision_enabled:
		disable_collision()
	elif not Input.is_action_pressed("ui_down") and not is_collision_enabled:
		enable_collision()

func disable_collision():
	$CollisionShape2D.disabled = true
	is_collision_enabled = false

func enable_collision():
	$CollisionShape2D.disabled = false
	is_collision_enabled = true
