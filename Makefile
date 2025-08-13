
# Where you did clone the wine source code:
WINE_INCLUDE=$(HOME)/wine/include
WINEPREFIX=$(HOME)/.wine

WINE_LIB_DIR=/opt/local/lib/wine



all: mylib.so mylib.dll client.exe

mylib.so: mylib_unix.c
	gcc -DWINE_UNIX_LIB -shared -I$(WINE_INCLUDE) -fPIC mylib_unix.c -o mylib.so   

mylib.dll: mylib_main.c unixlib.h mylib.spec
	mkdir -p 64 32
	winegcc  -b x86_64-w64-mingw32 -I$(WINE_INCLUDE) -Wl,--wine-builtin -shared mylib_main.c mylib.spec -o 64/mylib.dll 
	winegcc  -b i686-w64-mingw32 -I$(WINE_INCLUDE) -Wl,--wine-builtin -shared mylib_main.c mylib.spec -o 32/mylib.dll 
	
client.exe: client.c mylib.h
	winegcc  -L./64 -lmylib -b x86_64-w64-mingw32 client.c -o client64_1.exe
	winegcc -DLOAD_AT_RUNTIME  -b x86_64-w64-mingw32 client.c -o client64_2.exe
	winegcc  -L./32 -lmylib -b i686-w64-mingw32 client.c -o client1.exe
	winegcc -DLOAD_AT_RUNTIME  -b i686-w64-mingw32 client.c -o client2.exe

install: mylib.so mylib.dll	client.exe
# copy exe
	 cp client*.exe "$(WINEPREFIX)/drive_c/"

# copy builtins .. that might be enough ...
	 sudo cp ./64/mylib.dll "$(WINE_LIB_DIR)/x86_64-windows/"
	 sudo cp ./32/mylib.dll "$(WINE_LIB_DIR)/i386-windows/"
	 sudo cp mylib.so "$(WINE_LIB_DIR)/x86_64-unix/"
	 
# ... but placing the dll next to the exe is enough
# cp mylib.dll "$(WINEPREFIX)/drive_c/"

# or copying to system32 or syswow64  which frees us from keeping it around:
# cp 64/mylib.dll "$(WINEPREFIX)/drive_c/windows/system32/"
# cp 32/mylib.dll "$(WINEPREFIX)/drive_c/windows/syswow64/"

# or set a mylib override in winecfg and set it to "builtin" or via
# env var:
# WINEDLLOVERRIDES="mylib=b"
	 
	 
# try run without installing into builtin-dirs
run_no_install: clean mylib.so mylib.dll client.exe
	
	# Setting WINEPATH and WINEDLLPATH seems enough for stock wine, but
	# apparently not CrossOver - it wants stuff in x86_64-windows and x86_64-unix

	WINEPATH="$(PWD)/32" WINEDLLPATH="$(PWD)" WINEDEBUG=-all MVK_CONFIG_LOG_LEVEL=0 wine client1.exe
	WINEPATH="$(PWD)/32" WINEDLLPATH="$(PWD)" WINEDEBUG=-all MVK_CONFIG_LOG_LEVEL=0 wine client2.exe
	WINEPATH="$(PWD)/64" WINEDLLPATH="$(PWD)" WINEDEBUG=-all MVK_CONFIG_LOG_LEVEL=0 wine client64_1.exe
	WINEPATH="$(PWD)/64" WINEDLLPATH="$(PWD)" WINEDEBUG=-all MVK_CONFIG_LOG_LEVEL=0 wine client64_2.exe

run: install
	WINEDEBUG=-all MVK_CONFIG_LOG_LEVEL=0 wine "C:/client64_1.exe"
	WINEDEBUG=-all MVK_CONFIG_LOG_LEVEL=0 wine "C:/client64_2.exe"
	WINEDEBUG=-all MVK_CONFIG_LOG_LEVEL=0 wine "C:/client1.exe"
	WINEDEBUG=-all MVK_CONFIG_LOG_LEVEL=0 wine "C:/client2.exe"

clean:
	rm -f *.o
	rm -f *.exe
	rm -f *.so
	rm -f 32 64
	rm -rf out
	sudo rm -f "$(WINE_LIB_DIR)/x686-windows/mylib.dll"
	sudo rm -f "$(WINE_LIB_DIR)/x86_64-windows/mylib.dll"
	sudo rm -f "$(WINE_LIB_DIR)/x86_64-unix/mylib.so"
	rm -f "$(WINEPREFIX)/drive_c/windows/system32/mylib.dll"
	rm -f "$(WINEPREFIX)/drive_c/mylib.dll"
	rm -f "$(WINEPREFIX)/drive_c/client*.exe"
	
