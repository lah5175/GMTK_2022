extends KinematicBody2D
class_name Enemy

# This is a parent class for all enemies in the game.

# Initialize these variables with different values in the children
var max_hp: int = 5;
var current_hp: int = 5;
var move_speed: int = 100;
var damage: int = 1;
var attack_rate: float = 1.0;
var chase_dist: int = 200;
var attack_dist: int = 15;



onready var target = get_tree().get_root().get_node("MainScene/Player");
#onready var ui = get_node("/root/MainScene/CanvasLayer/UI");


# Called when the node enters the scene tree for the first time.
func _ready():
	pass;
#	ui.connect("enemy_hit", self, "_on_Enemy_enemy_hit");


# Replace with an actual attack function in child
func attack():
	pass;

# Replace with a death sound function in child
func playDeathSound():
	pass;

func take_damage(dmg):
	current_hp -= dmg;
	if current_hp <= 0:
		playDeathSound();
		die();
		
	
func die():
	queue_free(); 
	

# Function Overrides

func get_class(): return "Enemy";
