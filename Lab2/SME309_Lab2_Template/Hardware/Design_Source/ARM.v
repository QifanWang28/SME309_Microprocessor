module ARM(
    input CLK,
    input Reset,
    input [31:0] Instr,
    input [31:0] ReadData,

    output MemWrite,
    output [31:0] PC,
    output [31:0] ALUResult,
    output [31:0] WriteData
); 

    wire PCSrc, Busy;
    wire [31:0] Result, PC, PC_Plus_4;
    wire [31:0] MCycle_result;

    assign Result = MWrite? MCycle_result:(MemtoReg ? ReadData: ALUResult);
    ProgramCounter u_ProgramCounter(
    	.CLK       (CLK       ),
        .Reset     (Reset     ),
        .PCSrc     (PCSrc     ),
        .Result    (Result    ),
        .Busy      (Busy      ),

        .PC        (PC        ),
        .PC_Plus_4 (PC_Plus_4 )
    );

    wire [31:0] Instr;
    wire [3:0] ALUFlags;
    
    wire MemtoReg;
    wire MemWrite;
    wire ALUSrc;
    wire [1:0] ImmSrc;
    wire RegWrite;

    wire [2:0] RegSrc;
    wire [1:0] ALUControl;

    wire MCycleOp;
    wire MWrite;
    wire Start;
    ControlUnit u_ControlUnit(
    	.Instr      (Instr      ),
        .ALUFlags   (ALUFlags   ),
        .CLK        (CLK        ),
        .MemtoReg   (MemtoReg   ),
        .MemWrite   (MemWrite   ),
        .ALUSrc     (ALUSrc     ),
        .ImmSrc     (ImmSrc     ),
        .RegWrite   (RegWrite   ),
        .RegSrc     (RegSrc     ),
        .ALUControl (ALUControl ),
        .PCSrc      (PCSrc      ),

        .done       (~Busy      ),
        .M_Start    (Start      ),
        .MCycleOp   (MCycleOp   ),
        .MWrite     (MWrite     )
    );
    
    wire [3:0] RA1 = RegSrc[2] ? Instr[11:8] : (RegSrc[0] ? 4'd15: Instr[19:16]);
    wire [3:0] RA2 = RegSrc[2] ? Instr[3:0] : (RegSrc[1] ? Instr[15:12] : Instr[3:0]);
    wire [3:0] RA3 = RegSrc[2] ? Instr[19:16] : Instr[15:12];


    wire [31:0] Src_A, Src_B, RD2;

    RegisterFile u_RegisterFile(
    	.CLK (CLK ),
        .WE3 (RegWrite&(~Busy) ),
        .A1  (RA1  ),
        .A2  (RA2  ),
        .A3  (RA3  ),
        .WD3 (Result ),
        .R15 (PC_Plus_4 + 3'd4),
        .RD1 (Src_A ),
        .RD2 (RD2 )
    );
    
    assign WriteData = RD2;

    wire [31:0] ExtImm;
    wire [31:0] RD2_shift;
    assign Src_B = ALUSrc ? ExtImm : RD2_shift;

    Shifter u_Shifter(
    	.Sh     (Instr[6:5]     ),
        .Shamt5 (Instr[11:7] ),
        .ShIn   (RD2   ),
        .ShOut  (RD2_shift  )
    );
    
    Extend u_Extend(
    	.ImmSrc   (ImmSrc   ),
        .InstrImm (Instr[23:0] ),
        .ExtImm   (ExtImm   )
    );
    
    ALU u_ALU(
    	.Src_A      (Src_A      ),
        .Src_B      (Src_B      ),
        .ALUControl (ALUControl ),
        .ALUResult  (ALUResult  ),
        .ALUFlags   (ALUFlags   )
    );
    
    MCycle 
    #(
        .WIDTH     (32     )
    )
    u_MCycle(
    	.CLK      (CLK      ),
        .RESET    (Reset    ),
        .Start    (Start    ),
        .MCycleOp (MCycleOp ),
        .Operand1 (Src_A ),
        .Operand2 (RD2 ),
        .Result   (MCycle_result   ),
        .Busy     (Busy     )
    );
    
endmodule