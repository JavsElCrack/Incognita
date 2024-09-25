extends SubViewport

@export var password: String = "password"
@export var is_typing: bool = false
@export var audioclips: Array[AudioStreamWAV]
@onready var audiosource = $AudioStreamPlayer
@onready var progress_bar = $CanvasLayer/ProgressBar
var typed_text: String = ""
const MIN_PITCH = 0.2
const MAX_PITCH = 3
signal correctpass

# Store the state of keys that are currently pressed
var keys_pressed: Dictionary = {}

func _ready():
	set_process_input(true)

func _physics_process(delta):
	progress_bar.value = GameState.state["MinigameProgress"]

	# Update the password label
	$CanvasLayer/PasswordLabel.text = "Password: " + typed_text
	
	# Check if password matches
	if typed_text == password:
		emit_signal("correctpass")

	# Handle typing input while `is_typing` is true
	if is_typing:
		handle_typing()

func handle_typing():
	# Backspace (custom action can be mapped in project settings)
	if Input.is_action_just_released("ui_text_backspace"):
		if typed_text.length() > 0:
			typed_text = typed_text.left(typed_text.length() - 1)

	# Enter (stop typing, mapped to ui_accept)
	elif Input.is_action_just_released("ui_accept"):
		is_typing = false

	# Add characters (handle printable character input)
	for i in range(Key.KEY_A, Key.KEY_Z + 1):  # Only letters for simplicity
		# Check if the key is pressed and not already added to typed_text
		if Input.is_key_pressed(i) and not keys_pressed.has(i):
			keys_pressed[i] = true  # Mark the key as pressed
			var char = OS.get_keycode_string(i).to_lower()  # Get key as a string
			typed_text += char
			play_keyboard()

	# Remove keys from the pressed state once they are released
	for i in range(Key.KEY_A, Key.KEY_Z + 1):
		if not Input.is_key_pressed(i):
			keys_pressed.erase(i)

	# Handle toggle typing (for example, by pressing the "T" key)
	if Input.is_action_just_released("ui_accept"):  # Using ui_accept here to toggle typing
		is_typing = !is_typing

func play_keyboard():
	if audiosource.playing:
		audiosource.stop()
	audiosource.pitch_scale = randf_range(MIN_PITCH, MAX_PITCH)
	var randomIndex = randi_range(0, audioclips.size() - 1)
	audiosource.stream = audioclips[randomIndex]
	audiosource.play()

func clear_text():
	typed_text = ""
