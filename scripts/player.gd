extends KinematicBody

var speed = 0.0
var oldPos = Vector3.ZERO

export var test = {
	"jumpImpulse": 11.134,
	"gravity" : -0.55, 
	"groundAcceleration": 30.0,
	"groundSpeedLimit": 3.0,
	"airAcceleration": 700.0,
	"airSpeedLimit": 0.8,
	"groundFriction": 0.9 
}

export var mouseSensitivity = 0.15

var velocity = Vector3.ZERO

var restartTransform
var restartVelocity

func _ready():
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
		$PlayerUI/Label.text =  "speed: " + str(int(Mov.length() * 1000))
		oldPos = global_transform.origin
  
	
	# if Input.is_action_just_pressed("checkpoint"):
	#     print("Saving Checkpoint: %s / %s" % [self.translation, self.velocity])
	#     restartTransform = self.global_transform
	#     restartVelocity = self.velocity	
	
	# if Input.is_action_just_pressed("restart"):
	#     self.global_transform = restartTransform
	#     self.velocity = restartVelocity
	
	pass

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


	if event is InputEventMouseMotion:
		$head.rotate_x(deg2rad(event.relative.y * mouseSensitivity * -1))
		self.rotate_y(deg2rad(event.relative.x * mouseSensitivity * -1))

		# Clamp yaw to [-89, 89] degrees so you can't flip over
		var yaw = $head.rotation_degrees.x
		$head.rotation_degrees.x = clamp(yaw, -89, 89)    
