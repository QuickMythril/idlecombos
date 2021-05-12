global DictionaryVersion := "1.9"

PatronFromID(patronid) {
	switch patronid {
		case "0": namefromid := "None"
		case "1": namefromid := "Mirt"
		case "2": namefromid := "Vajra"
		case "3": namefromid := "Strahd"
		case "4": namefromid := "Zariel"
	}
	return namefromid
}

campaignFromID(campaignid) {
	switch campaignid {
		case "1": namefromid := "Grand Tour of the Sword Coast"
		case "2": namefromid := "Tomb of Annihilation"
		case "15": namefromid := "Waterdeep: Dragon Heist"
		case "22": namefromid := "Baldur's Gate: Descent into Avernus"
		case "24": namefromid := "Icewind Dale: Rime of the Frostmaiden"
		case "23": namefromid := "Special"
		case "17": namefromid := "Time Gates"
		case "3": namefromid := "Highharvestide"
		case "4": namefromid := "Liars' Night"
		case "5": namefromid := "Feast of the Moon"
		case "6": namefromid := "Simril"
		case "7": namefromid := "Wintershield"
		case "8": namefromid := "Midwinter"
		case "9": namefromid := "Grand Revel"
		case "10": namefromid := "Fleetswake"
		case "11": namefromid := "Festival of Fools"
		case "12": namefromid := "Greengrass"
		case "13": namefromid := "The Running"
		case "14": namefromid := "The Great Modron March"
		case "16": namefromid := "Dragondown"
		case "18": namefromid := "Founders' Day"
		case "19": namefromid := "Midsummer"
		case "20": namefromid := "Ahghairon's Day"
		case "21": namefromid := "Brightswords"
		default: namefromid := "Error: " campaignid
	}
	return namefromid
}

ChampFromID(id) {
	if (id < 21) {
		switch id {
			case "1": namefromid := "Bruenor"
			case "2": namefromid := "Celeste"
			case "3": namefromid := "Nayeli"
			case "4": namefromid := "Jarlaxle"
			case "5": namefromid := "Calliope"
			case "6": namefromid := "Asharra"
			case "7": namefromid := "Minsc"
			case "8": namefromid := "Delina"
			case "9": namefromid := "Makos"
			case "10": namefromid := "Tyril"
			case "11": namefromid := "Jamilah"
			case "12": namefromid := "Arkhan"
			case "13": namefromid := "Hitch"
			case "14": namefromid := "Stoki"
			case "15": namefromid := "Krond"
			case "16": namefromid := "Gromma"
			case "17": namefromid := "Dhadius"
			case "18": namefromid := "Drizzt"
			case "19": namefromid := "Barrowin"
			case "20": namefromid := "Regis"
		}
	}
	else if (id < 41) {
		switch id {
			case "21": namefromid := "Birdsong"
			case "22": namefromid := "Zorbu"
			case "23": namefromid := "Strix"
			case "24": namefromid := "Nrakk"
			case "25": namefromid := "Catti-brie"
			case "26": namefromid := "Evelyn"
			case "27": namefromid := "Binwin"
			case "28": namefromid := "Deekin"
			case "29": namefromid := "Xander"
			case "30": namefromid := "Azaka"
			case "31": namefromid := "Ishi"
			case "32": namefromid := "Wulfgar"
			case "33": namefromid := "Farideh"
			case "34": namefromid := "Donaar"
			case "35": namefromid := "Vlahnya"
			case "36": namefromid := "Warden"
			case "37": namefromid := "Nerys"
			case "38": namefromid := "K'thriss"
			case "39": namefromid := "Paultin"
			case "40": namefromid := "Black Viper"
		}
	}
	else if (id < 61) {
		switch id {
			case "41": namefromid := "Rosie"
			case "42": namefromid := "Aila"
			case "43": namefromid := "Spurt"
			case "44": namefromid := "Qillek"
			case "45": namefromid := "Korth"
			case "46": namefromid := "Walnut"
			case "47": namefromid := "Shandie"
			case "48": namefromid := "Jim"
			case "49": namefromid := "Turiel"
			case "50": namefromid := "Pwent"
			case "51": namefromid := "Avren"
			case "52": namefromid := "Sentry"
			case "53": namefromid := "Krull"
			case "54": namefromid := "Artemis"
			case "55": namefromid := "M" Chr(244) "rg" Chr(230) "n"
			case "56": namefromid := "Havilar"
			case "57": namefromid := "Sisaspia"
			case "58": namefromid := "Briv"
			case "59": namefromid := "Melf"
			case "60": namefromid := "Krydle"
			}
	}
	else if (id < 81) {
		switch id {
			case "61": namefromid := "Jaheira"
			case "62": namefromid := "Nova"
			case "63": namefromid := "Freely"
			case "64": namefromid := "B && G"
			case "65": namefromid := "Omin"
			case "66": namefromid := "Lazaapz"
			case "67": namefromid := "Dragonbait"
			case "68": namefromid := "Ulkoria"
			case "69": namefromid := "Torogar"
			case "70": namefromid := "Ezmerelda"
			case "71": namefromid := "Penelope"
			case "72": namefromid := "Lucius"
			case "73": namefromid := "Baeloth"
			case "74": namefromid := "Talin"
			case "75": namefromid := "Hew Maan"
			case "76": namefromid := "Orisha"
			case "77": namefromid := "Alyndra"
			case "78": namefromid := "Orkira"
			case "79": namefromid := "Shaka"
			case "80": namefromid := "Mehen"
		}
	}
	else if (id < 87) {
		switch id {
			case "81": namefromid := "Y4E13"
			case "82": namefromid := "Y4E14"
			case "83": namefromid := "Y4E15"
			case "84": namefromid := "Y4E16"
			case "85": namefromid := "Y4E17"
			case "86": namefromid := "Reya"
		}
	}
	else {
		namefromid := "UNKNOWN (" id ")"
	}
	return namefromid
}

