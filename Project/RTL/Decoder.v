module Decoder(
    input [31:0] Instr,
	
    output PCS,
    output reg RegW, 
    output reg MemW, 
    output reg MemtoReg,
    output reg ALUSrc,
    output reg [1:0] ImmSrc,
    output reg [2:0] RegSrc,
    output reg [2:0] ALUControl,
    output reg [1:0] FlagW,
    output reg NoWrite,

    input done,
    output reg M_Start,
    output reg [1:0] MCycleOp,
    output reg MWrite,

    output reg Carry_use,
    output reg Reverse_B,

    output reg Rev_Src
    ); 
    
    reg [1:0] ALUOp; 
    reg Branch;
    
    wire [1:0] op = Instr[27:26];
    wire funct_I = Instr[25];
    wire [3:0] funct_cmd = Instr[24:21];
    wire funct_S = Instr[20];
    wire funct_U = Instr[23];
    // PC Logic
    assign PCS = ((Instr[15:12] == 4'd15)&RegW)|Branch;

    always @(*) begin
        case(op)
            2'b00:  begin
                if(Instr[25]==0 && Instr[7:4] == 4'b1001 && Instr[24:21] == 4'b0000)    begin
                    RegSrc[2] = 1'b1;
                    MWrite = done;                  
                    MCycleOp = 2'b0;
                    M_Start = 1'b1;
                end
                else begin
                    RegSrc[2] = 1'b0;
                    MWrite = 1'b0;
                    MCycleOp = 2'b0;
                    M_Start = 1'b0;
                end
            end
            2'b01:  begin
                if(Instr[25:20] == 6'b111111 && Instr[7:4] == 4'b1111 && Instr[15:12] == 4'b0000)  begin
                    RegSrc[2] = 1'b1;
                    MWrite = done;
                    MCycleOp = 2'b1;
                    M_Start = 1'b1;
                end
                else if(Instr[25:20] == 6'b111111 && Instr[7:4] == 4'b1111 && Instr[15:12] == 4'b0001)  begin
                    RegSrc[2] = 1'b1;
                    MWrite = done;
                    MCycleOp = 2'd2;
                    M_Start = 1'b1;
                end
                else if(Instr[25:20] == 6'b111111 && Instr[7:4] == 4'b1111 && Instr[15:12] == 4'b0010)  begin
                    RegSrc[2] = 1'b1;
                    MWrite = done;
                    MCycleOp = 2'd3;
                    M_Start = 1'b1;
                end
                else begin
                    RegSrc[2] = 1'b0;
                    MWrite = 1'b0;
                    MCycleOp = 2'b0;
                    M_Start = 1'b0;
                end
            end
            default:    begin
                    RegSrc[2] = 1'b0;
                    MWrite = 1'b0;
                    MCycleOp = 1'b0;
                    M_Start = 1'b0;
            end
        endcase
    end
    
    wire mul_judge = Instr[25]==0 && Instr[7:4] == 4'b1001 && Instr[24:21] == 4'b0000;
    wire other_mul_cycle_judge = Instr[25:20] == 6'b111111 && Instr[7:4] == 4'b1111;
    always@(*)   begin
        casex({op, funct_I, funct_U, funct_S, mul_judge, other_mul_cycle_judge})
            // 7'b00_x_xx_1x:  {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0_0_0_x_xx_1_xx_00;
            7'b00_x_xx_1x:  {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0_0_0_x_xx_0_xx_00;
            7'b00_0_xx_0x:  {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0000xx100_11;
            7'b00_1_xx_0x:  {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0001001x0_11;
            // 7'b01_x_xx_x1:  {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0_0_0_x_xx_1_xx_00;
            7'b01_x_xx_x1:  {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0_0_0_x_xx_0_xx_00;
            7'b01_x_0_0_x0: {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0x1101010_01;
            7'b01_x_0_1_x0: {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0101011x0_01;
            7'b01_x_1_0_x0: {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0x1101010_00;
            7'b01_x_1_1_x0: {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0101011x0_00;
            7'b10_x_xx_xx:    {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b1001100x1_00;
            default:    {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}   = 11'h3FF;
        endcase
    end
    
    // ALU Decoder
    always @(*) begin
        casex({ALUOp, funct_cmd, funct_S})  // Carry_use: ADC SBC RSC   Reverse_B BIC MVN   Rev_Src RSB/ RSC
            7'b00_xxxx_x: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b000_00_0_0_0_0;
            7'b01_xxxx_x: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b001_00_0_0_0_0;

            // DP instruction
            7'b11_0000_0: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b010_00_0_0_0_0;
            7'b11_0000_1: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b010_10_0_0_0_0;   // And

            7'b11_0001_0: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b100_00_0_0_0_0;
            7'b11_0001_1: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b100_10_0_0_0_0;   // EOR

            7'b11_0010_0: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b001_00_0_0_0_0;
            7'b11_0010_1: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b001_11_0_0_0_0;   // SUB

            7'b11_0011_0: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b001_00_0_0_0_1;
            7'b11_0011_1: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b001_11_0_0_0_1;   // RSB

            7'b11_0100_0: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b000_00_0_0_0_0;
            7'b11_0100_1: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b000_11_0_0_0_0;   // ADD

            7'b11_0101_0: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b000_00_0_1_0_0;
            7'b11_0101_1: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b000_11_0_1_0_0;   // ADC

            7'b11_0110_0: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b001_00_0_1_0_0;
            7'b11_0110_1: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b001_11_0_1_0_0;   // SBC

            7'b11_0111_0: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b001_00_0_1_0_1;
            7'b11_0111_1: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b001_11_0_1_0_1;   // RSC

            7'b11_1000_1: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b010_10_1_0_0_0;   // TST

            7'b11_1001_1: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b100_10_1_0_0_0;   // TEQ
            
            7'b11_1010_1: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b001_11_1_0_0_0;   // CMP

            7'b11_1011_1: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b000_11_1_0_0_0;   // CMN

            7'b11_1100_0: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b011_00_0_0_0_0;
            7'b11_1100_1: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b011_10_0_0_0_0;   // ORR

            7'b11_1101_0: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b101_00_0_0_0_0;
            7'b11_1101_1: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b101_10_0_0_0_0;   // MOV

            7'b11_1110_0: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b010_00_0_0_1_0;
            7'b11_1110_1: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b010_10_0_0_1_0;   // BIC

            7'b11_1111_0: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b101_00_0_0_1_0;
            7'b11_1111_1: {ALUControl, FlagW, NoWrite, Carry_use, Reverse_B, Rev_Src} = 9'b101_10_0_0_1_0;   // MVN

            default:   {ALUControl, FlagW, NoWrite} = 9'b111111111;
        endcase
    end
endmodule