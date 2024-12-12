extends CharacterBody2D

# Константы
const PATROL_SPEED = 20
const DAMAGE = 1
const GRAVITY = 500  # сила гравитации
const MAX_FALL_SPEED = 200  # максимальная скорость падения

# Параметры патрулирования
var player_detected = false
var vertical_velocity = 0

# Ссылка на игрока, raycasts и анимированный спрайт
@onready var player = get_node("/root/Game/Player")
@onready var edge_check = $EdgeRayCast
@onready var edge_check2 = $EdgeRayCast2
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	# Начальная анимация для патрулирования
	animated_sprite.play("slither")

func _physics_process(delta):
	if not player_detected:
		if animated_sprite.animation == "charge" and animated_sprite.frame == 3:
			player.respawn()
			animated_sprite.speed_scale == 1
			animated_sprite.play("slither")
		if velocity.is_zero_approx():
			velocity.x = PATROL_SPEED
		velocity.y += GRAVITY * delta
		if not edge_check2.is_colliding():
			velocity.x = PATROL_SPEED
		elif not edge_check.is_colliding():
			velocity.x = -PATROL_SPEED
		if is_on_wall():
			velocity.x = -velocity.x
		
		move_and_slide()
		if velocity.x > 0.0:
			$AnimatedSprite2D.flip_h = false
			$Area2D/CollisionShape2D.position.x = 50
		elif velocity.x < 0.0:
			$Area2D/CollisionShape2D.position.x = -50
			$AnimatedSprite2D.flip_h = true

func bite_player():
	# Змея переключается на анимацию атаки и наносит урон
	animated_sprite.play("charge")
	player.take_damage(DAMAGE)
	animated_sprite.speed_scale == 0.2
	player_detected = false  # После атаки возвращается к патрулированию

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_detected = true
		bite_player()
