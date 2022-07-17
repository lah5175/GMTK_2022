extends Area2D


var damage = 2;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_WarningTimer_timeout():
	$CollisionShape2D.set_deferred("disabled", false);
	$AnimatedSprite.animation = "Active";
	$DurationTimer.start();


func _on_DurationTimer_timeout():
	queue_free();
	

func _on_PurpleAttack4_body_entered(body):
	var collider_type = body.get_class();
	if collider_type == "Player":
		body.take_damage(damage);

func _on_PurpleAttack4_area_entered(area):
	var collider_type = area.get_class();
	print(collider_type);
	if collider_type == "ParticleShield":
		area.reflect(damage);
		queue_free();
