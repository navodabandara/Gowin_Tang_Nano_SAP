/*
Generates a memory initialization file for Gowin SPRAM Core to create a LUT that outputs the 7 segment represention of
8 bit signed and unsigned integers.
*/
#include <stdio.h>
#include <stdint.h>

#define DATA_TYPE uint16_t
#define DATA_WIDTH 16

uint8_t segments[11] = {0b01111110,//0
                        0b00110000,//1
                        0b01101101,//2
                        0b01111001,//3
                        0b00110011,//4
                        0b01011011,//5
                        0b01011111,//6
                        0b01110000,//7
                        0b01111111,//8
                        0b01111011,//9
                        0b00000001,};//- minus sign

uint8_t get7SegFromASCII(int ascii){
   ascii = ascii - 48;
   if (ascii == -3) return segments[10];
   else return segments[ascii];
}

uint32_t fourDigits;
int main(void){
    printf("#File_format=AddrHex\n#Address_depth=512\n#Data_width=24\n");
    int i, address=0;
    char buff[6];

    for (i=0; i<256; i++){
        sprintf((char *)buff, "%04d\n", i);
        fourDigits = (get7SegFromASCII(buff[3]) << 21) | (get7SegFromASCII(buff[2]) << 14) | (get7SegFromASCII(buff[1]) << 7) |     get7SegFromASCII(buff[0]);
        printf("%x:%6x\n", address, fourDigits);
        address++;
    }
    for (i=-128; i<128; i++){
        sprintf((char *)buff, "%04d\n", i);
        fourDigits = (get7SegFromASCII(buff[3]) << 21) | (get7SegFromASCII(buff[2]) << 14) | (get7SegFromASCII(buff[1]) << 7) |     get7SegFromASCII(buff[0]);
        printf("%x:%6x\n", address, fourDigits);
        address++;
    }
}