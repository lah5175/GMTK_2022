extends Enemy


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
