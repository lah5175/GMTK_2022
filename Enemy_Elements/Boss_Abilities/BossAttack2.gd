extends Area2D


var damage = 1;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_WarningTimer_timeout():
	$CollisionShape2D.set_deferred("disabled", false);
	$AnimatedSprite.animation = "Active";
	$DurationTimer.start();


func _on_DurationTimer_timeout():
	queue_free();


func _on_BossAttack2_body_entered(body):
	var collider_type = body.get_class();
	if collider_type == "Player":
		body.take_damage(damage);
