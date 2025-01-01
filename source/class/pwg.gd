extends Holdable
class_name PulseWaveGenerator

@export_category("stats")

@export
var pwg_stats = {
	"slots": 0,
	"energy": 0,
	"weight": 0,
	"heat": 0,
	"spread": 0.1,
	"delay": 10,
	"amount": 0,
	"time": 0.5,
	"speed": 250,
	"damage": 0,
	"scale": 0,
	"special": ["null"] 
}
@export_category("Externals")

@export
var barrel: Node3D

# Active Stats
var act_ready = false # Ready to Fire
var act_rwait = 0 # Ready to fire wait timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize_stats()
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	# Reduce the wait timer if ready is false.
	if act_ready == false:
		act_rwait -= 1
	if act_rwait < 0:
		act_ready = true
		
# Fire the PWG
func primary_action():
	if act_ready == true:
		# Play a noise here
		
		# Create the projectile dictionary that we will send
		var proj = generate_projectile()

		# Give the server the projectile we created the number of times in amount.
		Peer.server_recieved_projectile.rpc_id(1, proj)

		# Reset the wait timer
		act_rwait = pwg_stats["delay"]
		
		# Reset the ready state
		act_ready = false
func secondary_action():
	randomize_stats()
	
# Create a projectile based off our stats
func generate_projectile():
	# Create the projectile dictionary
	var p = {}

	# Go through the list of segments here and apply the stats
	#
	# TODO: ADD SEGMENTS AND MAKE THIS DO THINGS
	#

	# Create the vector
	var v = (barrel.global_position - global_position).normalized()
	# Add spread
	var s = Vector3(randf_range(-1 * pwg_stats["spread"], pwg_stats["spread"]), randf_range(-1 * pwg_stats["spread"], pwg_stats["spread"]), randf_range(-1 * pwg_stats["spread"], pwg_stats["spread"]))
	# Combine the spread and the original vector
	v += s
	p["vector"] = v
	p["position"] = barrel.global_position

	# DEBUG 
	p["damage"] = pwg_stats["damage"]
	p["speed"] = pwg_stats["speed"]
	p["time"] = pwg_stats["time"]
	p["scale"] = pwg_stats["scale"]
	# END DEBUG

	return p
func randomize_stats():
	pwg_stats = {
	"slots": randi_range(0,100),
	"energy": randi_range(0,100),
	"weight": randf_range(0.01,2.0),
	"heat": randi_range(0,100),
	"spread": randf_range(0.0, 0.1),
	"delay": randi_range(0,100),
	"amount": randi_range(0,100),
	"time": 0.5,
	"speed": randi_range(50,500),
	"damage": randi_range(0,100),
	"scale": randf_range(0.1,10),
	"special": ["null"] 
}
	
func update():
	pass
