`define ADD 00
`define SUB 01
`define AND 10
`define ORR 11

module ALU(
    input [31:0] Src_A,
    input [31:0] Src_B,
    input [2:0] ALUControl,

    output reg [31:0] ALUResult,
    output [3:0] ALUFlags,   // NZ [3:2] CV [1:0]

    input Carry,
    input Carry_use,

    input Reverse_B

    );
    
    wire N, Z, C, V;
    reg Cout;

    wire ALUControl_1_n = ~ALUControl[1];

    assign N = ALUResult[31];
    assign Z = ~(|ALUResult);
    assign C = ALUControl_1_n & (Cout);
    assign V = ALUControl_1_n & (Src_A[31] ^ ALUResult[31]) & ~(Src_A[31]^Src_B[31]^ALUControl[0]);

    assign ALUFlags = {N, Z, C, V};
    
    wire Carry_pre = ALUControl[0] ? !Carry : Carry;
    wire Carry_ALU = Carry_pre & Carry_use;

    wire[31:0] SUM_B = (ALUControl[0]) ? ~Src_B + 1'b1: Src_B;

    wire [31:0] Re_src = Reverse_B ? ~ Src_B : Src_B;
    always @(*) begin
        case(ALUControl)    // 000: Add 001: Sub 010: And and BIC 011: ORR 100: EOR 101: MOV
            3'b000:  {Cout, ALUResult} = Src_A + SUM_B + Carry_ALU;
            3'b001:  {Cout, ALUResult} = Src_A + SUM_B - Carry_ALU;
            3'b010:  ALUResult = Src_A & Re_src;
            3'b011:  ALUResult = Src_A | Src_B;
            3'b100:  ALUResult = Src_A ^ Src_B;
            3'b101:  ALUResult = Re_src;
            default: ALUResult = 32'd0;
        endcase
    end

endmodule
