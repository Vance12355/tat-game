class_name Sage extends Area2D

# Переменная для отслеживания, находится ли игрок рядом
var player_in_range = false
var dialogue_open = false

# Ссылка на диалоговое окно
@onready var dialogue_panel = get_node("/root/Control/DialogPanel")  # Укажи путь к диалоговому окну

# Сообщения, которые мудрец будет говорить
var dialogues = [
	"Приветствую, путник!",
	"Эти земли полны тайн и опасностей.",
	"Следуй своему сердцу и не бойся неизвестного."
]
var current_dialogue = 0

func _ready() -> void:
	pass

func _process(delta):
	# Открываем диалог при нажатии на E, если игрок рядом
	if player_in_range and Input.is_action_just_pressed("ui_accept") and not dialogue_open:
		open_dialogue()

	# Закрываем диалог при нажатии на E, если он открыт
	elif dialogue_open and Input.is_action_just_pressed("ui_accept"):
		next_dialogue()

# Обработка входа игрока в зону взаимодействия
func _on_player_enter(body):
	if body.name == "Player":  # Проверка, что это именно игрок
		player_in_range = true

# Обработка выхода игрока из зоны взаимодействия
func _on_player_exit(body):
	if body.name == "Player":
		player_in_range = false
		close_dialogue()  # Закрыть диалог, если игрок уходит

# Функция открытия диалога
func open_dialogue():
	dialogue_open = true
	dialogue_panel.visible = true
	dialogue_panel.get_node("Label").text = dialogues[current_dialogue]

# Переход к следующему диалогу
func next_dialogue():
	current_dialogue += 1
	if current_dialogue < dialogues.size():
		dialogue_panel.get_node("Label").text = dialogues[current_dialogue]
	else:
		close_dialogue()  # Закрыть диалог, если все сообщения показаны

# Функция закрытия диалога
func close_dialogue():
	dialogue_open = false
	dialogue_panel.visible = false
	current_dialogue = 0
