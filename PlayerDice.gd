extends Dice


onready var sprite = $AnimatedSprite;


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	roll();
	print(number);


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func roll():
	generate_number();
	
	match number:
		1:
			sprite.animation = "1";
		2:
			sprite.animation = "2";
		3:
			sprite.animation = "3";
		4:
			sprite.animation = "4";
		5:
			sprite.animation = "5";
		6:
			sprite.animation = "6";
