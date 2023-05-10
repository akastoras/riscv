import re

mips_instructions = open("test_instructions.txt", "r")
tester = open("pipeline_tester_cpy.v", "r+")

instructions = mips_instructions.readlines()
file = tester.read()
matches = re.findall("32'b.*//", file)

for i in range(len(instructions)):
    instruction = instructions[i]
    words = instruction.split()
    new_instruction = ""

    if words[0] == "add" or words[0] == "sllv":
        opcode = "0110011"
        if words[0] == "add":
            funct3 = "000"
        else:
            funct3 = "001"
        funct7 = "0000000"
        rs2 = format(int(words[-1][1:]), '#07b')[2:]
        rs1 = format(int(words[-2][1:-1]), '#07b')[2:]  
        rd = format(int(words[-3][1:-1]), '#07b')[2:]
        new_instruction = funct7 + "_" + rs2 + "_" + rs1 + "_" + funct3 + "_" + rd + "_" + opcode
    elif words[0] == "lw":
        opcode = "0000011"
        funct3 = "010"
        rd = format(int(words[-2][1:-1]), '#07b')[2:]
        last_dollar = instruction.rfind("$")
        last_comma = instruction.rfind(",")
        imm = format(int(instruction[last_comma+2:last_dollar-1]), '#014b')[2:]
        rs1 = format(int(instruction[last_dollar+1:-2]), '#07b')[2:]  
        new_instruction = imm + "_" + rs1 + "_" + funct3 + "_" + rd + "_" + opcode
    elif words[0] == "bne":
        opcode = "1100011"
        funct3 = "001"
        rs1 = format(int(words[-3][1:-1]), '#07b')[2:]  
        rs2 = format(int(words[-2][1:-1]), '#07b')[2:]
        imm = format((int(words[-1]) * 2) & 0xfff, '012b')
        imm = imm + "0"
        imm = imm[::-1]
        new_instruction = imm[12] + imm[5:11][::-1] + "_" + rs2 + "_" + rs1 + "_" + funct3 + "_" + imm[1:5][::-1] + imm[11] + "_" + opcode
    elif words[0] == "beq":
        opcode = "1100011"
        funct3 = "000"
        rs1 = format(int(words[-3][1:-1]), '#07b')[2:]  
        rs2 = format(int(words[-2][1:-1]), '#07b')[2:]
        imm = format((int(words[-1]) * 2) & 0xfff, '012b')
        imm = imm + "0"
        imm = imm[::-1]
        new_instruction = imm[12] + imm[5:11][::-1] + "_" + rs2 + "_" + rs1 + "_" + funct3 + "_" + imm[1:5][::-1] + imm[11] + "_" + opcode
    elif words[0] == "j":
        opcode = "1101111"
        funct3 = "000"
        rd = "00000"
        imm = format((int(words[-1]) * 2) & 0xfffff, '020b')
        imm = imm + "0"
        imm = imm[::-1]
        new_instruction = imm[20] + imm[1:11][::-1] + "_" + imm[11] + imm[12:20][::-1] + "_" + rd + "_" + opcode
    elif words[0] == "sw":
        opcode = "0100011"
        funct3 = "010"
        rs2 = format(int(words[-2][1:-1]), '#07b')[2:]  
        last_dollar = instruction.rfind("$")
        rs1 = format(int(instruction[last_dollar+1:-2]), '#07b')[2:]  
        last_dollar = instruction.rfind("$")
        last_comma = instruction.rfind(",")
        imm = format(int(instruction[last_comma+2:last_dollar-1]), '#014b')[2:]
        new_instruction = imm[5:11] + "_" + rs2 + "_" + rs1 + "_" + funct3 + "_" + imm[0:5] + "_" + opcode
    elif words[0] == "addi" or words[0] == "sll":
        opcode = "0010011"
        if words[0] == "addi":
            funct3 = "000"
        elif words[0] == "sll":
            funct3 = "001"
        rs1 = format(int(words[-2][1:-1]), '#07b')[2:]  
        rd = format(int(words[-3][1:-1]), '#07b')[2:]
        imm = format(int(words[-1]) & 0xfff, '012b')
        new_instruction = imm + "_" + rs1 + "_" + funct3 + "_" + rd + "_" + opcode
    
    file = file.replace(matches[i], "32'b"+new_instruction+";\t" + "//")

tester.truncate(0)
tester.write(file)
tester.close()