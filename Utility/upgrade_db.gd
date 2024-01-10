extends Node

const UPGRADE_PATH = "res://Art/upgrades/icons/"
const WEAPON_PATH = "res://Art/attacks/icons/"
const UPGRADES = {
	"earpick1": {
		"icon": WEAPON_PATH + "earpick_icon.png",
		"displayname": "Ear Pick",
		"details": "Let me see your ears.",
		"level": "Lvl. 1",
		"prerequisite":  [],
		"type": "weapon"
	},
	"earpick2": {
		"icon": WEAPON_PATH + "earpick_icon.png",
		"displayname": "Ear Pick",
		"details": "You're disgusting.",
		"level": "Lvl. 2",
		"prerequisite":  ["earpick1"],
		"type": "weapon"
	},
	"earpick3": {
		"icon": WEAPON_PATH + "earpick_icon.png",
		"displayname": "Ear Pick",
		"details": "Look what I found.",
		"level": "Lvl. 3",
		"prerequisite":  ["earpick2"],
		"type": "weapon"
	},
	"earpick4": {
		"icon": WEAPON_PATH + "earpick_icon.png",
		"displayname": "Ear Pick",
		"details": "It's like digging for gold.",
		"level": "Lvl. 4",
		"prerequisite":  ["earpick3"],
		"type": "weapon"
	},
	"fannypack1": {
		"icon": WEAPON_PATH + "fanny_p_icon.png",
		"displayname": "Fanny Pack",
		"details": "Whip out your fanny pack, gurl!",
		"level": "Lvl. 1",
		"prerequisite":  [],
		"type": "weapon"
	},
	"fannypack2": {
		"icon": WEAPON_PATH + "fanny_p_icon.png",
		"displayname": "Fanny Pack",
		"details": "Whip it out faster!",
		"level": "Lvl. 2",
		"prerequisite":  ["fannypack1"],
		"type": "weapon"
	},
	"fannypack3": {
		"icon": WEAPON_PATH + "fanny_p_icon.png",
		"displayname": "Fanny Pack",
		"details": "Whip out more fanny packs!",
		"level": "Lvl. 3",
		"prerequisite":  ["fannypack2"],
		"type": "weapon"
	},
	"fannypack4": {
		"icon": WEAPON_PATH + "fanny_p_icon.png",
		"displayname": "Fanny Pack",
		"details": "MORE AND FASTER, GURL!",
		"level": "Lvl. 4",
		"prerequisite":  ["fannypack3"],
		"type": "weapon"
	},
	"gaslight1": {
		"icon": WEAPON_PATH + "gaslight_icon.png",
		"displayname": "Gas Light",
		"details": "You are being overly dramatic.",
		"level": "Lvl. 1",
		"prerequisite":  [],
		"type": "weapon"
	},
	"gaslight2": {
		"icon": WEAPON_PATH + "gaslight_icon.png",
		"displayname": "Gas Light",
		"details": "You know, I do this because I love you.",
		"level": "Lvl. 2",
		"prerequisite":  ["gaslight1"],
		"type": "weapon"
	},
	"gaslight3": {
		"icon": WEAPON_PATH + "gaslight_icon.png",
		"displayname": "Gas Light",
		"details": "You're being paranoid.",
		"level": "Lvl. 3",
		"prerequisite":  ["gaslight2"],
		"type": "weapon"
	},
	"gaslight4": {
		"icon": WEAPON_PATH + "gaslight_icon.png",
		"displayname": "Gas Light",
		"details": "I guess you don't really love me.",
		"level": "Lvl. 4",
		"prerequisite":  ["gaslight3"],
		"type": "weapon"
	},
	"clothes1": {
		"icon": UPGRADE_PATH + "popflex_icon.png",
		"displayname": "Popflex Leggings",
		"details": "Gain some protection.",
		"level": "Lvl. 1",
		"prerequisite":  [],
		"type": "upgrade"
	},
	"clothes2": {
		"icon": UPGRADE_PATH + "beanie_icon.png",
		"displayname": "Beanie",
		"details": "Gain some more protection.",
		"level": "Lvl. 2",
		"prerequisite":  ["clothes1"],
		"type": "upgrade"
	},
	"clothes3": {
		"icon": UPGRADE_PATH + "reisweater_icon.png",
		"displayname": "REI Sweater",
		"details": "Getting warmer.",
		"level": "Lvl. 3",
		"prerequisite":  ["clothes2"],
		"type": "upgrade"
	},
	"clothes4": {
		"icon": UPGRADE_PATH + "puffer_icon.png",
		"displayname": "Jin Soo's Puffer",
		"details": "She's not using it",
		"level": "Lvl. 4",
		"prerequisite":  ["clothes3"],
		"type": "upgrade"
	},
	"coffee1": {
		"icon": UPGRADE_PATH + "americano_icon.png",
		"displayname": "Iced Americano",
		"details": "I have a headache. I need coffee.",
		"level": "Lvl. 1",
		"prerequisite":  [],
		"type": "upgrade"
	},
	"coffee2": {
		"icon": UPGRADE_PATH + "americano_icon.png",
		"displayname": "Iced Americano",
		"details": "This is overextracted.",
		"level": "Lvl. 2",
		"prerequisite":  ["coffee1"],
		"type": "upgrade"
	},
	"coffee3": {
		"icon": UPGRADE_PATH + "coldbrew_icon.png",
		"displayname": "Choco Cold Foam Cold Brew",
		"details": "Mmmmm. This is overextracted.",
		"level": "Lvl. 3",
		"prerequisite":  ["coffee2"],
		"type": "upgrade"
	},
	"coffee4": {
		"icon": UPGRADE_PATH + "coldbrew_icon.png",
		"displayname": "Choco Cold Foam Cold Brew",
		"details": "It's like 4 in the afternoon.",
		"level": "Lvl. 4",
		"prerequisite":  ["coffee3"],
		"type": "upgrade"
	},
	"book1": {
		"icon": UPGRADE_PATH + "hibiscus_icon.png",
		"displayname": "Book",
		"details": "I'm a scholastic book fair queen.",
		"level": "Lvl. 1",
		"prerequisite":  [],
		"type": "upgrade"
	},
	"book2": {
		"icon": UPGRADE_PATH + "earthlings_icon.png",
		"displayname": "Book",
		"details": "This book stretches my brain.",
		"level": "Lvl. 2",
		"prerequisite":  ["book1"],
		"type": "upgrade"
	},
	"book3": {
		"icon": UPGRADE_PATH + "badson_icon.png",
		"displayname": "Book",
		"details": "I only want to read POC authors.",
		"level": "Lvl. 3",
		"prerequisite":  ["book2"],
		"type": "upgrade"
	},
	"book4": {
		"icon": UPGRADE_PATH + "spiral_icon.png",
		"displayname": "Book",
		"details": "I'll just skim the genetics part...",
		"level": "Lvl. 4",
		"prerequisite":  ["book3"],
		"type": "upgrade"
	},
	"podcast1": {
		"icon": UPGRADE_PATH + "podcast_icon.png",
		"displayname": "True Crime Podcast",
		"details": "She was kind of an outcast...",
		"level": "Lvl. 1",
		"prerequisite":  [],
		"type": "upgrade"
	},
	"podcast2": {
		"icon": UPGRADE_PATH + "podcast_icon.png",
		"displayname": "True Crime Podcast",
		"details": "They bullied her until she snapped...",
		"level": "Lvl. 2",
		"prerequisite":  ["podcast1"],
		"type": "upgrade"
	},
	"podcast3": {
		"icon": UPGRADE_PATH + "podcast_icon.png",
		"displayname": "True Crime Podcast",
		"details": "The police found blood in her room...",
		"level": "Lvl. 3",
		"prerequisite":  ["podcast2"],
		"type": "upgrade"
	},
	"podcast4": {
		"icon": UPGRADE_PATH + "podcast_icon.png",
		"displayname": "True Crime Podcast",
		"details": "Then they found her bully's body in a suitcase.",
		"level": "Lvl. 4",
		"prerequisite":  ["podcast3"],
		"type": "upgrade"
	},
	"glasses1": {
		"icon": UPGRADE_PATH + "glasses_icon.png",
		"displayname": "Glasses",
		"details": "I forgot to wear my glasses.",
		"level": "Lvl. 1",
		"prerequisite":  [],
		"type": "upgrade"
	},
	"glasses2": {
		"icon": UPGRADE_PATH + "glasses_icon.png",
		"displayname": "Glasses",
		"details": "Oh I can see a lot better now.",
		"level": "Lvl. 2",
		"prerequisite":  ["glasses1"],
		"type": "upgrade"
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
