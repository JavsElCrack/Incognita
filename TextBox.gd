class_name Textbox extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $Control/LetterDisplayTimer
@onready var audiosource = $Control/AudioStreamPlayer
@onready var pitch = $Control/AudioStreamPlayer.pitch_scale
@onready var buttonparent = $VBoxContainer/HBoxContainer
@onready var choicebuttonscene = preload("res://UI/ChoiceButton.tscn")
@onready var initialsize = size

@export var audioclipsjavs : Array[AudioStreamWAV]
@export var audioclipsogro : Array[AudioStreamWAV]
@export var audioclipsma : Array[AudioStreamWAV]
@export var audioclipsaletonota : Array[AudioStreamWAV]
@export var audioclipspa : Array[AudioStreamWAV]

var StopAudioSource = true
const MAX_WIDTH = 256
const MIN_PITCH = 0.2
const MAX_PITCH = 3
var text = ""
var voiceid = 0
var islastdialogue = false
var letter_index = 0
var choice_buttons: Array[Button] = []

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2
var count = 0
var initialsizetext = Vector2(0,0)
signal finished_displaying()
signal dialogue_started()
signal dialogue_ended()

func _ready():
	pass

func display_text(text_to_display: String):
	count += 1
	letter_index = 0
	text = text_to_display
	label.text = ""
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		custom_minimum_size.y = size.y
	_display_letter()

func add_choice(choice_text: String):
	var button_obj: ChoiceButton = choicebuttonscene.instantiate()
	button_obj.choice_index = choice_buttons.size()
	button_obj.text = choice_text
	choice_buttons.push_back(button_obj)
	button_obj.choice_selected.connect(on_choice_selected)
	return button_obj

func clear_dialogue_box():
	for choice in choice_buttons:
		choice.queue_free()
	choice_buttons = []
	label.text = ""

func on_choice_selected(choice_index: int):
	($EzDialogue as EzDialogue).next(choice_index)

func _display_letter():
	if letter_index < text.length():
		label.text += text[letter_index]
		match voiceid:
			0:
				play_sound_hash(text[letter_index], audioclipsjavs)
			1:
				play_sound_hash(text[letter_index], audioclipsaletonota)
			2:
				play_sound_hash(text[letter_index], audioclipsogro)
			3:
				play_sound_hash(text[letter_index], audioclipsma)
			4:
				play_sound_hash(text[letter_index], audioclipspa)

		
		letter_index += 1
		if letter_index >= text.length():
			finished_displaying.emit()
			if islastdialogue == true:
				finish_dialogue()
			return
		match text[letter_index]:
			"!", ".", ",", "?":
				timer.start(punctuation_time)
			" ":
				timer.start(space_time)
			_:
				timer.start(letter_time)
	else:
		finished_displaying.emit()

func play_sound_random(letter, audioclips):
	if audiosource.playing == true and StopAudioSource == true:
		audiosource.stop()
	pitch = randf_range(MIN_PITCH, MAX_PITCH)
	var randomIndex = randi_range(0, audioclips.size() - 1)
	audiosource.stream = audioclips[randomIndex]
	audiosource.play()

func play_sound_hash(letter: String, audioclips):
	if audiosource.playing == true and StopAudioSource == true:
		audiosource.stop()
	pitch = randf_range(MIN_PITCH, MAX_PITCH)
	var hashs = letter.sha256_buffer()
	var index = hashs[0] % audioclips.size()
	var max_Pitchint: int = MAX_PITCH * 100
	var min_Pitchint: int = MIN_PITCH * 100

	var pitchRange = max_Pitchint - min_Pitchint
	pitch = ((hashs[0] % pitchRange) + MIN_PITCH) / 100
	audiosource.stream = audioclips[index]
	audiosource.play()

func _on_letter_display_timer_timeout():
	_display_letter()

func _on_ez_dialogue_dialogue_generated(response: DialogueResponse):
	dialogue_started.emit()
	clear_dialogue_box()
	$"VBoxContainer/HBoxContainer/Finish Button".visible = false
	display_text(response.text)
	for choice in response.choices:
		add_choice(choice)

func _on_finished_displaying():
	timer.stop()  # Ensure the timer is stopped
	for choice in choice_buttons:
		buttonparent.add_child(choice)

func _on_ez_dialogue_end_of_dialogue_reached():
	islastdialogue = true

func finish_dialogue():
	$"VBoxContainer/HBoxContainer/Finish Button".visible = true

func _on_finish_button_pressed():
	visible = false
	islastdialogue = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	clear_dialogue_box()
	dialogue_ended.emit()
