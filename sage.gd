class_name Sage extends Area2D

# Переменные для состояния взаимодействия
var player_in_range = false
var dialogue_open = false
var current_dialogue = 0

# Путь к JSON-файлу с диалогами
var dialogue_file = "res://dialogues.json"
# Название диалога для каждого мудреца (уникальный ключ в JSON-файле)
@export var dialogue_name: String
# Текущий язык (по умолчанию русский)
var current_language = "tt"
# Диалоги из JSON
var dialogues = []
# Ссылка на диалоговое окно
@onready var dialogue_panel = $"../DialogUI"
@onready var dialogue_label = $"../DialogUI/DialogPanel/DialogLabel"
@onready var next_button = $"../DialogUI/DialogPanel/NextButton"
@onready var tt_button = $"../DialogUI/DialogPanel/Language_tt"
@onready var ru_button = $"../DialogUI/DialogPanel/Language_ru"
@onready var en_button = $"../DialogUI/DialogPanel/Language_en"

func _ready() -> void:
	dialogue_panel.visible = false
	$Key_animation.play("default")
	load_dialogues()

func load_dialogues():
	# Загружаем JSON с диалогами
	var file = FileAccess.open(dialogue_file, FileAccess.READ)
	if file:
		var data = file.get_as_text()
		data = JSON.parse_string(data)
		if dialogue_name in data:
			dialogues = data[dialogue_name].get(current_language, [])
		file.close()
	else:
		push_error("Failed to load dialogues from JSON.")


func _process(delta):
	# Начало диалога при нажатии E, если игрок рядом и диалог не открыт
	if player_in_range and Input.is_action_just_pressed("accept_action") and not dialogue_open:
		start_dialogue()

# Обработка входа игрока в зону взаимодействия
func _on_player_enter(body):
	if body.name == "Player":
		player_in_range = true

# Обработка выхода игрока из зоны взаимодействия
func _on_player_exit(body):
	if body.name == "Player":
		player_in_range = false
		if dialogue_open:
			close_dialogue()

func close_dialogue():
	dialogue_open = false
	dialogue_panel.visible = false
	get_tree().paused = false  # Снимаем игру с паузы
	current_dialogue = 0
	next_button.disconnect("pressed", Callable(self, "_on_next_button_pressed"))

var text_speed = 0.03  # Скорость показа текста
var full_text = ""     # Полный текст текущей фразы
var current_text = ""  # Текущий текст, который будет отображаться
var text_visible = false
var is_animating_text = false

func start_dialogue():
	$Key_animation.visible = false
	next_button.connect("pressed", Callable(self, "_on_next_button_pressed"))
	tt_button.pressed.connect(_change_language_tt)
	tt_button.connect("pressed", Callable(self, "_change_language_tt"))
	ru_button.connect("pressed", Callable(self, "_change_language_ru"))
	en_button.connect("pressed", Callable(self, "_change_language_en"))
	dialogue_open = true
	dialogue_panel.visible = true
	current_dialogue = 0
	start_text_animation(dialogues[current_dialogue])
	get_tree().paused = true

func start_text_animation(text: String) -> void:
	full_text = text
	current_text = ""
	text_visible = true
	is_animating_text = true
	dialogue_label.text = ""
	animate_text()

func animate_text() -> void:
	is_animating_text = true
	for i in full_text.length():
		# Прекращаем анимацию, если пользователь нажал кнопку
		if not is_animating_text:
			dialogue_label.text = full_text
			break
		await get_tree().create_timer(text_speed).timeout
		current_text += full_text[i]
		dialogue_label.text = current_text
	is_animating_text = false  # Текст полностью виден

func _on_next_button_pressed():
	if is_animating_text:
		# Останавливаем анимацию и показываем весь текст
		is_animating_text = false
		dialogue_label.text = full_text
	elif current_dialogue < dialogues.size() - 1:
		current_dialogue += 1
		start_text_animation(dialogues[current_dialogue])
	else:
		close_dialogue()


# Функция для смены языка
func _change_language_tt():
	current_language = "tt"
	print("lksuhgoisbjgn")
	load_dialogues()
	print(dialogues)
	if dialogue_open:
		start_text_animation(dialogues[current_dialogue])  # Перезапуск диалога на новом языке

# Функция для смены языка
func _change_language_ru():
	current_language = "ru"
	load_dialogues()
	if dialogue_open:
		start_text_animation(dialogues[current_dialogue])  # Перезапуск диалога на новом языке

# Функция для смены языка
func _change_language_en():
	current_language = "en"
	load_dialogues()
	if dialogue_open:
		start_text_animation(dialogues[current_dialogue])  # Перезапуск диалога на новом языке
