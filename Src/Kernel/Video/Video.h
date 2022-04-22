#ifndef STDINT
#define STDINT

#include <stdint.h>

#define LOBYTE(w) ((uint8_t)(w))
#define HIBYTE(w) ((uint8_t)(((uint16_t)(w) >> 8) & 0xFF))

#endif 

void print(char* String);

void placeChar(uint16_t Position, uint8_t Character);

void placeNum(uint16_t Position, uint32_t Number);

inline uint8_t getGraphicsMode();
