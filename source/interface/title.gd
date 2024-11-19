extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_join_pressed() -> void:
	Peer.start_multiplayer(Peer.TYPES.CLIENT)


func _on_host_pressed() -> void:
	Peer.start_multiplayer(Peer.TYPES.SERVER)
