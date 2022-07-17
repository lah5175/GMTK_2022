extends Area2D

onready var sprite = $AnimatedSprite;
onready var credits = get_node("/root/SceneManager/TransitionScreen");

func _ready():
	self.connect("body_entered", self, "_on_CreditsDoor_body_entered");

func _on_CreditsDoor_body_entered(body):
	var collider_type = body.get_class();
	if collider_type == "Player":
		$EnterDoor.play();
		get_node("../BossBGM").stop();
		get_node("../CreditsBGM").play();
		#Trigger Credits
		credits.transition();

func OpenDoor():
	sprite.play("open")


func _on_Boss_BossKilled():
	print("killed recieved")
	OpenDoor(); # Replace with function body.
