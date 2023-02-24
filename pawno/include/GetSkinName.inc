stock GetSkinName(skinid)
{
	new returnt[64];
	switch(skinid)
	{
		case 0	: { format(returnt,sizeof(returnt),  "Carl CJ Johnson"); }
		case 1	: { format(returnt,sizeof(returnt),  "The Truth"); }
		case 2	: { format(returnt,sizeof(returnt),  "Maccer"); }
		case 3	: { format(returnt,sizeof(returnt),  "INVALID_SKIN_ID"); }
		case 4	: { format(returnt,sizeof(returnt),  "INVALID_SKIN_ID"); }
		case 5	: { format(returnt,sizeof(returnt),  "INVALID_SKIN_ID"); }
		case 6	: { format(returnt,sizeof(returnt),  "INVALID_SKIN_ID"); }
		case 7	: { format(returnt,sizeof(returnt),  "Taxi Driver/Train Driver"); }
		case 8	: { format(returnt,sizeof(returnt),  "INVALID_SKIN_ID"); }
		case 9	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 10	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 11	: { format(returnt,sizeof(returnt),  "Casino Worker"); }
		case 12	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 13	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 14	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 15	: { format(returnt,sizeof(returnt),  "RS Haul Owner"); }
		case 16	: { format(returnt,sizeof(returnt),  "Airport Ground Worker"); }
		case 17	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 18	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 19	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 20	: { format(returnt,sizeof(returnt),  "Madd Dogg's Manager"); }
		case 21	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 22	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 23	: { format(returnt,sizeof(returnt),  "BMXer"); }
		case 24	: { format(returnt,sizeof(returnt),  "Madd Dogg Bodyguard"); }
		case 25	: { format(returnt,sizeof(returnt),  "Madd Dogg Bodyguard"); }
		case 26	: { format(returnt,sizeof(returnt),  "Mountain Climber"); }
		case 27	: { format(returnt,sizeof(returnt),  "Builder"); }
		case 28	: { format(returnt,sizeof(returnt),  "Drug Dealer"); }
		case 29	: { format(returnt,sizeof(returnt),  "Drug Dealer"); }
		case 30	: { format(returnt,sizeof(returnt),  "Drug Dealer"); }
		case 31	: { format(returnt,sizeof(returnt),  "Farm-Town inhabitant"); }
		case 32	: { format(returnt,sizeof(returnt),  "Farm-Town inhabitant"); }
		case 33	: { format(returnt,sizeof(returnt),  "Farm-Town inhabitant"); }
		case 34	: { format(returnt,sizeof(returnt),  "Farm-Town inhabitant"); }
		case 35	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 36	: { format(returnt,sizeof(returnt),  "Golfer"); }
		case 37	: { format(returnt,sizeof(returnt),  "Golfer"); }
		case 38	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 39	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 40	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 41	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 42	: { format(returnt,sizeof(returnt),  "INVALID_SKIN_ID"); }
		case 43	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 44	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 45	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 46	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 47	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 48	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 49	: { format(returnt,sizeof(returnt),  "Snakehead (Da Nang)"); }
		case 50	: { format(returnt,sizeof(returnt),  "Mechanic"); }
		case 51	: { format(returnt,sizeof(returnt),  "Mountain Biker"); }
		case 52	: { format(returnt,sizeof(returnt),  "Mountain Biker"); }
		case 53	: { format(returnt,sizeof(returnt),  "INVALID_SKIN_ID"); }
		case 54	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 55	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 56	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 57	: { format(returnt,sizeof(returnt),  "Feds"); }
		case 58	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 59	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 60	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 61	: { format(returnt,sizeof(returnt),  "Pilot"); }
		case 62	: { format(returnt,sizeof(returnt),  "Colonel Fuhrberger"); }
		case 63	: { format(returnt,sizeof(returnt),  "Prostitute"); }
		case 64	: { format(returnt,sizeof(returnt),  "Prostitute"); }
		case 65	: { format(returnt,sizeof(returnt),  "INVALID_SKIN_ID"); }
		case 66	: { format(returnt,sizeof(returnt),  "Pool Player"); }
		case 67	: { format(returnt,sizeof(returnt),  "Pool Player"); }
		case 68	: { format(returnt,sizeof(returnt),  "Priest"); }
		case 69	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 70	: { format(returnt,sizeof(returnt),  "Scientist"); }
		case 71	: { format(returnt,sizeof(returnt),  "Security Guard"); }
		case 72	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 73	: { format(returnt,sizeof(returnt),  "Jethro"); }
		case 74	: { format(returnt,sizeof(returnt),  "INVALID_SKIN_ID"); }
		case 75	: { format(returnt,sizeof(returnt),  "Prostitute"); }
		case 76	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 77	: { format(returnt,sizeof(returnt),  "Homeless"); }
		case 78	: { format(returnt,sizeof(returnt),  "Homeless"); }
		case 79	: { format(returnt,sizeof(returnt),  "Homeless"); }
		case 80	: { format(returnt,sizeof(returnt),  "Boxer"); }
		case 81	: { format(returnt,sizeof(returnt),  "Boxer"); }
		case 82	: { format(returnt,sizeof(returnt),  "Elvis Wannabe"); }
		case 83	: { format(returnt,sizeof(returnt),  "Elvis Wannabe"); }
		case 84	: { format(returnt,sizeof(returnt),  "Elvis Wannabe"); }
		case 85	: { format(returnt,sizeof(returnt),  "Prostitute"); }
		case 86	: { format(returnt,sizeof(returnt),  "INVALID_SKIN_ID"); }
		case 87	: { format(returnt,sizeof(returnt),  "Whore"); }
		case 88	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 89	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 90	: { format(returnt,sizeof(returnt),  "Whore"); }
		case 91	: { format(returnt,sizeof(returnt),  "INVALID_SKIN_ID"); }
		case 92	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 93	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 94	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 95	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 96	: { format(returnt,sizeof(returnt),  "Jogger"); }
		case 97	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 98	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 99	: { format(returnt,sizeof(returnt),  "Skeelering"); }
		case 100	: { format(returnt,sizeof(returnt),  "Biker"); }
		case 101	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 102	: { format(returnt,sizeof(returnt),  "Balla"); }
		case 103	: { format(returnt,sizeof(returnt),  "Balla"); }
		case 104	: { format(returnt,sizeof(returnt),  "Balla"); }
		case 105	: { format(returnt,sizeof(returnt),  "Grove Street Families"); }
		case 106	: { format(returnt,sizeof(returnt),  "Grove Street Families"); }
		case 107	: { format(returnt,sizeof(returnt),  "Grove Street Families"); }
		case 108	: { format(returnt,sizeof(returnt),  "Los Santos Vagos"); }
		case 109	: { format(returnt,sizeof(returnt),  "Los Santos Vagos"); }
		case 110	: { format(returnt,sizeof(returnt),  "Los Santos Vagos"); }
		case 111	: { format(returnt,sizeof(returnt),  "The Russian Mafia"); }
		case 112	: { format(returnt,sizeof(returnt),  "The Russian Mafia"); }
		case 113	: { format(returnt,sizeof(returnt),  "The Russian Mafia"); }
		case 114	: { format(returnt,sizeof(returnt),  "Varios Los Aztecas"); }
		case 115	: { format(returnt,sizeof(returnt),  "Varios Los Aztecas"); }
		case 116	: { format(returnt,sizeof(returnt),  "Varios Los Aztecas"); }
		case 117	: { format(returnt,sizeof(returnt),  "Traid"); }
		case 118	: { format(returnt,sizeof(returnt),  "Traid"); }
		case 119	: { format(returnt,sizeof(returnt),  "INVALID_SKIN_ID"); }
		case 120	: { format(returnt,sizeof(returnt),  "Traid"); }
		case 121	: { format(returnt,sizeof(returnt),  "Da Nang Boy"); }
		case 122	: { format(returnt,sizeof(returnt),  "Da Nang Boy"); }
		case 123	: { format(returnt,sizeof(returnt),  "Da Nang Boy"); }
		case 124	: { format(returnt,sizeof(returnt),  "The Mafia"); }
		case 125	: { format(returnt,sizeof(returnt),  "The Mafia"); }
		case 126	: { format(returnt,sizeof(returnt),  "The Mafia"); }
		case 127	: { format(returnt,sizeof(returnt),  "The Mafia"); }
		case 128	: { format(returnt,sizeof(returnt),  "Farm Inhabitant"); }
		case 129	: { format(returnt,sizeof(returnt),  "Farm Inhabitant"); }
		case 130	: { format(returnt,sizeof(returnt),  "Farm Inhabitant"); }
		case 131	: { format(returnt,sizeof(returnt),  "Farm Inhabitant"); }
		case 132	: { format(returnt,sizeof(returnt),  "Farm Inhabitant"); }
		case 133	: { format(returnt,sizeof(returnt),  "Farm Inhabitant"); }
		case 134	: { format(returnt,sizeof(returnt),  "Homeless"); }
		case 135	: { format(returnt,sizeof(returnt),  "Homeless"); }
		case 136	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 137	: { format(returnt,sizeof(returnt),  "Homeless"); }
		case 138	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 139	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 140	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 141	: { format(returnt,sizeof(returnt),  "Office Worker"); }
		case 142	: { format(returnt,sizeof(returnt),  "Taxi Driver"); }
		case 143	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 144	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 145	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 146	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 147	: { format(returnt,sizeof(returnt),  "Director"); }
		case 148	: { format(returnt,sizeof(returnt),  "Secretary"); }
		case 149	: { format(returnt,sizeof(returnt),  "INVALID_SKIN_ID"); }
		case 150	: { format(returnt,sizeof(returnt),  "Secretary"); }
		case 151	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 152	: { format(returnt,sizeof(returnt),  "Prostitute"); }
		case 153	: { format(returnt,sizeof(returnt),  "Coffee mam'"); }
		case 154	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 155	: { format(returnt,sizeof(returnt),  "Well Stacked Pizza"); }
		case 156	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 157	: { format(returnt,sizeof(returnt),  "Farmer"); }
		case 158	: { format(returnt,sizeof(returnt),  "Farmer"); }
		case 159	: { format(returnt,sizeof(returnt),  "Farmer"); }
		case 160	: { format(returnt,sizeof(returnt),  "Farmer"); }
		case 161	: { format(returnt,sizeof(returnt),  "Farmer"); }
		case 162	: { format(returnt,sizeof(returnt),  "Farmer"); }
		case 163	: { format(returnt,sizeof(returnt),  "Bouncer"); }
		case 164	: { format(returnt,sizeof(returnt),  "Bouncer"); }
		case 165	: { format(returnt,sizeof(returnt),  "MIB Agent"); }
		case 166	: { format(returnt,sizeof(returnt),  "MIB Agent"); }
		case 167	: { format(returnt,sizeof(returnt),  "Cluckin' Bell"); }
		case 168	: { format(returnt,sizeof(returnt),  "Food Vendor"); }
		case 169	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 170	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 171	: { format(returnt,sizeof(returnt),  "Casino Worker"); }
		case 172	: { format(returnt,sizeof(returnt),  "Hotel Services"); }
		case 173	: { format(returnt,sizeof(returnt),  "San Fierro Rifa"); }
		case 174	: { format(returnt,sizeof(returnt),  "San Fierro Rifa"); }
		case 175	: { format(returnt,sizeof(returnt),  "San Fierro Rifa"); }
		case 176	: { format(returnt,sizeof(returnt),  "Tatoo Shop"); }
		case 177	: { format(returnt,sizeof(returnt),  "Tatoo Shop"); }
		case 178	: { format(returnt,sizeof(returnt),  "Whore"); }
		case 179	: { format(returnt,sizeof(returnt),  "Ammu-Nation Salesmen"); }
		case 180	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 181	: { format(returnt,sizeof(returnt),  "Punker"); }
		case 182	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 183	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 184	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 185	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 186	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 187	: { format(returnt,sizeof(returnt),  "Buisnessman"); }
		case 188	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 189	: { format(returnt,sizeof(returnt),  "Valet"); }
		case 190	: { format(returnt,sizeof(returnt),  "Barbara Schternvart"); }
		case 191	: { format(returnt,sizeof(returnt),  "Helena Wankstein"); }
		case 192	: { format(returnt,sizeof(returnt),  "Michelle Cannes"); }
		case 193	: { format(returnt,sizeof(returnt),  "Katie Zhan"); }
		case 194	: { format(returnt,sizeof(returnt),  "Millie Perkins"); }
		case 195	: { format(returnt,sizeof(returnt),  "Denise Robinson"); }
		case 196	: { format(returnt,sizeof(returnt),  "Farm-Town inhabitant"); }
		case 197	: { format(returnt,sizeof(returnt),  "Farm-Town inhabitant"); }
		case 198	: { format(returnt,sizeof(returnt),  "Farm-Town inhabitant"); }
		case 199	: { format(returnt,sizeof(returnt),  "Farm-Town inhabitant"); }
		case 200	: { format(returnt,sizeof(returnt),  "Farmer"); }
		case 201	: { format(returnt,sizeof(returnt),  "Farmer"); }
		case 202	: { format(returnt,sizeof(returnt),  "Farmer"); }
		case 203	: { format(returnt,sizeof(returnt),  "Karate Teacher"); }
		case 204	: { format(returnt,sizeof(returnt),  "Karate Teacher"); }
		case 205	: { format(returnt,sizeof(returnt),  "Burger Shot Cashier"); }
		case 206	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 207	: { format(returnt,sizeof(returnt),  "Prostitute"); }
		case 208	: { format(returnt,sizeof(returnt),  "Well Stacked Pizza"); }
		case 209	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 210	: { format(returnt,sizeof(returnt),  "INVALID_SKIN_ID"); }
		case 211	: { format(returnt,sizeof(returnt),  "Shop Staff"); }
		case 212	: { format(returnt,sizeof(returnt),  "Homeless"); }
		case 213	: { format(returnt,sizeof(returnt),  "Weird old man"); }
		case 214	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 215	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 216	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 217	: { format(returnt,sizeof(returnt),  "Shop Staff"); }
		case 218	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 219	: { format(returnt,sizeof(returnt),  "Secretary"); }
		case 220	: { format(returnt,sizeof(returnt),  "Taxi Driver"); }
		case 221	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 222	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 223	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 224	: { format(returnt,sizeof(returnt),  "Sofori"); }
		case 225	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 226	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 227	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 228	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 229	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 230	: { format(returnt,sizeof(returnt),  "Homeless"); }
		case 231	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 232	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 233	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 234	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 235	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 236	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 237	: { format(returnt,sizeof(returnt),  "Prostitute"); }
		case 238	: { format(returnt,sizeof(returnt),  "Prostitute"); }
		case 239	: { format(returnt,sizeof(returnt),  "Homeless"); }
		case 240	: { format(returnt,sizeof(returnt),  "The D.A"); }
		case 241	: { format(returnt,sizeof(returnt),  "Afro-American"); }
		case 242	: { format(returnt,sizeof(returnt),  "Mexican"); }
		case 243	: { format(returnt,sizeof(returnt),  "Prostitute"); }
		case 244	: { format(returnt,sizeof(returnt),  "Whore"); }
		case 245	: { format(returnt,sizeof(returnt),  "Prostitute"); }
		case 246	: { format(returnt,sizeof(returnt),  "Whore"); }
		case 247	: { format(returnt,sizeof(returnt),  "Biker"); }
		case 248	: { format(returnt,sizeof(returnt),  "Biker"); }
		case 249	: { format(returnt,sizeof(returnt),  "Pimp"); }
		case 250	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 251	: { format(returnt,sizeof(returnt),  "Beach Visitor"); }
		case 252	: { format(returnt,sizeof(returnt),  "Naked Valet"); }
		case 253	: { format(returnt,sizeof(returnt),  "Bus Driver"); }
		case 254	: { format(returnt,sizeof(returnt),  "Drug Dealer"); }
		case 255	: { format(returnt,sizeof(returnt),  "Limo Driver"); }
		case 256	: { format(returnt,sizeof(returnt),  "Whore"); }
		case 257	: { format(returnt,sizeof(returnt),  "Whore"); }
		case 258	: { format(returnt,sizeof(returnt),  "Golfer"); }
		case 259	: { format(returnt,sizeof(returnt),  "Golfer"); }
		case 260	: { format(returnt,sizeof(returnt),  "Construction Site"); }
		case 261	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 262	: { format(returnt,sizeof(returnt),  "Taxi Driver"); }
		case 263	: { format(returnt,sizeof(returnt),  "Normal Ped"); }
		case 264	: { format(returnt,sizeof(returnt),  "Clown"); }
		case 265	: { format(returnt,sizeof(returnt),  "Tenpenny"); }
		case 266	: { format(returnt,sizeof(returnt),  "Pulaski"); }
		case 267	: { format(returnt,sizeof(returnt),  "Officer Frank Tenpenny (Crooked Cop)"); }
		case 268	: { format(returnt,sizeof(returnt),  "Dwaine"); }
		case 269	: { format(returnt,sizeof(returnt),  "Melvin Big Smoke Harris"); }
		case 270	: { format(returnt,sizeof(returnt),  "Sweet "); }
		case 271	: { format(returnt,sizeof(returnt),  "Lance Ryder Wilson"); }
		case 272	: { format(returnt,sizeof(returnt),  "Mafia Boss"); }
		case 273	: { format(returnt,sizeof(returnt),  "INVALID_SKIN_ID"); }
		case 274	: { format(returnt,sizeof(returnt),  "Paramedic"); }
		case 275	: { format(returnt,sizeof(returnt),  "Paramedic"); }
		case 276	: { format(returnt,sizeof(returnt),  "Paramedic"); }
		case 277	: { format(returnt,sizeof(returnt),  "Firefighter"); }
		case 278	: { format(returnt,sizeof(returnt),  "Firefighter"); }
		case 279	: { format(returnt,sizeof(returnt),  "Firefighter"); }
		case 280	: { format(returnt,sizeof(returnt),  "Los Santos Police"); }
		case 281	: { format(returnt,sizeof(returnt),  "San Fierro Police"); }
		case 282	: { format(returnt,sizeof(returnt),  "Las Venturas Police"); }
		case 283	: { format(returnt,sizeof(returnt),  "Country Sheriff"); }
		case 284	: { format(returnt,sizeof(returnt),  "San Andreas Police Dept."); }
		case 285	: { format(returnt,sizeof(returnt),  "S.W.A.T Special Forces"); }
		case 286	: { format(returnt,sizeof(returnt),  "Federal Agents"); }
		case 287	: { format(returnt,sizeof(returnt),  "San Andreas Army"); }
		case 288	: { format(returnt,sizeof(returnt),  "Desert Sheriff"); }
		case 289	: { format(returnt,sizeof(returnt),  "INVALID_SKIN_ID"); }
		case 290	: { format(returnt,sizeof(returnt),  "Ken Rosenberg"); }
		case 291	: { format(returnt,sizeof(returnt),  "Desert Sheriff"); }
		case 292	: { format(returnt,sizeof(returnt),  "Cesar Vialpando"); }
		case 293	: { format(returnt,sizeof(returnt),  "Jeffrey OG Loc Cross"); }
		case 294	: { format(returnt,sizeof(returnt),  "Wu Zi Mu (Woozie)"); }
		case 295	: { format(returnt,sizeof(returnt),  "Michael Toreno"); }
		case 296	: { format(returnt,sizeof(returnt),  "Jizzy B."); }
		case 297	: { format(returnt,sizeof(returnt),  "Madd Dogg"); }
		case 298	: { format(returnt,sizeof(returnt),  "Catalina"); }
		case 299	: { format(returnt,sizeof(returnt),  "Claude"); }
		default: { format(returnt,sizeof(returnt),  "INVALID_SKIN_ID"); }
	}
	return returnt;
}

