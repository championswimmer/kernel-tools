#!/usr/bin/perl -W

#
# DooMLoRD modified unpack-bootimg.pl script for SEMC devices
#
# Info:
# this will unpack kernel.sin to zImage and ramdisk
#
# Supported Devices:
# Xperia X10 (GB update, custom kernels for unlocked bootloaders)
# Xperia 2011 devices (Arc, Neo, Play, Mini, Mini Pro, Ray, Pro)
#

use strict;
use bytes;
use File::Path;

print "\n DooMLoRD modified unpack-bootimg.pl script for SEMC devices\n";
print "\n Info:\n";
print " this will unpack kernel.sin to zImage and ramdisk\n";
print "\n";
print "\n Supported Devices:\n";
print " Xperia X10 (GB update, custom kernels for unlocked bootloaders)\n";
print " Xperia 2011 devices (Arc, Neo, Play, Mini, Mini Pro, Ray, Pro)\n";

die "did not specify kernel sin file\n" unless $ARGV[0];

my $kernelsinfile = $ARGV[0];

my $slurpvar = $/;
undef $/;
open (KERNELSINFILE, "$kernelsinfile") or die "could not open boot img file: $kernelsinfile\n";
my $kernelsin = <KERNELSINFILE>;
close KERNELSINFILE;
$/ = $slurpvar;

# chop off the header
$kernelsin =~ /(.*\x00\x00\x00\x00)(\x00\x00\xA0\xE1\x00\x00\xA0\xE1\x00\x00\xA0\xE1\x00\x00\xA0\xE1\x00\x00\xA0\xE1\x00\x00\xA0\xE1\x00\x00\xA0\xE1\x00\x00\xA0\xE1.*)/s;

my $header = $1;
my $bootimg = $2;

open (HEADERFILE, ">$ARGV[0]-header");
print HEADERFILE $header or die;
close HEADERFILE;


# we'll check how many ramdisks are embedded in this image
my $numfiles = 0;

# we look for the hex 00 00 00 00 1F 8B because we expect some trailing padding zeroes from the kernel or previous ramdisk, followed by 1F 8B (the gzip magic number)
while ($bootimg =~ m/\x00\x00\x00\x00\x1F\x8B/g) {
	$numfiles++;
}

if ($numfiles == 0) {
	die "Could not find any embedded ramdisk images. Are you sure this is a full boot image?\n";
} elsif ($numfiles > 1) {
	die "Found a secondary file after the ramdisk image.  According to the spec (mkbootimg.h) this file can exist, but this script is not designed to deal with this scenario.\n";
}

$bootimg =~ /(.*\x00\x00\x00\x00)(\x1F\x8B.*)/s;

my $kernel = $1;
my $ramdisk = $2;


open (KERNELFILE, ">$ARGV[0]-kernel");
print KERNELFILE $kernel or die;
close KERNELFILE;

open (RAMDISKFILE, ">$ARGV[0]-ramdisk.cpio.gz");
print RAMDISKFILE $ramdisk or die;
close RAMDISKFILE;

print "\nsin file has been splitted\n";
if (-e "$ARGV[0]-ramdisk") { 
	rmtree "$ARGV[0]-ramdisk";
	print "\nremoved old directory $ARGV[0]-ramdisk\n";
}

mkdir "$ARGV[0]-ramdisk" or die;
chdir "$ARGV[0]-ramdisk" or die;
system ("gunzip -c ../$ARGV[0]-ramdisk.cpio.gz | cpio -i");


