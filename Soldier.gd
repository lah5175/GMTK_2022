extends Enemy

var projectile_speed = 300;

# Preload assets for attacks
var rat_projectile = preload("res://RatProjectile.tscn");

onready var timer = $AttackTimer;

# Called when the node enters the scene tree for the first time.
func _ready():
	set_params();


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_params():
	max_hp = 5;
	current_hp = 5;
	move_speed = 100;
	damage = 1;
	attack_rate = 1.0;
		
	timer.wait_time = attack_rate;
	timer.start();	

func spawn_projectile():
	# Create a RatProjectile node and attach it to the main scene
	var proj = rat_projectile.instance();
	get_node("/root/MainScene").add_child(proj);
	
	# Set the initial position, direction, and rotation
	# I don't really know, this is some black magic stuff
	proj.position = position;
	var dir = (target.global_position - proj.global_position).normalized();
	proj.global_rotation = dir.angle() + PI / 2.0;
	proj.direction = dir;


func _on_AttackTimer_timeout():
	spawn_projectile();
