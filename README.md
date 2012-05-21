#Android Kernel Kitchen
tools to tinker with kernels and ramdisks 


## Install Pre-requisite Packages

####Java archiver 'jar' tool (only required if you work with ftf files)
If you have java, jre, open-jdk or sun-java-jdk installed then jar should be already present in your system, other wise install it by running   

	sudo apt-get install fastjar   

For cygwin users, you have to install the sun java jre BEFORE installing cygwin

####ImageMagick (only for bootsplash image editing)
This is required for linux users. For cygwin, precompiled binary is already present.   

	sudo apt-get install imagemagick   

####GNU C Compiler ( not required for Linux x86_64)
Some funtions need precompiled binaries for your architecture to work. The sources are already present inside the kitchen and the binaries will be compiled during execution. (as I'm using Linux 64bit, binaries for this architecture are already present)   


	sudo apt-get install gcc

**********
__________

##How to use

go to terminal, cd to the top directory of kitchen and run   

	./menu

or if you are on ubuntu you can just double-click menu and click "Run in Terminal"


___________________
___________________
___________________
###For advanced manual usage, without using menu, read instructions below
___________________
___________________
___________________











####Working with boot.img files 

##### 1. unpacking kernel contents from boot.img
This unpacks zImage and initrd.img (ramdisk) from boot.img   
This will also extract the contents of ramdisk for you   

keep the "boot.img" file inside input folder and run this command   

	./edit-kernel/bootimg/unpack

or for more advanced funtioinality call the file using argument   

	./edit-kernel/bootimg/unpack /path/to/boot.img
<sup> NOTE : The path must be an absolute path to file </sup>

While execution, the script will ask you to provide a name with which it will save the boot.img configuration (base address and cmdline)   
This is necessary so that when you next time build a boot.img for that same device, it can use the saved configuration   

##### 2. building boot.img from zImage and ramdisk
This will create a boot.img file using zImage and ramdisk.   
It can use a previously saved boot.img configuration (see above), or if you wish you can manually enter kernel, ramdisk addresses during execution of script.   

keep the kernel as "zImage" and ramdisk as "initrd.img" inside input folder and run   

	./edit-kernel/bootimg/build

or for more advanced funtionality call the zimage and ramdisk through arguement   

	./edit-kernel/bootimg/build /path/to/zimage /path/to/ramdisk



**********
__________
####Working with FTF and SIN files (for Xperia with Flashtool)   

##### 1. Unpacking kernel contents from ftf 
(required for Xperia 2010, 2011, 2012 series of smartphones only)

this extracts zimage and ramdisk from ftf file if it contains kernel.sin   
this works on linux natively or on cygwin, but not native windows   


Keep the ftf file as "kernel.ftf" in input folder and run this  

	./edit-kernel/ftf/unpack   

Or for more advanced functionality you can call ftf file through argument   

	./edit-kernel/ftf/unpack path/to/kernel.ftf   
<sup>NOTE: The path must be absolute path to file</sup>   
	

***********
##### 2. Creating Kernel.sin and flashable ftf files 
(Required for Xperia X10, X8,  X10 Mini and X10 MiniPro only)   

######   For linux 
The script will ask during execution if you want ftf file for X10 or msm-7x27 device (X8, Mini, MiniPro)   
You can enter branding details like kernel name, dev name and kernel version automatically while creating ftf

You can keep zImage as "image" and ramdisk archive as "ramdisk" inside input
folder and run this command

	./edit-kernel/ftf/build
	
Or for more advanced funtionality use this

	./edit-kernel/ftf/build /path/to/zImage /path/to/ramdisk.cpio.gz
	
<sup>NOTE: The paths must be absolute paths to the files.</sup>   

The ftf file can be found inside output folder named as (kernel)-(version).ftf
_ _ _
######  For windows use BUILD-IT.bat file instead
this runs natively on Windows (without cygwin)


	cd edit-kernel
	cd ftf
	BUILD-IT.bat
	
For Windows,  
The zImage and ramdisk should be placed inside the same folder as BUILD-IT.bat   
and they should be named "image" and "ramdisk"

***************
_______________
####Working with Ramdisks

#####1. Extracting ramdisks
This works on linux or with cygwin (with cpio and gzip installed)
Keep the ramdisk.cpio.gz or initrd.img file inside input folder and run this  

	./edit-ramdisk/extract

or for more advanced functionality, use the arguement to call ramdisk from other location   

	./edit-ramdisk/extract path/to/ramdisk   
<sup>Note: The path must be absolute path</sup>

ALTERNATE METHOD
If you face any problem on MacOSX or cygwin (ramdisk not properly getting packed), then use the alternative script (argument is supported here too)    

	./edit-ramdisk/extract-alt
_ _ _
#####2. (re)packing ramdisks
This works on linux or with cygwin (with cpio and gzip installed)
Keep the ramdisk folder inside input folder named as "ramdisk-folder" and run this  

	./edit-ramdisk/pack

or for more advanced functionality, use the arguement to call ramdisk folder from other location   

	./edit-ramdisk/extract path/to/ramdisk/folder
<sup>Note: The path must be absolute path</sup>   

The packed ramdisk can be found as 'ramdisk.cpio.gz' inside output folder

<sup>Note: The ramdisk folder should contain ramdisk contents directly inside it (i.e. the root of ramdisk-folder should contain init)</sup>

ALTERNATE METHOD
If you face any problem on MacOSX or cygwin (ramdisk not properly getting packed), then use the alternative script (argument is supported here too)    

	./edit-ramdisk/pack-alt
<sup>the alternate method requires gcc to compile the mkbootfs binary </sup>

***********************
______________________
#### Working with boot splash images
This uses rgb2565 and 5652rgb binaries. If those precompiled binaries are not found, the script will compile them during execution using GNU C Compiler.
Also ImageMagick program should be installed on your system

#####1. Converting png image to rle format
######for linux   
<sup>NOTE: The script will ask you the size (width x height) of image while execution</sup>   

keep your png file named as 'bootsplash.png' in input folder and run this   

	./edit-image/png2rle

or for more advanced functionality use argument to call the file   

	./edit-image/png2rle /path/to/filename.png   

The converted file will be found as 'bootsplash.rle' inside output folder

######for windows 
This runs natively on windows (without cygwin)   

place the png file inside edit-image folder and run this from command   

	cd edit-image
	png2rle.bat filename.png   

the output will be filename.png.rle inside the same folder   

#####2. Convert rle bootlogo to png image file
######for Linux
<sup>NOTE: The script will ask you the size (width x height) of image while execution</sup>   

keep your rle file named as 'bootsplash.rle' in input folder and run this   

	./edit-image/rle2png

or for more advanced functionality use argument to call the file   

	./edit-image/pg2rle /path/to/filename.rle   

The converted file will be found as 'bootsplash.png' inside output folder

######for windows 
This runs natively on windows.   

IMPORTANT: The default size is 480x854. For other sizes please manually edit the rle2png.bat file before using it.

place the rle file inside edit-image folder and run this from command   

	cd edit-image
	png2rle.bat filename.rle   

the output will be filename.rle.png inside the same folder   



