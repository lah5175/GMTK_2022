extends Area2D


var damage = 1;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_AttackArea_body_entered(body):
	var collider_type = body.get_class();
	if collider_type == "Enemy":
		body.take_damage(damage);
		body.modulate.a = 0.5;
		body.start_flicker_timer();
