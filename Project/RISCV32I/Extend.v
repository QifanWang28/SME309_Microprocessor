`define R_type 3'b000
`define I_type 3'b001
`define S_type 3'b010
`define B_type 3'b011
`define U_type 3'b100
`define J_type 3'b101


module Extend(
    input [3:0] ImmSrc,
    input [31:7] InstrImm,

    output reg [31:0] ExtImm
    );  
    
    // ImmSrc 00: DP    01: LDR/STR 10: B
    always @(*) begin
        case(ImmSrc[2:0])
            `I_type:    ExtImm = {{(20){InstrImm[31]&(!ImmSrc[3])}},InstrImm[31:20]};
            `S_type:    ExtImm = {{(20){InstrImm[31]}},InstrImm[31:25],InstrImm[4:0]};
            `B_type:    ExtImm = {{(19){InstrImm[31]&(!ImmSrc[3])}}, InstrImm[31], InstrImm[7], InstrImm[30:25], InstrImm[11:8], 1'b0};
            `U_type:    ExtImm = {InstrImm[31:12], 12'b0};
            `J_type:    ExtImm = {{(11){InstrImm[31]}},InstrImm[31],InstrImm[19:12], InstrImm[20],InstrImm[30:21],1'b0};
            default:    ExtImm = 32'B0;
        endcase
    end
endmodule
