#include "unixlib.h"
#include <stdio.h>

// Wrapper to call Unix-side function
__declspec(dllexport) void call_say_hello(const char* name)
{
   fprintf(stdout,"trying to call into unix library arg: %s\n",name);
   WINE_UNIX_CALL( say_hello, name );
}
 
__declspec(dllexport) int call_add_numbers(int a, int b)
{
    fprintf(stdout,"trying to call into unix library args: %i %i\n",a,b);
    struct add_numbers_params p = { a, b};
    return WINE_UNIX_CALL(add_numbers,&p);
}



BOOL WINAPI DllMain(HINSTANCE instance, DWORD reason, void *reserved)
{
    if (reason == DLL_PROCESS_ATTACH)
    {
        fprintf(stdout,"dll loaded\n");
        
        if(__wine_init_unix_call()){
            fprintf(stderr,"__wine_init_unix_call failed\n");
            return FALSE;
        }

        fprintf(stdout,"unix calls apparently initialized fine __wine_unixlib_handle: %x\n",__wine_unixlib_handle);
        
    }
    return TRUE;
}

// // Driver entry point
// NTSTATUS WINAPI DriverEntry(DRIVER_OBJECT *driver, UNICODE_STRING *path)
// {
//     TRACE("Driver loaded.\n");

//     // Initialize the Unix library interface
//     if (wine_init_unix_lib(&unix_funcs, sizeof(*unix_funcs),
//                            MYDRIVER_FUNC_SAY_HELLO, NULL,
//                            MYDRIVER_FUNC_ADD_NUMBERS, NULL,
//                            0))
//     {
//         TRACE("Unix lib initialized.\n");
//         call_say_hello();
//         int result = call_add_numbers(3, 4);
//         TRACE("3 + 4 = %d\n", result);
//     }
//     else
//     {
//         ERR("Failed to initialize Unix lib.\n");
//         return STATUS_DLL_NOT_FOUND;
//     }

//     return STATUS_SUCCESS;
// }   


