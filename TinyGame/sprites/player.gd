extends CharacterBody2D

signal player_attack_lockon
signal player_attack
signal player_switch_target

const SPEED = 500.0
const JUMP_VELOCITY = -400.0

const JUMP_CD = 15
const MAX_JUMP_LIM = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumps = 0

var current_jump_cd = JUMP_CD


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_pressed("ui_up"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jumps = MAX_JUMP_LIM
		else:
			if jumps > 0:
				if current_jump_cd > 0:
					current_jump_cd -= 1
				else:
					velocity.y += JUMP_VELOCITY
					current_jump_cd = JUMP_CD
					jumps -= 1
	
	if Input.is_action_just_pressed("attack"):
		player_attack_lockon.emit()
	
	if Input.is_action_just_released("attack"):
		player_attack.emit()
		
	if Input.is_action_just_pressed("switch_target"):
		player_switch_target.emit()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if velocity.x > 0:
		$Animation.animation = "run"
		$Animation.flip_h = false
	elif velocity.x < 0:
		$Animation.animation = "run"
		$Animation.flip_h = true
	else:
		$Animation.animation = "default"
	
		 

	move_and_slide()
