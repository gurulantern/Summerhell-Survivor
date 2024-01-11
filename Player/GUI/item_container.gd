extends TextureRect

var upgrade = null
var upgrade_type = null

func _ready():
	if upgrade != null:
		$ItemTexture.texture = load(UpgradeDb.UPGRADES[upgrade]["icon"])

func update_upgrade(new_upgrade):
	upgrade = new_upgrade
	$ItemTexture.texture = load(UpgradeDb.UPGRADES[upgrade]["icon"])
