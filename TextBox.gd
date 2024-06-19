extends MarginContainer

@onready var label =$MarginContainer/Label
@onready var timer = $Control/LetterDisplayTimer
@onready var audiosource = $Control/AudioStreamPlayer
@onready var pitch = $Control/AudioStreamPlayer.pitch_scale
@onready var buttonparent = $VBoxContainer/HBoxContainer
@onready var choicebuttonscene = preload("res://UI/ChoiceButton.tscn")
@onready var textbox = preload("res://UI/text_box.tscn")
@onready var currentTextbox = $TextBox
@onready var initialsize = size
@export var audioclipsjavs = [] 
@export var audioclipsogro = [] 
@export var audioclipsale = [] 
@export var audioclipsma = [] 

var StopAudioSource= true
const MAX_WIDTH = 256
const MIN_PITCH = 0.2
const MAX_PITCH = 3
var text = ""
var letter_index = 0
var choice_buttons: Array[Button] = []

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2


signal finished_displaying()

func _ready():
	pass


func display_text(text_to_display:String):
	text = text_to_display
	label.text = text_to_display
	await  resized
	custom_minimum_size.x = min(size.x,MAX_WIDTH)
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
	label.text = ""
	_display_letter()
	
func add_choice(choice_text : String):
	var button_obj : ChoiceButton = choicebuttonscene.instantiate()
	button_obj.choice_index = choice_buttons.size()
	button_obj.text = choice_text
	choice_buttons.push_back(button_obj)
	button_obj.choice_selected.connect(on_choice_selected)


func clear_dialogue_box():
	currentTextbox.queue_free()

func on_choice_selected(choice_index:int):
	($EzDialogue as EzDialogue).next(choice_index)


func _display_letter():
	label.text += text[letter_index]
	play_sound_hash(text[letter_index],audioclipsjavs)
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
	match  text[letter_index]:
		"!",".",",","?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)

func play_sound_random(letter , audioclips):
	if audiosource.playing == true && StopAudioSource ==  true:
		audiosource.stop()
	pitch = randf_range(MIN_PITCH,MAX_PITCH)
	var randomIndex = randi_range(0,audioclips.size()-1)
	audiosource.stream = audioclips[randomIndex];
	audiosource.play()

func play_sound_hash(letter: String , audioclips):
	if audiosource.playing == true && StopAudioSource ==  true:
		audiosource.stop()
	pitch = randf_range(MIN_PITCH,MAX_PITCH)
	var hash = letter.sha256_buffer()
	var index = hash[0] % audioclips.size()
	var max_Pitchint : int = MAX_PITCH * 100 
	var min_Pitchint : int = MIN_PITCH * 100
	
	var pitchRange = max_Pitchint - min_Pitchint
	pitch = ((hash[0]%pitchRange) + MIN_PITCH)/100
	audiosource.stream = audioclips[index];
	audiosource.play()


func _on_letter_display_timer_timeout():
	_display_letter()


func _on_ez_dialogue_dialogue_generated(response : DialogueResponse):
	display_text(response.text)
	for choice in response.choices:
		add_choice(choice)


func _on_finished_displaying():
	for choice in choice_buttons:
		buttonparent.add_child(choice)
