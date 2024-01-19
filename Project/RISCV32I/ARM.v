module ARM(
    input CLK,
    input Reset,
    input [31:0] Instr,
    input [31:0] ReadData,

    output MemWrite,
    output [31:0] PC,
    output [31:0] ALUResult,
    output [31:0] WriteData,

    output [1:0] Load_size
); 
    wire PCSrc;
    wire PCS_dire;
    
    wire [31:0] Result, PC, PC_Plus_4;
    assign PCSrc_final = PCS_dire | PCSrc;
    
    wire [31:0] MCycle_result;
    wire Condex;
    assign Result = PC_4? PC_Plus_4 : (MemtoReg ? ReadData: ALUResult);
    
    wire [31:0] Result_trun;

    assign Result_trun = (Load_size == 2'd0)?Result:(Load_size == 2'd1)? Result[15:0]:Result[7:0];
    
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
    wire PC_4;
    wire ALUSrc_A;
    // wire [1:0] Load_size;

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
    assign Src_B = ALUSrc ? ExtImm : RD2;

    
    Extend u_Extend(
    	.ImmSrc   (ImmSrc   ),
        .InstrImm (Instr[31:7] ),
        .ExtImm   (ExtImm   )
    );
    

    ALU u_ALU(
    	.Src_A      (Src_A      ),
        .Src_B      (Src_B      ),
        .ALUControl (ALUControl ),
        .Imm        (Imm),
        .PC         (PC         ),
        .ALUSrc_A   (ALUSrc_A   ),
        .ALUResult  (ALUResult  )
    );
    
endmodule