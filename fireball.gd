extends Area2D

@export var speed: float = 200.0  # Скорость полета
@export var life_time: float = 3.0  # Время жизни
var direction = Vector2.ZERO  # Направление движения

func _ready() -> void:
	$Timer.start(life_time)
	$Timer.connect("timeout", Callable(self, "_on_timeout"))
	$AnimatedSprite2D.play("fireball")

func _process(delta: float) -> void:
	position += - direction * speed * delta

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()

func _on_timeout() -> void:
	queue_free()  # Удаляем огненный шар по истечении времени
