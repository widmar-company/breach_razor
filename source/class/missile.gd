extends Area3D
class_name Missile

@export_category("Data")
@export var data: Dictionary = {
	"nme": "Default",
	"pos": Vector3(),
	"vec": Vector3(),
	"spd": 0,
	"wgt": 0,
	"dmg": 0,
	"typ": "None",
	"rad": 0,
	"lfe": "0"
}

func _init(m: Dictionary) -> void:
	data = m

# Called when the node enters the scene tree for the first time.
func _ready():
	position = data["pos"]
	
	var c = CollisionObject3D 
	var s = SphereShape3D.new()
	s.radius = data["col"]
	c.shape = s 
	add_child(c)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta: float) -> void:
	pass