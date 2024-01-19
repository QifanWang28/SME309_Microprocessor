module ControlUnit(
    input [31:0] Instr,

    input CLK,
    input rst,
    output MemtoReg,
    output MemWrite,
    
    output ALUSrc,
    output [3:0] ImmSrc,
    output RegWrite,

    output [3:0] ALUControl,	
    output PCSrc,
    output Imm,
    output ALUSrc_A,
    output PC_4,
    output [1:0] Load_size,

    output PCS_dire
    ); 
    
    wire PCS, RegW, MemW;

    assign PCSrc = PCS;
    assign RegWrite = RegW;
    assign MemWrite = MemW;

    Decoder u_Decoder(
    	.Instr      (Instr      ),
        .PCS        (PCS        ),
        .RegW       (RegW       ),
        .MemW       (MemW       ),
        .MemtoReg   (MemtoReg   ),
        .ALUSrc     (ALUSrc     ),
        .ALUControl (ALUControl ),

        .ImmSrc     (ImmSrc     ),
        .ALUSrc_A   (ALUSrc_A   ),
        .PC_4       (PC_4       ),
        .Imm        (Imm        ),
        .Load_size  (Load_size  ),

        .PCS_dire   (PCS_dire)
    );
    
endmodule