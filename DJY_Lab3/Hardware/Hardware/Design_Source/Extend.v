module Extend(
    input [1:0] ImmSrc,
    input [23:0] InstrImm,

    output reg [31:0] ExtImm
    );  
    
    always@(*) begin
        case(ImmSrc)
            2'b00:
                ExtImm = {24'b0,InstrImm[7:0]};
            2'b01:
                ExtImm = {20'b0,InstrImm[11:0]};
            2'b10:
                if(InstrImm[23] == 1) begin
                    ExtImm = {6'b111111,InstrImm[23:0],2'b00};
                end
                else if(InstrImm[23] == 0) begin
                    ExtImm = {6'b000000,InstrImm[23:0],2'b00};
                end
        endcase
    end
    
endmodule
