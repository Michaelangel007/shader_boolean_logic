/*

 Boolean Logic Demo
 Michael Pohoreski aka mysticreddit
 Copyleft {C} 2017
 https://github.com/Michaelangel007/shader_boolean_logic

Version 5

DISCLAIMER:

      You are free to use this code as you wish.

      However, if you are going to copy/paste this code
      and paste snippets on StackOverflow, StackExchange, Reddit, etc.
      Please provide a link back to the original source
      so that people can find updates and bugfixes.
      Thanks!

Boolean Logic or Truth Tables are tradionally defined as integer only.
https://en.wikipedia.org/wiki/Truth_table#Binary_operations

We _can_ extend this to floating-poing math.

This demo shows how to define the boolean operators such as AND, OR, NOT, etc.
using floating-poing math when you don't have boolean operators.

This lets you create all sorts of interesting patterns.

i.e.
    Checkerboard = (x XOR y);

Also see:

 Cross Hatch Patterns
 https://www.shadertoy.com/view/MdfyDH

*/

    float   bNOT  ( float a )          { return 1.-a; }

    #define bFALSE                     (        0.                     ) // 0000 0
    float   bAND  ( float a, float b ) { return a*b;                   } // 0001 1
    float   bNTHEN( float a, float b ) { return a*(1.-b);              } // 0010 2
    #define bA                         (        a                      ) // 0011 3
    float   bNIF  ( float a, float b ) { return (1.-a)*b;              } // 0100 4
    #define bB                         (        b                      ) // 0101 5
    float   bXOR  ( float a, float b ) { return a*(1.-b)+(1.-a)*b;     } // 0110 6
    float   bOR   ( float a, float b ) { return 1.-(1.-a)*(1.-b);      } // 0111 7
    float   bNOR  ( float a, float b ) { return    (1.-a)*(1.-b);      } // 1000 8
    float   bXNOR ( float a, float b ) { return 1.-(a*(1.-b)+(1.-a)*b);} // 1001 9
    #define bNB                        (        1.-b                   ) // 1010 10
    float   bTHEN ( float a, float b ) { return 1.-(1.-a)*b;           } // 1011 11
    #define bNA                        (        1.-a                   ) // 1100 12
    float   bIF   ( float a, float b ) { return 1.-a*(1.-b);           } // 1101 13
    float   bNAND ( float a, float b ) { return 1.-a*b;                } // 1110 14
    #define bTRUE                      (        1.                     ) // 1111 15

    /*
        Sometimes you will seen this alternative definition for XOR:

            float bXOR2( float a, float b ) { return mod(a+b,2.0); }

        Which produces this output:

            0 0  0+0=0
            0 1  0+1=1
            1 0  1+0=1
            1 1  0+0=0

        This is valid for integers but technically doesn't produce
        "clean" floating-point values. See the GitHub README.md for more details.
    */

// Integer Boolean -- exact when a and b are quantized to 0.0 and 1.0
// Float   Boolean -- naive implementation
// =================================
float bBoolean( float op, float a, float b )
{
    float g = -1.0;

    if( op == 0.0 ) g = bFALSE;
    if( op == 1.0 ) g = bAND  ( a, b );
    if( op == 2.0 ) g = bNTHEN( a, b );
    if( op == 3.0 ) g = bA;
    if( op == 4.0 ) g = bNIF  ( a, b );
    if( op == 5.0 ) g = bB;
    if( op == 6.0 ) g = bXOR  ( a, b );
    if( op == 7.0 ) g = bOR   ( a, b );
    if( op == 8.0 ) g = bNOR  ( a, b );
    if( op == 9.0 ) g = bXNOR ( a, b );
    if( op ==10.0 ) g = bNB;
    if( op ==11.0 ) g = bTHEN ( a, b );
    if( op ==12.0 ) g = bNA;
    if( op ==13.0 ) g = bIF   ( a, b );
    if( op ==14.0 ) g = bNAND ( a, b );
    if( op ==15.0 ) g = bTRUE;

    return g;
}


