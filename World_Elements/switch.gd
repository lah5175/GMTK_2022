extends Area2D

onready var sprite = $AnimatedSprite;
onready var switchOn = false;

func _ready():
	self.connect("body_entered", self, "_on_Area2D_body_entered")
	self.connect("body_exited", self, "_on_Area2D_body_exited")
	
func _on_Area2D_body_entered(body):
	var area_parent = body.get_parent()
	print(body);
	print(body.get_parent());
	if area_parent.name == "player" && switchOn == false:
		body.keys += 1;
		sprite.animation = "on";
		switchOn = true;

