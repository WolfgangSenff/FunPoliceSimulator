extends TextureButton

export (Texture) onready var StandardTexture
export (Texture) onready var AccessibleTexture

func _ready() -> void:
    _on_update_accessibility()
    Globals.connect("update_accessibility", self, "_on_update_accessibility")

func _on_update_accessibility() -> void:
    if Globals.is_accessible:
        texture_normal = AccessibleTexture
    else:
        texture_normal = StandardTexture
