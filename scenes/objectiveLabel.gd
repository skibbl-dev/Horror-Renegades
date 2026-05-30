extends Label

func _ready():
	text = Objective.current_objective
	Objective.objective_changed.connect(_on_objective_changed)

func _on_objective_changed(new_text):
	text = new_text
