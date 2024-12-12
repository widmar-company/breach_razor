extends RigidBody3D
class_name Missile

var type:  String
var vector: Vector3

@export var speed: int

func _ready() -> void:
    linear_velocity = vector * speed
    print(linear_velocity)