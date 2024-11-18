extends Node 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Data.change_state(Data.STATES.TITLE)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Change our game state per whatever we want on the frame after it was changed.
	# This is a terrible way of handling the almighty game state, but it's a solution.
	if Data.state_changed == true: 
		for n in $game.get_children():
			n.remove_child(n)
			n.queue_free()
			
		if Data.state == Data.STATES.TITLE:
			var s = ResourceLoader.load("res://scene/interface/title.tscn").instantiate()
			$game.add_child(s)
		Data.state_changed = false
			

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Data.toggle_mouse_capture()
		#$Title.visible = !$Title.visible
