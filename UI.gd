extends Control


onready var player_dice = get_node("DiceBG/PlayerDice");
onready var monster_dice = get_node("DiceBG/MonsterDice");


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DiceTimer_timeout():
	$DiceSFX.play();
	player_dice.roll();
	monster_dice.roll();
