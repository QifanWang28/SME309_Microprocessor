module ControlUnit(
    input [31:0] Instr,
    input [3:0] ALUFlags,
    input CLK,

    output MemtoReg,
    output MemWrite,
    output ALUSrc,
    output [1:0] ImmSrc,
    output RegWrite,
    output [1:0] RegSrc,
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

        .done       (done       ),
        .M_Start    (M_Start    ),
        .MCycleOp   (MCycleOp   ),
        .MWrite     (MWrite     )
    );
    
endmodule