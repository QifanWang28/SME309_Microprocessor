module ARM(
    input CLK,
    input Reset,
    input [31:0] Instr,
    input [31:0] ReadData,

    output MemWrite,
    output [31:0] PC,
    output [31:0] o_ALUResult,
    output [31:0] WriteData
); 

    // All wires    
    // Accorss multi layers
    wire Busy;
    wire PCSrc;
    wire RegWrite;
    
    wire [31:0] ResultW;
    wire [31:0] RD_W;

    wire [31:0] ALUResult;

    // First layer F layer
    wire [31:0] PC_Plus_4;
    wire refresh_F2D;
    wire StallF;

    // Second layer D layer
    wire [31:0] InstrD;

    wire [1:0] ImmSrc;
    wire [2:0] RegSrc;

    wire [3:0] RA1 = RegSrc[2] ? InstrD[11:8] : (RegSrc[0] ? 4'd15: InstrD[19:16]);
    wire [3:0] RA2 = RegSrc[2] ? InstrD[3:0] : (RegSrc[1] ? InstrD[15:12] : InstrD[3:0]);
    wire [3:0] RA3 = RegSrc[2] ? InstrD[19:16] : InstrD[15:12];

    wire [31:0] Src_A, RD2;
    
    wire refresh_D2E;

    wire [31:0] ExtImm;

    wire StallD;
    // Third layer E layer
    wire MemtoRegE;
    wire RegWriteE;
    wire ALUSrc;
    wire [31:0] Src_B;

    wire [31:0] MCycle_result;
    wire [3:0] ALUFlags;
    wire [1:0] ALUControl;

    wire MCycleOp;
    wire MWrite;
    wire Start;

    wire [3:0] RA1_E;
    wire [3:0] RA2_E;

    wire [3:0] A3_addrE;

    wire [31:0] Extend_E;

    wire [31:0] RD1_E;
    wire [31:0] RD2_E;

    wire [31:0] RD2_shiftE;

    assign Src_B = ALUSrc ? Extend_E : RD2_shiftE;

    wire [31:0] ALUResult_Chosen = MCycle_out_signal ? MCycle_result : ALUResult;

    wire [1:0] Sh_E;
    wire [4:0] Shamt5_E;

    wire [1:0] ForwardAE, ForwardBE;

    wire [31:0] ALUM_A, ALUM_B;

    wire StartD;
    // wire StallE;
    wire MCycle_out_signal;
    wire [3:0] MCycle_addr;

    wire PCSrcE;
    assign PCSrc = MCycle_out_signal ? 1'b0: PCSrcE;

    wire [3:0] A3_addrE_pre;
    assign A3_addrE = MCycle_out_signal ? MCycle_addr : A3_addrE_pre;


    wire MCycle_Stall = ((MCycle_addr==RA1) || (MCycle_addr==RA2) || StartD) && Busy;
    // Forth layer M layer
    // wire MemtoRegM;

    wire [31:0] ALUResultM;

    assign ALUM_A = (ForwardAE == 2'b10)? ALUResultM:(ForwardAE == 2'b01)? ResultW : RD1_E;
    assign ALUM_B = (ForwardBE == 2'b10)? ALUResultM:(ForwardBE == 2'b01)? ResultW : RD2_E; // E layer

    wire [31:0] WriteDataM;
    wire [3:0] A3_addrM;

    assign WriteData =  ForwardM ? ResultW :WriteDataM;

    wire [3:0] RA2_M;
    wire MemWriteM;

    wire ForwardM;
    assign o_ALUResult = ALUResultM;

    wire BusyM;

    // wire StallM;
    
    wire RegWriteM;
    // Fifth layer W layer
    wire MemtoRegW;
    
    wire [31:0] ALUOut_W;
    wire [3:0] A3_addrW;
    wire BusyW;
    // wire StallW;

    assign ResultW = MemtoRegW ? RD_W : ALUOut_W;
    // Module
    // Cross layer
    ControlUnit u_ControlUnit(
        .Instr      (InstrD     ),
        .ALUFlags   (ALUFlags   ),
        .CLK        (CLK        ),

        .Reset      (Reset      ),

        .refresh_D2E(refresh_D2E|MCycle_Stall),

        .StallE     (MCycle_out_signal),
        // .StallM     (MCycle_Stall),
        // .StallW     (MCycle_Stall),
        .MemtoReg   (MemtoRegW   ),
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
        .MWrite     (MWrite     ),

        .RegWriteM  (RegWriteM  ),
        .RegWriteE  (RegWriteE  ),
        .MemtoRegE  (MemtoRegE  ),

        .MCycle_out_signal  (MCycle_out_signal),
        .M_StartD   (StartD)
    );

    Hazard_Unit u_Hazard_Unit(
    	.RA1D        (RA1         ),
        .RA2D        (RA2         ),

        .RA1E        (RA1_E       ),
        .RA2E        (RA2_E       ),

        .A3_addrE    (A3_addrE    ),

        .MemtoRegE   (MemtoRegE   ),
        .PCSrcE      (PCSrcE      ),
        .RegWriteE   (RegWriteE   ),

        .A3_addrM    (A3_addrM    ),
        .RegWriteM   (RegWriteM   ),
        .RA2M        (RA2_M        ),
        .MemWriteM   (MemWrite   ),

        .MemtoRegW   (MemtoRegW   ),
        .A3_addrW    (A3_addrW    ),
        .RegWriteW   (RegWrite    ),

        .StallF      (StallF      ),
        .StallD      (StallD      ),

        .refresh_F2D (refresh_F2D ),
        .refresh_D2E (refresh_D2E ),

        .ForwardAE   (ForwardAE   ),
        .ForwardBE   (ForwardBE   ),
        .ForwardM    (ForwardM    )
    );
    
    // F layer
    ProgramCounter u_ProgramCounter(
    	.CLK       (CLK       ),
        .Reset     (Reset     ),

        .PCSrc     (PCSrc     ),
        .Result    (ALUResult ),
        // .Stall     (MCycle_out_signal | StallF | MCycle_Stall  ),
        .Stall     (StallF | MCycle_Stall |MCycle_out_signal ),
        .PC        (PC        ),
        .PC_Plus_4 (PC_Plus_4 )
    );

    RegisterF2D u_RegisterF2D(
    	.clk     (CLK     ),
        .rst_p   (Reset   ),

        .refresh (refresh_F2D ),
        // .Stall   (StallD | MCycle_out_signal | MCycle_Stall ),
        .Stall   (StallD | MCycle_Stall |MCycle_out_signal),
        .InstrF  (Instr  ),
        .InstrD  (InstrD  )
    );

    // D layer
    RegisterFile u_RegisterFile(
    	.CLK (~CLK ),
        .WE3 (RegWrite),
        .A1  (RA1  ),
        .A2  (RA2  ),
        .A3  (A3_addrW  ),
        .WD3 (ResultW ),
        .R15 (PC_Plus_4),
        .RD1 (Src_A ),
        .RD2 (RD2 )
    );

    Extend u_Extend(
    	.ImmSrc   (ImmSrc   ),
        .InstrImm (InstrD[23:0] ),
        .ExtImm   (ExtImm   )
    );

    RegisterD2E_Data u_RegisterD2E_Data(
    	.clk       (CLK         ),
        .rst_p     (Reset      ),
        .refresh   (refresh_D2E |MCycle_Stall),
        .Stall     (MCycle_out_signal),

        .RA1_D     (RA1       ),
        .RA2_D     (RA2       ),

        .RD1_D     (Src_A     ),
        .RD2_D     (RD2       ),

        .Extend_D  (ExtImm    ),
        .A3_addrD  (RA3       ),

        .Sh_D       (InstrD[6:5]),
        .Shamt5_D   (InstrD[11:7]),

        .RA1_E      (RA1_E      ),
        .RA2_E      (RA2_E      ),

        .RD1_E      (RD1_E     ),
        .RD2_E      (RD2_E     ),

        .Extend_E   (Extend_E  ),
        .A3_addrE   (A3_addrE_pre ),

        .Sh_E       (Sh_E),
        .Shamt5_E   (Shamt5_E)
    );
    
    // E layer
    Shifter u_Shifter(
    	.Sh     (Sh_E     ),
        .Shamt5 (Shamt5_E ),
        .ShIn   (ALUM_B      ),
        .ShOut  (RD2_shiftE  )
    );

    ALU u_ALU(
    	.Src_A      (ALUM_A      ),
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
        .i_MCycle_signal(MCycle_out_signal),
        
        .MCycleOp (MCycleOp ),
        .Operand1 (ALUM_A ),
        .Operand2 (ALUM_B ),
        .Result   (MCycle_result   ),
        .Busy     (Busy     )
    );

    MCycle_register u_MCycle_register(
    	.CLK              (CLK              ),
        .Reset            (Reset            ),

        .Start            (Start            ),
        .i_Busy           (Busy           ),

        .i_RA3            (A3_addrE         ),
        .o_Mul_result_out (MCycle_out_signal ),
        .o_RA3            (MCycle_addr       )
    );
    
    ResgisterE2M_Data u_ResgisterE2M_Data(
    	.clk        (CLK        ),
        .rst_p      (Reset      ),
        // .Stall      ( MCycle_Stall    ),

        .ALUResultE (ALUResult_Chosen),
        .WriteDataE (ALUM_B       ),          
        .A3_addrE   (A3_addrE   ),
        // .MemtoRegE  (MemtoRegE),

        .ALUResultM (ALUResultM ),
        .WriteDataM (WriteDataM ),
        .A3_addrM   (A3_addrM   ),
        // .MemtoRegM  (MemtoRegM),

        .RA2_E(RA2_E),
        .RA2_M(RA2_M),

        .BusyE (Busy),
        .BusyM (BusyM)
    );

    // M layer
    RegisterM2W_Data u_RegisterM2W_Data(
    	.clk       (CLK         ),
        .rst_p     (Reset       ),
        // .Stall      ( MCycle_Stall   ),

        .RD_M      (ReadData    ),
        .ALUOut_M  (ALUResultM  ),
        .A3_addrM (A3_addrM ),
        // .MemtoRegM  (MemtoRegM),

        .RD_W      (RD_W      ),
        .ALUOut_W  (ALUOut_W  ),
        .A3_addrW   (A3_addrW ),
        // .MemtoRegW  (MemtoRegW),

        .BusyM      (BusyM),
        .BusyW      (BusyW)
    );
    
endmodule