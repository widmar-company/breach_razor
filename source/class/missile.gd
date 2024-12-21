extends RigidBody3D
class_name Missile

var type:  String
var vector: Vector3

var lifetimer: Timer

@export var is_dead = false

@export var speed: int
@export var lifetime: int

func _ready() -> void:
	linear_velocity = vector * speed
	lifetimer = Timer.new()
	lifetimer.timeout.connect(_end_lifetime)
	add_child(lifetimer)
	lifetimer.start(lifetime)
	# print(linear_velocity)
func _physics_process(delta: float) -> void:
	if is_dead == true:
		self.queue_free()
		
func _end_lifetime():
	is_dead = true
