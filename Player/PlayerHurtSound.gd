extends AudioStreamPlayer

func _ready():
	return connect("finished", self, "queue_free")