// Float   Boolean -- proper implementation
// ====================
float fBoolean( float op, float a, float b, float gradient )
{
    float g = -1.0;

    a = ceil( a );
    b = ceil( b );

    if( op == 0.0 ) g = bFALSE;
    if( op == 1.0 ) g = bAND  ( a, b );
    if( op == 2.0 ) g = bNTHEN( a, b );
    if( op == 3.0 ) g = bA;
    if( op == 4.0 ) g = bNIF  ( a, b );
    if( op == 5.0 ) g = bB;
    if( op == 6.0 ) g = bXOR  ( a, b );
    if( op == 7.0 ) g = bOR   ( a, b );
    if( op == 8.0 ) g = bNOR  ( a, b );
    if( op == 9.0 ) g = bXNOR ( a, b );
    if( op ==10.0 ) g = bNB;
    if( op ==11.0 ) g = bTHEN ( a, b );
    if( op ==12.0 ) g = bNA;
    if( op ==13.0 ) g = bIF   ( a, b );
    if( op ==14.0 ) g = bNAND ( a, b );
    if( op ==15.0 ) g = bTRUE;

    return g * gradient;
}

vec3 vBoolean( float op, vec3 a, vec3 b, float gradient )
{
    return vec3(
        fBoolean( op, a.x, b.x, gradient ),
        fBoolean( op, a.y, b.y, gradient ),
        fBoolean( op, a.z, b.z, gradient )
    );
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

// WebGL 2.0: trunc()
float truncate( float x )
{
    return x - fract(x);
}

// WebGL 1.0: fract()
float Fract( float x )
{
    return x - floor( x );
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

vec3 hsv2rgb( vec3 c )
{
    vec3 K = vec3(3,2,1) / 3.0;
    vec3 p = abs(fract(c.rrr + K.rgb) * 6.0 - vec3(3));
    return c.b * mix(K.rrr, clamp(p - K.rrr, 0.0, 1.0), c.g);
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

// Creative Commons CC0 1.0 Universal (CC-0)
// Based on:
// https://www.shadertoy.com/view/4sBSWW

/* */ vec2  gvFontSize    = vec2(4.0, 15.0); // Multiples of 4x5 work best
/* */ vec2  gvPrintCharXY = vec2( 0.0, 0.0 ); // in pixels, NOT normalized
const float nPrintDelta = 32.0;
const float nPrintShift = 96.0;

// x = ASCII value in decimal
// Bits are left-to-right, 4x5
float GlyphBin(const in int x)
{
    if (x < 47)
        return // Glyphs added by Michael Pohoreski
             x==32 ?      0.0
            :x==33 ? 139778.0 // '!' 0x21
            :x==38 ? 152154.0 // '&' 0x25
            :x==42 ?  21072.0 // '*' 0x2A
            :x==45 ?   3840.0 // '-' 0x2D
            :/* 46*/      2.0 // '.' 0x2E
            ;
    if ((x < 58))
        return // Mostly original glyphs
             x==48 ? 480599.0 // '0' 0x30
            :x==49 ? 143911.0 // '1' // Original: 139810.0
            :x==50 ? 476951.0 // '2'
            :x==51 ? 476999.0 // '3'
            :x==52 ? 350020.0 // '4'
            :x==53 ? 464711.0 // '5'
            :x==54 ? 464727.0 // '6'
            :x==55 ? 476228.0 // '7'
            :x==56 ? 481111.0 // '8'
            :/* 57*/ 481095.0 // '9' 0x39
            ;
    else
    if (x < 78)
        return // Glyphs added by Michael Pohoreski
             x==61 ?  61680.0 // '=' 0x3D
            :x==65 ? 434073.0 // 'A' 0x41
            :x==66 ? 497559.0 // 'B' 0x42
            :x==67 ? 921886.0 // 'C' 0x43
            :x==68 ? 498071.0 // 'D' 0x44
            :x==69 ? 988959.0 // 'E' 0x45
            :x==70 ? 988945.0 // 'F' 0x46
            :x==71 ? 925086.0 // 'G' 0x47
            :x==72 ? 630681.0 // 'H' 0x48
            :x==73 ? 467495.0 // 'I' 0x49
            :x==74 ? 559239.0 // 'J' 0x4A
            :x==75 ? 611161.0 // 'K' 0x4B
            :x==76 ?  69919.0 // 'L' 0x4C
            :/* 77*/ 653721.0 // 'M' 0x4D
            ;
    else
    if (x < 91)
        return // Glyphs added by Michael Pohoreski
             x==78 ? 638361.0 // 'N' 0x4E
            :x==79 ? 432534.0 // 'O' 0x4F // width=4, 432534; width=3 152914
            :x==80 ? 497425.0 // 'P' 0x50
            :x==81 ? 432606.0 // 'Q' 0x51
            :x==82 ? 497561.0 // 'R' 0x52
            :x==83 ? 923271.0 // 'S' 0x53
            :x==84 ? 467490.0 // 'T' 0x54
            :x==85 ? 629142.0 // 'U' 0x55
            :x==86 ? 349474.0 // 'V' 0x56
            :x==87 ? 629241.0 // 'W' 0x57
            :x==88 ? 628377.0 // 'X' 0x58
            :x==89 ? 348706.0 // 'Y' 0x59
            :/* 90*/ 475671.0 // 'Z' 0x5A
            ;
    else
    if (x < 127 )
        return
          x ==101 ?  10006.0 // 'e' 0x65
         :x ==102 ? 272162.0 // 'f' 0x66
         :x ==104 ?  70485.0 // 'h' 0x68
         :x ==105 ? 131618.0 // 'i' 0x69
         :x ==110 ?    853.0 // 'n' 0x6E
         :x ==116 ? 141092.0 // 't' 0x74
         :x ==127 ? 678490.0 //     0x7F
         :               0.0
         ;
    return 0.0;
}


// Returns alpha of character
// =================================
float CharAlpha( vec2 vFragCoord, float fValue )
{
    vec2 vStringCharCoords = (vFragCoord.xy - gvPrintCharXY) / gvFontSize;
    if ((vStringCharCoords.y < 0.0) || (vStringCharCoords.y >= 1.0)) return 0.0; // backgroundColor;
    if ( vStringCharCoords.x < 0.0)                                  return 0.0; // backgroundColor;

    fValue += nPrintDelta;
    float fCharBin = (vStringCharCoords.x < 1.0) ? GlyphBin(int(fValue)) : 0.0;

    // Auto-Advance cursor one glyph plus 1 pixel padding
    // thus characters are spaced 9 pixels apart
    float fAdvance = false
        || (fValue == 42.) // *
        || (fValue == 73.) // I
        || (fValue == 84.) // T
        || (fValue == 86.) // V
        || (fValue == 89.) // Y
        || (fValue ==104.) // h
        || (fValue ==105.) // i
        || (fValue ==116.) // t
        ? 0.0 // glyph width has no padding
        : 1.0;
    if( fValue == 33.) // !
        fAdvance = -(gvFontSize.x / 6.0);
    gvPrintCharXY.x += gvFontSize.x + fAdvance;

    // a = floor(mod((fCharBin / pow(2.0, floor(fract(vStringCharCoords.x) * 4.0) + (floor(vStringCharCoords.y * 5.0) * 4.0))), 2.0));
    //return mix( backgroundColor, textColor, a );

    return floor(
        mod(
            (fCharBin / pow(
                2.0,
                floor(fract(vStringCharCoords.x) * 4.0) +
                (floor(vStringCharCoords.y * 5.0) * 4.0))),
            2.0
        )
    );
}

/*
Usage:
    // void mainImage( out vec4 fragColor, in vec2 fragCoord )

    vec3 colorBG  = vec( 1 );
    vec3 colorFG  = vec( 0 );
    vec3 color;

    vec2 centerXY = iResolution.xy * 0.5;
    gvPrintCharXY = vec2( centerXY );

    float len;
    float text = text3( len, 65.0, 66.0, 67.0 );
    color = PutChar( colorBG, colorFG, fragCoord, text ); // "ABC"

    text = text3( len, 88.0, 89.0, 90.0 );
    color = mix(     color  , colorFG, fragCoord, text ); // "XYZ"

    fragColor.rgb = color;
*/
// =================================
vec3 PutChar( vec3 vBackgroundColor, vec3 vTextColor, vec2 vFragCoord, float fValue )
{
    float a = CharAlpha( vFragCoord, fValue - nPrintDelta );
    return mix( vBackgroundColor, vTextColor, a );
}

/*
   Print a maximum of 3 characters
       = floating-point 24-bits mantissa / 7-bits/char
       = 3.42... chars
*/
// =================================
vec3 Print( vec3 vBackgroundColor, vec3 vTextColor, vec2 vFragCoord, float fChars )
{
    vec3  color = vBackgroundColor;
    float bits  = fChars;

    for( int i = 0; i < 3; i++ )
    {
        float nChar = mod( bits, nPrintShift );
        nChar += nPrintDelta;
        if( nChar < 32.0 )
            break;

        bits /= nPrintShift;
        bits = floor( bits );

        color = PutChar( color, vTextColor, vFragCoord, nChar );
    }
    return color;
}


// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

float cell_gradient( vec2 q, float y, float h )
{
    return mod( 4.0*(q.y - y), h ) / h;
}

// Pack 3 chars into 24-bit float mantissa
float text3( out float len, float c1, float c2, float c3 )
{
    float s = 1.0;
    float t = nPrintShift;

    float text     = 0.0;
    float numChars = 0.0;

    if( c1 > 0.0) { numChars += 1.0; text += s*(c1 - nPrintDelta); s *= t; }
    if( c2 > 0.0) { numChars += 1.0; text += s*(c2 - nPrintDelta); s *= t; }
    if( c3 > 0.0) { numChars += 1.0; text += s*(c3 - nPrintDelta); s *= t; }
//    if( c4 > 0.0) { numChars += 1.0; text += s*(c4 - nPrintDelta); s *= t; }

    len = numChars;
    return text;
}

float center( float glyphWidth, float numChars )
{
    return (glyphWidth - numChars*gvFontSize.x) * 0.5;
}

#define GRID_HORZ_COLOR if( i < (edgeH / iResolution.y) ) color = colorG* mod( p.x, 2.0 );

// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


// =================================
void mainImage( out vec4 f, in vec2 p )
{
    vec2 q = p / iResolution.xy;
    bool m = (iMouse.z > 0.5); // left mouse button down

    float g;

    float COL = 18.0;
    float x = floor( q.x * COL );
    float y;
    float z = 0.0;

    float w = iResolution.x / COL;
    float h = 0.25;
    float statusH = 0.05;
    float spacerH = (1.0 - statusH - (3.0*h)) / 3.0;

    float a,b;
    vec3  c,d;

    vec3 colorA = vec3( 1.0, 0.0, 0.0 ); // Red
    vec3 colorB = vec3( 0.0, 1.0, 0.0 ); // Green
    vec3 colorT = vec3( 1.0, 1.0, 0.0 ); // Yellow - Status Text
    vec3 colorF = vec3( 0.0, 0.7, 1.0 ); // HSB( 200, 100, 100 ) = #00AAFF; X Windows: Deep Sky Blue #00BBFF
    vec3 colorG = m ? vec3( 0.0 ) : vec3( 1.0 );
    vec3 colorN = vec3( 0.5, 0.5, 1.0 ); // #0 .. #15
    vec3 colorS = vec3( 1.0 ); // White header background

    vec3 color = colorS;

    float s    = 128.0; // 2nd glyph
    float t    = s*s; // 3rd glyph
    float text = 0.0;
    float prefixGap = (w - gvFontSize.x)*0.5;
    float len;

    if( iResolution.x > 512. )
        gvFontSize.x *= 2.0;
        
    float x0 = fract( q.x * COL );
    float edgeW = COL / iResolution.x;
    float edgeH = 12.0; // Magic Number: 1 scanline of h

    if( x0 > (1.0 - edgeW) ) // Vertical Grid has priority
    {
        color = colorG * mod( p.y, 2.0 ); // stipple = dotted vertical grid line
    }
    else
    if( q.y >= (1.0 - (gvFontSize.y / iResolution.y)) ) // Normalized Font Height
    {

        gvPrintCharXY.y = iResolution.y - gvFontSize.y;

            // Show '#'
            if( x >= 2.0 )
            {
                float text = text3( len, 48.0 + (x - 2.0), 0.0, 0.0 ); // '0' .. '9'
                if( x >= 12.0 )
                {
                    text = text3( len, 49.0, (48.0 + x - 12.0), 0.0 );
                }

                prefixGap = center( w, len );
                gvPrintCharXY.x = x*w + prefixGap;

                color = Print  ( vec3( 1.0, 1.0, 0.0) , colorN, p, text );
            }
    }
    else
    if( q.y >= 0.5 + 2.*spacerH ) // top - Quantized integer Boolean
    {
        y = 0.5 + 2.*spacerH;
        float i = cell_gradient( q, y, h ); // monochrome gradient ramp

        // y = 0 at bottom
        if( q.y <= (y + h*4./4.) ) // 18 columns x 4 rows
        {
            if( q.y < (y + h*1./4.) ) { a = 1.; b = 1.; }
else        if( q.y < (y + h*2./4.) ) { a = 1.; b = 0.; }
else        if( q.y < (y + h*3./4.) ) { a = 0.; b = 1.; }
else        if( q.y < (y + h*4./4.) ) { a = 0.; b = 0.; }

            float j = bBoolean( x-2.0, a, b );
            float k = j;

            if( x == 0.0 ) { color = colorA * a; k = a;       }
            if( x == 1.0 ) { color = colorB * b; k = b*3./6.; } // green
            if( x >= 2.0 ) { color = colorF * j; k*=   1./6.; } // sky blue

            if( m )
              color = hsv2rgb( vec3( fract(2./3. * (1.0 - k)), 1.0, 1.0 ) );

            // horizontal grid lines at bottom of cell
            GRID_HORZ_COLOR
        }
        else
        {
            gvPrintCharXY.y = (y + h) * iResolution.y;

            if( x < 2.0 )
            {
                text = text3( len, 65.0, 0.0, 0.0 ); // 'A'
                gvPrintCharXY.x = prefixGap; // x/2 = center
                color = Print( color, colorA, p, text );

                text = text3( len, 66.0, 0.0, 0.0 ); // 'B'
                gvPrintCharXY.x = w + prefixGap; // x/2 = center
                color = Print( color, colorB*0.85, p, text );
            }
            else
            {
                float col = x - 2.0;
                vec2  saveSize = gvFontSize;
                float len = 1.0;

                if( col == 0.0 ) text = text3( len, 70.0,  0.0,  0.0 ); // FALSE '0'=48
                if( col == 1.0 ) text = text3( len, 65.0, 78.0, 68.0 ); // AND '&'=38
                if( col == 2.0 ) text = text3( len, 33.0,116.0,104.0 ); // !THEN // prefixGap = gvFontSize.x*0.5;
                if( col == 3.0 ) text = text3( len, 65.0,  0.0,  0.0 ); // A
                if( col == 4.0 ) text = text3( len, 33.0,105.0,102.0 ); // !if // prefixGap = gvFontSize.x*0.5; }
                if( col == 5.0 ) text = text3( len, 66.0,  0.0,  0.0 ); // B
                if( col == 6.0 ) text = text3( len, 88.0, 79.0, 82.0 ); // XOR
                if( col == 7.0 ) text = text3( len, 79.0, 82.0,  0.0 ); // OR
                if( col == 8.0 ) text = text3( len, 78.0, 79.0, 82.0 ); // NOR
                if( col == 9.0 ) text = text3( len, 88.0, 78.0, 79.0 ); // XNOR
                if( col ==10.0 ) text = text3( len, 33.0, 66.0,  0.0 ); // !B
                if( col ==11.0 ) text = text3( len,116.0,104.0,101.0 ); // then
                if( col ==12.0 ) text = text3( len, 33.0, 65.0,  0.0 ); // !A
                if( col ==13.0 ) text = text3( len,105.0,102.0,  0.0 ); // IF
                if( col ==14.0 ) text = text3( len, 78.0, 65.0, 78.0 ); // NAND '&'=33,38
                if( col ==15.0 ) text = text3( len, 84.0,  0.0,  0.0 ); // TRUE '1'=49

                if( col== 2.0 ) len = 5.0; // !THEN
else            if( col== 9.0 ) len = 4.0; // XNOR
else            if( col==11.0 ) len = 4.0; // THEN
else            if( col==14.0 ) len = 4.0; // NAND

                prefixGap = center( w, len ); 

                gvPrintCharXY.x = x*w + prefixGap; // x/2 = center on x chars

                color = Print( colorS, colorF, p, text );

                if( col == 2.0 ) // !THEN
                {
                    text = text3( len, 101.0, 110.0, 0.0 ); // !TH__ = EN
                    color = Print( color, colorF, p, text );
                }
                if( col == 9.0 ) // XNOR
                {
                    text = text3( len, 82.0, 0.0, 0.0 ); // XNO_ = R
                    color = Print( color, colorF, p, text );
                }
                if( col ==11.0 ) // THEN
                {
                    text = text3( len, 110.0, 0.0, 0.0 ); // the_ = n
                    color = Print( color, colorF, p, text );
                }
                if( col ==14.0 ) // NAND
                {
                    text = text3( len, 68.0, 0.0, 0.0 ); // NAN_ = D
                    color = Print( color, colorF, p, text );
                }
            }
        }
    }
    else
    if( q.y >= 0.25 + spacerH ) // middle -- Naive floating-point Boolean
    {
        y = 0.25 + spacerH;
        float i = cell_gradient( q, y, h ); // monochrome gradient ramp

        // y = 0 at bottom
        if( q.y <= (y + h*4./4.) ) // 18 columns x 4 rows
        {
            if( q.y < (y + h*1./4.) ) { a = i; b = i; }
else        if( q.y < (y + h*2./4.) ) { a = i; b = z; }
else        if( q.y < (y + h*3./4.) ) { a = z; b = i; }
else        if( q.y < (y + h*4./4.) ) { a = z; b = z; }

            float j = bBoolean( x-2.0, a, b );
            float k;

            if( x == 0.0 ) { color = colorA * a; k = a; }
            if( x == 1.0 ) { color = colorB * b; k = b; }
            if( x >= 2.0 ) { color = colorF * j; k = j; }

            if( m )
                color = hsv2rgb( vec3( fract(2./3. * (1.0 - k)), 1.0, 1.0 ) );

            // horizontal grid lines at bottom of cell
            GRID_HORZ_COLOR
        }
    }
    else
    if( q.y >= 0.0) // bottom - proper gradient Boolean
    {
        y  = 0.0;
        float i = cell_gradient( q, y, h ); // monochrome gradient ramp

        // y = 0 at bottom
        if( q.y <= (y + h*4./4.) ) // 18 columns x 4 rows
        {
            // 18 columns x 4 rows
            if( q.y < (y + h*1./4.) ) { a = i; b = i; }
else        if( q.y < (y + h*2./4.) ) { a = i; b = z; }
else        if( q.y < (y + h*3./4.) ) { a = z; b = i; }
else        if( q.y < (y + h*4./4.) ) { a = z; b = z; }

            float j = fBoolean( x-2.0, a, b, i );

            if( x == 0.0 ) { color = vec3(a); } // Column  0 = A
            if( x == 1.0 ) { color = vec3(b); } // Column  1 = B
            if( x >= 2.0 ) { color = vec3(j); } // Columns 2..18 = Truth Table

            if( m )
                color = hsv2rgb( vec3( fract(2./3. * (1.0 - color.r)), 1.0, 1.0 ) );

            // horizontal grid lines at bottom of cell
            GRID_HORZ_COLOR
        }
    }

    /*
        NOTE:

        Color Gradients can be used to verify correct floating-point Boolean Operators
        show if the output gradient has the same gradient as the input

        i.e.

        When

            a = 0.0 .. 1.0
            b = 0.0 .. 1.0
            g = 0.0 .. 1.0

        Then AND is usually defined as a*b

                         WrongGradient                   Correct
            a     b      a*b     a*b/sqrt(a*b)  2.0*a*b  g*(ceil(a)*ceil(b))
            0.75  0.75   0.5625  0.75           1.125    0.75
            0.5   0.5    0.25    0.50           0.05     0.75
            0.25  0.25   0.0625  0.25           0.125    0.25
            0.0   0.75   0.0     NaN            0.0      0.0
            0.75  0.0    0.0     NaN            0.0      0.0
    */

    // Slightly dim every other column in the table for readability
    if( (x >= 2.0 && mod(x,2.0) == 0.0) )
        color *= 0.95;

    f.rgb = color;
}

