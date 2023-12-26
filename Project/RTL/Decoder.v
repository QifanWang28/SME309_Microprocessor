module Decoder(
    input [31:0] Instr,
	
    output PCS,
    output reg RegW, 
    output reg MemW, 
    output reg MemtoReg,
    output reg ALUSrc,
    output reg [1:0] ImmSrc,
    output reg [2:0] RegSrc,
    output reg [1:0] ALUControl,
    output reg [1:0] FlagW,
    output reg NoWrite,

    input done,
    output reg M_Start,
    output reg MCycleOp,
    output reg MWrite   
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
                    MCycleOp = 1'b0;
                    M_Start = 1'b1;
                end
                else begin
                    RegSrc[2] = 1'b0;
                    MWrite = 1'b0;
                    MCycleOp = 1'b0;
                    M_Start = 1'b0;
                end
            end
            2'b01:  begin
                if(Instr[25:20] == 6'b111111 && Instr[7:4] == 4'b1111)  begin
                    RegSrc[2] = 1'b1;
                    MWrite = done;
                    MCycleOp = 1'b1;
                    M_Start = 1'b1;
                end
                else begin
                    RegSrc[2] = 1'b0;
                    MWrite = 1'b0;
                    MCycleOp = 1'b0;
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
    wire div_judge = Instr[25:20] == 6'b111111 && Instr[7:4] == 4'b1111;
    always@(*)   begin
        casex({op, funct_I, funct_U, funct_S, mul_judge, div_judge})
            // 7'b00_x_xx_1x:  {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0_0_0_x_xx_1_xx_00;
            7'b00_x_xx_1x:  {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0_0_0_x_xx_0_xx_00;
            7'b00_0_xx_0x:  {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0000xx10011;
            7'b00_1_xx_0x:  {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0001001x011;
            // 7'b01_x_xx_x1:  {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0_0_0_x_xx_1_xx_00;
            7'b01_x_xx_x1:  {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0_0_0_x_xx_0_xx_00;
            7'b01_x_0_0_x0: {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0x110101001;
            7'b01_x_0_1_x0: {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0101011x001;
            7'b01_x_1_0_x0: {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0x110101000;
            7'b01_x_1_1_x0: {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0101011x000;
            7'b10_x_xx_xx:    {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b1001100x100;
            default:    {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}   = 10'h3FF;
        endcase
    end
    
    // ALU Decoder
    always @(*) begin
        casex({ALUOp, funct_cmd, funct_S})
            7'b00_xxxx_x: {ALUControl, FlagW, NoWrite} = 5'b00_00_0;
            7'b01_xxxx_x: {ALUControl, FlagW, NoWrite} = 5'b01_00_0;
            7'b11_0100_0: {ALUControl, FlagW, NoWrite} = 5'b00_00_0;
            7'b11_0100_1: {ALUControl, FlagW, NoWrite} = 5'b00_11_0;
            7'b11_0010_0: {ALUControl, FlagW, NoWrite} = 5'b01_00_0;
            7'b11_0010_1: {ALUControl, FlagW, NoWrite} = 5'b01_11_0;
            7'b11_0000_0: {ALUControl, FlagW, NoWrite} = 5'b10_00_0;
            7'b11_0000_1: {ALUControl, FlagW, NoWrite} = 5'b10_10_0;
            7'b11_1100_0: {ALUControl, FlagW, NoWrite} = 5'b11_00_0;
            7'b11_1100_1: {ALUControl, FlagW, NoWrite} = 5'b11_10_0;
            7'b11_1010_1: {ALUControl, FlagW, NoWrite} = 5'b01_11_1;
            7'b11_1011_1: {ALUControl, FlagW, NoWrite} = 5'b00_11_1;
            default:   {ALUControl, FlagW, NoWrite} = 5'b11111;
        endcase
    end
endmodule