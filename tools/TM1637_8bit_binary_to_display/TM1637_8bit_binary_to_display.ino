//Connect Pins B0 to B7 to corresponding output pins on the Tang Nano to display...
//8bit data on the TM167 display as a decimal number. Also includes a pin to toggle...
//between displaying 2-s complement signed numbers. If not in use, ground this pin.
//Tested and works on Arduino Uno.

#include <Arduino.h>
#include <TM1637Display.h>

// Module connection pins (Digital Pins)
#define CLK 2
#define DIO 3

//Pins to set the binary value
#define B0 5
#define B1 6
#define B2 7
#define B3 8
#define B4 9
#define B5 10
#define B6 11
#define B7 12
#define SIGNED 13

uint8_t value = 0;
TM1637Display display(CLK, DIO); //Init display

void setup()
{
  //Set pins as inputs
  pinMode(B0, INPUT);
  pinMode(B1, INPUT);
  pinMode(B2, INPUT);
  pinMode(B3, INPUT);
  pinMode(B4, INPUT);
  pinMode(B5, INPUT);
  pinMode(B6, INPUT);
  pinMode(B7, INPUT);
  pinMode(SIGNED, INPUT);
  
  display.setBrightness(0x04);
}

void loop()
{
  //read all the bits
  uint8_t bit0 = digitalRead(B0);
  uint8_t bit1 = digitalRead(B1);
  uint8_t bit2 = digitalRead(B2);
  uint8_t bit3 = digitalRead(B3);
  uint8_t bit4 = digitalRead(B4);
  uint8_t bit5 = digitalRead(B5);
  uint8_t bit6 = digitalRead(B6);
  uint8_t bit7 = digitalRead(B7);
  uint8_t signedbit = digitalRead(SIGNED);

  //convert individual bits to a 8 bit unsigned integer
  value = 0 | bit0;
  value = value | (bit1 << 1);
  value = value | (bit2 << 2);
  value = value | (bit3 << 3);
  value = value | (bit4 << 4);
  value = value | (bit5 << 5);
  value = value | (bit6 << 6);
  value = value | (bit7 << 7);

  if (signedbit){ //if signed bit is high, display as a signed 8 bit integer
    display.showNumberDec(int8_t(value), false);
  }
  else  display.showNumberDec(value, false);
  delay(10);
}
