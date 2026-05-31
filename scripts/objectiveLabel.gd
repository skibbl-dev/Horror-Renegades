extends Label

var current_tween: Tween
var can_show_objective := true

func _ready():
	modulate.a = 0.0
	Objective.objective_changed.connect(_on_objective_changed)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("show_objectives") and can_show_objective:
		show_objective(Objective.current_objective)

func _on_objective_changed(new_text: String):
	show_objective(new_text)

func show_objective(new_text: String):
	can_show_objective = false

	text = new_text

	if current_tween:
		current_tween.kill()

	modulate.a = 0.0

	current_tween = create_tween()
	current_tween.tween_property(self, "modulate:a", 1.0, 0.5)
	current_tween.tween_interval(4.0)
	current_tween.tween_property(self, "modulate:a", 0.0, 0.5)

	await current_tween.finished
	can_show_objective = true
