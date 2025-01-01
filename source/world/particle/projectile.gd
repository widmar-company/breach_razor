extends RigidBody3D

# Stats
@export
var proj_stats: Dictionary

# Active Variables

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = proj_stats["position"]
	linear_velocity = proj_stats["speed"] * proj_stats["vector"]
	scale = Vector3(proj_stats["scale"], proj_stats["scale"], proj_stats["scale"])
	$Mesh.scale = Vector3(proj_stats["scale"], proj_stats["scale"], proj_stats["scale"])
	$Lifetimer.wait_time = proj_stats["time"]
	$Lifetimer.start()

func _on_lifetimer_timeout() -> void:
	self.queue_free()
