#include <a_samp>
#include <streamer>
#include <colandreas>
#include <MAP>
#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	LoadObj();
	CA_Init();
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}
#endif
