extends Item
class_name Firearm

@export_enum("Energy", "Physical")
var firearm_type

@export_category("Stats")
#@export_range(0, 100, 1) var value: int
@export var randomize_stats: bool
@export var missile_delay: int
@export var missile_reload: int
@export var missile_spread: int
@export_category("Nodes")
@export var missile: String
@export var modifications: Array

@export var barrel: Node3D

@export
var mesh: MeshInstance3D

var sel_missile = 0

func _ready() -> void:
	set_multiplayer_authority(multiplayer.get_unique_id())

func fire_missile():
	var v = (barrel.global_position - global_position).normalized()
	var md = {"p": $barrel.global_position, "v": v, "m": missile}
	Peer.server_recieved_missile.rpc_id(1, md)
	print(v)
	
