#kernel-tools
#============

tools to tinker with kernels and ramdisks 

# install boot image modifier package (for ubuntu)
sudo apt-get install abootimg

# from now on use "unpacksin" command at any directory 
sudo cp unpack-kernel/sin/unpack-kernelsin.pl /bin/unpacksin

# now we can create .ftf kernel file for x10 from linux

cd kernel-tools/pack-kernel/ftf
./build-ftf

##(for windows use BUILD-IT.bat file instead) 

