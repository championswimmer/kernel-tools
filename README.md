#Android Kernel Kitchen
tools to tinker with kernels and ramdisks 


## Install Pre-requisite Packages

####Android Boot Image modifier package
	sudo apt-get install abootimg



**********
__________
##Working with FTF and SIN files (for Xperia with Flashtool)   

### 1. Unpacking kernel contents from ftf 
(required for Xperia series of smartphones only)

######   Unpack ftf  file to zimage and ramdisk (credits DoomLord) 
   this works on linux natively or on cygwin, but not native windows   
   This uses DoomLord's kernel.sin unpacker tool written in perl (with minor modifications)
   update : now you can directly use the ftf file, i have included an easy script for that   
   update2: automatised the process now to accept arguements   
   use this command 
 
	./edit-kernel/ftf/unpack path/to/kernel.ftf
	
NOTE: if no arguement is given it uses the "kernel.ftf" file in input folder. thus you cas use only   

	./edit-kernel/ftf/unpack


***********
### 2. Creating Kernel.sin and flashable ftf files (credits DoomLord, Androxyde, the_laser, nobodyAtall)
(Required for Xperia X10, X8,  Mini and MiniPro only)   

#####   For linux use this
This uses freexperia's bin2sin and bin2elf linux binaries (thanks nobodyAtall for informing me of them)   
And the script is a modified version of DoomLord's Kernel.ftf creator script for Windows   
(update: Now supports X10, X8, X10Mini and X10MiniPro)
(update: You can enter branding details like kernel name, dev name and kernel version automatically while creating ftf)

You can keep zImage as "image" and ramdisk archive as "ramdisk" inside input
folder and run this command

	./edit-kernel/ftf/build
	
Or for more advanced funtionality use this

	./edit-kernel/ftf/build /path/to/zImage /path/to/ramdisk.cpio.gz
	
NOTE: The paths must be absolute paths to the files
_ _ _
#####  For windows use BUILD-IT.bat file instead
this runs natively on Windows, no wine, whisky, beer or scotch needed ... ha ha ha
(This is purely DoomLord's work. I have done no additions to it)

	cd edit-kernel
	cd ftf
	BUILD-IT.bat
	
For Windows,  
The zImage and ramdisk should be placed inside the same folder as BUILD-IT.bat   
and they should be named "image" and "ramdisk"

***************
_______________
##Working with Ramdisks

###1. Extracting ramdisks
This works on linux or with cygwin (with cpio and gzip installed)
Keep the ramdisk.cpio.gz or initrd.img file inside input folder and run this  

	./edit-ramdisk/extract

or for more advanced functionality, use the arguement to call ramdisk from other location   

	./edit-ramdisk/extract path/to/ramdisk
Note: The path must be absolute path

_ _ _
###2. (re)packing ramdisks
This works on linux or with cygwin (with cpio and gzip installed)
Keep the ramdisk folder inside input folder named as "ramdisk-folder" and run this  

	./edit-ramdisk/pack

or for more advanced functionality, use the arguement to call ramdisk folder from other location   

	./edit-ramdisk/extract path/to/ramdisk/folder
Note: The path must be absolute path   

Note: The ramdisk folder should contain ramdisk contents directly inside it (i.e. the root of ramdisk-folder should contain init)



