extends Area2D

@export var next_scene_path: String = "res://level_1_2.tscn"  # Сцена пещеры
@onready var player = get_node("/root/Game/Player")

func _ready() -> void:
	# Убедимся, что игрок есть в дереве
	player = get_tree().get_current_scene().get_node("Player")

# Обработка входа игрока в зону триггера
func _on_EntranceArea_body_entered(body: Node2D) -> void:
	if body == player:  # Проверяем, что это игрок
		player.enter_cave(next_scene_path)
