class_name Player extends CharacterBody2D

# Константы для скорости и прыжка
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 1000.0
const MAX_JUMPS = 2  # Максимум двойных прыжков

# Переменные для отслеживания состояния прыжков
var jumps_left = MAX_JUMPS
var health = 3
# Функция обновления физики персонажа
func _physics_process(delta: float) -> void:
	# Если персонаж не на полу, применяем гравитацию
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		# Когда персонаж приземляется, восстанавливаем возможность прыжков
		jumps_left = MAX_JUMPS
	
	# Обработка прыжков
	if Input.is_action_just_pressed("ui_accept") and jumps_left > 0:
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1  # Уменьшаем количество прыжков
	
	# Получение направления для движения
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		# Анимация бега (если есть)
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = direction < 0  # Флип персонажа по горизонтали
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		# Анимация ожидания (если есть)
		$AnimatedSprite2D.play("idle")

	# Движение персонажа
	move_and_slide()

	# Проверка для анимации прыжка
	if not is_on_floor():
		$AnimatedSprite2D.play("jump")

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()  # Метод для обработки смерти игрока

func die():
	pass
