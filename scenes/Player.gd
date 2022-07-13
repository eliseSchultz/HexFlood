extends KinematicBody

export(NodePath) var cam_path := NodePath("Camera")
onready var cam: Camera = get_node(cam_path)
export var mouse_sensitivity := 150.0
export var y_limit := 90.0
var mouse_axis := Vector2()
var rot := Vector3()

export var joystick_sensitivity = 3

export var gravity_multiplier := 3.0
export var speed := 3
export var acceleration := 3
export var deceleration := 10
export(float, 0.0, 1.0, 0.05) var air_control := 0.3
export var jump_height := 8
var direction := Vector3()
var input_axis := Vector2()
var velocity := Vector3()
var snap := Vector3()
var up_direction := Vector3.UP
var stop_on_slope := true

onready var floor_max_angle: float = deg2rad(45.0)
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
onready var gravity = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* gravity_multiplier)

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_sensitivity = mouse_sensitivity / 1000
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	y_limit = deg2rad(y_limit)

func _input(event):
	if event is InputEventMouseMotion:
		var movement = event.relative
		cam.rotation.x += -deg2rad(movement.y * mouse_sensitivity)
		cam.rotation.x = clamp(cam.rotation.x, deg2rad(-90), deg2rad(90))
		rotation.y += -deg2rad(movement.x * mouse_sensitivity)
		
	

# Called every physics tick. 'delta' is constant
func _physics_process(delta) -> void:
	#if(Input.is_action_just_pressed("start")):
	#	get_tree().paused = !get_tree().paused
	input_axis = Input.get_vector("move_back", "move_forward",
			"move_left", "move_right")
	
	direction_input_mouse()
	
	#direction_input_gamepad(delta)

	if is_on_floor():
		snap = -get_floor_normal() - get_floor_velocity() * delta
		
		# Workaround for sliding down after jump on slope
		if velocity.y < 0:
			velocity.y = 0
		
		#if Input.is_action_just_pressed("jump"):
		#	snap = Vector3.ZERO
		#	velocity.y = jump_height
	else:
		# Workaround for 'vertical bump' when going off platform
		if snap != Vector3.ZERO && velocity.y != 0:
			velocity.y = 0
		
		snap = Vector3.ZERO
		
		velocity.y -= gravity * delta
	
	accelerate(delta)
	
	velocity = move_and_slide_with_snap(velocity, snap, up_direction, 
			stop_on_slope, 4, floor_max_angle)

	#end of _process

func direction_input_mouse() -> void:
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	if input_axis.x >= 0.5:
		direction -= aim.z * mouse_sensitivity
	if input_axis.x <= -0.5:
		direction += aim.z * mouse_sensitivity
	if input_axis.y <= -0.5:
		direction -= aim.x * mouse_sensitivity
	if input_axis.y >= 0.5:
		direction += aim.x * mouse_sensitivity
	direction.y = 0
	direction = direction.normalized()

func direction_input_gamepad(delta):
	var axis_vector = Vector2.ZERO
	axis_vector.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	axis_vector.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	
	if InputEventJoypadMotion:
		rotate_y(deg2rad(-axis_vector.x) * joystick_sensitivity)
		cam.rotate_x(deg2rad(-axis_vector.y) * joystick_sensitivity)


func accelerate(delta: float) -> void:
	# Using only the horizontal velocity, interpolate towards the input.
	var temp_vel := velocity
	temp_vel.y = 0
	
	var temp_accel: float
	var target: Vector3 = direction * speed
	
	if direction.dot(temp_vel) > 0:
		temp_accel = acceleration
	else:
		temp_accel = deceleration
	
	if not is_on_floor():
		temp_accel *= air_control
	
	temp_vel = temp_vel.linear_interpolate(target, temp_accel * delta)
	
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z
