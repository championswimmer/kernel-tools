#Android Kernel Kitchen
tools to tinker with kernels and ramdisks 


## Install Pre-requisite Packages

####Android Boot Image modifier package
	sudo apt-get install abootimg



**********
### 1. Unpacking kernel contents from ftf 
(required for Xperia series of smartphones only)

######   Unpack ftf  file to zimage and ramdisk (credits DoomLord) 
   this works on linux natively or on cygwin, but not native windows  
   update : now you can directly use the ftf file, i have included an easy script for that   
   update2: automatised the process now to accept arguements   
   use this command 
 
	./unpack-kernel/ftf/unpack path/to/kernel.ftf
	
NOTE: if no arguement is given it uses the "kernel.ftf" file in input folder


***********
### 2. Creating Kernel.sin and flashable ftf files (credits DoomLord, Androxyde, the_laser, nobodyAtall)
(only for Xperia X10i or X10a for now)

#####   For linux use this
This uses freexperia's bin2sin and bin2elf linux binaries (thanks nobodyAtall for informing me of them)   
And the script is a modified version of DoomLord's Kernel.ftf creator script for Windows (Xperia X10)   

You can keep zImage as "image" and ramdisk archive as "ramdisk" inside input
folder and run this command

	./kernel-tools/pack-kernel/ftf/build
	
Or for more advanced funtionality use this

	./kernel-tools/pack-kernel/ftf/build /path/to/zImage /path/to/ramdisk.cpio.gz
NOTE: The paths must be absolute paths to the files
_ _ _
#####  For windows use BUILD-IT.bat file instead
this runs natively on Windows, no wine, whisky, beer or scotch needed ... ha ha ha
(This is purely DoomLord's work. I have done no additions to it)

	cd kernel-tools
	cd pack-kernel
	cd ftf
	BUILD-IT.bat
	
For Windows,  
The zImage and ramdisk should be placed inside the same folder as BUILD-IT.bat   
and they should be named "image" and "ramdisk"

***************

