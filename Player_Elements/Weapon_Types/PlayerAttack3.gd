extends KinematicBody2D


onready var cross_factory = preload("res://Player_Elements/Weapon_Types/BombCrossExplosion.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_ExplosionTimer_timeout():
	print("spawning cross");
	var cross = cross_factory.instance();
	get_node("..").add_child(cross);
	cross.global_position = global_position;
	queue_free();
