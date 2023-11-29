module ControlUnit(
    input [31:0] Instr,
    input [3:0] ALUFlags,
    input CLK,

    output MemtoReg,
    output MemWrite,
    output ALUSrc,
    output [1:0] ImmSrc,
    output RegWrite,
    output [2:0] RegSrc,
    output M_Start,
    output MWrite,
    output MCycleOp,
    output [1:0] ALUControl,	
    output PCSrc
    ); 
    
    wire [3:0] Cond;
    wire PSC, RegW, MemW;
    wire [1:0] FlagW;
    wire NoWrite;

    assign Cond=Instr[31:28];


    CondLogic CondLogic1(
     CLK,
     PCS,
     RegW,
     MemW,
     NoWrite,
     FlagW,
     Cond,
     ALUFlags,

     PCSrc,
     RegWrite,
     MemWrite
    );

    Decoder Decoder1(
     Instr,
     PCS,
     RegW,
     MemW,
     MemtoReg,
     ALUSrc,
     ImmSrc,
     RegSrc,
     NoWrite,
     M_Start,
     MWrite,
     MCycleOp,
     ALUControl,
     FlagW
    );
endmodule