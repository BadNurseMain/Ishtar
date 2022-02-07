#ifndef STDINT
#define STDINT
#include <stdint.h>

#endif STDINT

#ifndef MACROS
#define MACROS

#define HIWORD(x) (x >> 8) << 8
#define LOWORD(x) (x << 8) >> 8

#endif MACROS

#ifndef GFX_DEF
#define GFX_DEF

//VGA Video Mode Types.
#define GFX_VGA_TEXTMODE        0x03
#define GFX_VGA_VIDEOMODE       0x0D

//VGA Text Types.
#define VGA_DEFAULT_CHAR    0x0f00

//VGA Colours.
#define VGA_COLOUR_BLACK    0x0000
#define VGA_COLOUR_BLUE     0x0001
#define VGA_COLOUR_GREEN    0x0002

#endif


void setVideoMode(int8_t Mode);
int8_t getVideoMode();

void placeChar(int8_t Char, int16_t Location);
void placePixel(int8_t Colour, int32_t Location);
