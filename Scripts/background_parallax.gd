extends Node2D

@onready var player  = $"../Player"

var parallax : float = 0.7

func _process(delta):
	global_position = player.global_position * parallax
