extends Node

const UPGRADE_PATH = "res://Art/upgrades/icons/"
const WEAPON_PATH = "res://Art/attacks/icons/"
const UPGRADES = {
	"earpick1": {
		"icon": WEAPON_PATH + "earpick_icon.png",
		"displayname": "Ear Pick",
		"details": "An ear pick is thrown into an enemy's ear",
		"level": "Lvl. 1",
		"prerequisite":  [],
		"type": "weapon"
	},
	"earpick2": {
		"icon": WEAPON_PATH + "earpick_icon.png",
		"displayname": "Ear Pick",
		"details": "An additional ear pick is thrown",
		"level": "Lvl. 2",
		"prerequisite":  ["earpick1"],
		"type": "weapon"
	},
	"sashimi": {
		"icon": UPGRADE_PATH + "sashimi.png",
		"displayname": "Sashimi",
		"details": "Raw fish to heal 20 HP",
		"level": "N/A",
		"prerequisite":  [],
		"type": "item"
	},
}
