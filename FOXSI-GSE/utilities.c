//
//  utilities.c
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/24/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#include "utilities.h"

unsigned getbits(unsigned x, int p, int n)
{
    // This function extracts n bits, starting at position p, from integer x.
    // The most common use is n=1 to extract a single bit at position p.
    // p=0 refers to the rightmost (LSB) bit.
    // The full description is at
    // http://www.java-samples.com/showtutorial.php?tutorialid=500
    
    return (x >> (p+1-n)) & ~(~0 << n);
    
}

unsigned reversebits(unsigned x, int n)
{
    // This function reverses the bit order of an integer and returns it.  Only the n number of LSB are included;
    // all other bits are zero.
    
    // example for 5 bits; the code does:
    // getbits(x,4,1)*1 + getbits(x,3,1)*2 + getbits(x,2,1)*4 + getbits(x,1,1)*8 + getbits(x,0,1)*16
    
    unsigned y = 0;
    
    for(int i=0; i<n; i++){
        
        y = y + getbits(x, n-i-1, 1)*pow(2,i);
        //		cout << y << '\t';  // debug
        
    }
    
    return y;
    
}
