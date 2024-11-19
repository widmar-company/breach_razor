extends Node3D

var loaded: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect everything
	
	# When we are created, we are not loaded yet.
	loaded = false
	create_world()
	if Data.terrain_verts:
		$terrain.apply_terrain(Data.terrain_verts)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Create a world
func create_world():
	if Peer.type == Peer.TYPES.SERVER:
		$terrain.generate_terrain()
# Spawn a new player
func _spawn_player():
	
# Recieve a world
func recieve_world():
	pass
