extends CharacterBody2D

# Константы для движения и обнаружения
const PATROL_SPEED = 100.0
const ATTACK_SPEED = 200.0
const DAMAGE = 1
const DETECTION_DISTANCE = 150.0  # Радиус обнаружения игрока перед змеей

# Переменные состояния
var direction = 1  # 1 = вправо, -1 = влево
var is_chasing = false  # Змея преследует игрока?

# Ссылка на игрока
var player: Node2D

func _ready() -> void:
	player = get_parent().get_node("Player")  # Найти игрока
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if is_player_ahead():
		# Если игрок перед змеей, переключаемся на преследование
		is_chasing = true
		chase_player(delta)
	else:
		# Иначе патрулируем
		is_chasing = false
		patrol(delta)

	# Обновляем сторону, в которую смотрит змея
	update_sprite_flip()

	move_and_slide()

# Логика патрулирования змеи
func patrol(delta: float) -> void:
	velocity.x = direction * PATROL_SPEED
	if is_at_edge():
		direction *= -1  # Меняем направление, если достигли края платформы
		$RayCast2D_Downward
	$AnimatedSprite2D.play("slither")  # Анимация патрулирования

# Преследование игрока
func chase_player(delta: float) -> void:
	direction = sign(player.global_position.x - global_position.x)  # Определяем направление к игроку
	velocity.x = direction * ATTACK_SPEED
	$AnimatedSprite2D.play("charge")  # Анимация атаки

	# Проверка на столкновение с игроком
	if global_position.distance_to(player.global_position) < 10.0:
		player.take_damage(DAMAGE)  # Наносим урон игроку

# Проверка, находится ли игрок перед змеей
func is_player_ahead() -> bool:
	return $RayCast2D_Forward.is_colliding() and $RayCast2D_Forward.get_collider() == player and player.global_position.distance_to(global_position) < DETECTION_DISTANCE

# Проверка, достигла ли змея края платформы
func is_at_edge() -> bool:
	return not $RayCast2D_Downward.is_colliding()

# Поворот змеи в сторону движения
func update_sprite_flip() -> void:
	$AnimatedSprite2D.flip_h = direction < 0
