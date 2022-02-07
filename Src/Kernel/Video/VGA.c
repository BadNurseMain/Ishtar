#include "Video.h"

//Memory Mapped Addresses for VGA.
#define GFX_VGA_VIDEOMEM        0xA0000
#define GFX_VGA_TEXTMEM         0xB8000
#define GFX_VGA_MODE            0x0449

void setVideoMode(int8_t Mode)
{
    int8_t* ModeAddress = GFX_VGA_MODE;
    *ModeAddress = Mode;
    return;
}

int8_t getVideoMode()
{
    int8_t* ModeAddress = GFX_VGA_MODE;
    return *ModeAddress;
}

void placeChar(int8_t Char, int16_t Location)
{
    int8_t XPosition = LOWORD(Location);
    int8_t YPosition = HIWORD(Location);

    int16_t* CharAddress = GFX_VGA_TEXTMEM + (XPosition * 80 + YPosition) * 2;

    *CharAddress = VGA_DEFAULT_CHAR | Char;
    return;
}

void placePixel(int8_t Colour, int32_t Location)
{
    int16_t XPosition = LODWORD(Location);
    int16_t YPosition = HIDWORD(Location);

    int8_t* VideoAddress = GFX_VGA_VIDEOMEM + (XPosition * 320 +  YPosition * 200);
    *VideoAddress = Colour;
    return;
}
