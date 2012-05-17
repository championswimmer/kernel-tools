/*
 * Copyright (C) 2008 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * gcc -O2 -Wall -Wno-unused-parameter -o 5652rgb from565.c
 * ./5652rgb -rle < logo.rle > logo.raw
 * convert -depth 8 -size 320x480 rgb:logo.raw logo.png
 */
	
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define to565(r,g,b)                                            \
    ((((r) >> 3) << 11) | (((g) >> 2) << 5) | ((b) >> 3))


#define from565_r(x) ((((x) >> 11) & 0x1f) * 255 / 31)
#define from565_g(x) ((((x) >> 5) & 0x3f) * 255 / 63)
#define from565_b(x) (((x) & 0x1f) * 255 / 31)

void from_565_raw(void)
{
    unsigned short out;
    unsigned short in;

    while(read(0, &in, 2) == 2) {
	out = from565_r(in);
        write(1, &out, 1);
	out = from565_g(in);
        write(1, &out, 1);
	out = from565_b(in);
        write(1, &out, 1);
    }
    return;
}

void from_565_rle(void)
{
    unsigned short times, count;
    unsigned short in [2];
    unsigned short color, outR, outG, outB;
    unsigned total = 0;

    while(read(0, in, 4)) {
        count = in[0];
	color = in[1];
	total += count;

	outR = from565_r(color);
	outG = from565_g(color);
	outB = from565_b(color);

	for (times=0;times<count;times++) {
	    write(1, &outR, 1);
	    write(1, &outG, 1);
	    write(1, &outB, 1);
	}
    }

    fprintf(stderr,"%d pixels\n",total);
}

int main(int argc, char **argv)
{
    if ((argc == 2) && (!strcmp(argv[1],"-rle"))) {
        from_565_rle();
    } else {
        if (argc == 1) {
            from_565_raw();
        } else {
        fprintf(stderr,"Usage : %s [-rle] < rgb_565_input_file > raw_rgb_output_file\n   -rle : RLE decode input file\n",argv[0]);
        }
    }
    return 0;
}
