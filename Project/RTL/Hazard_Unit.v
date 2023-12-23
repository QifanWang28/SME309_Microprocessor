module Hazard_Unit (
    input [3:0] RA1D,
    input [3:0] RA2D,

    input [3:0] RA1E,
    input [3:0] RA2E,

    input [3:0] A3_addrE,
    input MemtoRegE,
    input PCSrcE,
    input RegWriteE,

    input [3:0] A3_addrM,
    input RegWriteM,
    input [3:0] RA2M,
    input MemWriteM,

    input MemtoRegW,
    input [3:0] A3_addrW,
    input RegWriteW,

    output StallF,
    output StallD,

    output refresh_F2D,
    output refresh_D2E,

    output [1:0] ForwardAE,
    output [1:0] ForwardBE,

    output ForwardM
);
    
    // We judge RA whether equal to LDR element
    wire Match_1E_M = (RA1E == A3_addrM); 
    wire Match_2E_M = (RA2E == A3_addrM);

    wire Match_1E_W = (RA1E == A3_addrW);
    wire Match_2E_W = (RA2E == A3_addrW);

    assign ForwardAE = (Match_1E_M & RegWriteM) ? 2'b10 : (Match_1E_W & RegWriteW) ? 2'b01: 2'b00;
    assign ForwardBE = (Match_2E_M & RegWriteM) ? 2'b10 : (Match_2E_W & RegWriteW) ? 2'b01: 2'b00;

    // We judge whether STR is same with LDR element
    assign ForwardM = (RA2M == A3_addrW) & MemWriteM & MemtoRegW & RegWriteW;

    // We stall the first two stages if we the element LDR and need to be used in E stage
    wire Match_12D_E = (RA1D == A3_addrE) || (RA2D == A3_addrE);

    wire Idrstall = Match_12D_E & MemtoRegE & RegWriteE;

    // Branch refresh

    assign StallF = Idrstall;
    assign StallD = Idrstall;
    assign refresh_D2E = Idrstall || PCSrcE;
    assign refresh_F2D = PCSrcE;
endmodule