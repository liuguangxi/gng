/* Test program for GNG */

/*
 * Copyright (C) 2014, Guangxi Liu <guangxi.liu@opencores.org>
 *
 * This source file may be used and distributed without restriction provided
 * that this copyright statement is not removed from the file and that any
 * derivative work contains the original copyright notice and the associated
 * disclaimer.
 *
 * This source file is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License,
 * or (at your option) any later version.
 *
 * This source is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
 * License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this source; if not, download it from
 * http://www.opencores.org/lgpl.shtml
 */


#include <stdio.h>
#include "taus176.h"
#include "icdf.h"


int main()
{
    const int N = 1000000;
    taus_state_t state;
    unsigned seed;
    unsigned long long r;
    int x;
    FILE *fp;

    seed = 1;
    taus_set(&state, seed);

    fp = fopen("gng_data_out.txt", "w");
    for (int i = 0; i < N; i++) {
        r = taus_get(&state);
        x = icdf(r);
        fprintf(fp, "%d\n", x);
    }
    fclose(fp);

    return 0;
}
