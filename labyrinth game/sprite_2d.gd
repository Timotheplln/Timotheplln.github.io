extends Sprite2D

@onready var tween := create_tween()

func _ready():
	osciller()

func osciller():
	tween.tween_property(self, "rotation_degrees", -10, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "rotation_degrees", 10, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.set_loops()  # boucle infiniment
