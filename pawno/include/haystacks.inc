#if defined _haystacks_included
	#endinput
#endif
#define _haystacks_included

#if !defined FONT
	#define FONT 3374
#endif

#if defined _streamer_included
	#define CreateObject CreateDynamicObject
#endif
stock CreateSentence(text[], Float:x, Float:y, Float:z, Float:rZ)
{
	new Float:spacing;
	for(new i; i < strlen(text); i++)
	{
	    switch(text[i])
	    {
	        case 'a', 'A':
	        {
	            CreateObject(FONT, x + (0.133789 + spacing) * floatsin(-rZ, degrees), y + (0.133789 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.104736 + spacing) * floatsin(-rZ, degrees), y + (0.104736 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.094726 + spacing) * floatsin(-rZ, degrees), y + (0.094726 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.093261 + spacing) * floatsin(-rZ, degrees), y + (0.093261 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.962890 + spacing) * floatsin(-rZ, degrees), y + (3.962890 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.902099 + spacing) * floatsin(-rZ, degrees), y + (3.902099 + spacing) * floatcos(-rZ, degrees), z + 6.824987, 0, 0, rZ);
	            CreateObject(FONT, x + (7.946289 + spacing) * floatsin(-rZ, degrees), y + (7.946289 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.920898 + spacing) * floatsin(-rZ, degrees), y + (7.920898 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.939208 + spacing) * floatsin(-rZ, degrees), y + (7.939208 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.932861 + spacing) * floatsin(-rZ, degrees), y + (7.932861 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.860351 + spacing) * floatsin(-rZ, degrees), y + (7.860351 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            spacing += 15.8;
	        }
	        case 'b', 'B':
	        {
	            CreateObject(FONT, x + (0.133789 + spacing) * floatsin(-rZ, degrees), y + (0.133789 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.104736 + spacing) * floatsin(-rZ, degrees), y + (0.104736 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.094726 + spacing) * floatsin(-rZ, degrees), y + (0.094726 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.093261 + spacing) * floatsin(-rZ, degrees), y + (0.093261 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.962890 + spacing) * floatsin(-rZ, degrees), y + (3.962890 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.901367 + spacing) * floatsin(-rZ, degrees), y + (3.901367 + spacing) * floatcos(-rZ, degrees), z + 6.824987, 0, 0, rZ);
	            CreateObject(FONT, x + (7.366210 + spacing) * floatsin(-rZ, degrees), y + (7.366210 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.948242 + spacing) * floatsin(-rZ, degrees), y + (7.948242 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.939208 + spacing) * floatsin(-rZ, degrees), y + (7.939208 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.932861 + spacing) * floatsin(-rZ, degrees), y + (7.932861 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.412109 + spacing) * floatsin(-rZ, degrees), y + (7.412109 + spacing) * floatcos(-rZ, degrees), z + 0.549991, 0, 0, rZ);
	            CreateObject(FONT, x + (3.966796 + spacing) * floatsin(-rZ, degrees), y + (3.966796 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            spacing += 15.8;
	        }
	        case 'c', 'C':
	        {
	            CreateObject(FONT, x + (7.997314 + spacing) * floatsin(-rZ, degrees), y + (7.997314 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (4.160156 + spacing) * floatsin(-rZ, degrees), y + (4.160156 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.176757 + spacing) * floatsin(-rZ, degrees), y + (0.176757 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.181152 + spacing) * floatsin(-rZ, degrees), y + (0.181152 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (4.023193 + spacing) * floatsin(-rZ, degrees), y + (4.023193 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.763427 + spacing) * floatsin(-rZ, degrees), y + (7.763427 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (8.072509 + spacing) * floatsin(-rZ, degrees), y + (8.072509 + spacing) * floatcos(-rZ, degrees), z + 2.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.888427 + spacing) * floatsin(-rZ, degrees), y + (7.888427 + spacing) * floatcos(-rZ, degrees), z + 10.500000, 0, 0, rZ);
	            spacing += 15.95;
	        }
	        case 'd', 'D':
			{
	            CreateObject(FONT, x + (0.133789 + spacing) * floatsin(-rZ, degrees), y + (0.133789 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.104736 + spacing) * floatsin(-rZ, degrees), y + (0.104736 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.094726 + spacing) * floatsin(-rZ, degrees), y + (0.094726 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.093261 + spacing) * floatsin(-rZ, degrees), y + (0.093261 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.962890 + spacing) * floatsin(-rZ, degrees), y + (3.962890 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.366210 + spacing) * floatsin(-rZ, degrees), y + (7.366210 + spacing) * floatcos(-rZ, degrees), z + 11.400000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.920898 + spacing) * floatsin(-rZ, degrees), y + (7.920898 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.939208 + spacing) * floatsin(-rZ, degrees), y + (7.939208 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.932861 + spacing) * floatsin(-rZ, degrees), y + (7.932861 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.441162 + spacing) * floatsin(-rZ, degrees), y + (7.441162 + spacing) * floatcos(-rZ, degrees), z + 0.275000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.441162 + spacing) * floatsin(-rZ, degrees), y + (3.441162 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            spacing += 15.8;

			}
	        case 'e', 'E':
			{
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.902890 + spacing) * floatsin(-rZ, degrees), y + (3.902890 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.902099 + spacing) * floatsin(-rZ, degrees), y + (3.902099 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.820898 + spacing) * floatsin(-rZ, degrees), y + (7.820898 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.909208 + spacing) * floatsin(-rZ, degrees), y + (3.909208 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.822861 + spacing) * floatsin(-rZ, degrees), y + (7.822861 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
				spacing += 15.8;
			}
			case 'f', 'F':
			{
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.902890 + spacing) * floatsin(-rZ, degrees), y + (3.902890 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.902099 + spacing) * floatsin(-rZ, degrees), y + (3.902099 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.820898 + spacing) * floatsin(-rZ, degrees), y + (7.820898 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
				spacing += 15.8;
			}
			case 'g', 'G':
			{
	            CreateObject(FONT, x + (7.997314 + spacing) * floatsin(-rZ, degrees), y + (7.997314 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (4.160156 + spacing) * floatsin(-rZ, degrees), y + (4.160156 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (1.205078 + spacing) * floatsin(-rZ, degrees), y + (1.205078 + spacing) * floatcos(-rZ, degrees), z + 1.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.181152 + spacing) * floatsin(-rZ, degrees), y + (0.181152 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (1.050048 + spacing) * floatsin(-rZ, degrees), y + (1.050048 + spacing) * floatcos(-rZ, degrees), z + 11.075000, 0, 0, rZ);
	            CreateObject(FONT, x + (4.023193 + spacing) * floatsin(-rZ, degrees), y + (4.023193 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.763427 + spacing) * floatsin(-rZ, degrees), y + (7.763427 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (8.072509 + spacing) * floatsin(-rZ, degrees), y + (8.072509 + spacing) * floatcos(-rZ, degrees), z + 2.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.888427 + spacing) * floatsin(-rZ, degrees), y + (7.888427 + spacing) * floatcos(-rZ, degrees), z + 11.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (8.165771 + spacing) * floatsin(-rZ, degrees), y + (8.165771 + spacing) * floatcos(-rZ, degrees), z + 5.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (5.992187 + spacing) * floatsin(-rZ, degrees), y + (5.992187 + spacing) * floatcos(-rZ, degrees), z + 5.000000, 0, 0, rZ);
	            spacing += 15.95;
			}
	        case 'h', 'H':
	        {
	            CreateObject(FONT, x + (0.133789 + spacing) * floatsin(-rZ, degrees), y + (0.133789 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.104736 + spacing) * floatsin(-rZ, degrees), y + (0.104736 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.094726 + spacing) * floatsin(-rZ, degrees), y + (0.094726 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.093261 + spacing) * floatsin(-rZ, degrees), y + (0.093261 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.902099 + spacing) * floatsin(-rZ, degrees), y + (3.902099 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.946289 + spacing) * floatsin(-rZ, degrees), y + (7.946289 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.946289 + spacing) * floatsin(-rZ, degrees), y + (7.946289 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.946289 + spacing) * floatsin(-rZ, degrees), y + (7.946289 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.946289 + spacing) * floatsin(-rZ, degrees), y + (7.946289 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.946289 + spacing) * floatsin(-rZ, degrees), y + (7.946289 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            spacing += 15.8;
	        }
	        case 'i', 'I':
	        {
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            spacing += 6.8;
	        }
	        case 'j', 'J':
	        {
	            CreateObject(FONT, x + (4.959960 + spacing) * floatsin(-rZ, degrees), y + (4.959960 + spacing) * floatcos(-rZ, degrees), z + 5.700000, 0, 0, rZ);
	            CreateObject(FONT, x + (4.959960 + spacing) * floatsin(-rZ, degrees), y + (4.959960 + spacing) * floatcos(-rZ, degrees), z + 2.700000, 0, 0, rZ);
	            CreateObject(FONT, x + (2.218261 + spacing) * floatsin(-rZ, degrees), y + (2.218261 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (4.959960 + spacing) * floatsin(-rZ, degrees), y + (4.959960 + spacing) * floatcos(-rZ, degrees), z + 12.300000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 2.000000, 0, 0, rZ);
	            spacing += 13.2;
	        }
	        case 'k', 'K':
	        {
	            CreateObject(FONT, x + (0.133789 + spacing) * floatsin(-rZ, degrees), y + (0.133789 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.104736 + spacing) * floatsin(-rZ, degrees), y + (0.104736 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.094726 + spacing) * floatsin(-rZ, degrees), y + (0.094726 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.093261 + spacing) * floatsin(-rZ, degrees), y + (0.093261 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.902099 + spacing) * floatsin(-rZ, degrees), y + (3.902099 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (5.973144 + spacing) * floatsin(-rZ, degrees), y + (5.973144 + spacing) * floatcos(-rZ, degrees), z + 8.800000, 0, 0, rZ);
	            CreateObject(FONT, x + (5.890869 + spacing) * floatsin(-rZ, degrees), y + (5.890869 + spacing) * floatcos(-rZ, degrees), z + 2.900000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.860351 + spacing) * floatsin(-rZ, degrees), y + (7.860351 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.787109 + spacing) * floatsin(-rZ, degrees), y + (7.787109 + spacing) * floatcos(-rZ, degrees), z + 11.800000, 0, 0, rZ);
	            spacing += 15.8;
	        }
	        case 'l', 'L':
	        {
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.900000 + spacing) * floatsin(-rZ, degrees), y + (3.900000 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.800000 + spacing) * floatsin(-rZ, degrees), y + (7.800000 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            spacing += 15.8;
	        }
	        case 'm', 'M':
	        {
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.901367 + spacing) * floatsin(-rZ, degrees), y + (3.901367 + spacing) * floatcos(-rZ, degrees), z + 6.900000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.857910 + spacing) * floatsin(-rZ, degrees), y + (7.857910 + spacing) * floatcos(-rZ, degrees), z + 4.060000, 0, 0, rZ);
	            CreateObject(FONT, x + (11.791748 + spacing) * floatsin(-rZ, degrees), y + (11.791748 + spacing) * floatcos(-rZ, degrees), z + 6.900000, 0, 0, rZ);
	            CreateObject(FONT, x + (15.643798 + spacing) * floatsin(-rZ, degrees), y + (15.643798 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (15.643798 + spacing) * floatsin(-rZ, degrees), y + (15.643798 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (15.643798 + spacing) * floatsin(-rZ, degrees), y + (15.643798 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (15.643798 + spacing) * floatsin(-rZ, degrees), y + (15.643798 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (15.643798 + spacing) * floatsin(-rZ, degrees), y + (15.643798 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            spacing += 23.8;
	        }
	        case 'n', 'N':
	        {
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.901367 + spacing) * floatsin(-rZ, degrees), y + (3.901367 + spacing) * floatcos(-rZ, degrees), z + 6.900000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.834472 + spacing) * floatsin(-rZ, degrees), y + (7.834472 + spacing) * floatcos(-rZ, degrees), z + 4.060000, 0, 0, rZ);
	            CreateObject(FONT, x + (11.699951 + spacing) * floatsin(-rZ, degrees), y + (11.699951 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (11.699951 + spacing) * floatsin(-rZ, degrees), y + (11.699951 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (11.699951 + spacing) * floatsin(-rZ, degrees), y + (11.699951 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (11.699951 + spacing) * floatsin(-rZ, degrees), y + (11.699951 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (11.699951 + spacing) * floatsin(-rZ, degrees), y + (11.699951 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            spacing += 20.1;
	        }
	        case 'o', 'O':
	        {
	            CreateObject(FONT, x + (7.192626 + spacing) * floatsin(-rZ, degrees), y + (7.192626 + spacing) * floatcos(-rZ, degrees), z + 0.924000, 0, 0, rZ);
	            CreateObject(FONT, x + (4.160156 + spacing) * floatsin(-rZ, degrees), y + (4.160156 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (1.222167 + spacing) * floatsin(-rZ, degrees), y + (1.222167 + spacing) * floatcos(-rZ, degrees), z + 1.100000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.181152 + spacing) * floatsin(-rZ, degrees), y + (0.181152 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.020019 + spacing) * floatsin(-rZ, degrees), y + (0.020019 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (1.050048 + spacing) * floatsin(-rZ, degrees), y + (1.050048 + spacing) * floatcos(-rZ, degrees), z + 11.075000, 0, 0, rZ);
	            CreateObject(FONT, x + (4.023193 + spacing) * floatsin(-rZ, degrees), y + (4.023193 + spacing) * floatcos(-rZ, degrees), z + 11.964000, 0, 0, rZ);
	            CreateObject(FONT, x + (6.966552 + spacing) * floatsin(-rZ, degrees), y + (6.966552 + spacing) * floatcos(-rZ, degrees), z + 11.050000, 0, 0, rZ);
	            CreateObject(FONT, x + (8.072021 + spacing) * floatsin(-rZ, degrees), y + (8.072021 + spacing) * floatcos(-rZ, degrees), z + 3.675000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.888427 + spacing) * floatsin(-rZ, degrees), y + (7.888427 + spacing) * floatcos(-rZ, degrees), z + 9.814000, 0, 0, rZ);
	            CreateObject(FONT, x + (8.227783 + spacing) * floatsin(-rZ, degrees), y + (8.227783 + spacing) * floatcos(-rZ, degrees), z + 6.675000, 0, 0, rZ);
	            spacing += 16.2;
	        }
	        case 'p', 'P':
	        {
	            CreateObject(FONT, x + (0.133789 + spacing) * floatsin(-rZ, degrees), y + (0.133789 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.104736 + spacing) * floatsin(-rZ, degrees), y + (0.104736 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.094726 + spacing) * floatsin(-rZ, degrees), y + (0.094726 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.093261 + spacing) * floatsin(-rZ, degrees), y + (0.093261 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.901367 + spacing) * floatsin(-rZ, degrees), y + (3.901367 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.626953 + spacing) * floatsin(-rZ, degrees), y + (3.626953 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (5.345214 + spacing) * floatsin(-rZ, degrees), y + (5.345214 + spacing) * floatcos(-rZ, degrees), z + 10.880000, 0, 0, rZ);
	            CreateObject(FONT, x + (5.205566 + spacing) * floatsin(-rZ, degrees), y + (6.205566 + spacing) * floatcos(-rZ, degrees), z + 7.067700, 0, 0, rZ);
	            CreateObject(FONT, x + (6.236083 + spacing) * floatsin(-rZ, degrees), y + (6.236083 + spacing) * floatcos(-rZ, degrees), z + 8.886000, 0, 0, rZ);
	            spacing += 14.5;
	        }
	        case 'q', 'Q':
	        {
	            CreateObject(FONT, x + (7.192626 + spacing) * floatsin(-rZ, degrees), y + (7.192626 + spacing) * floatcos(-rZ, degrees), z + 0.924000, 0, 0, rZ);
	            CreateObject(FONT, x + (4.160156 + spacing) * floatsin(-rZ, degrees), y + (4.160156 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (1.222167 + spacing) * floatsin(-rZ, degrees), y + (1.222167 + spacing) * floatcos(-rZ, degrees), z + 1.100000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.181152 + spacing) * floatsin(-rZ, degrees), y + (0.181152 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.020019 + spacing) * floatsin(-rZ, degrees), y + (0.020019 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (1.050048 + spacing) * floatsin(-rZ, degrees), y + (1.050048 + spacing) * floatcos(-rZ, degrees), z + 11.075000, 0, 0, rZ);
	            CreateObject(FONT, x + (4.023193 + spacing) * floatsin(-rZ, degrees), y + (4.023193 + spacing) * floatcos(-rZ, degrees), z + 11.964000, 0, 0, rZ);
	            CreateObject(FONT, x + (6.966552 + spacing) * floatsin(-rZ, degrees), y + (6.966552 + spacing) * floatcos(-rZ, degrees), z + 11.050000, 0, 0, rZ);
	            CreateObject(FONT, x + (8.072021 + spacing) * floatsin(-rZ, degrees), y + (8.072021 + spacing) * floatcos(-rZ, degrees), z + 3.675000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.888427 + spacing) * floatsin(-rZ, degrees), y + (7.888427 + spacing) * floatcos(-rZ, degrees), z + 9.814000, 0, 0, rZ);
	            CreateObject(FONT, x + (8.227783 + spacing) * floatsin(-rZ, degrees), y + (8.227783 + spacing) * floatcos(-rZ, degrees), z + 6.675000, 0, 0, rZ);
	            CreateObject(FONT, x + (9.811035 + spacing) * floatsin(-rZ, degrees), y + (9.811035 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            spacing += 17.8;
	        }
	        case 'r', 'R':
	        {
	            CreateObject(FONT, x + (0.133789 + spacing) * floatsin(-rZ, degrees), y + (0.133789 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.104736 + spacing) * floatsin(-rZ, degrees), y + (0.104736 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.094726 + spacing) * floatsin(-rZ, degrees), y + (0.094726 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.093261 + spacing) * floatsin(-rZ, degrees), y + (0.093261 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.901367 + spacing) * floatsin(-rZ, degrees), y + (3.901367 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.626953 + spacing) * floatsin(-rZ, degrees), y + (3.626953 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (5.344726 + spacing) * floatsin(-rZ, degrees), y + (5.344726 + spacing) * floatcos(-rZ, degrees), z + 11.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (5.205078 + spacing) * floatsin(-rZ, degrees), y + (5.205078 + spacing) * floatcos(-rZ, degrees), z + 7.017000, 0, 0, rZ);
	            CreateObject(FONT, x + (6.236083 + spacing) * floatsin(-rZ, degrees), y + (6.236083 + spacing) * floatcos(-rZ, degrees), z + 8.886000, 0, 0, rZ);
	            CreateObject(FONT, x + (5.136718 + spacing) * floatsin(-rZ, degrees), y + (5.136718 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (6.594726 + spacing) * floatsin(-rZ, degrees), y + (6.594726 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            spacing += 14.9;
	        }
	        case 's', 'S':
	        {
	            CreateObject(FONT, x + (4.305419 + spacing) * floatsin(-rZ, degrees), y + (4.305419 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.479248 + spacing) * floatsin(-rZ, degrees), y + (0.479248 + spacing) * floatcos(-rZ, degrees), z + 1.025000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.606201 + spacing) * floatsin(-rZ, degrees), y + (7.606201 + spacing) * floatcos(-rZ, degrees), z + 1.984000, 0, 0, rZ);
	            CreateObject(FONT, x + (5.208496 + spacing) * floatsin(-rZ, degrees), y + (5.208496 + spacing) * floatcos(-rZ, degrees), z + 4.878000, 0, 0, rZ);
	            CreateObject(FONT, x + (2.171386 + spacing) * floatsin(-rZ, degrees), y + (2.171386 + spacing) * floatcos(-rZ, degrees), z + 6.928000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 9.204000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.175048 + spacing) * floatsin(-rZ, degrees), y + (3.175048 + spacing) * floatcos(-rZ, degrees), z + 11.533000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.070556 + spacing) * floatsin(-rZ, degrees), y + (7.070556 + spacing) * floatcos(-rZ, degrees), z + 10.574000, 0, 0, rZ);
	            spacing += 15.8;
	        }
	        case 't', 'T':
	        {
	            CreateObject(FONT, x + (7.900000 + spacing) * floatsin(-rZ, degrees), y + (7.900000 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.900000 + spacing) * floatsin(-rZ, degrees), y + (7.900000 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.900000 + spacing) * floatsin(-rZ, degrees), y + (7.900000 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.900000 + spacing) * floatsin(-rZ, degrees), y + (7.900000 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.900000 + spacing) * floatsin(-rZ, degrees), y + (7.900000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (11.850000 + spacing) * floatsin(-rZ, degrees), y + (11.850000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (15.800000 + spacing) * floatsin(-rZ, degrees), y + (15.800000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.9500000 + spacing) * floatsin(-rZ, degrees), y + (3.950000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            spacing += 24.8;
	        }
	        case 'u', 'U':
	        {
	            CreateObject(FONT, x + (7.192382 + spacing) * floatsin(-rZ, degrees), y + (7.192382 + spacing) * floatcos(-rZ, degrees), z + 1.175000, 0, 0, rZ);
	            CreateObject(FONT, x + (4.160400 + spacing) * floatsin(-rZ, degrees), y + (4.160400 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (1.221679 + spacing) * floatsin(-rZ, degrees), y + (1.221679 + spacing) * floatcos(-rZ, degrees), z + 1.375000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.180664 + spacing) * floatsin(-rZ, degrees), y + (0.180664 + spacing) * floatcos(-rZ, degrees), z + 3.975000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 6.950000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.019531 + spacing) * floatsin(-rZ, degrees), y + (0.019531 + spacing) * floatcos(-rZ, degrees), z + 9.900000, 0, 0, rZ);
	            CreateObject(FONT, x + (8.072265 + spacing) * floatsin(-rZ, degrees), y + (8.072265 + spacing) * floatcos(-rZ, degrees), z + 3.675000, 0, 0, rZ);
	            CreateObject(FONT, x + (8.212402 + spacing) * floatsin(-rZ, degrees), y + (8.212402 + spacing) * floatcos(-rZ, degrees), z + 9.815000, 0, 0, rZ);
	            CreateObject(FONT, x + (8.228027 + spacing) * floatsin(-rZ, degrees), y + (8.228027 + spacing) * floatcos(-rZ, degrees), z + 6.675000, 0, 0, rZ);
	            CreateObject(FONT, x + (8.890869 + spacing) * floatsin(-rZ, degrees), y + (8.890869 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            spacing += 17.8;
	        }
	        case 'v', 'V':
	        {
	            CreateObject(FONT, x + (10.350341 + spacing) * floatsin(-rZ, degrees), y + (10.350341 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.318359 + spacing) * floatsin(-rZ, degrees), y + (7.318359 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (4.379638 + spacing) * floatsin(-rZ, degrees), y + (4.379638 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (2.460693 + spacing) * floatsin(-rZ, degrees), y + (2.460693 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (12.126464 + spacing) * floatsin(-rZ, degrees), y + (12.126464 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (13.553466 + spacing) * floatsin(-rZ, degrees), y + (13.553466 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (1.166992 + spacing) * floatsin(-rZ, degrees), y + (1.166992 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (14.588378 + spacing) * floatsin(-rZ, degrees), y + (14.588378 + spacing) * floatcos(-rZ, degrees), z + 11.849956, 0, 0, rZ);
	            spacing += 22.8;
	        }
	        case 'w', 'W':
	        {
	            CreateObject(FONT, x + (0.133789 + spacing) * floatsin(-rZ, degrees), y + (0.133789 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.104736 + spacing) * floatsin(-rZ, degrees), y + (0.104736 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.094726 + spacing) * floatsin(-rZ, degrees), y + (0.094726 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.094726 + spacing) * floatsin(-rZ, degrees), y + (0.094726 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.901367 + spacing) * floatsin(-rZ, degrees), y + (3.901367 + spacing) * floatcos(-rZ, degrees), z + 2.175000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.857421 + spacing) * floatsin(-rZ, degrees), y + (7.857421 + spacing) * floatcos(-rZ, degrees), z + 4.361000, 0, 0, rZ);
	            CreateObject(FONT, x + (11.791015 + spacing) * floatsin(-rZ, degrees), y + (11.791015 + spacing) * floatcos(-rZ, degrees), z + 2.175000, 0, 0, rZ);
	            CreateObject(FONT, x + (15.643798 + spacing) * floatsin(-rZ, degrees), y + (15.643798 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (15.643798 + spacing) * floatsin(-rZ, degrees), y + (15.643798 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (15.643798 + spacing) * floatsin(-rZ, degrees), y + (15.643798 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (15.643798 + spacing) * floatsin(-rZ, degrees), y + (15.643798 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (15.643798 + spacing) * floatsin(-rZ, degrees), y + (15.643798 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            spacing += 22.8;
	        }
	        case 'x', 'X':
	        {
	            CreateObject(FONT, x + (3.040771 + spacing) * floatsin(-rZ, degrees), y + (3.040771 + spacing) * floatcos(-rZ, degrees), z + 2.849956 , 0, 0, rZ);
	            CreateObject(FONT, x + (0.083251 + spacing) * floatsin(-rZ, degrees), y + (0.083251 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (9.026123 + spacing) * floatsin(-rZ, degrees), y + (9.026123 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (12.128662 + spacing) * floatsin(-rZ, degrees), y + (12.128662 + spacing) * floatcos(-rZ, degrees), z + 0.174921, 0, 0, rZ);
	            CreateObject(FONT, x + (5.987304 + spacing) * floatsin(-rZ, degrees), y + (5.987304 + spacing) * floatcos(-rZ, degrees), z + 5.849956, 0, 0, rZ);
	            CreateObject(FONT, x + (8.986083 + spacing) * floatsin(-rZ, degrees), y + (8.986083 + spacing) * floatcos(-rZ, degrees), z + 8.849956, 0, 0, rZ);
	            CreateObject(FONT, x + (2.963134 + spacing) * floatsin(-rZ, degrees), y + (2.963134 + spacing) * floatcos(-rZ, degrees), z + 8.699958, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 11.699962, 0, 0, rZ);
	            CreateObject(FONT, x + (11.940673 + spacing) * floatsin(-rZ, degrees), y + (11.940673 + spacing) * floatcos(-rZ, degrees), z + 11.849956, 0, 0, rZ);
	            spacing += 20.8;
	        }
	        case 'y', 'Y':
	        {
	            CreateObject(FONT, x + (5.383789 + spacing) * floatsin(-rZ, degrees), y + (5.383789 + spacing) * floatcos(-rZ, degrees), z + 2.849956, 0, 0, rZ);
	            CreateObject(FONT, x + (5.383789 + spacing) * floatsin(-rZ, degrees), y + (5.383789 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (5.383789 + spacing) * floatsin(-rZ, degrees), y + (5.383789 + spacing) * floatcos(-rZ, degrees), z + 5.849956, 0, 0, rZ);
	            CreateObject(FONT, x + (7.315429 + spacing) * floatsin(-rZ, degrees), y + (7.315429 + spacing) * floatcos(-rZ, degrees), z + 7.324979, 0, 0, rZ);
	            CreateObject(FONT, x + (3.349853 + spacing) * floatsin(-rZ, degrees), y + (3.349853 + spacing) * floatcos(-rZ, degrees), z + 7.174959, 0, 0, rZ);
	            CreateObject(FONT, x + (9.130126 + spacing) * floatsin(-rZ, degrees), y + (9.130126 + spacing) * floatcos(-rZ, degrees), z + 10.199958, 0, 0, rZ);
	            CreateObject(FONT, x + (1.435546 + spacing) * floatsin(-rZ, degrees), y + (1.435546 + spacing) * floatcos(-rZ, degrees), z + 10.149982, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 11.650005, 0, 0, rZ);
	            CreateObject(FONT, x + (10.653320 + spacing) * floatsin(-rZ, degrees), y + (10.653320 + spacing) * floatcos(-rZ, degrees), z + 11.650005, 0, 0, rZ);
	            spacing += 18.8;
	        }
	        case 'z', 'Z':
	        {
	            CreateObject(FONT, x + (0.133789 + spacing) * floatsin(-rZ, degrees), y + (0.133789 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (1.464355 + spacing) * floatsin(-rZ, degrees), y + (1.464355 + spacing) * floatcos(-rZ, degrees), z + 3.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (6.291992 + spacing) * floatsin(-rZ, degrees), y + (6.291992 + spacing) * floatcos(-rZ, degrees), z + 9.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (0.000000 + spacing) * floatsin(-rZ, degrees), y + (0.000000 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.962890 + spacing) * floatsin(-rZ, degrees), y + (3.962890 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.962890 + spacing) * floatsin(-rZ, degrees), y + (3.962890 + spacing) * floatcos(-rZ, degrees), z + 6.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (7.946289 + spacing) * floatsin(-rZ, degrees), y + (7.946289 + spacing) * floatcos(-rZ, degrees), z + 12.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (3.946289 + spacing) * floatsin(-rZ, degrees), y + (3.946289 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            CreateObject(FONT, x + (8.074218 + spacing) * floatsin(-rZ, degrees), y + (8.074218 + spacing) * floatcos(-rZ, degrees), z + 0.000000, 0, 0, rZ);
	            spacing += 16.4;
	        }
	        default: spacing += 8.2;
	    }
	}
}
/*
native CreateSentence(text[], Float:x, Float:y, Float:z;, Float:rZ);
*/