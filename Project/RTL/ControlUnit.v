module ControlUnit(
    input [31:0] Instr,
    input [3:0] ALUFlags,
    input CLK,
    input Reset,

    input refresh_D2E,
    // input refresh_E2M,
    // input refresh_M2W,
    input StallE,
    input StallM,
    input StallW,

    output MemtoReg,
    output MemWrite,
    output ALUSrc,
    output [1:0] ImmSrc,
    output RegWrite,
    output [2:0] RegSrc,
    output [1:0] ALUControl,	
    output PCSrc,

    input done,
    output M_Start,
    output MCycleOp,
    output MWrite,           // Need to be modified
    
    output RegWriteM,
    output RegWriteE,
    output MemtoRegE
    ); 
    
    wire [3:0] Cond;
    wire PCS, RegW, MemW;
    wire [1:0] FlagW;   // Watch out
    wire CondEx;

    assign Cond = Instr[31:28];

    wire PCSE;
    wire RegWE;
    wire MemWE;
    wire [1:0] FlagWE;  // Watch out
    wire [1:0] ALUControlE;
    wire ALUSrcE;
    wire [3:0] CondE;
    wire doneE;
    wire M_StartE;
    wire MCycleOpE;
    wire MWriteE;

    wire NoWriteD;
    wire NoWriteE;  
    
    wire M_StartD;

    wire PCSrcE;
    wire MemWriteE;

    wire MemtoRegD;
    wire ALUSrcD;
    wire [1:0] ALUControlD;
    wire MWriteD;
    wire MCycleOpD;
    
    Decoder u_Decoder(
    	.Instr      (Instr      ),
        .PCS        (PCS        ),
        .RegW       (RegW       ),
        .MemW       (MemW       ),

        .MemtoReg   (MemtoRegD   ),
        .ALUSrc     (ALUSrcD     ),
        .ImmSrc     (ImmSrc     ),
        .RegSrc     (RegSrc     ),
        .ALUControl (ALUControlD ),
        .FlagW      (FlagW      ),
        .NoWrite    (NoWriteD    ),
        
        .done       (done       ),
        .M_Start    (M_StartD   ),
        .MCycleOp   (MCycleOpD   ),
        .MWrite     (MWriteD     )
    );

    RegisterD2E_Cond u_RegisterD2E_Cond(
    	.clk         (CLK         ),
        .rst_p       (Reset       ),
        .refresh     (refresh_D2E ),
        .Stall       (StallE),

        .PCSD        (PCS        ),
        .RegWD       (RegW       ),
        .MemWD       (MemW       ),
        .FlagWD      (FlagW      ),
        .ALUControlD (ALUControlD ),
        .MemtoRegD   (MemtoRegD   ),
        .ALUSrcD     (ALUSrcD     ),
        .CondD       (Cond       ),

        .PCSE        (PCSE        ),
        .RegWE       (RegWE       ),
        .MemWE       (MemWE       ),
        .FlagWE      (FlagWE      ),
        .ALUControlE (ALUControlE ),
        .MemtoRegE   (MemtoRegE   ),
        .ALUSrcE     (ALUSrcE     ),
        .CondE       (CondE       ),

        .doneD       (done        ),    // There can be a forward signal
        .M_StartD    (M_StartD    ),
        .MCycleOpD   (MCycleOpD    ),
        .MWriteD     (MWriteD     ),
  
        .M_StartE    (M_StartE    ),
        .MCycleOpE   (MCycleOpE   ),
        .MWriteE     (MWriteE     ),

        .NoWriteD    (NoWriteD     ),
        .NoWriteE    (NoWriteE     )
    );
    
    // CondLogic CondLogic1(
    //     CLK,
    //     PCSE,

    //     RegWE,
    //     MemWE,
    //     FlagWE,
    //     CondE,
    //     ALUFlags,
    //     NoWriteE,
    //     M_StartE,

    //     PCSrcE,
    //     RegWriteE,
    //     MemWriteE,

    //     M_Start
    // );

    CondLogic u_CondLogic(
    	.CLK      (CLK      ),
        .PCS      (PCSE      ),
        .RegW     (RegWE     ),
        .MemW     (MemWE     ),
        .FlagW    (FlagWE    ),
        .Cond     (CondE     ),
        .ALUFlags (ALUFlags ),
        .NoWrite  (NoWriteE  ),
        .M_StartS (M_StartE ),
        .PCSrc    (PCSrcE    ),
        .RegWrite (RegWriteE ),
        .MemWrite (MemWriteE ),
        .M_Start  (M_Start  ),
        .MWriteE  (MWriteE  ),
        .MWrite   (MWrite   )
    );
    




    wire PCSrcM;
    wire RegWriteM;
    wire MemWriteM;
    wire MemtoRegM;
    wire MWriteM;

    ResgisterE2M_Cond u_ResgisterE2M_Cond(
    	.clk       (CLK         ),
        .rst_p     (Reset       ),
        // .refresh   (refresh_E2M ),
        .Stall       (StallM),

        .PCSrcE    (PCSrcE      ),
        .RegWriteE (RegWriteE   ),
        .MemWriteE (MemWriteE   ),
        .MemtoRegE (MemtoRegE   ),
        .MWriteE   (MWrite     ),

        .PCSrcM    (PCSrcM    ),
        .RegWriteM (RegWriteM ),
        .MemWriteM (MemWriteM ),
        .MemtoRegM (MemtoRegM ),
        .MWriteM     (MWriteM     )
    );
    
    wire PCsrcW;
    wire RegWriteW;
    wire MemtoRegW;
    wire MWriteW;

    RegisterM2W_Cond u_RegisterM2W_Cond(
        .clk       (CLK       ),
        .rst_p     (Reset     ),
        // .refresh   (refresh_M2),
        .Stall       (StallW),

        .PCsrcM    (PCsrcM    ),
        .RegWriteM (RegWriteM ),
        .MemtoRegM (MemtoRegM ),
        .MWriteM   (MWriteM   ),

        .PCsrcW    (PCsrcW    ),
        .RegWriteW (RegWriteW ),
        .MemtoRegW (MemtoRegW ),
        .MWriteW   (MWriteW   )
    );

    assign MemtoReg = MemtoRegW;
    assign MemWrite = MemWriteM;
    assign ALUSrc = ALUSrcE;
    assign RegWrite = RegWriteW;
    assign ALUControl = ALUControlE;
    assign PCSrc = PCSrcE;

    // assign MWrite = MWriteE;
    assign MCycleOp = MCycleOpE;
endmodule