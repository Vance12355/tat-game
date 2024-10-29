extends StaticBody2D

const disappear_time: float = 1.0  # Время, через которое платформа исчезнет

var timer_started = false  # Проверка, запущен ли таймер
var timer

func _ready():
	# Добавление таймера к платформе
	timer = $Timer
	timer.wait_time = disappear_time
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timeout"))

func _on_body_entered(body):
	if body.name == "Player" and not timer_started:
		timer_started = true
		timer.start()  # Запуск таймера при попадании игрока

func _on_timeout():
	queue_free()
