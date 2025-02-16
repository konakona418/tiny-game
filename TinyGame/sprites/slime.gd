extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -400.0

signal hit(which_mob, target_area)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var damage_shader = preload("res://shaders/damage.gdshader")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
var random_speed = 0.0
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if abs(velocity.x) + 1.0 >= abs(random_speed) or round(velocity.x) == 0.0:
		random_speed = randf_range(-SPEED, SPEED)
		
	if round(velocity.x) == 0.0 and is_on_floor():
		velocity.y += JUMP_VELOCITY
	velocity.x = move_toward(velocity.x, random_speed, 10.0)
	#print("random:", random_speed, "; velocity:", velocity.x)
	
		
	$Animation.flip_h = velocity.x > 0
	
	move_and_slide()
	

func _on_inner_body_entered(body):
	print('enter')
	hit.emit(self, body)
	pass # Replace with function body.


func _on_inner_area_entered(area):
	#print('enter')
	#material.set_shader_parameter("bias", 1.0)
	hit.emit(self, area)
	pass # Replace with function body.
