/*
Based on Ben Eater's microcode-eeprom-programmer.
https://github.com/beneater/eeprom-programmer/blob/master/microcode-eeprom-programmer/microcode-eeprom-programmer.ino
This example can be used to generate the memory initialization file for GOWIN 1.9.8.03 to create the LUT...
for the instruction decoder.

Compile with : gcc -Wall generator.c -o generator.exe
To generate mi file : generator.exe > microcode_LUT.mi
*/


#include <stdio.h>
#include <stdint.h>

#define DATA_TYPE uint16_t
#define DATA_WIDTH 16

#define SHIFT_DATA 2
#define SHIFT_CLK 3
#define SHIFT_LATCH 4
#define EEPROM_D0 5
#define EEPROM_D7 12
#define WRITE_EN 13

#define HLT 0b1000000000000000  // Halt clock
#define MI  0b0100000000000000  // Memory address register in
#define RI  0b0010000000000000  // RAM data in
#define RO  0b0001000000000000  // RAM data out
#define IO  0b0000100000000000  // Instruction register out
#define II  0b0000010000000000  // Instruction register in
#define AI  0b0000001000000000  // A register in
#define AO  0b0000000100000000  // A register out
#define EO  0b0000000010000000  // ALU out
#define SU  0b0000000001000000  // ALU subtract
#define BI  0b0000000000100000  // B register in
#define OI  0b0000000000010000  // Output register in
#define CE  0b0000000000001000  // Program counter enable
#define CO  0b0000000000000100  // Program counter out
#define J   0b0000000000000010  // Jump (program counter in)
#define FI  0b0000000000000010 // Flag Register in

DATA_TYPE data[] = {
  MI|CO,  RO|II|CE,  0,      0,      0,           0, 0, 0,   // 0000 - NOP
  MI|CO,  RO|II|CE,  IO|MI,  RO|AI,  0,           0, 0, 0,   // 0001 - LDA
  MI|CO,  RO|II|CE,  IO|MI,  RO|BI,  EO|AI|FI,    0, 0, 0,   // 0010 - ADD
  MI|CO,  RO|II|CE,  IO|MI,  RO|BI,  EO|AI|SU|FI, 0, 0, 0,   // 0011 - SUB
  MI|CO,  RO|II|CE,  IO|MI,  AO|RI,  0,           0, 0, 0,   // 0100 - STA
  MI|CO,  RO|II|CE,  IO|AI,  0,      0,           0, 0, 0,   // 0101 - LDI
  MI|CO,  RO|II|CE,  IO|J,   0,      0,           0, 0, 0,   // 0110 - JMP
  MI|CO,  RO|II|CE,  0,      0,      0,           0, 0, 0,   // 0111
  MI|CO,  RO|II|CE,  0,      0,      0,           0, 0, 0,   // 1000
  MI|CO,  RO|II|CE,  0,      0,      0,           0, 0, 0,   // 1001
  MI|CO,  RO|II|CE,  0,      0,      0,           0, 0, 0,   // 1010
  MI|CO,  RO|II|CE,  0,      0,      0,           0, 0, 0,   // 1011
  MI|CO,  RO|II|CE,  0,      0,      0,           0, 0, 0,   // 1100
  MI|CO,  RO|II|CE,  0,      0,      0,           0, 0, 0,   // 1101
  MI|CO,  RO|II|CE,  AO|OI,  0,      0,           0, 0, 0,   // 1110 - OUT
  MI|CO,  RO|II|CE,  HLT,    0,      0,           0, 0, 0,   // 1111 - HLT
};

int main(void){
	printf("#File_format=AddrHex\n#Address_depth=%d\n#Data_width=%d\n",(int) sizeof(data)/ (int) sizeof(DATA_TYPE), DATA_WIDTH);
	int i;
	for(i=0;i<sizeof(data)/ (int) sizeof(DATA_TYPE);i++){
		printf("%x:%.4x\n", i,data[i]);
	}
}