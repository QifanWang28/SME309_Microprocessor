module ALU(
    input [31:0] Src_A,
    input [31:0] Src_B,
    input [3:0] ALUControl,
    input [31:0] PC,
    input Imm,
    input ALUSrc_A,
    output reg [31:0] ALUResult
    // output [3:0] ALUFlags   // NZ [3:2] CV [1:0]
    );
    
    // wire N, Z, C, V;
    // reg Cout;

    // wire ALUControl_1_n = ~ALUControl[1];

    // assign N = ALUResult[31];
    // assign Z = ~(|ALUResult);
    // assign C = ALUControl_1_n & (Cout);
    // assign V = ALUControl_1_n & (Src_A[31] ^ ALUResult[31]) & ~(Src_A[31]^Src_B[31]^ALUControl[0]);

    // assign ALUFlags = {N, Z, C, V};
    
    // wire[31:0] SUM_B = (ALUControl[0]) ? ~Src_B : Src_B;
    wire [31:0] trun_B = Imm? Src_B[31:27]:Src_B;
    wire [31:0] Real_Src_A = ALUSrc_A ? PC: Src_A;
    always @(*) begin
        case(ALUControl)
            4'd0: ALUResult = Real_Src_A + Src_B;
            4'd1: ALUResult = Real_Src_A - Src_B;
            4'd2: ALUResult = Real_Src_A ^ Src_B;
            4'd3: ALUResult = Real_Src_A | Src_B;
            4'd4: ALUResult = Real_Src_A & Src_B;
            4'd5: ALUResult = Real_Src_A << trun_B;
            4'd6: ALUResult = Real_Src_A >> trun_B;
            4'd7: ALUResult = Real_Src_A >>> trun_B;
            4'd8: ALUResult = (Real_Src_A < Src_B)?1'b1:1'b0;
            4'd9: ALUResult = (Real_Src_A < Src_B)?1'b1:1'b0;
            4'd10: ALUResult = Src_B << 12;
            4'd11: ALUResult = PC + Src_B << 12;
            default: ALUResult = 32'd0;
        endcase
    end

endmodule
