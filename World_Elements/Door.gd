extends Area2D

onready var sprite = $AnimatedSprite;
onready var switchOn = false;

func _ready():
	self.connect("body_entered", self, "_on_Area2D_body_entered")

func _on_Area2D_body_entered(body):
	var collider_type = body.get_class();
	if collider_type == "Player" && body.keys >= 3:
		$EnterDoor.play();
		get_node("../FieldBGM").stop();
		get_node("../BossBGM").play();
		body.set_position(Vector2(1287,5));
		get_node("../Boss").aggro();