FeatFromID(id) {
	if (id < 83) {
		switch id {
			case "3": namefromid := "Bruenor (Rally +40%)"
			case "6": namefromid := "Bruenor (CHA +1)"
			case "9": namefromid := "Celeste (Global DPS +25%)"
			case "12": namefromid := "Celeste (Mass Cure Wounds +30%)"
			case "19": namefromid := "Nayeli (Overwhelm point +10)"
			case "24": namefromid := "Jarlaxle (CHA +1)"
			case "26": namefromid := "Calliope (Global DPS +25%)"
			case "34": namefromid := "Asharra (CHA +1)"
			case "36": namefromid := "Minsc (Self DPS +60%)"
			case "44": namefromid := "Delina (Surge of Power +40%)"
			case "45": namefromid := "Delina (WIS +1)"
			case "51": namefromid := "Makos (Gold +25%)"
			case "53": namefromid := "Tyril (Global DPS +25%)"
			case "59": namefromid := "Tyril (Overwhelm point +10)"
			case "61": namefromid := "Jamilah (Self DPS +60%)"
			case "63": namefromid := "Jamilah (DEX +1)"
			case "68": namefromid := "Arkhan (Self DPS +60%)"
			case "71": namefromid := "Arkhan (DEX +1)"
			case "77": namefromid := "Hitch (Global DPS +25%)"
			case "82": namefromid := "Stoki (Gold +25%)"
		}
	}
	else if (id < 171) {
		switch id {
			case "87": namefromid := "Krond (Global DPS +25%)"
			case "89": namefromid := "Krond (WIS +1)"
			case "95": namefromid := "Gromma (Health +30%)"
			case "98": namefromid := "Dhadius (Self DPS +60%)"
			case "105": namefromid := "Drizzt (Gold +25%)"
			case "106": namefromid := "Drizzt (Companions of the Hall +40%)"
			case "112": namefromid := "Barrowin (Blessed Hammer +40%)"
			case "114": namefromid := "Regis (Global DPS +25%)"
			case "119": namefromid := "Birdsong (Self DPS +60%)"
			case "128": namefromid := "Zorbu (Hunter's Pack +40%)"
			case "132": namefromid := "Strix (Global DPS +25%)"
			case "135": namefromid := "Nrakk (Self DPS +60%)"
			case "143": namefromid := "Catti-brie (Death March +40%)"
			case "144": namefromid := "Catti-brie (CHA +1)"
			case "148": namefromid := "Evelyn (Health +30%)"
			case "150": namefromid := "Evelyn (Overwhelm point +10)"
			case "154": namefromid := "Binwin (Tallest in Faerûn +40%)"
			case "158": namefromid := "Deekin (Global DPS +25%)"
			case "164": namefromid := "Xander (Streetwise +40%)"
			case "170": namefromid := "Azaka (Gold +25%)"
		}
	}
	else if (id < 255) {
		switch id {
			case "172": namefromid := "Ishi (Self DPS +60%)"
			case "181": namefromid := "Wulfgar (Health +30%)"
			case "184": namefromid := "Farideh (Self DPS +60%)"
			case "191": namefromid := "Donaar (Aura of Vitality +30%)"
			case "193": namefromid := "Zorbu (INT +1)"
			case "195": namefromid := "Vlahnya (Global DPS +25%)"
			case "198": namefromid := "Vlahnya (DEX +1)"
			case "203": namefromid := "Warden (CON +1)"
			case "207": namefromid := "Nerys (War Healing +30%)"
			case "210": namefromid := "K'thriss (Global DPS +25%)"
			case "218": namefromid := "Paultin (WIS +1)"
			case "220": namefromid := "Black Viper (Self DPS +60%)"
			case "229": namefromid := "Rosie (INT +1)"
			case "231": namefromid := "Aila (Global DPS +25%)"
			case "236": namefromid := "Aila (Overwhelm point +10)"
			case "241": namefromid := "Spurt (CON +1)"
			case "243": namefromid := "Qillek (Global DPS +25%)"
			case "248": namefromid := "Korth (Global DPS +25%)"
			case "251": namefromid := "Korth (Calculated +40%)"
			case "254": namefromid := "Walnut (Global DPS +25%)"
			}
	}
	else if (id < 340) {
		switch id {
			case "262": namefromid := "Shandie (WIS +1)"
			case "263": namefromid := "Shandie (CHA +1)"
			case "265": namefromid := "Jim (Self DPS +60%)"
			case "269": namefromid := "Spurt (Pack Tactics +40%)"
			case "284": namefromid := "Turiel (Gold +25%)"
			case "288": namefromid := "Pwent (Global DPS +25%)"
			case "295": namefromid := "Avren (Mirror Image +40%)"
			case "296": namefromid := "Avren (Seeing Double +40%)"
			case "300": namefromid := "Sentry (Global DPS +25%)"
			case "302": namefromid := "Sentry (Health +30%)"
			case "308": namefromid := "Krull (Global DPS +25%)"
			case "309": namefromid := "Krull (Gold +25%)"
			case "316": namefromid := "Krull (Virulent Strain +100%)"
			case "320": namefromid := "Artemis (Gold +25%)"
			case "322": namefromid := "Artemis (Jeweled Power +40%)"
			case "326": namefromid := "Dragonbait (Health +30%)"
			case "329": namefromid := "Dragonbait (Overwhelm point +10)"
			case "333": namefromid := "M" Chr(244) "rg" Chr(230) "n (Paid Up Front +40%)"
			case "336": namefromid := "Havilar (Global DPS +25%)"
			case "339": namefromid := "Havilar (Leadership Summit +40%)"
		}
	}
	else if (id < 406) {
		switch id {
			case "342": namefromid := "Sisaspia (Global DPS +25%)"
			case "345": namefromid := "Sisaspia (Halo of Spores +40%)"
			case "351": namefromid := "Briv (Health +30%)"
			case "354": namefromid := "Briv (Overwhelm point +10)"
			case "355": namefromid := "Deekin (Confidence in the Boss +40%)"
			case "356": namefromid := "Birdsong (Tempo of Victory +40%)"
			case "357": namefromid := "Barrowin (Base Attack Cooldown -0.5s)"
			case "358": namefromid := "Hitch (Chance of Daggers Ricocheting +40%)"
			case "366": namefromid := "Melf (Melf's Adaptive Support Spell +40%)"
			case "367": namefromid := "Melf (Melf's Speedy Supplement +40%)"
			case "374": namefromid := "Krydle (Global DPS +25%)"
			case "376": namefromid := "Krydle (Charismatic Leader +40%)"
			case "380": namefromid := "Freely (Gold +25%)"
			case "381": namefromid := "Freely (Luck of Yondalla Requisition +40%)"
			case "385": namefromid := "Jaheira (Self DPS +60%)"
			case "388": namefromid := "Jaheira (Class Warfare +40%)"
			case "392": namefromid := "Beadle & Grimm (Global DPS +25%)"
			case "395": namefromid := "Beadle & Grimm (Get Buff +40%)"
			case "397": namefromid := "Beadle & Grimm (Long Rest +40%)"
			case "405": namefromid := "Nova (Global DPS +25%)"
		}
	}
	else if (id < 458) {
		switch id {
			case "410": namefromid := "Nova (Close Encounter +40%)"
			case "412": namefromid := "Omin (Global DPS +25%)"
			case "413": namefromid := "Omin (Gold +25%)"
			case "416": namefromid := "Omin (Contractual Obligations Gold Find +40%)"
			case "418": namefromid := "Ulkoria (Global DPS +25%)"
			case "421": namefromid := "Ulkoria (Watchful Order +40%)"
			case "422": namefromid := "Ulkoria (Watchful Order +40%)"
			case "426": namefromid := "Lazaapz (Global DPS +25%)"
			case "428": namefromid := "Lazaapz (Health +30%)"
			case "446": namefromid := "Torogar (Dark Order Synergy +40%)"
			case "448": namefromid := "Ezmerelda (Global DPS +25%)"
			case "450": namefromid := "Ezmerelda (Training Montage +40%)"
			case "454": namefromid := "Penelope (Global DPS +25%)"
			case "457": namefromid := "Penelope (Chwinga Mask +40%)"
		}
	}
	else {
		namefromid := "UNKNOWN (" id ")"
	}
	return namefromid
}

