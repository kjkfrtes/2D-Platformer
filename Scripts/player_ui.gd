extends CanvasLayer

@onready var health_containter = $HealthContainer
@onready var score_text : Label = $ScoreText
@onready var player = get_parent()

var hearts : Array = []

func _ready():
	hearts = health_containter.get_children()

	player.OnUpdateHealth.connect(_update_hearts)
	player.OnUpdateScore.connect(_update_score)
	
	_update_hearts(player.health)
	_update_score(PlayerStats.score)

func _update_hearts (health:int):
	for i in len(hearts):
		hearts[i].visible = i < health

func _update_score (score:int):
	score_text.text = "score:" + str(score)
