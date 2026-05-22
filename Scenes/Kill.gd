extends Area2D

func _on_body_entered(body):
	print("Something entered: ", body.name)
	if body.is_in_group("player"): 
		call_deferred("game_over")
		#get_tree().change_scene_to_file("res://Scenes/menu.tscn")
