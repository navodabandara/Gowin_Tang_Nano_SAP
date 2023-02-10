# Ben Eater's SAP Computer with VHDL on Gowin Tang Nano 9K

This project aims to build Ben Eater's Simple As Possible (SAP) computer using VHDL language and run it on a Gowin Tang Nano 9K FPGA board. The SAP computer is a simple 8-bit computer designed to demonstrate the basic principles of computer architecture and operation.

The project includes the implementation of the SAP computer in VHDL, including the design of the ALU, Memory and registers. The implementation will be tested on a the Gowin Tang Nano 9K FPGA board. Also included is a simple assembler written in Python with examples included.

This project was created with the goal of gaining hands-on experience with digital design, computer architecture, and FPGA technology. It can serve as a learning resource for students, hobbyists, and anyone interested in understanding the inner workings of a computer. Credits to Ben Eater for his video series on YouTube, which served as a guide and inspiration for this project. 

## <u>Getting Started</u>

To get started with this project, you will need the following (or adapt the source to work with similar variations):

- Gowin Tang Nano 9K FPGA board
- Gowin FPGA Designer (Built with version 1.9.8.03 Education Build)
- Arduino UNO
- TM1637 
- Arduino IDE
- Python 3
- Following Ben Eater's video series would make things easier

### <u>Gowin FPGA Designer Setup Instructions</u>

Follow the instructions as described here : [Install IDE - Sipeed Wiki](https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-Doc/install-the-ide.html) to setup the IDE. Clone this repository to workspace and open *Gowin_Tang_Nano_SAP_1.gprj* with the Gowin FPGA Designer.

```bash
 git clone https://github.com/navodabandara/Gowin_Tang_Nano_SAP_1
```

Navigate to the Process tab and right click Systhesis, click Configuration > Syntheize > General > Systhesis Language and set to VHDL 2008. Back in the main window, click run all to synthesize, place and route. 

Connect device to USB, open the Program Device  application and set access mode to either SRAM mode or Embedded flash mode. The former is faster than the latter with regards to bitstream write speed, although the program is lost after the power is disconnected.

Select the Program/Configure to write bitstream to device.

## <u>Design</u>

Features:

- Upto 27MHz clock cycle frequency

- 16 Bytes of RAM (Yes, you read that right)

- 1 General purpose register

- 11 Instructions

- Fixed 8 cycles per instruction

- Output bus
  
  

![block_diagram_high_level.drawio.png](C:\Users\navod\Desktop\Gowin_Tang_Nano_SAP_1\assets\block_diagram_high_level.drawio.png)

# 

## <u>Programming</u>

| Mnemonic | Operand Type | Description                                                                                                                                       | Cycles |
| -------- | ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| NOP      | -            | No operation                                                                                                                                      | 8      |
| LDA      | Variable     | Load variable to register A                                                                                                                       | 8      |
| ADD      | Variable     | Add contents in register A<br/>and register B                                                                                                     | 8      |
| SUB      | Variable     | Substract the contents in register A<br/>and register B                                                                                           | 8      |
| STA      | Variable     | Stores contents in register A to variable                                                                                                         | 8      |
| LDI      | Value        | Loads value (4 bit unisgned integer: 0 to 15) to register A                                                                                       | 8      |
| JMP      | Label        | Jump to memory location specified by Label                                                                                                        | 8      |
| JC       | Label        | Jump to memory location specified by Label if the previous ADD or SUB instruction resulted in a carry flag set (Overflow condition)               | 8      |
| JZ       | Label        | Jump to memory location specified by Label if the previous ADD or SUB instruction resulted in a zero flag set (Result of the ADD or SUB was zero) | 8      |
| OUT      | -            | Copies the value in the register A to the Output register. Displays on the 7 segment display if connected.                                        | 8      |
| HLT      | -            | Halts the computer.                                                                                                                               | -      |

The syntax for an instruction is:  "mnemonic<space> operand <newline>". Variables may be declared as "VAR<space>variableName<space>value<newline>" , where value is 8 bit unsigned (0 to 255). Labels are defined as "labelName:<newline>."



Example assembly file for an 8bit fibonacci sequence generator.

```asmatmel
VAR x 0 ;declare variables
VAR y 1
VAR z 1

reset: ;set a label

LDI 0 ;instructions
STA x ;referencing variables
OUT
LDI 1

loop:

STA y
OUT

ADD x
JC reset ;referencing labels
STA z
LDA y
STA x
LDA z
JMP loop 
```

To assemble, save a text file containing the program to the workspace and run the assembler (tools folder)

```bash
python SAP_assembler.py fibonacci.txt
```

Example output :

```vhdl
INIT_RAM_00 => X"000000000000000000000000000000000101641D4F1E4D702FE04E51E04F50"
```

Copy the generated memory init sequence to src/gowin_sp and replace the existing line. (Should be around line 136) 

# Contributing

This project is open source and contributions are welcome. If you have any suggestions or improvements, feel free to open a pull request.
