module ControlUnit(
    input [31:0] Instr,
    input [3:0] ALUFlags,
    input CLK,
    input rst,

    output MemtoReg,
    output MemWrite,
    output ALUSrc,
    output [2:0] ImmSrc,
    output RegWrite,
    output [2:0] RegSrc,
    output [1:0] ALUControl,	
    output PCSrc,

    input done,
    output M_Start,
    output MCycleOp,
    output MWrite
    ); 
    
    wire [3:0] Cond;
    wire PCS, RegW, MemW;
    wire [1:0] FlagW;
    wire CondEx;

    assign Cond=Instr[31:28];

    CondLogic CondLogic1(
     CLK,
     PCS,
     RegW,
     MemW,
     FlagW,
     Cond,
     ALUFlags,
     NoWrite,
     rst,

     CondEx,

     PCSrc,
     RegWrite,
     MemWrite
    );

    Decoder u_Decoder(
    	.Instr      (Instr      ),
        .PCS        (PCS        ),
        .RegW       (RegW       ),
        .MemW       (MemW       ),
        .MemtoReg   (MemtoReg   ),
        .ALUSrc     (ALUSrc     ),
        .ImmSrc     (ImmSrc     ),
        .RegSrc     (RegSrc     ),
        .ALUControl (ALUControl ),
        .FlagW      (FlagW      ),
        .NoWrite    (NoWrite    ),

        .CondEx     (CondEx     ),
        
        .done       (done       ),
        .M_Start    (M_Start    ),
        .MCycleOp   (MCycleOp   ),
        .MWrite     (MWrite     )
    );
    
endmodule