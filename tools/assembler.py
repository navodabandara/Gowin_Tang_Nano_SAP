import numpy as np
import sys

MAX_MEMORY = 16
instructionStackPointer = -1
MAX_LDI = 15
#_________________________VARIABLES___________________________
variableDefinitions = []
definitionPointer = []
variableStackPointer = MAX_MEMORY

import re
def is_valid_variable_name(name, line):
    pattern = re.compile("^[a-zA-Z_][a-zA-Z0-9_]*$")
    if (bool(pattern.match(name))):
        return
    else:
        raise Exception("Variable has invalid name at line : " + line)

def defineVariable(identifier, line):   
    global variableDefinitions
    global definitionPointer
    global variableStackPointer
    
    is_valid_variable_name(identifier, line)
    variableStackPointer = variableStackPointer - 1 # advance variable stack pointer
        
    if (variableStackPointer == -1 or variableStackPointer == instructionStackPointer): #check overflow/collision
        raise Exception("Variable stack overflow/collision at line : " + line)
    if (identifier in variableDefinitions): #check definitions
        raise Exception("Redefinition of variable at line : " + line)
    else: #if no exceptions, create variable
        variableDefinitions.append(identifier) #add to variable name and location to list
        definitionPointer.append(variableStackPointer)
        return variableStackPointer
 
def resolveVariable(identifier, line):
    is_valid_variable_name(identifier, line)
    for i in range(len(variableDefinitions)): #note: this could be optimised
        if (variableDefinitions[i]==identifier):
            return definitionPointer[i]
    raise Exception("Undefined variable at line : " + line)

#_________________________LABELS___________________________
labelNames = []
labelLocations = []
def createLabel(identifier, line):
    global instructionStackPointer
    global variableStackPointer
    global labelNames
    global labelLocations

    if (instructionStackPointer+1 >= MAX_MEMORY or instructionStackPointer+1 == variableStackPointer):
        raise Exception("Label location exceeds memory or collides with variable stack at line " + line)
    if (identifier in labelNames):
        raise Exception("Redefinition of label at line " + line)
    labelNames.append(identifier)
    labelLocations.append(instructionStackPointer+1)
    
unresolvedLabel = []
unresolvedLabelLocation = []
def resolveLabelAddress(identifier, line):
    for i in range(len(labelNames)): #note: this could be optimised
        if (labelNames[i]==identifier):
            return labelLocations[i]               
    #reaches here if no matching labels are found
    #create a to resolve list for labels to be seen in the future (lines not yet parsed)
    unresolvedLabel.append(identifier)
    unresolvedLabelLocation.append(instructionStackPointer+1)
    return 0
  
#_________________________CONVERSIONS___________________________
def int_anybase(string): #convert binary and hex numbers to integers as well
    if string.startswith("0b"):
        return int(string, base=2)
    elif string.startswith("0x"):
        return int(string, base=16)
    else:
        return int(string, base=10)
    
def reverse_hex_no_0x(byte_list):
    hex_str = ''.join(format(b, '02X') for b in reversed(byte_list))
    return hex_str

#___________________________ASSEMBLY_______________________________
def assemble(program):
    global instructionStackPointer
    
    machine_code = np.zeros(MAX_MEMORY, dtype=np.uint8) #create empty array representing memory
    i=0
    lineNum = 1
    for line in program: #for each line
        lineNum = lineNum + 1
        line = line.strip()
        
        #discard garbage
        if line == "":
            continue
        if line.startswith(";"):
            continue
            
        #Setting variables/constants in memory
        if line.startswith("VAR"):
            parts = line.split()
            address = defineVariable(parts[1], line)
            value = int_anybase(parts[2])
            if (address>=MAX_MEMORY):
                raise Exception("Variable exceeds memory size at line : " + str(lineNum))
            elif (value>255 or value <0):
                raise Exception("Variable is not 8 bit unsigned at line : " +  str(lineNum))
            machine_code[address] = value
            continue
            
        #Add labels
        if line.endswith(":"):
            parts = line.replace(':', ' ').split() #remove the :
            createLabel(parts[0], line)
            continue
            
        #instructions to machine code
        parts = line.split()
        opcode = parts[0]
        if opcode == "LDA":
            address = resolveVariable(parts[1],  str(lineNum))
            machine_code[i]=(( 1 << 4 | address))
        elif opcode == "ADD":
            address = resolveVariable(parts[1],  str(lineNum))
            machine_code[i]=((2 << 4  | address))
        elif opcode == "SUB":
            address = resolveVariable(parts[1],  str(lineNum))
            machine_code[i]=((3 << 4  | address))
        elif opcode == "STA":
            address = resolveVariable(parts[1],  str(lineNum))
            machine_code[i]=((4 << 4  | address))
        elif opcode == "LDI":
            value = int_anybase(parts[1])
            if (value) > MAX_LDI:
                raise Exception("LDI exceeds maximum allowed value of "+ str(MAX_LDI) +" at line: " +  str(lineNum))
            machine_code[i]=((5 << 4  | value))
        elif opcode == "JMP":
            address = resolveLabelAddress(parts[1], str(lineNum))
            machine_code[i]=((6 << 4  | address))
        elif opcode == "JC":
            address = resolveLabelAddress(parts[1], str(lineNum))
            machine_code[i]=((7 << 4  | address))
        elif opcode == "JZ":
            address = resolveLabelAddress(parts[1], str(lineNum))
            machine_code[i]=((8 << 4  | address))
        elif opcode == "OUT":
            machine_code[i]=((14 << 4))
        elif opcode == "HLT":
            machine_code[i]=((15 << 4))
        else:
            raise Exception("Unknown opcode: " + opcode + " at line "+ str(lineNum))
        i=i+1
        instructionStackPointer = instructionStackPointer + 1 #increment instruction stack pointer
        if (instructionStackPointer >= MAX_MEMORY or instructionStackPointer == variableStackPointer):
            raise Exception("Instruction stack overflow/collision at line: " +  str(lineNum))
             
    #resolve unresolved labels
    for j in (range(len(unresolvedLabel))):
        if (unresolvedLabel[j] in labelNames): #attach memory locations of unattached labels
            machine_code[unresolvedLabelLocation] = machine_code[unresolvedLabelLocation] | labelLocations[labelNames.index(unresolvedLabel[j])]
        else:
            raise Exception("Label: " + unresolvedLabel + " not declared")
    return machine_code

#___________________________MAIN_______________________________
def main():
    if len(sys.argv) != 2:
        print("Error: Incorrect number of arguments. Usage: python assembler.py inputFile.txt")
        sys.exit(1)
    filename = sys.argv[1]
    try:
        with open(filename, "r") as file:
            program = file.readlines()
            machine_code = assemble(program)
            print(machine_code)
            print("INIT_RAM_00 => X\"000000000000000000000000000000" + str(reverse_hex_no_0x(machine_code))+"\"")
    except FileNotFoundError:
            print(f"Error: The file '{filename}' could not be found.")
            
if __name__ == "__main__":
    main()
