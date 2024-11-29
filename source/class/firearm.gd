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
@export var missiles: Array
@export var modifications: Array

@export var barrel: Node3D

@export
var mesh: MeshInstance3D

var sel_missile = 0


func fire_missile():
    print("We are shooting a missile with type")
    var v = (barrel.global_position - global_position).normalized()
    print(v)
    