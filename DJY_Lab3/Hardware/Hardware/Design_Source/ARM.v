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

    wire [31:0] PCPlus4;
    wire PCSrc;
    wire RegWrite;
    wire MemtoReg;
    wire ALUSrc;
    wire [1:0]ImmSrc;
    wire [1:0]ALUControl;
    wire [31:0]ExtImm;
    wire [31:0] Result;
    wire [2:0] RegSrc;
    wire [3:0]RA1;
    wire [3:0]RA2;
    wire [3:0]RA3;
    wire [3:0]ALUFlags;
    wire [31:0]R15;
    wire [31:0]RD1;
    wire [31:0]RD2;
    wire [31:0]Src_A;
    wire [31:0]Src_B;
    wire [31:0]ShOut;
    wire M_Start;
    wire MWrite;
    wire MCycleOp;
    wire Busy;
    wire [31:0]MCycleResult;
    
    assign R15 = PCPlus4 + 3'b100;
    assign Result  = (MWrite) ? MCycleResult:(MemtoReg == 1) ? ReadData : ALUResult;
   
  
    // assign RA3 = Instr[15:12];
    assign Src_A = RD1;
    assign Src_B = (ALUSrc == 1) ? ExtImm : ShOut;
    assign WriteData = RD2;
    
    assign RA1 = (RegSrc[2]) ? Instr[11:8] : ((RegSrc[0] == 1) ? 4'b1111 : Instr[19:16]);
    assign RA2 = (RegSrc[2]) ? Instr[3:0] : (RegSrc[1] == 1) ? Instr[15:12] : Instr[3:0];
    assign RA3 = RegSrc[2] ? Instr[19:16] : Instr[15:12];
    
    
    
    ProgramCounter ProgramCounter1(
        .CLK(CLK),
        .Reset(Reset),
        .PCSrc(PCSrc),
        .Result(Result),//
        .PC(PC),
        .PC_Plus_4(PCPlus4),
        .Busy(Busy)
    );

    RegisterFile RegisterFile1(
        .CLK(CLK),
        .WE3(RegWrite),
        .A1(RA1),
        .A2(RA2),
        .A3(RA3),
        .WD3(Result),
        .R15(R15),
        .RD1(RD1),
        .RD2(RD2)
    );
    
    ControlUnit ControlUnit1(
        .Instr(Instr),
        .ALUFlags(ALUFlags),
        .CLK(CLK),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .RegSrc(RegSrc),
        .M_Start(M_Start),
        .MWrite(MWrite),
        .MCycleOp(MCycleOp),
        .ALUControl(ALUControl),
        .PCSrc(PCSrc)
    );
 
    
    ALU ALU1(
        .Src_A(Src_A),
        .Src_B(Src_B),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .ALUFlags(ALUFlags)
    );
    
    Extend Extend1(
        .ImmSrc(ImmSrc),
        .InstrImm(Instr[23:0]),
        .ExtImm(ExtImm)
    );

    Shifter Shifer1(
        .Sh(Instr[6:5]),
        .Shamt5(Instr[11:7]),
        .ShIn(RD2),
        .ShOut(ShOut)
    );
    
    MCycle MCycle1(
        .CLK(CLK),
        .RESET(Reset),
        .Start(M_Start),
        .MCycleOp(MCycleOp),
        .Operand1(RD1),
        .Operand2(RD2),
        .Result(MCycleResult),
        .Busy(Busy)
    );
endmodule