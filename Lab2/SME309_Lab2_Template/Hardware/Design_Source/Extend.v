module Extend(
    input [1:0] ImmSrc,
    input [23:0] InstrImm,

    output reg [31:0] ExtImm
    );  
    
    // ImmSrc 00: DP    01: LDR/STR 10: B
    always @(*) begin
        case(ImmSrc)
            2'b00:  ExtImm = {{24{1'b0}},InstrImm[7:0]};
            2'b01:  ExtImm = {{20{1'b0}},InstrImm[11:0]};
            2'b10:  ExtImm = {{6{InstrImm[23]}},InstrImm[23:0],2'b00};
        endcase
    end
endmodule
