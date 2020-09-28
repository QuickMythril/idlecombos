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
	return namefromid
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
	return namefromid
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
	return namefromid
	}
	else if (id < 81) {
		switch id {
			case "61": namefromid := "Jaheira"
			case "62": namefromid := "Nova"
			case "63": namefromid := "Freely"
			case "64": namefromid := "B & G"
			case "65": namefromid := "Omin"
			case "66": namefromid := "Lazaapz"
			case "67": namefromid := "Dragonbait"
			case "68": namefromid := "Ulkoria"
			case "69": namefromid := "Torogar"
			case "70": namefromid := "Ezmerelda"
			case "71": namefromid := "Y4E3"
			case "72": namefromid := "Y4E4"
			case "73": namefromid := "Y4E5"
			case "74": namefromid := "Y4E6"
			case "75": namefromid := "Y4E7"
			case "76": namefromid := "Y4E8"
			case "77": namefromid := "Y4E9"
			case "78": namefromid := "Y4E10"
			case "79": namefromid := "Y4E11"
			case "80": namefromid := "Y4E12"
		}
	return namefromid
	}
	else if (id < 86) {
		switch id {
			case "81": namefromid := "Y4E13"
			case "82": namefromid := "Y4E14"
			case "83": namefromid := "Y4E15"
			case "84": namefromid := "Y4E16"
			case "85": namefromid := "Y4E17"
		}
	return namefromid
	}
	else {
		namefromid := "UNKNOWN"
		return namefromid
	}
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
	return namefromid
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
	return namefromid
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
	return namefromid
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
	return namefromid
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
	return namefromid
	}
	else if (id < 447) {
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
		}
	return namefromid
	}
	else {
		namefromid := "UNKNOWN"
		return namefromid
	}
}