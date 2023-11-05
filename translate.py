

def translate():
    code_b = bin(int("E5135004", 16))[2:]
    cond = code_b[0:4]
    op = code_b[4:6]
    if int(op) == 0:
        I = code_b[6]
        cmd = code_b[7:11]
        S = code_b[11]
        Rn = code_b[12:16]
        Rd = code_b[16:20]
        Src2 = code_b[21:]
        print("Data-processing:     cond:{}, I:{}, cmd:{}, S:{}, Rn:{}, Rd:{}, Src2:{}".format(
              cond, I, cmd, S, Rn, Rd, Src2))
    elif int(op) == 1:
        funct = code_b[6:12]
        Rn = code_b[12:16]
        Rd = code_b[16:20]
        Src2 = code_b[21:]
        print("Memory:      cond: {}, funct: {}, Rn: {}, Rd: {}, Src2: {}".format(
              cond, funct, Rn, Rd, Src2))
    elif int(op) == 2:
        funct = code_b[6:8]
        Imm24 = code_b[8]
        print("Brach:       cond: {}, funct: {}, Imm24: {}".format(
              cond, funct, Imm24))


translate()
