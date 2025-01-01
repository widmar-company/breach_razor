extends Node 

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Breach razor is now loading...")
	preloader()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Data.toggle_mouse_capture()
		$interface/Menu.visible = !$interface/Menu.visible
		#$Title.visible = !$Title.visible
	if Input.is_action_just_pressed("razor_inventory"):
		Data.toggle_mouse_capture()
		$interface/Inventory.update()
		$interface/Inventory.visible = !$interface/Inventory.visible

func preloader():
	print("Loaded everything.")
