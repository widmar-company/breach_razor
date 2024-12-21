extends Item
class_name Firearm

@export_enum("Energy", "Physical")
var firearm_type

@export_category("Stats")
#@export_range(0, 100, 1) var value: int
@export var randomize_stats: bool
@export var missile_delay: int
@export var missile_reload: int
@export var missile_spread: float
@export_category("Nodes")
@export var missile: String
@export var modifications: Array

@export var barrel: Node3D

@export
var mesh: MeshInstance3D

var roll

var sel_missile = 0

func _ready() -> void:
	set_multiplayer_authority(multiplayer.get_unique_id())

func fire_missile(): 
	$AudioStreamPlayer3D.play()
	var v = (barrel.global_position - global_position).normalized()
	var s = Vector3(randf_range(-1 * missile_spread, missile_spread), randf_range(-1 * missile_spread, missile_spread), randf_range(-1 * missile_spread, missile_spread))
	#print(s)
	v += s 
	var md = {"p": $barrel.global_position, "v": v, "m": missile}
	Peer.server_recieved_missile.rpc_id(1, md)
	#print(v)
	# This is really nice, yes? I wonder what maddening things we can do with this 
