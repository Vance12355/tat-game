class_name Player extends CharacterBody2D

# Константы для скорости и прыжка
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 1000.0
const MAX_JUMPS = 1  # Максимум двойных прыжков

# Внутри скрипта игрока
var on_water = false
const WATER_JUMP_VELOCITY = -300.0  # Сниженная высота прыжка в воде
const WATER_SPEED = 50.0  # Сниженная скорость в воде

# Переменные для отслеживания состояния прыжков
var jumps_left = MAX_JUMPS
var health = 3

var UI

var get_food = false

# Функция обновления физики персонажа
func _physics_process(delta: float) -> void:
	if get_food:
		get_food = false
		health += 1
		update_health_display()
	
	if on_ladder:
		#GRAVITY = 0
		if Input.is_action_pressed("ui_up"):
			velocity.y = -SPEED
		elif on_ladder and Input.is_action_pressed("ui_down"):
			velocity.y = SPEED  # Движение вниз по лестнице
		else:
			velocity.y = 0
	# Если персонаж не на полу, применяем гравитацию
	elif not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		# Когда персонаж приземляется, восстанавливаем возможность прыжков
		jumps_left = MAX_JUMPS
	
	# Обработка прыжков
	if Input.is_action_just_pressed("ui_accept") and jumps_left > 0:
		if on_water:
			velocity.y = WATER_JUMP_VELOCITY
		else:
			velocity.y = JUMP_VELOCITY
		jumps_left -= 1  # Уменьшаем количество прыжков
	
	# Получение направления для движения
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		if on_water:
			velocity.x = direction * WATER_SPEED
		else:
			velocity.x = direction * SPEED
		# Анимация бега (если есть)
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = direction < 0  # Флип персонажа по горизонтали
	else:
		if on_water:
			velocity.x = move_toward(velocity.x, 0, WATER_SPEED)
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
		die()
	update_health_display()

func die():
	# Логика для обработки смерти игрока
	print("Игрок мертв")
	$"../UI/GameOver".visible = true
	get_tree().paused = true

# В скрипте игрока
var checkpoint_position: Vector2

func _ready():
	# Задаем начальный чекпоинт как позицию Checkpoint
	checkpoint_position = $"../SpawnPoint".global_position
	global_position = checkpoint_position
	var UI = $"../UI"
	update_health_display()
	
	
	#$"../LadderArea".connect("player_entered", Callable(self, "_on_ladder_entered"))
	#$"../LadderArea".connect("player_exited", Callable(self, "_on_ladder_exited"))


func _on_ladder_entered(player):
	on_ladder = true

func _on_ladder_exited(player):
	on_ladder = false



var heart_texture: Texture = preload("res://assets/Assets/heart_60px.png")
# Функция для обновления отображения жизней
func update_health_display() -> void:
	#UI.get_node('HeartsCont').queue_free()
	var HeartsCont = $"../UI/HeartsCont".get_children()
	for Hearts in HeartsCont:
		Hearts.queue_free()
	for i in range(health):
		var heart = TextureRect.new()
		heart.texture = heart_texture
		#heart.rect_size = Vector2(32, 32)  # Размер сердечка
		$"../UI/HeartsCont".add_child(heart)

func respawn():
	# Возвращаем игрока к последнему чекпоинту
	velocity.y = 0
	global_position = checkpoint_position

func set_checkpoint(new_position: Vector2):
	checkpoint_position = new_position

func abyss_die():
	take_damage(1)
	respawn()

func _on_abyss_body_entered(body: Node2D, marker: NodePath) -> void:
	checkpoint_position = get_node(marker).global_position
	take_damage(1)
	respawn()
	print(health)

# Переменные для состояния лестницы
var on_ladder = false
