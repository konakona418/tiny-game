extends Node2D

var slime = preload("res://sprites/slime.tscn")
var target_selector = preload("res://scenes/elements/target_selector.tscn")

var bullet = preload("res://sprites/player_bullet.tscn")
const BULLET_SPEED = 2400.0

const MAX_MP = 500
const CASTING_MP_COST = 20.0
const MP_INC = 5.0

const INFINITE_MP = true

const BULLET_SHAKE_AMPLITUDE = 0.2
const BULLET_QUEUE_MAX_CNT = 10

var current_mp = MAX_MP / 2

var mobs: Array[CharacterBody2D]
var bullets: Array

@onready var mp_bar = $ParallaxBackground/LayerUI/UI/MPBar
@onready var mp_text = $ParallaxBackground/LayerUI/UI/MPText
@onready var player: CharacterBody2D = $ParallaxBackground/LayerMain/Player
@onready var camera: Camera2D = $ParallaxBackground/LayerMain/Player/Camera
@onready var mob_node = $ParallaxBackground/LayerMain/Mobs

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func gen_mobs(count):
	for i in range(0, count):
		var slime = slime.instantiate()
		
		slime.hit.connect(_on_mob_hit)
		
		#var selector = target_selector.instantiate()
		#slime.add_child(selector)
		slime.position = Vector2(randf_range(-100.0, 300.0), 0.0)
		slime.scale = Vector2(3.0, 3.0)
		
		mob_node.add_child(slime)
		mobs.append(slime)

# Called when the node enters the scene tree for the first time.
func _ready():
	mp_bar.value = current_mp
	mp_bar.max_value = MAX_MP
	mp_text.text = str(round(current_mp)) + ' / ' + str(round(MAX_MP))
	
	player = player
	player.player_attack.connect(_on_player_attack)
	player.player_attack_lockon.connect(_on_player_attack_lockon)
	player.player_switch_target.connect(_on_player_switch_target)
	
	gen_mobs(3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mobs.size() == 0:
		gen_mobs(5)
		
	if bullets.size() > BULLET_QUEUE_MAX_CNT:
		var b = bullets.pop_front()
		b.queue_free()
	
var selected: CharacterBody2D = null
var selector = null
	
func _on_player_attack_lockon():
	if current_mp < CASTING_MP_COST and not INFINITE_MP:
		return
	
	if (selector != null):
		selector.queue_free()
	
	print('lockon!')
	var player_pos: Vector2 = player.position
	
	selected = null
	var min_distance = INF
	
	for mob in mobs:
		var mob_pos = mob.position
		var distance = player_pos.distance_squared_to(mob_pos)
		if distance < min_distance:
			selected = mob
			min_distance = distance
	
	if selected != null:
		selector = target_selector.instantiate()
		selected.add_child(selector)
		
	Engine.time_scale = 0.2 # make the time flow slower...
	animation_player.play("camera_zoom")
	
		
@onready var bullet_node = $ParallaxBackground/LayerMain/Bullets
@onready var animation_node = $ParallaxBackground/LayerMain/Player/Animation
	
func _on_player_attack():
	print('attack!')
	if current_mp < CASTING_MP_COST and not INFINITE_MP:
		return
		
	if (selector != null):
		selector.queue_free()
	
	if selected != null:
		print(selected.name)
		
		var bullet: Area2D = bullet.instantiate()
		
		var shake = Vector2(randf(), randf())
		var bullet_speed_normalized = \
			(selected.position - player.position).normalized() \
		 	+ shake * BULLET_SHAKE_AMPLITUDE
		
		bullet.position = player.position + bullet_speed_normalized * 20.0
		bullet.velocity = bullet_speed_normalized * BULLET_SPEED
		
		if bullet.velocity.x < 0:
			animation_node.flip_h = true
		else:
			animation_node.flip_h = false
		
		bullet_node.add_child(bullet)
		bullets.append(bullet)
		
		current_mp -= CASTING_MP_COST
		
		selected = null
	else:
		print('queue empty...')
		
		var bullet: Area2D = bullet.instantiate()
		
		var shake = Vector2(randf(), randf())
		var bullet_speed_normalized = player.velocity.normalized()
			
		if floor(player.velocity.length()) <= 0:
			bullet_speed_normalized = \
				Vector2(-1.0, 0.0) \
				if animation_node.flip_h else \
				Vector2(1.0, 0.0)
		
		bullet_speed_normalized += shake * BULLET_SHAKE_AMPLITUDE
		
		bullet.position = player.position + bullet_speed_normalized * 20.0
		bullet.velocity = bullet_speed_normalized * BULLET_SPEED
		
		bullet_node.add_child(bullet)
		bullets.append(bullet)
		
		current_mp -= CASTING_MP_COST
		
	Engine.time_scale = 1.0
	animation_player.play_backwards("camera_zoom")
	
func _on_player_switch_target():
	var new_selection = selected
	while (new_selection == selected and not mobs.size() <= 1):
		new_selection = mobs.pick_random()
	if new_selection == null:
		return
	selected = new_selection
	
	if selector != null:
		selector.queue_free()
	
	selector = target_selector.instantiate()
	if selected != null:
		selected.add_child(selector)
	else:
		selector = null

func _on_mob_hit(which_mob, area):
	print('hit!')
	mobs.erase(which_mob)
	which_mob.queue_free()
	#area.queue_free()


func _on_mp_timer_timeout():
	if current_mp <= MAX_MP:
		current_mp += MP_INC
	current_mp = min(current_mp, MAX_MP)
	if not INFINITE_MP:
		mp_bar.value = current_mp
		mp_text.text = str(round(current_mp)) + ' / ' + str(round(MAX_MP))
	else:
		mp_bar.value = mp_bar.max_value
		mp_text.text = "INFINITE MP"
