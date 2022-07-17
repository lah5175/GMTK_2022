extends Area2D

signal BossSwitchOn

onready var sprite = $Sprite_State;
onready var switchOn = false;

func _ready():
	$BossSwitchCollision.disabled = false;
	self.connect("body_entered", self, "_on_Area2D_body_entered");
	#enableSwitch();
	
func _on_Area2D_body_entered(body):
	var collider_type = body.get_class();
	if collider_type == "Player" && switchOn == false:
		sprite.animation = "on";
		switchOn = true;
		emit_signal("BossSwitchOn");
		$DingSFX.play();

func enableSwitch():
	$BossSwitchCollision.disabled = false;
	sprite.animation = "off";
