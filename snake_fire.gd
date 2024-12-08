extends CharacterBody2D

# Настройки
@export var attack_interval: float = 5.0  # Интервал между атаками
@export var fireball_scene : PackedScene  # Префаб огненного шара
@export var fall_speed: float = 400.0  # Скорость падения

# Состояния
var is_falling = false

@onready var attack_timer = $Timer
@onready var fireball_spawner = $FireballSpawner

func _ready() -> void:
	# Запускаем таймер для атак
	attack_timer.start(attack_interval)
	attack_timer.connect("timeout", Callable(self, "_attack"))

func _physics_process(delta: float) -> void:
	# Проверка состояния падения
	if is_falling:
		velocity.y += fall_speed * delta
		move_and_slide()
		if is_on_floor():
			is_falling = false
			$AnimatedSprite2D.play("slither")

func _attack() -> void:
	# Проигрываем анимацию атаки
	$AnimatedSprite2D.play("attack")
	await $AnimatedSprite2D.animation_finished  # Ждем окончания анимации

	# Создаем огненный шар
	var fireball = fireball_scene.instantiate()
	get_parent().add_child(fireball)  # Добавляем огненный шар в сцену
	fireball.global_position = fireball_spawner.global_position

	# Направление движения огненного шара
	fireball.set_direction(Vector2(-1, 0) if $AnimatedSprite2D.flip_h else Vector2(1, 0))

	$AnimatedSprite2D.play("slither")  # Возвращаемся к ожиданию

func start_falling() -> void:
	if not is_falling:
		is_falling = true
		$AnimatedSprite2D.play("slither")

func _on_Area2D_area_exited(area: Area2D) -> void:
	if area.name == "Trapdoor":  # Убедимся, что это люк
		start_falling()
