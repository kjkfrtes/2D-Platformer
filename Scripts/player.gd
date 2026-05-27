extends CharacterBody2D
@export var move_speed : float = 100
@export var acceleration : float = 50
@export var breaking : float = 20 
@export var gravity: float = 500
@export var jump_force : float = 350
@export var health : int = 4
@onready var sprite : Sprite2D = $sprite
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer

signal OnUpdateHealth (health:int)
signal OnUpdateScore (score:int)
var move_input : float
var jump_count = 0
var max_jumps = 1
var take_damage_sfx : AudioStream = preload("res://Audio/take_damage.wav")
var coin_sfx : AudioStream = preload("res://Audio/coin.wav")

func _process(_delta):
	if velocity.x !=0:
		sprite.flip_h = velocity.x<0
	_manage_animation()
	if  global_position.y>600:
		if not is_inside_tree():
			return
		call_deferred("game_over")

func _manage_animation (): 
	if not is_on_floor() and velocity.y<0:
		if anim.current_animation != "Jump":
			anim.play("Jump")
	elif not is_on_floor() and velocity.y>0:
		anim.play("Fall")
	elif move_input != 0:
		anim.play("Move")
	else:
		anim.play("Idle")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jump_count = 0
	move_input = Input.get_axis("Move_left","Move_right")
	if move_input !=0:
		velocity.x = lerp(velocity.x, move_input * move_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, breaking * delta)
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = -jump_force
		elif jump_count < max_jumps:
			velocity.y = -jump_force
			jump_count += 1
	move_and_slide()

func take_damage(amount:int):
	health -= amount
	OnUpdateHealth.emit(health)
	_damage_flash()
	play_sound(take_damage_sfx)
	if health <= 0:
		if not is_inside_tree():
			return
		call_deferred("game_over")

func _damage_flash  ():
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.05).timeout
	sprite.modulate = Color.WHITE

func game_over():
	if not is_inside_tree():
		return

	get_tree().call_deferred(
		"change_scene_to_file",
		"res://Scenes/menu.tscn"
	)

func increase_score (amount : int):
	PlayerStats.score += amount
	OnUpdateScore.emit(PlayerStats.score)
	play_sound(coin_sfx)

func play_sound (sound: AudioStream):
	audio.stream = sound
	audio.play()