ChestFromID(id) {
	if (id < 21) {
		switch id {
			case "1": namefromid := "Silver Chest"
			case "2": namefromid := "Gold Chest"
			case "3": namefromid := "Silver Stoki Chest"
			case "4": namefromid := "Gold Stoki Chest"
			case "5": namefromid := "Silver Krond Chest"
			case "6": namefromid := "Gold Krond Chest"
			case "7": namefromid := "Silver Gromma Chest"
			case "8": namefromid := "Gold Gromma Chest"
			case "9": namefromid := "Silver Dhadius Chest"
			case "10": namefromid := "Gold Dhadius Chest"
			case "11": namefromid := "Silver Barrowin Chest"
			case "12": namefromid := "Gold Barrowin Chest"
			case "13": namefromid := "Gold Snowy Chest"
			case "14": namefromid := "Gold Chultan Chest"
			case "15": namefromid := "Gold Wayside Chest"
			case "16": namefromid := "Silver Regis Chest"
			case "17": namefromid := "Gold Regis Chest"
			case "18": namefromid := "Silver Birdsong Chest"
			case "19": namefromid := "Gold Birdsong Chest"
			case "20": namefromid := "Gold Neutral Chest"
		}
	}
	else if (id < 41) {
		switch id {
			case "21": namefromid := "Silver Zorbu Chest"
			case "22": namefromid := "Gold Zorbu Chest"
			case "23": namefromid := "Gold Evil Chest"
			case "24": namefromid := "Gold Chaos Chest"
			case "25": namefromid := "Gold Good Chest"
			case "26": namefromid := "Silver Strix Chest"
			case "27": namefromid := "Gold Strix Chest"
			case "28": namefromid := "Gold Spring Chest"
			case "29": namefromid := "Silver Nrakk Chest"
			case "30": namefromid := "Gold Nrakk Chest"
			case "31": namefromid := "Gold Lawful Chest"
			case "32": namefromid := "Gold Companions' Chest"
			case "33": namefromid := "Gold Force Grey Chest"
			case "34": namefromid := "Gold Bird-Loving Chest"
			case "35": namefromid := "Silver Catti-brie Chest"
			case "36": namefromid := "Gold Catti-brie Chest"
			case "37": namefromid := "Gold Supply Chest"
			case "38": namefromid := "Gold Tough Chest"
			case "39": namefromid := "Gold Magic Chest"
			case "40": namefromid := "Silver Evelyn Chest"
		}
	}
	else if (id < 61) {
		switch id {
			case "41": namefromid := "Gold Evelyn Chest"
			case "42": namefromid := "Gold Warrior Chest"
			case "43": namefromid := "Gold Stuffed Chest"
			case "44": namefromid := "Gold Googly-Eyed Chest"
			case "45": namefromid := "Silver Binwin Chest"
			case "46": namefromid := "Gold Binwin Chest"
			case "47": namefromid := "Gold Gentlemen Chest"
			case "48": namefromid := "Gold Adventurers' Chest"
			case "49": namefromid := "Gold Minion Chest"
			case "50": namefromid := "Gold Scroll-Filled Chest"
			case "51": namefromid := "Gold Chaotic Chest"
			case "52": namefromid := "Gold Gate Chest"
			case "53": namefromid := "Silver Deekin Chest"
			case "54": namefromid := "Gold Deekin Chest"
			case "55": namefromid := "Silver Xander Chest"
			case "56": namefromid := "Gold Xander Chest"
			case "57": namefromid := "Silver Ishi Chest"
			case "58": namefromid := "Gold Ishi Chest"
			case "59": namefromid := "Gold Storyteller Chest"
			case "60": namefromid := "Gold Many-Horned Chest"
		}
	}
	else if (id < 81) {
		switch id {
			case "61": namefromid := "Gold Pummeled Chest"
			case "62": namefromid := "Gold Puzzle Cube Chest"
			case "63": namefromid := "Gold Friend Chest"
			case "64": namefromid := "Gold Warband Chest"
			case "65": namefromid := "Gold Weave-Bound Chest"
			case "66": namefromid := "Gold Band Chest"
			case "67": namefromid := "Silver Wulfgar Chest"
			case "68": namefromid := "Gold Wulfgar Chest"
			case "69": namefromid := "Gold Mithral Hall Chest"
			case "70": namefromid := "Gold Heist Chest"
			case "71": namefromid := "Silver Farideh Chest"
			case "72": namefromid := "Gold Farideh Chest"
			case "73": namefromid := "Silver Donaar Chest"
			case "74": namefromid := "Gold Donaar Chest"
			case "75": namefromid := "Silver Vlahnya Chest"
			case "76": namefromid := "Gold Vlahnya Chest"
			case "77": namefromid := "Gold Dice Chest"
			case "78": namefromid := "Gold Sheaf Chest"
			case "79": namefromid := "Gold Brimstone Chest"
			case "80": namefromid := "Gold Rampage Chest"
		}
	}
	else if (id < 101) {
		switch id {
			case "81": namefromid := "Silver Warden Chest"
			case "82": namefromid := "Gold Warden Chest"
			case "83": namefromid := "Silver Nerys Chest"
			case "84": namefromid := "Gold Nerys Chest"
			case "85": namefromid := "Silver K'thriss Chest"
			case "86": namefromid := "Gold K'thriss Chest"
			case "87": namefromid := "Silver Paultin Chest"
			case "88": namefromid := "Gold Paultin Chest"
			case "89": namefromid := "Silver Black Viper Chest"
			case "90": namefromid := "Gold Black Viper Chest"
			case "91": namefromid := "Silver Rosie Chest"
			case "92": namefromid := "Gold Rosie Chest"
			case "93": namefromid := "Silver Aila Chest"
			case "94": namefromid := "Gold Aila Chest"
			case "95": namefromid := "Silver Spurt Chest"
			case "96": namefromid := "Gold Spurt Chest"
			case "97": namefromid := "Silver Qillek Chest"
			case "98": namefromid := "Gold Qillek Chest"
			case "99": namefromid := "Silver Korth Chest"
			case "100": namefromid := "Gold Korth Chest"
		}
	}
	else if (id < 121) {
		switch id {
			case "101": namefromid := "Silver Walnut Chest"
			case "102": namefromid := "Gold Walnut Chest"
			case "103": namefromid := "Silver Shandie Chest"
			case "104": namefromid := "Gold Shandie Chest"
			case "105": namefromid := "Silver Jim Chest"
			case "106": namefromid := "Gold Jim Chest"
			case "107": namefromid := "Silver Turiel Chest"
			case "108": namefromid := "Gold Turiel Chest"
			case "109": namefromid := "Gold Story Chest"
			case "110": namefromid := "Gold Crew Chest"
			case "111": namefromid := "Gold Runic Chest"
			case "112": namefromid := "Gold Friend Chest"
			case "113": namefromid := "Gold Battlegroup Chest"
			case "114": namefromid := "Gold Returning Hero Chest"
			case "115": namefromid := "Gold Jungle Chest"
			case "116": namefromid := "Gold Welcome Chest"
			case "117": namefromid := "Gold Braggy Chest"
			case "118": namefromid := "Gold Protected Chest"
			case "119": namefromid := "Gold Wild Chest"
			case "120": namefromid := "Gold Watchful Chest"
		}
	}
	else if (id < 141) {
		switch id {
			case "121": namefromid := "Gold Exotic Chest"
			case "122": namefromid := "Gold Inventive Chest"
			case "123": namefromid := "Gold Cruel Chest"
			case "124": namefromid := "Gold Owlbear Chest"
			case "125": namefromid := "Gold Siren Chest"
			case "126": namefromid := "Gold Distressed Chest"
			case "127": namefromid := "Gold Trapped Chest"
			case "128": namefromid := "Gold Murderbot Chest"
			case "129": namefromid := "Gold Fit Chest"
			case "130": namefromid := "Gold Honeycomb Chest"
			case "131": namefromid := "Gold Spiritual Chest"
			case "132": namefromid := "Gold Non-Mimic Chest"
			case "133": namefromid := "Gold Misfit Chest"
			case "134": namefromid := "Gold Gust Chest"
			case "135": namefromid := "Gold Spider Climb Chest"
			case "136": namefromid := "Gold Feywild Chest"
			case "137": namefromid := "Gold Kobold Chest"
			case "138": namefromid := "Gold Descent Chest"
			case "139": namefromid := "Gold Scourge Chest"
			case "140": namefromid := "Gold Rage-Filled Chest"
		}
	}
	else if (id < 161) {
		switch id {
			case "141": namefromid := "Gold Well-Aligned Chest"
			case "142": namefromid := "Gold OK Chest"
			case "143": namefromid := "Gold Petrified Chest"
			case "144": namefromid := "Gold Feathered Chest"
			case "145": namefromid := "Gold Stock-Up Chest"
			case "146": namefromid := "Gold Zombiefied Chest"
			case "147": namefromid := "Gold Rebalanced Chest"
			case "148": namefromid := "Gold Ranged Chest"
			case "149": namefromid := "Gold Measured Chest"
			case "150": namefromid := "Gold Together Chest"
			case "151": namefromid := "Gold Documented Chest"
			case "152": namefromid := "Gold Mirt Patron Chest"
			case "153": namefromid := "Gold Vajra Patron Chest"
			case "154": namefromid := "Gold Allied Chest"
			case "155": namefromid := "Gold Welcoming Chest"
			case "156": namefromid := "Gold Skulking Chest"
			case "157": namefromid := "Gold Dashing Chest"
			case "158": namefromid := "Silver Pwent Chest"
			case "159": namefromid := "Gold Pwent Chest"
			case "160": namefromid := "Silver Avren Chest"
		}
	}
	else if (id < 181) {
		switch id {
			case "161": namefromid := "Gold Avren Chest"
			case "162": namefromid := "Silver Sentry Chest"
			case "163": namefromid := "Gold Sentry Chest"
			case "164": namefromid := "Silver Krull Chest"
			case "165": namefromid := "Gold Krull Chest"
			case "166": namefromid := "Silver Artemis Chest"
			case "167": namefromid := "Gold Artemis Chest"
			case "168": namefromid := "Silver M" Chr(244) "rg" Chr(230) "n Chest"
			case "169": namefromid := "Gold M" Chr(244) "rg" Chr(230) "n Chest"
			case "170": namefromid := "Silver Havilar Chest"
			case "171": namefromid := "Gold Havilar Chest"
			case "172": namefromid := "Silver Sisaspia Chest"
			case "173": namefromid := "Gold Sisaspia Chest"
			case "174": namefromid := "Silver Briv Chest"
			case "175": namefromid := "Gold Briv Chest"
			case "176": namefromid := "Silver Melf Chest"
			case "177": namefromid := "Gold Melf Chest"
			case "178": namefromid := "Silver Krydle Chest"
			case "179": namefromid := "Gold Krydle Chest"
			case "180": namefromid := "Silver Jaheira Chest"
		}
	}
	else if (id < 201) {
		switch id {
			case "181": namefromid := "Gold Jaheira Chest"
			case "182": namefromid := "Silver Nova Chest"
			case "183": namefromid := "Gold Nova Chest"
			case "184": namefromid := "Silver Freely Chest"
			case "185": namefromid := "Gold Freely Chest"
			case "186": namefromid := "Silver Beadle & Grimm Chest"
			case "187": namefromid := "Gold Beadle & Grimm Chest"
			case "188": namefromid := "Silver Omin Chest"
			case "189": namefromid := "Gold Omin Chest"
			case "190": namefromid := "Silver Lazaapz Chest"
			case "191": namefromid := "Gold Lazaapz Chest"
			case "192": namefromid := "Gold Lucky Chest"
			case "193": namefromid := "Gold Courageous Chest"
			case "194": namefromid := "Gold Heroic Chest"
			case "195": namefromid := "Gold Splattered Chest"
			case "196": namefromid := "Gold Magical Chest"
			case "197": namefromid := "Gold Versatile Chest"
			case "198": namefromid := "Gold Quest-Filled Chest"
			case "199": namefromid := "Gold Lowlands Chest"
			case "200": namefromid := "Gold Cloned Chest"
		}
	}
	else if (id < 221) {
		switch id {
			case "201": namefromid := "Gold Pristine Chest"
			case "202": namefromid := "Gold Dark Days Chest"
			case "203": namefromid := "Gold Dusty Chest"
			case "204": namefromid := "Gold Screened Chest"
			case "205": namefromid := "Gold Mithral Hall Chest (NOT USED)"
			case "206": namefromid := "Gold Hexed Chest"
			case "207": namefromid := "Gold Arkhan's Army Chest"
			case "208": namefromid := "Gold Stained Chest"
			case "209": namefromid := "Gold Broken Chest"
			case "210": namefromid := "Gold Arrow-Filled Chest"
			case "211": namefromid := "Gold Grubby Chest"
			case "212": namefromid := "Gold Ruby Chest"
			case "213": namefromid := "Gold Secret Chest"
			case "214": namefromid := "Gold Twothbrush Chest"
			case "215": namefromid := "Gold Packaged Chest"
			case "216": namefromid := "Gold Sprung Chest"
			case "217": namefromid := "Gold Shadow Chest"
			case "218": namefromid := "Gold Hooked Chest"
			case "219": namefromid := "Gold Strahd Patron Chest"
			case "220": namefromid := "Gold Extra-Golden Chest"
		}
	}
	else if (id < 241) {
		switch id {
			case "221": namefromid := "Gold Shelled Chest"
			case "222": namefromid := "Gold Hugged Chest"
			case "223": namefromid := "Gold Footprint Chest"
			case "224": namefromid := "Gold Armored Chest"
			case "225": namefromid := "Gold May Day Chest"
			case "226": namefromid := "Gold Solwynn Chest"
			case "227": namefromid := "Gold Hunted Chest"
			case "228": namefromid := "Gold Shielded Chest"
			case "229": namefromid := "Gold Pebbled Chest"
			case "230": namefromid := "Modron Component Chest"
			case "231": namefromid := "Gold Shifted Chest"
			case "232": namefromid := "Gold Kissed Chest"
			case "233": namefromid := "Gold Tartan Chest"
			case "234": namefromid := "Gold Legends Chest"
			case "235": namefromid := "Gold Wittled Chest"
			case "236": namefromid := "Gold Snakeskin Chest"
			case "237": namefromid := "Gold Book-End Chest"
			case "238": namefromid := "Gold Striking Chest"
			case "239": namefromid := "Gold Rainbowed Chest"
			case "240": namefromid := "Gold Whisker Chest"
		}
	}
	else if (id < 261) {
		switch id {
			case "241": namefromid := "Gold Egg Chest"
			case "242": namefromid := "Gold Undermountain Chest"
			case "243": namefromid := "Gold Historical Chest"
			case "244": namefromid := "Silver Torogar Chest"
			case "245": namefromid := "Gold Torogar Chest"
			case "246": namefromid := "Silver Ezmerelda Chest"
			case "247": namefromid := "Gold Ezmerelda Chest"
			case "248": namefromid := "Silver Penelope Chest"
			case "249": namefromid := "Gold Penelope Chest"
			case "250": namefromid := "Silver Lucius Chest"
			case "251": namefromid := "Gold Lucius Chest"
			case "252": namefromid := "Silver Baeloth Chest"
			case "253": namefromid := "Gold Baeloth Chest"
			case "254": namefromid := "Silver Talin Chest"
			case "255": namefromid := "Gold Talin Chest"
			case "256": namefromid := "Silver Hew Mann Chest"
			case "257": namefromid := "Gold Hew Mann Chest"
			case "258": namefromid := "Silver Orisha Chest"
			case "259": namefromid := "Gold Orisha Chest"
			case "260": namefromid := "Silver Alyndra Chest"
		}
	}
	else if (id < 281) {
		switch id {
			case "261": namefromid := "Gold Alyndra Chest"
			case "262": namefromid := "Silver Orkira Chest"
			case "263": namefromid := "Gold Orkira Chest"
			case "264": namefromid := "Silver Shaka Chest"
			case "265": namefromid := "Gold Shaka Chest"
			case "266": namefromid := "Silver Mehan Chest"
			case "267": namefromid := "Gold Mehan Chest"
			case "268": namefromid := "Silver Y4E13 Chest"
			case "269": namefromid := "Gold Y4E13 Chest"
			case "270": namefromid := "Silver Y4E14 Chest"
			case "271": namefromid := "Gold Y4E14 Chest"
			case "272": namefromid := "Silver Y4E15 Chest"
			case "273": namefromid := "Gold Y4E15 Chest"
			case "274": namefromid := "Silver Y4E16 Chest"
			case "275": namefromid := "Gold Y4E16 Chest"
			case "276": namefromid := "Silver Y4E17 Chest"
			case "277": namefromid := "Gold Y4E17 Chest"
			case "278": namefromid := "Gold Bold Chest"
			case "279": namefromid := "Gold Rime Chest"
			case "280": namefromid := "Gold Feathered Hat Chest"
		}
	}
	else if (id < 290) {
		switch id {
			case "281": namefromid := "Gold Experimental Chest"
			case "282": namefromid := "Electrum Chest"
			case "284": namefromid := "Gold Ichor Covered Chest"
			case "285": namefromid := "Gold Scrappy Chest"
			case "286": namefromid := "Gold Giant's Bane Chest"
			case "287": namefromid := "Gold Dragonscale Chest"
			case "288": namefromid := "Gold Maze Chest"
			case "289": namefromid := "Gold Freezing Chest"
		}
	}
	else {
		namefromid := "UNKNOWN (" id ")"
	}
	return namefromid
}

