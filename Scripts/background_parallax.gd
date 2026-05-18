extends Node2D

@onready var player  = $"../Player"

var parallax : float = 0.7

func _process(_delta):
	global_position = player.global_position * parallax

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Something entered: ", body.name)
	if body.is_in_group("Player"): 
		call_deferred("game_over")

func game_over():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
