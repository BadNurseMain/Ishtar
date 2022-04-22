#include "Video.h"

#define VGA_TEXTMEM (uint16_t*)0xb8000

uint16_t Count = 0;

void print(char* String)
{
    uint16_t Loop = Count;
    
    do
    {
        placeChar(Loop, String[Loop]);
        ++Loop;
    } while(String[Loop]);

    Count += 0x0100;
    return;
}

void placeNum(uint16_t Position, uint32_t Number)
{
    //Declaring Variables.
    uint32_t Count = 0, tempNum = Number, num = 0;

    //Calculating Length.
    for(; tempNum > 0; tempNum = tempNum / 10) ++Count;
    Position += Count;

    //Looping through all numbers and displaying them.
    do
    {
        num = Number % 10;
        placeChar(--Position, num + '0');
        Number = Number / 10;
    }
    while(Number > 0);

    return;
}

void placeChar(uint16_t Position, uint8_t Character)
{
    uint16_t* VideoMemory = VGA_TEXTMEM + ((HIBYTE(Position) * 80) + LOBYTE(Position) * 2); 

    *VideoMemory = 0x0f00 + Character;
    return;
}

inline uint8_t getGraphicsMode()
{
    uint8_t* Ptr = (uint8_t*)0x0449;
    return *Ptr;    
}
