extends Node

var mouse_free: bool = true
const TERRAIN_SIZE = 75

# Handle game states
var state_changed: bool 
var state
enum STATES {TITLE, LOBBY, WORLD}

# Change the game state so the main can handle the rest.
# This doesn't check the state, so unassigned states are entirely possible but unusable. 
func change_state(s) -> void:
	state_changed = true
	state = s
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func toggle_mouse_capture() -> void: 
	if mouse_free:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	mouse_free = !mouse_free
