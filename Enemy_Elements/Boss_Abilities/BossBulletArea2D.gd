extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var parentNode

# Called when the node enters the scene tree for the first time.
func _ready():
	parentNode = get_owner()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BossBulletArea2D_area_entered(area):
	var collider_type = area.get_class();
	print(collider_type);
	if collider_type == "ParticleShield":
		area.reflect(parentNode.damage);
		parentNode.damage = 0;
		parentNode.queue_free();
