#kernel-tools


##tools to tinker with kernels and ramdisks 

#### install boot image modifier package (for ubuntu)

	sudo apt-get install abootimg

###Unpacking kernel.sin files
#### unpack kernel.sin file (credits DoomLord) 
this works on linux natively or on cygwin, not native windows

	cd unpack-kernel/sin/ 
	./unpack-kernelsin.pl kernel.sin

###Creating Kernel.sin and flashable ftf files
#### For linux use this
I have ported Doom's script onto Linux but it needs wine to work

	sudo apt-get install wine
	cd kernel-tools/pack-kernel/ftf
	./build-ftf


####for windows use BUILD-IT.bat file instead
this runs natively on Windows, no wine, whisky, beer or scotch needed ... ha ha ha

	cd kernel-tools
	cd pack-kernel
	cd ftf
	BUILD-IT.bat


