extends Control

signal roll_results(player, monster);

onready var player_dice = get_node("DiceBG/PlayerDice");
onready var monster_dice = get_node("DiceBG/MonsterDice");


# Called when the node enters the scene tree for the first time.
func _ready():
	$StartTimer.start()
	
func roll_dice():
	$DiceSFX.play();
	player_dice.roll();
	monster_dice.roll();
	emit_signal("roll_results", player_dice.number, monster_dice.number);


func _on_DiceTimer_timeout():
	roll_dice();


func _on_StartTimer_timeout():
	roll_dice();
