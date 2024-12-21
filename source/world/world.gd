extends Node3D

var loaded: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect signals from peer to ourselves
	print("Connecting signals.")
	Peer.begin_new_player.connect(_spawn_player)
	Peer.begin_new_world.connect(_new_world)
	Peer.spawn_missile.connect(_spawn_missile)
	# When we are created, we are not loaded yet.
	loaded = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Create a world
func _new_world():
	if Peer.type == Peer.TYPES.SERVER:
		$nav/terrain.generate_terrain()
	if Data.terrain_verts:
		$nav/terrain.apply_terrain(Data.terrain_verts)
	for c in Peer.clients:
		_spawn_player(c)
	
# Spawn a new player
func _spawn_player(id):
	print("Spawning a new player")
	var p = ResourceLoader.load("res://scene/player/player.tscn").instantiate()
	p.name = str(id)
	p.m_id = id
	p.position = Vector3(randi_range(Data.TERRAIN_SIZE/2 - Data.TERRAIN_SIZE/4, Data.TERRAIN_SIZE/2 + Data.TERRAIN_SIZE/4), 10, -randi_range(Data.TERRAIN_SIZE/2 - Data.TERRAIN_SIZE/4, Data.TERRAIN_SIZE/2 + Data.TERRAIN_SIZE/4))
	$player.add_child(p)

# Spawn a new missile
func _spawn_missile(md):
	if Data.missile_collection[md["m"]] != null:
		#print("Success, spawning a missile with the stats:\n", md)
		var n = Data.missile_collection[md["m"]].instantiate()
		n.position = md["p"]
		n.vector = md["v"]
		$missile.add_child(n)
	else: 
		print("We failed to spawn a missile of type [", md["m"], "]. Why?")
