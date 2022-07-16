extends Area2D

var damage = 3;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_BombCrossExplosion_body_entered(body):
	var collider_type = body.get_class();
	if collider_type == "Enemy":
		body.take_damage(damage);
		body.modulate.a = 0.5;
		body.start_flicker_timer();
	if collider_type == "Player":
		body.take_damage(damage);


func _on_BlastTimer_timeout():
	queue_free();
