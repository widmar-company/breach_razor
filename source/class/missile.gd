extends RigidBody3D
class_name Missile

var type:  String
var vector: Vector3
var data: Dictionary
  
var lifetimer: Timer

@export var is_dead = false
# Or do I want to use this keyboard and monitor instead? 
# I do not know right now. Perhaps at another time, I will do so. 
@export var speed: int
@export var lifetime: int
@export var damage: int

func _ready() -> void:
	#set_multiplayer_authority(1)
	#continuous_cd = true
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
