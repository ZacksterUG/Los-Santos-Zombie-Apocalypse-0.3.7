///////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
////\/\/\/\/\/\/\\/\/\//\/\/\/\/\/\\\/\\/\/\/\/\/\//\/\/\/\/\//\/\/\\/\/\
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
///X P       F O R       R A N K     F R O M       4 0  -   1 0 0
	{
		case 40: PInfo[playerid][XPToRankUp] = 85000;
        case 41: PInfo[playerid][XPToRankUp] = 90000;
        case 42: PInfo[playerid][XPToRankUp] = 95000;
        case 43: PInfo[playerid][XPToRankUp] = 100000;
        case 44: PInfo[playerid][XPToRankUp] = 105000;
        case 45: PInfo[playerid][XPToRankUp] = 110000;
        case 46: PInfo[playerid][XPToRankUp] = 120000;
        case 47: PInfo[playerid][XPToRankUp] = 140000;
        case 48: PInfo[playerid][XPToRankUp] = 160000;
        case 49: PInfo[playerid][XPToRankUp] = 180000;
        case 50: PInfo[playerid][XPToRankUp] = 200000;
		case 51: PInfo[playerid][XPToRankUp] = 225000;
		case 52: PInfo[playerid][XPToRankUp] = 250000;
		case 53: PInfo[playerid][XPToRankUp] = 275000;
		case 54: PInfo[playerid][XPToRankUp] = 300000;
		case 55: PInfo[playerid][XPToRankUp] = 325000;
		case 56: PInfo[playerid][XPToRankUp] = 350000;
		case 57: PInfo[playerid][XPToRankUp] = 375000;
		case 58: PInfo[playerid][XPToRankUp] = 400000;
		case 59: PInfo[playerid][XPToRankUp] = 425000;
		case 60: PInfo[playerid][XPToRankUp] = 450000;
		case 61: PInfo[playerid][XPToRankUp] = 500000;
		case 62: PInfo[playerid][XPToRankUp] = 550000;
		case 63: PInfo[playerid][XPToRankUp] = 600000;
		case 64: PInfo[playerid][XPToRankUp] = 650000;
		case 65: PInfo[playerid][XPToRankUp] = 700000;
		case 66: PInfo[playerid][XPToRankUp] = 750000;
		case 67: PInfo[playerid][XPToRankUp] = 800000;
		case 68: PInfo[playerid][XPToRankUp] = 850000;
		case 69: PInfo[playerid][XPToRankUp] = 900000;
		case 70: PInfo[playerid][XPToRankUp] = 1000000;
		case 71: PInfo[playerid][XPToRankUp] = 1100000;
		case 72: PInfo[playerid][XPToRankUp] = 1200000;
		case 73: PInfo[playerid][XPToRankUp] = 1300000;
		case 74: PInfo[playerid][XPToRankUp] = 1400000;
		case 75: PInfo[playerid][XPToRankUp] = 1500000;
		case 76: PInfo[playerid][XPToRankUp] = 1600000;
		case 77: PInfo[playerid][XPToRankUp] = 1700000;
		case 78: PInfo[playerid][XPToRankUp] = 1800000;
		case 79: PInfo[playerid][XPToRankUp] = 1900000;
		case 80: PInfo[playerid][XPToRankUp] = 2000000;
		case 81: PInfo[playerid][XPToRankUp] = 2250000;
		case 82: PInfo[playerid][XPToRankUp] = 2500000;
		case 83: PInfo[playerid][XPToRankUp] = 2750000;
		case 84: PInfo[playerid][XPToRankUp] = 3000000;
		case 85: PInfo[playerid][XPToRankUp] = 3250000;
        case 86: PInfo[playerid][XPToRankUp] = 3500000;
        case 87: PInfo[playerid][XPToRankUp] = 3750000;
        case 88: PInfo[playerid][XPToRankUp] = 4000000;
        case 89: PInfo[playerid][XPToRankUp] = 4250000;
        case 90: PInfo[playerid][XPToRankUp] = 4500000;
        case 91: PInfo[playerid][XPToRankUp] = 5000000;
        case 92: PInfo[playerid][XPToRankUp] = 5500000;
        case 93: PInfo[playerid][XPToRankUp] = 6000000;
        case 94: PInfo[playerid][XPToRankUp] = 6500000;
        case 95: PInfo[playerid][XPToRankUp] = 7000000;
        case 96: PInfo[playerid][XPToRankUp] = 7500000;
        case 97: PInfo[playerid][XPToRankUp] = 8000000;
        case 98: PInfo[playerid][XPToRankUp] = 8500000;
        case 99: PInfo[playerid][XPToRankUp] = 9000000;
        case 100: PInfo[playerid][XPToRankUp] = 10000000;
	}
	////////////////\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\///\//\/////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////
	//////N E W     R A N K      W E A P O N S
	//////
	
 		if(Team[playerid] == ZOMBIE) return 0;
	    switch(PInfo[playerid][Rank])
		{
		    case 1: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,23,60),GivePlayerWeapon(playerid,2,1); //Silenced Pistol + Knuckles + Cane
		    case 2: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,23,110),GivePlayerWeapon(playerid,2,1);//Silenced Pistol + Knuckles + Cane
		    case 3: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,23,160),GivePlayerWeapon(playerid,7,1);//Silenced Pistol + Knuckles + Billiard Cue
		    case 4: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,23,190),GivePlayerWeapon(playerid,7,1);//Silenced Pistol + Knuckles + Billiard Cue
		    case 5: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,100),GivePlayerWeapon(playerid,7,1);//2 dual pistols + Knuckles + Billiard Cue
		    case 6: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,150),GivePlayerWeapon(playerid,7,1);//2 dual pistols + Knuckles + Billiard Cue
		    case 7: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,200),GivePlayerWeapon(playerid,7,1);//2 dual pistols + Knuckles + Billiard Cue
		    case 8: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,250),GivePlayerWeapon(playerid,7,1);//2 dual pistols + Knuckles + Billiard Cue
		    case 9: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,300),GivePlayerWeapon(playerid,6,1);//2 dual pistols + Knuckles + shovel
		    case 10: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,400),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,50);//2 dual pistols + Knuckles + shovel+shotgun
		    case 11: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,500),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,100);//2 dual pistols + Knuckles + shovel+shotgun
		    case 12: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,600),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,150);//2 dual pistols + Knuckles + shovel+shotgun
		    case 13: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,700),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,200);//2 dual pistols +Knuckles + shovel+Shotgun
		    case 14: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,800),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,250);//2 dual pistols +Knuckles + BaseBall Bat + Shotgun
		    case 15: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,100),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,500);//Deagle +Knuckles + BaseBall Bat + Shotgun
		    case 16: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,200),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,750);//Deagle +Knuckles + BaseBall Bat + Shotgun
		    case 17: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,300),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,1000);//Deagle +Knuckles + BaseBall Bat + Shotgun
		    case 18: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,400),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,1250);//Deagle +Knuckles + BaseBall Bat + Shotgun
		    case 19: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,500),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,1500);//Deagle +Knuckles + knife + Shotgun
		    case 20: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,650),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,2000),GivePlayerWeapon(playerid,28,150),GivePlayerWeapon(playerid,33,50); //Deagle +Knuckles + knife + Shotgun + UZIS + rifle
		    case 21: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,800),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,2500),GivePlayerWeapon(playerid,28,200),GivePlayerWeapon(playerid,33,100); //Deagle +Knuckles + knife + Shotgun + UZIS+ rifle
		    case 22: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,1050),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,3000),GivePlayerWeapon(playerid,28,250),GivePlayerWeapon(playerid,33,150); //Deagle +Knuckles + knife + Shotgun + UZIS+ rifle
		    case 23: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,1200),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,3500),GivePlayerWeapon(playerid,28,300),GivePlayerWeapon(playerid,33,200); //Deagle +Knuckles + knife + Shotgun + UZIS + rifle
		    case 24: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,1350),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,25,4000),GivePlayerWeapon(playerid,28,350),GivePlayerWeapon(playerid,33,250); //Deagle +Knuckles + Night Stick + Shotgun + UZIS + rifle
		    case 25: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,1600),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,26,300),GivePlayerWeapon(playerid,28,400),GivePlayerWeapon(playerid,33,300); //Deagle +Knuckles + Night Stick + Sawn-off Shotgun + UZIS + rifle
		    case 26: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,1800),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,26,400),GivePlayerWeapon(playerid,28,500),GivePlayerWeapon(playerid,33,400); //Deagle +Knuckles + Night Stick + Sawn-off Shotgun + UZIS + rifle
		    case 27: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,2000),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,26,500),GivePlayerWeapon(playerid,28,600),GivePlayerWeapon(playerid,33,500); //Deagle +Knuckles + Night Stick + Sawn-off Shotgun + UZIS + rifle
		    case 28: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,2200),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,26,600),GivePlayerWeapon(playerid,28,700),GivePlayerWeapon(playerid,33,600); //Deagle +Knuckles + Night Stick + Sawn-off Shotgun + UZIS + rifle
		    case 29: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,2400),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,700),GivePlayerWeapon(playerid,28,800),GivePlayerWeapon(playerid,33,700); //Deagle +Knuckles + Katana + Sawn-off Shotgun + UZIS + rifle
		    case 30: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,2700),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,1000),GivePlayerWeapon(playerid,32,300),GivePlayerWeapon(playerid,30,120),GivePlayerWeapon(playerid,33,900); //Deagle +Knuckles + Katana + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
			case 31: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,3000),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,1300),GivePlayerWeapon(playerid,32,400),GivePlayerWeapon(playerid,30,180),GivePlayerWeapon(playerid,33,1100); //Deagle +Knuckles + Katana + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
			case 32: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,3300),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,1600),GivePlayerWeapon(playerid,32,500),GivePlayerWeapon(playerid,30,240),GivePlayerWeapon(playerid,33,1300); //Deagle +Knuckles + Katana + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
            case 33: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,3600),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,1900),GivePlayerWeapon(playerid,32,600),GivePlayerWeapon(playerid,30,300),GivePlayerWeapon(playerid,33,1500); //Deagle +Knuckles + Katana + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
            case 34: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,3900),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,26,2200),GivePlayerWeapon(playerid,32,700),GivePlayerWeapon(playerid,30,360),GivePlayerWeapon(playerid,33,1700); //Deagle +Knuckles + ChainSaw + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
            case 35: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,4500),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,400),GivePlayerWeapon(playerid,32,1000),GivePlayerWeapon(playerid,30,420),GivePlayerWeapon(playerid,33,2000); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 36: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,5000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,500),GivePlayerWeapon(playerid,32,1250),GivePlayerWeapon(playerid,30,540),GivePlayerWeapon(playerid,33,2300); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 37: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,5500),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,600),GivePlayerWeapon(playerid,32,1500),GivePlayerWeapon(playerid,30,660),GivePlayerWeapon(playerid,33,2600); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 38: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,6000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,700),GivePlayerWeapon(playerid,32,1750),GivePlayerWeapon(playerid,30,880),GivePlayerWeapon(playerid,33,2900); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 39: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,6500),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,800),GivePlayerWeapon(playerid,32,2000),GivePlayerWeapon(playerid,30,1100),GivePlayerWeapon(playerid,33,3200); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 40: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,6500),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,1000),GivePlayerWeapon(playerid,32,2500),GivePlayerWeapon(playerid,31,200),GivePlayerWeapon(playerid,33,3600); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 41: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,7000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,1500),GivePlayerWeapon(playerid,32,3000),GivePlayerWeapon(playerid,31,350),GivePlayerWeapon(playerid,33,4000); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + M4A1 + rifle
			case 42: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,8000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,2000),GivePlayerWeapon(playerid,32,3500),GivePlayerWeapon(playerid,31,500),GivePlayerWeapon(playerid,33,4400); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + M4A1 + rifle
			case 43: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,9000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,2500),GivePlayerWeapon(playerid,32,4000),GivePlayerWeapon(playerid,31,650),GivePlayerWeapon(playerid,33,4800); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + M4A1 + rifle
			case 44: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,10000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,3000),GivePlayerWeapon(playerid,32,4500),GivePlayerWeapon(playerid,31,800),GivePlayerWeapon(playerid,33,5200); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + M4A1 + rifle
			case 45: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,11000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,4000),GivePlayerWeapon(playerid,29,600),GivePlayerWeapon(playerid,31,1000),GivePlayerWeapon(playerid,34,150); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 46: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,12000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,5000),GivePlayerWeapon(playerid,29,800),GivePlayerWeapon(playerid,31,1250),GivePlayerWeapon(playerid,34,300); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 47: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,13000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,6000),GivePlayerWeapon(playerid,29,1000),GivePlayerWeapon(playerid,31,1500),GivePlayerWeapon(playerid,34,450); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 48: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,14000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,7000),GivePlayerWeapon(playerid,29,1200),GivePlayerWeapon(playerid,31,1750),GivePlayerWeapon(playerid,34,600); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 49: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,15000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,8000),GivePlayerWeapon(playerid,29,1400),GivePlayerWeapon(playerid,31,2000),GivePlayerWeapon(playerid,34,750); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 50: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,16000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,10000),GivePlayerWeapon(playerid,29,1750),GivePlayerWeapon(playerid,31,2500),GivePlayerWeapon(playerid,34,1000); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 51..100: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,17000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,12500),GivePlayerWeapon(playerid,29,2100),GivePlayerWeapon(playerid,31,3000),GivePlayerWeapon(playerid,34,1250); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
		}
