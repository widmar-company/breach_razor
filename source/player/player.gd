extends CharacterBody3D

# Our own player data that we save
var player_data: Dictionary

var SPEED = 8.0
var MAX_SPEED = 50.0
const JUMP_VELOCITY = 12.0
var drag: float = 0.1

var m_id

func _ready() -> void:
	set_multiplayer_authority(m_id)

func _process(delta):
	player_data["position"] = position

func _physics_process(delta: float) -> void:
	var friction = 0.25


	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("razor_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY + (abs(velocity.x) + abs(velocity.z) * 0.005)
		velocity.x = velocity.x * 1.50
		velocity.z = velocity.z * 1.50

	var magnitude = SPEED

	# Handle specials
	if Input.is_action_pressed("razor_sprint"):
		magnitude = SPEED * 1.5
	if Input.is_action_pressed("razor_crouch"):
		if is_on_floor():
			friction = drag + 0.05
			magnitude = (SPEED / 4)
			if abs(velocity.x) + abs(velocity.z) > 10 and is_on_floor():
				magnitude = SPEED * 4

	if abs(velocity.x) > 5 or abs(velocity.z):
		drag = clampf(drag - (abs(velocity.x + velocity.z) / 10000), 0.01, 1)
		friction = friction / 4

	else:
		drag = lerpf(drag, 0.1, 0.01)

	print(drag, " ", friction)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("razor_strafe_left", "razor_strafe_right", "razor_forward", "razor_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction and !Data.mouse_free:
		if is_on_floor():
			velocity.x = lerpf(velocity.x, direction.x * magnitude, friction)
			velocity.z = lerpf(velocity.z, direction.z * magnitude, friction)
		else:
			velocity.x = lerpf(velocity.x, direction.x * magnitude, drag)
			velocity.z = lerpf(velocity.z, direction.z * magnitude, drag)
	else:
		if is_on_floor():
			velocity.x = lerpf(velocity.x, 0.0, friction)
			velocity.z = lerpf(velocity.z, 0.0, friction)
		else:
			velocity.x = lerpf(velocity.x, 0.0, drag)
			velocity.z = lerpf(velocity.z, 0.0, drag)
	
	#move_and_collide(velocity)
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouse and not Data.mouse_free: 
		self.rotate_y(deg_to_rad(event.relative.x * 0.1 * -1))
		$Camera3D.rotate_x(deg_to_rad(event.relative.y * 0.1 * -1))
