#include "common.hpp"
#include <cstdio>

int PrintHelp()
{
	printf("%s", HELP_STRING);
#ifdef DEBUGGING
	printf("\n    knave %s-debug\n", VERSION_STRING);
#else
	printf("\n    knave %s\n", VERSION_STRING);
#endif
	return 0;
}

int main(int argc, char** argv)
{
	if(argc <= 1)
		return PrintHelp();

	return 0;
}
