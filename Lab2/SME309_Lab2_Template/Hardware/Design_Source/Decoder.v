module Decoder(
    input [31:0] Instr,
	
    output PCS,
    output reg RegW, 
    output reg MemW, 
    output reg MemtoReg,
    output reg ALUSrc,
    output reg [1:0] ImmSrc,
    output reg [1:0] RegSrc,
    output reg [1:0] ALUControl,
    output reg [1:0] FlagW,
    output reg NoWrite
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

    // Main Decoder
    always@(*)   begin
        casex({op, funct_I, funct_U, funct_S})
            5'b00_0_xx:    {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp}   = 11'b0000xx10011;
            5'b00_1_xx:    {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp}   = 11'b0001001x011;

            5'b01_x_0_0:    {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp}   = 11'b0x110101001;
            5'b01_x_0_1:    {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp}   = 11'b0101011x001;
            5'b01_x_1_0:    {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp}   = 11'b0x110101000;
            5'b01_x_1_1:    {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp}   = 11'b0101011x000;

            5'b10_x_xx:    {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp}   = 11'b1001100x100;
            default:    {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp}   = 10'h3FF;
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