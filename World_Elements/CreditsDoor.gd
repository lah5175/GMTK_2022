extends Area2D

onready var sprite = $AnimatedSprite;

func _ready():
	$CollisionShape2D.disabled = false;
	self.connect("body_entered", self, "_on_CreditsDoor_body_entered");

func _on_CreditsDoor_body_entered(body):
	var collider_type = body.get_class();
	print("entered")
	if collider_type == "Player":
		$EnterDoor.play();
		#Trigger Credits
