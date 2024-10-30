extends Area2D

# Переменные для состояния взаимодействия
var player_in_range = false
var hatch_open = false

func _ready() -> void:
	$hatch_close.visible = true
	$hatch_open.visible = false
	$Key_animation.play("default")

func _process(delta):
	# Начало диалога при нажатии E, если игрок рядом и диалог не открыт
	if player_in_range and Input.is_action_just_pressed("accept_action") and not hatch_open:
		open_hatch()

# Обработка входа игрока в зону взаимодействия
func _on_player_enter(body):
	if body.name == "Player":
		player_in_range = true

# Обработка выхода игрока из зоны взаимодействия
func _on_player_exit(body):
	if body.name == "Player":
		player_in_range = false

func open_hatch():
	$Key_animation.visible = false
	get_node("/root/Game/Hatch").queue_free()
	hatch_open = true
	$hatch_close.visible = false
	$hatch_open.visible = true
	pass
