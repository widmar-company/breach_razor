extends CharacterBody3D


# Our own player data that we save
@export var player_data: Dictionary

const holder_hip = Vector3(0.25, -0.35, -0.5)
const holder_aim = Vector3(0.0, -0.25, -0.25)

const fov_nrm = 120
const fov_aim = 90

var SPEED = 8.0
var MAX_SPEED = 50.0
const JUMP_VELOCITY = 20.0

var m_id

func _ready() -> void:
	set_multiplayer_authority(m_id)
	$Camera3D.fov = fov_nrm
	$Camera3D/Holder.position = holder_hip

func _process(delta):
	player_data["position"] = position

func _physics_process(delta: float) -> void:
	var friction = 0.25
	var drag     = 0.1

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("razor_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY #+ (abs(velocity.x) + abs(velocity.z) * 0.005)
		velocity.x = velocity.x * 1.50
		velocity.z = velocity.z * 1.50

	var magnitude = SPEED

	# Handle specials
	if Input.is_action_pressed("razor_sprint"):
		magnitude = SPEED * 1.5
	if Input.is_action_pressed("razor_crouch"):
		if is_on_floor():
			magnitude = (SPEED / 4)

	if abs(velocity.x) + abs(velocity.z) > SPEED * 3:
		drag = 0.01
		friction = 0.05
		magnitude = SPEED * 3
	#else:
	#	drag = lerpf(drag, 0.1, 0.01)

	#print(drag, " ", friction)
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
			if Input.is_action_just_pressed("razor_jump"):
				velocity.x = direction.x * (abs(velocity.x) + SPEED * 2)
				velocity.z = direction.z * (abs(velocity.z) + SPEED * 2)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0.0, SPEED)
			velocity.z = move_toward(velocity.z, 0.0, SPEED)
		else:
			velocity.x = lerpf(velocity.x, 0.0, drag)
			velocity.z = lerpf(velocity.z, 0.0, drag)
	
	if Input.is_action_pressed("razor_aim"):
		$Camera3D/Holder.position = Vector3(move_toward($Camera3D/Holder.position.x, holder_aim.x, 0.025), move_toward($Camera3D/Holder.position.y, holder_aim.y, 0.025), move_toward($Camera3D/Holder.position.z, holder_aim.z, 0.025))

		#$Camera3D.fov = fov_aim
	if Input.is_action_just_released("razor_aim"):
		$Camera3D/Holder.position = holder_hip
		$Camera3D.fov = fov_nrm

	#move_and_collide(velocity)
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not Data.mouse_free: 
		self.rotate_y(deg_to_rad(event.relative.x * 0.1 * -1))
		$Camera3D.rotate_x(deg_to_rad(event.relative.y * 0.1 * -1))

	#Handle player firing weapon
	if Input.is_action_pressed("razor_fire"):
		for n in $Camera3D/Holder.get_children():
			if n is  Firearm:
				n.fire_missile()
	
