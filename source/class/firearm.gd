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

@export var forward: RayCast3D

@export
var mesh: MeshInstance3D

# Please dear god help me 
@export_category("Pain")
var something: int
