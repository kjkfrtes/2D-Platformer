extends Area2D

@onready var start_pos : Vector2 = global_position
@onready var sprite : Sprite2D = $Sprite2D

var rotate_speed : float = 3.0
var bob_height : float = 5.0
var bob_speed : float = 5.0

func _physics_process(_delta):
	var time = Time.get_unix_time_from_system()
	
	sprite.scale.x = sin(time * rotate_speed)
	
	var y_pos = (1 + sin(time * bob_height))/2 * bob_height
	global_position.y = start_pos.y - y_pos


func _on_body_entered(body) -> void:
	if body.is_in_group("Player"):
		queue_free()
	body.take_damage(1)
	body.increase_score(10)
