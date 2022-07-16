extends Node2D
class_name Enemy

# This is a parent class for all enemies in the game.

# Initialize these variables with different values in the children
var max_hp: int = 5;
var current_hp: int = 5;
var move_speed: int = 100;
var damage: int = 1;
var attack_rate: float = 1.0;


onready var target = get_node("/root/MainScene/Player");


# Called when the node enters the scene tree for the first time.
func _ready():
	# Don't set anything here because if another _ready function
	# overwrites this one, the timer won't be set
	pass;


# Replace with an actual attack function in child
func attack():
	pass;


func take_damage(dmg):
	current_hp -= dmg;
	if current_hp <= 0:
		die();
		
	
func die():
	queue_free(); 
