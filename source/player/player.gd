extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 4.5

var m_id

func _ready() -> void:
	set_multiplayer_authority(m_id)

func _process(delta):
	Data.player_data["position"] = position
	#$interface/debug/pos.text = String(str(position.x) + " " + str(position.y) + " " + str(position.z))


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and !Data.mouse_free:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	#move_and_collide(velocity)
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouse and not Data.mouse_free: 
		self.rotate_y(deg_to_rad(event.relative.x * 0.1 * -1))
		$Camera3D.rotate_x(deg_to_rad(event.relative.y * 0.1 * -1))