KlehoFromID(id) {
	if (id < 21) {
		switch id {
			case "14": namefromid := "3a23"
			case "15": namefromid := "4a44"
			case "16": namefromid := "5a49"
			case "17": namefromid := "6a64"
			case "19": namefromid := "7a84"
			case "20": namefromid := "8a89"
		}
	}
	else if (id < 41) {
		switch id {
			case "21": namefromid := "9a104"
			case "22": namefromid := "10a119"
			case "23": namefromid := "11a134"
			case "24": namefromid := "12a139"
			case "25": namefromid := "13a144"
			case "26": namefromid := "14a159"
			case "27": namefromid := "16a174"
			case "28": namefromid := "18a202"
			case "29": namefromid := "19a218"
			case "31": namefromid := "20a224"
			case "32": namefromid := "21a240"
			case "33": namefromid := "3a256"
			case "34": namefromid := "4a272"
			case "35": namefromid := "5a288"
			case "36": namefromid := "6a293"
			case "37": namefromid := "7a298"
			case "38": namefromid := "8a303"
			case "39": namefromid := "9a308"
			case "40": namefromid := "10a313"
		}
	}
	else if (id < 61) {
		switch id {
			case "41": namefromid := "11a318"
			case "42": namefromid := "12a323"
			case "43": namefromid := "13a328"
			case "44": namefromid := "14a333"
			case "45": namefromid := "16a338"
			case "46": namefromid := "18a343"
			case "47": namefromid := "19a348"
			case "48": namefromid := "20a353"
			case "49": namefromid := "21a358"
			case "50": namefromid := "3a438"
			case "51": namefromid := "4a443"
			case "52": namefromid := "5a448"
			case "53": namefromid := "6a453"
			case "54": namefromid := "7a458"
			case "55": namefromid := "8a463"
			case "56": namefromid := "9a468"
			case "57": namefromid := "10a473"
			case "58": namefromid := "11a478"
			case "59": namefromid := "12a483"
			case "60": namefromid := "13a488"
			}
	}
	else if (id < 81) {
		switch id {
			case "61": namefromid := "14a493"
			case "62": namefromid := "16a498"
			case "63": namefromid := "18a503"
			case "64": namefromid := "19a508"
			case "65": namefromid := "20a513"
			case "66": namefromid := "21a518"
			case "69": namefromid := "3a700"
			case "70": namefromid := "4a705"
			case "71": namefromid := "5a710"
			case "72": namefromid := "6a715"
			case "73": namefromid := "7a720"
			case "74": namefromid := "8a725"
			case "75": namefromid := "9a730"
			case "76": namefromid := "10a735"
			case "77": namefromid := "11a740"
			case "78": namefromid := "12a745"
			case "79": namefromid := "13a750"
			case "80": namefromid := "14a755"
		}
	}
	else if (id < 86) {
		switch id {
			case "81": namefromid := "16a760"
			case "82": namefromid := "18a765"
			case "83": namefromid := "19a770"
			case "84": namefromid := "20a775"
			case "85": namefromid := "21a780"
		}
	}
	else {
		namefromid := "UNKNOWN (" id ")"
	}
	return namefromid
}

