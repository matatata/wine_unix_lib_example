#ifndef __MYLIB_UNIXLIB_H
#define __MYLIB_UNIXLIB_H

#include <stdarg.h>
#include "wine/unixlib.h"

struct add_numbers_params { int a; int b; } ;

enum unix_funcs
{
    say_hello,
    add_numbers
};

#endif /* __MYLIB_UNIXLIB_H */   

