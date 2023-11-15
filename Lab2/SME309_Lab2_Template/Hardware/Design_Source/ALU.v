`define ADD 00
`define SUB 01
`define AND 10
`define ORR 11

module ALU(
    input [31:0] Src_A,
    input [31:0] Src_B,
    input [1:0] ALUControl,

    output reg [31:0] ALUResult,
    output [3:0] ALUFlags   // NZ [3:2] CV [1:0]
    );
    
    wire N, Z, C, V;
    reg Cout;

    wire ALUControl_1_n = ~ALUControl[1];

    assign N = ALUResult[31];
    assign Z = ~(|ALUResult);
    assign C = ALUControl_1_n & (Cout);
    assign V = ALUControl_1_n & (Src_A[31] ^ ALUResult[31]) & ~(Src_A[31]^Src_B[31]^ALUControl[0]);

    assign ALUFlags = {N, Z, C, V};
    
    wire[31:0] SUM_B = (ALUControl[0]) ? ~Src_B : Src_B;
    always @(*) begin
        case(ALUControl)
            2'b00:  {Cout, ALUResult} = Src_A + SUM_B;
            2'b01:  {Cout, ALUResult} = Src_A + SUM_B + 1'b1;
            2'b10:  ALUResult = Src_A & Src_B;
            2'b11:  ALUResult = Src_A | Src_B;
            default: ALUResult = 32'd0;
        endcase
    end

endmodule
