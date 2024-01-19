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

    wire PCS_dire;
    wire PCSrc_final;//, Busy;
    assign PCSrc_final = PCS_dire | Condex;
    wire [31:0] Result, PC, PC_Plus_4;
    
    wire [31:0] MCycle_result;
    wire Condex;
    assign Result = MemtoReg ? ReadData: ALUResult;

    ProgramCounter u_ProgramCounter(
    	.CLK       (CLK       ),
        .Reset     (Reset     ),
        .PCSrc     (PCSrc_final     ),
        .Result    (Result    ),

        .PC        (PC        ),
        .PC_Plus_4 (PC_Plus_4 )
    );

    wire [31:0] Instr;
    
    wire MemtoReg;
    wire MemWrite;
    wire ALUSrc;
    wire [3:0] ImmSrc;
    wire RegWrite;

    wire [3:0] ALUControl;
    wire Imm;

    ControlUnit u_ControlUnit(
    	.Instr      (Instr      ),
        .CLK        (CLK        ),
        .rst        (Reset      ),
        .MemtoReg   (MemtoReg   ),
        .MemWrite   (MemWrite   ),
        .ALUSrc     (ALUSrc     ),
        .ImmSrc     (ImmSrc     ),
        .RegWrite   (RegWrite   ),
        .ALUControl (ALUControl ),
        .PCSrc      (PCSrc      ),
        .Imm        (Imm        ),
        .ALUSrc_A   (ALUSrc_A   ),
        .PC_4       (PC_4       ),
        .Load_size  (Load_size  ),
        .PCS_dire   (PCS_dire   ),
        .Condex     (Condex)
    );
    
    
    wire [4:0] RA1 = Instr[19:15];
    wire [4:0] RA2 = Instr[24:20];
    wire [4:0] RA3 = Instr[11:7];


    wire [31:0] Src_A, Src_B, RD2;

    RegisterFile u_RegisterFile(
    	.CLK (CLK ),
        .WE3 (RegWrite ),
        .A1  (RA1  ),
        .A2  (RA2  ),
        .A3  (RA3  ),
        .WD3 (Result ),
        .RD1 (Src_A ),
        .RD2 (RD2 )
    );
    
    State_compare u_State_compare(
    	.Instr  (Instr  ),
        .RS1    (Src_A    ),
        .RS2    (RD2    ),
        .Condex (Condex )
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
        .InstrImm (Instr[31:12] ),
        .ExtImm   (ExtImm   )
    );
    
    ALU u_ALU(
    	.Src_A      (Src_A      ),
        .Src_B      (Src_B      ),
        .Imm        (Imm),
        .ALUControl (ALUControl ),
        .ALUResult  (ALUResult  ),
        .ALUFlags   (ALUFlags   )
    );
    
    // MCycle 
    // #(
    //     .WIDTH     (32     )
    // )
    // u_MCycle(
    // 	.CLK      (CLK      ),
    //     .RESET    (Reset    ),
    //     .Start    (Start    ),
    //     .MCycleOp (MCycleOp ),
    //     .Operand1 (Src_A ),
    //     .Operand2 (RD2 ),
    //     .Result   (MCycle_result   ),
    //     .Busy     (Busy     )
    // );
    
endmodule