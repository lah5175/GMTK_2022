extends Control

onready var hpText : Label = get_node("HealthLabel");
onready var hpDice : Node2D = get_node("HealthDice");
onready var sprite = $HealthDice/AnimatedSprite;

func update_hp(curHP, maxHP):
	hpText.text = String(curHP);
	setHealthState(curHP, maxHP);
	
func setHealthState(curHP, maxHP):
	var healthvalue : float = float(curHP) / float(maxHP);
	print(healthvalue);
	var healthState : = ceil(6 * healthvalue);
	sprite.animation = String(healthState);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
