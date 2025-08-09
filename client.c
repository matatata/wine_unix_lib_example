
#ifndef LOAD_AT_RUNTIME
#include "mylib.h"
#endif

#include <stdio.h>
#include <windows.h>

int main(int argc,char** argv) {

#ifdef LOAD_AT_RUNTIME
    printf("loading the library at runtime\n");
    HINSTANCE hGetProcIDDLL = LoadLibrary("mylib.dll");
    if (hGetProcIDDLL) {
        typedef int (__stdcall *f_funci)(const char *n);
        f_funci funci = (f_funci)GetProcAddress(hGetProcIDDLL, "say_hello");
        if (funci) {
            int result = funci("LoadLibrary");
        }
    }
#else
    printf("loading dynamically linked code\n");
    say_hello("World");
    printf("Unix calculated %i\n",add_numbers(12,3));
#endif

}