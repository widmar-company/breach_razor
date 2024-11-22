extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	Peer.bootstrap_done.connect(_set_auth)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_auth(id):
	for n in get_children():
		n.set_multiplayer_authority(id) 
