#include "common.hpp"
#include <cstdio>

// TODO: Put this macro (and more) in its own header file (or make it a function instead, that takes an enum for the color type)
#include <string> // IWYU pragma: keep
#define COLOR_BLUE(text) "\033[1;34m " text " \033[0m"

int PrintHelp()
{
	printf("%s", HELP_STRING);
#ifdef DEBUGGING
	printf(COLOR_BLUE("\n    knave %s-debug\n"), VERSION_STRING);
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
