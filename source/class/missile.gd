extends Area3D
class_name Missile

@export_category("Stats")
@export_enum("Physical", "Fire", "Poison", "Electric") var damage_type
@export var damage: int
@export var speed: int

@export
var collider: CollisionShape3D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
