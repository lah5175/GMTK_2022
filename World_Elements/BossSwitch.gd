extends Area2D

onready var sprite = $Sprite_State;
onready var switchOn = false;

func _ready():
	self.connect("body_entered", self, "_on_Area2D_body_entered");
	
func _on_Area2D_body_entered(body):
	var collider_type = body.get_class();
	if collider_type == "Player" && switchOn == false:
		sprite.animation = "on";
		switchOn = true;
		get_node("../Boss").stop_explosion();
		$DingSFX.play();

func enable_switch():
	$BossSwitchCollision.disabled = false;
	visible = true;
	sprite.animation = "off";
	
func disable_switch():
	$BossSwitchCollision.disabled = true;
	visible = false;
	sprite.animation = "disabled";
	switchOn = false;
