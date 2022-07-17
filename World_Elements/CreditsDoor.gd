extends Area2D

onready var sprite = $AnimatedSprite;
onready var credits = get_node("/root/SceneManager/TransitionScreen");

func _ready():
	$CollisionShape2D.disabled = true;
	self.connect("body_entered", self, "_on_CreditsDoor_body_entered");

func _on_CreditsDoor_body_entered(body):
	var collider_type = body.get_class();
	if collider_type == "Player":
		$EnterDoor.play();
		#Trigger Credits
		credits.transition();
