extends Node

var mouse_free: bool = true

# Terrain variables
const TERRAIN_SIZE =  128 #512
var terrain_verts: PackedVector3Array

# Player data
var player_data: Dictionary

var base_player_data = {
	"name": "empty",
	"health": 100,
	"armour": 0,
	"energy": 100,
	"agility": 10,
	"strength": 10,
	"dexterity": 10,
	"wisdom": 10,
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func toggle_mouse_capture() -> void: 
	if mouse_free:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	mouse_free = !mouse_free
