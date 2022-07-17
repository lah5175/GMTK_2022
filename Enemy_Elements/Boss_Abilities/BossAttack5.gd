extends Area2D


var damage = 1;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_WarningTimer_timeout():
	$CollisionPolygon2D.set_deferred("disabled", false);
	$AnimatedSprite.animation = "Active";
	$DurationTimer.start();


func _on_DurationTimer_timeout():
	queue_free();


func _on_BossAttack5_body_entered(body):
	var collider_type = body.get_class();
	if collider_type == "Player":
		body.take_damage(damage);
