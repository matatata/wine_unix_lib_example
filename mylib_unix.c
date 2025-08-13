#include <stdio.h>

#include "unixlib.h"
#include "wine/unixlib.h"


static NTSTATUS unix_say_hello( void *args )
{
    fprintf(stderr,"Hello '%s' from Unix-Code!\n",(const char*) args);
}

static NTSTATUS unix_add_numbers(void *args)
{
    struct {
        int a;
        int b;
    }  const *params = args; 
    return params->a + params->b;
}

const unixlib_entry_t __wine_unix_call_funcs[] =
{
    unix_say_hello,
    unix_add_numbers
};



#ifdef _WIN64

// https://list.winehq.org/pipermail/wine-devel/2022-April/213679.html

const unixlib_entry_t __wine_unix_call_wow64_funcs[] =
{
    unix_say_hello,
    unix_add_numbers
};

#endif  /* _WIN64 */

