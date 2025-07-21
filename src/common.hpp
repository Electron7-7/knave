#ifndef COMMON_H
#define COMMON_H

constexpr const char* HELP_STRING = \
R"~(    Usage: knave [-hv] [command1|command2|command3 <arguments>]

        -h, --help       print help document
        -v, --version    print program version

    Examples:
        knave --help
)~";

constexpr const char* VERSION_STRING = "v0.0.1";

#endif // COMMON_H
