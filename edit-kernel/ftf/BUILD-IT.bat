@echo off
echo -----------------------------------------------------
echo      DooMLoRD's kernel.sin and FTF creator (v1.0)
echo -----------------------------------------------------
echo                FOR XPERIA X10 ONLY
echo -----------------------------------------------------
echo   Credits: 
echo      the_laser - sin packer tools
echo      Androxyde - FTF packer tools
echo      DooMLoRD  - making this easy for all ;)
echo -----------------------------------------------------
echo   before you begin make sure that:
echo      kernel's zImage is called "image"
echo      ramdisk.cpio.gz is called "ramdisk"
echo      and you have java 1.6 installed
echo -----------------------------------------------------
pause
bin2Elf.exe 2 0x20008000 image 0x20008000 0x0 ramdisk 0x24000000 0x80000000
bin2sin.exe result.elf 03000000220000007502000062000000
del result.elf
ren result.elf.sin kernel.sin
echo Manifest-Version: 1.0 > manifest.mf
echo device: X10S >>  manifest.mf
echo branding: kCernel-SONY-thgokang-v3-998mhz >>  manifest.mf
echo Created-By: championswimmer >>  manifest.mf
echo version: 2.3.4 >>  manifest.mf
jar cvfm0 kernel.jar manifest.mf loader.sin kernel.sin
ren kernel.jar kCernel-SONY-thgokang-v3-998mhz.ftf
del manifest.mf
del kernel.sin
