extends Node2D

class_name Dice

var number: int = 1;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func generate_number():
	number = (randi() % 6) + 1;
