extends KinematicBody

var oldPos = Vector3.ZERO

export var test = {
	"jumpImpulse": 12,
	"gravity" : -0.55, 
	"groundAcceleration": 100.0,
	"groundSpeedLimit": 10.0,
	"airAcceleration": 1600.0,
	"airSpeedLimit": 0.9,
	"groundFriction": 0.8,
	"speed": 0.0,
	"fov": 90.0
}

export var mouseSensitivity = 0.15

var velocity = Vector3.ZERO

var restartTransform
var restartVelocity

func _ready():
	$head/Camera.fov = test.fov
	restartTransform = self.global_transform
	restartVelocity = self.velocity
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Apply gravity, jumping, and ground friction to velocity
	velocity.y += test.gravity
	if is_on_floor():
		# By using is_action_pressed() rather than is_action_just_pressed()
		# we get automatic bunny hopping.
		if Input.is_action_pressed("jump"):
			velocity.y = test.jumpImpulse
		else:
			velocity *= test.groundFriction
	
	# Compute X/Z axis strafe vector from WASD inputs
	var basis = $head/Camera.get_global_transform().basis
	var strafeDir = Vector3(0, 0, 0)
	if Input.is_action_pressed("forward"):
		strafeDir -= basis.z
	if Input.is_action_pressed("backward"):
		strafeDir += basis.z
	if Input.is_action_pressed("left"):
		strafeDir -= basis.x
	if Input.is_action_pressed("right"):
		strafeDir += basis.x
	strafeDir.y = 0
	strafeDir = strafeDir.normalized()
	
	# Figure out which strafe force and speed limit applies
	var strafeAccel = test.groundAcceleration if is_on_floor() else test.airAcceleration
	var speedLimit = test.groundSpeedLimit if is_on_floor() else test.airSpeedLimit
	
	# Project current velocity onto the strafe direction, and compute a capped
	# acceleration such that *projected* speed will remain within the limit.
	var currentSpeed = strafeDir.dot(velocity)
	var accel = strafeAccel * delta
	accel = max(0, min(accel, speedLimit - currentSpeed))
	
	# Apply strafe acceleration to velocity and then integrate motion
	velocity += strafeDir * accel * 1.2
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if global_transform.origin != oldPos:
		var Mov = Vector2(global_transform.origin.x - oldPos.x, global_transform.origin.z - oldPos.z)
		#print(int(Mov.length() * 1000))
		test.speed = int(Mov.length() * 1000)
		$PlayerUI/Label.text =  "speed: " + str(test.speed)
		oldPos = global_transform.origin
	
	pass

func _input(event):
	if Input.is_action_just_pressed("ui_focus_next"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event is InputEventMouseMotion:
		$head.rotate_x(deg2rad(event.relative.y * mouseSensitivity * -1))
		self.rotate_y(deg2rad(event.relative.x * mouseSensitivity * -1))
		# Clamp yaw to [-89, 89] degrees so you can't flip over
		var yaw = $head.rotation_degrees.x
		$head.rotation_degrees.x = clamp(yaw, -89, 89)    
