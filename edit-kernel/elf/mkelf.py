#!/usr/bin/env python
#
# DESCRIPTION
#
#   Combine one or more files to a elf file.
#
# SYNOPSIS
#
#   mkelf.py -o elf file@addr[,ramdisk] ...
#
#   elf         The path to the output file
#   file        Input file
#   addr        ELF vaddr and paddr of this file
#   ramdisk     Mark this segment to be presented in ATAG list as ramdisk (optional)
#   ipl         Mark this segment to be handled by the boot code as IPL (optional)
#   cmdline     Mark this segment to be handled by the boot code as kernel cmdline (optional)
#

import re
import os
import sys
import struct
from optparse import OptionParser

# Elf definitions
PT_NULL = 0
PT_LOAD = 1
PT_NOTE = 4

# SEMC Elf definitions
P_FLAGS_RAMDISK = 0x80000000
P_FLAGS_IPL     = 0x40000000 # used for STE U8500
P_FLAGS_CMDLINE = 0x20000000
P_FLAGS_RPM     = 0x01000000 # used for QCT MSM8x60

def fatal(message):
    print >> sys.stderr, '%s: %s' % (os.path.basename(sys.argv[0]), message)
    sys.exit(1)

def parse_inputs(args):
    segs = []
    for arg in args:
        try:
            seg = {}
            tokens = arg.split('@')
            if len(tokens) != 2:
                fatal('Incorrect format of input parameter: ' + arg)

            seg['file'] = tokens[0]
            if tokens[1] == 'cmdline':
                seg['addr'] = '0'
                seg['flags'] = 'cmdline'
            else:
                input = re.match("^(0x[0-9a-fA-F]+)(?:,(ramdisk|ipl|entry|rpm))?$", tokens[1]).groups()
                seg['addr'] = input[0]
                seg['flags'] = input[1]
            segs.append(seg)
        except AttributeError:
            fatal("Incorrect format of input parameter: " + arg)
    return segs

def write_elf_header(elf, entry, phnum):
    elfhdr = {
        'e_ident': '\x7fELF\x01\x01\x01\x61',
        'e_type': 2,
        'e_machine': 40,
        'e_version': 1,
        'e_entry': long(entry, 16),
        'e_phoff': 52,
        'e_shoff': 0,
        'e_flags': 0,
        'e_ehsize': 52,
        'e_phentsize': 32,
        'e_phnum': phnum,
        'e_shentsize': 0,
        'e_shnum': 0,
        'e_shstrndx': 0
    }

    elf.write(struct.pack('<8s8xHHLLLLLHHHHHH',
                           elfhdr['e_ident'], elfhdr['e_type'], elfhdr['e_machine'],
                           elfhdr['e_version'], elfhdr['e_entry'], elfhdr['e_phoff'],
                           elfhdr['e_shoff'], elfhdr['e_flags'], elfhdr['e_ehsize'],
                           elfhdr['e_phentsize'], elfhdr['e_phnum'], elfhdr['e_shentsize'],
                           elfhdr['e_shnum'], elfhdr['e_shstrndx']))

def write_elf_phdr(elf, seg):
    type = PT_LOAD
    flags = 0

    if seg['flags'] == 'ramdisk':
        flags = P_FLAGS_RAMDISK
    elif seg['flags'] == 'ipl':
        flags = P_FLAGS_IPL
    elif seg['flags'] == 'cmdline':
        flags = P_FLAGS_CMDLINE
        type = PT_NOTE
    elif seg['flags'] == 'rpm':
        flags = P_FLAGS_RPM

    elfphdr = {
        'p_type': type,
        'p_offset': seg['offset'],
        'p_vaddr': long(seg['addr'], 16),
        'p_paddr': long(seg['addr'], 16),
        'p_filesz': seg['size'],
        'p_memsz': seg['size'],
        'p_flags': flags,
        'p_align': 0
    }

    elf.write(struct.pack('<LLLLLLLL',
                          elfphdr['p_type'],
                          elfphdr['p_offset'],
                          elfphdr['p_vaddr'],
                          elfphdr['p_paddr'],
                          elfphdr['p_filesz'],
                          elfphdr['p_memsz'],
                          elfphdr['p_flags'],
                          elfphdr['p_align']))

def main(args):
    parser = OptionParser("usage: %prog options")
    parser.add_option("-o", dest="outputfile", help="path to the output file")
    (opts, args) = parser.parse_args()

    if not opts.outputfile:
        fatal("Missing -o on command line")
    if len(args) < 1:
        fatal("Missing input files")

    offset = 4096
    segments = []
    for seg in parse_inputs(args):
        size = os.path.getsize(seg['file'])
        seg['offset'] = offset
        seg['size'] = size
        segments.append(seg)
        offset += size

    elf = open(opts.outputfile, 'wb')

    write_elf_header(elf, segments[0]['addr'], len(segments))
    for seg in segments:
        write_elf_phdr(elf, seg)

    for seg in segments:
        elf.seek(seg['offset'])

        f = open(seg['file'], 'rb')
        data = f.read()
        elf.write(data)
        f.close()

    elf.close()

if __name__ == "__main__":
    main(sys.argv[1:])

