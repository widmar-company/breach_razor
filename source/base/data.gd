extends Node

var mouse_free: bool = true

# Terrain variables
const TERRAIN_SIZE =  128 #512
var terrain_verts: PackedVector3Array

# Player data
var player_data: Dictionary

# Missile Collection 
var missile_collection = {
	"m_bullet": ResourceLoader.load("res://scene/missile/m_bullet.tscn")
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