ChestIDFromChampID(id) {
	if (id < 21) {
		switch id {
			case "14": chestfromchamp := "4"
			case "15": chestfromchamp := "6"
			case "16": chestfromchamp := "8"
			case "17": chestfromchamp := "10"
			case "19": chestfromchamp := "12"
			case "20": chestfromchamp := "17"
		}
	}
	else if (id < 41) {
		switch id {
			case "21": chestfromchamp := "19"
			case "22": chestfromchamp := "22"
			case "23": chestfromchamp := "27"
			case "24": chestfromchamp := "30"
			case "25": chestfromchamp := "36"
			case "26": chestfromchamp := "41"
			case "27": chestfromchamp := "46"
			case "28": chestfromchamp := "54"
			case "29": chestfromchamp := "56"
			case "31": chestfromchamp := "58"
			case "32": chestfromchamp := "68"
			case "33": chestfromchamp := "72"
			case "34": chestfromchamp := "74"
			case "35": chestfromchamp := "76"
			case "36": chestfromchamp := "82"
			case "37": chestfromchamp := "84"
			case "38": chestfromchamp := "86"
			case "39": chestfromchamp := "88"
			case "40": chestfromchamp := "90"
		}
	}
	else if (id < 61) {
		switch id {
			case "41": chestfromchamp := "92"
			case "42": chestfromchamp := "94"
			case "43": chestfromchamp := "96"
			case "44": chestfromchamp := "98"
			case "45": chestfromchamp := "100"
			case "46": chestfromchamp := "102"
			case "47": chestfromchamp := "104"
			case "48": chestfromchamp := "106"
			case "49": chestfromchamp := "108"
			case "50": chestfromchamp := "159"
			case "51": chestfromchamp := "161"
			case "52": chestfromchamp := "163"
			case "53": chestfromchamp := "165"
			case "54": chestfromchamp := "167"
			case "55": chestfromchamp := "169"
			case "56": chestfromchamp := "171"
			case "57": chestfromchamp := "173"
			case "58": chestfromchamp := "175"
			case "59": chestfromchamp := "177"
			case "60": chestfromchamp := "179"
			}
	}
	else if (id < 81) {
		switch id {
			case "61": chestfromchamp := "181"
			case "62": chestfromchamp := "183"
			case "63": chestfromchamp := "185"
			case "64": chestfromchamp := "187"
			case "65": chestfromchamp := "189"
			case "66": chestfromchamp := "191"
			case "69": chestfromchamp := "245"
			case "70": chestfromchamp := "247"
			case "71": chestfromchamp := "249"
			case "72": chestfromchamp := "251"
			case "73": chestfromchamp := "253"
			case "74": chestfromchamp := "255"
			case "75": chestfromchamp := "257"
			case "76": chestfromchamp := "259"
			case "77": chestfromchamp := "261"
			case "78": chestfromchamp := "263"
			case "79": chestfromchamp := "265"
			case "80": chestfromchamp := "267"
		}
	}
	else if (id < 86) {
		switch id {
			case "81": chestfromchamp := "269"
			case "82": chestfromchamp := "271"
			case "93": chestfromchamp := "273"
			case "84": chestfromchamp := "275"
			case "85": chestfromchamp := "277"
		}
	}
	else {
		chestfromchamp := "UNKNOWN (" id ")"
	}
	return chestfromchamp
}