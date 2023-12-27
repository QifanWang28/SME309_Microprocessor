module Shifter(
    input [1:0] Sh,
    input [4:0] Shamt5,
    input [31:0] ShIn,
    
    output reg [31:0] ShOut
    );

    wire [31:0] LL16, LL8, LL4, LL2, LL1;
    assign LL16 = Shamt5[4] ? {ShIn[0+:16],16'd0}:(ShIn);
    assign LL8 = Shamt5[3] ? {LL16[0+:24],8'd0}:(LL16);
    assign LL4 = Shamt5[2] ? {LL8[0+:28],4'd0}:(LL8);
    assign LL2 = Shamt5[1] ? {LL4[30], LL4[0+:30],2'd0}:(LL4);
    assign LL1 = Shamt5[0] ? {LL2[31], LL2[0+:31],1'd0}:(LL2);

    wire [31:0] LR16, LR8, LR4, LR2, LR1;
    assign LR16 = Shamt5[4] ? {16'd0, ShIn[31-:16]}:(ShIn);
    assign LR8 = Shamt5[3] ? {8'd0, LR16[31-:24]}:(LR16);
    assign LR4 = Shamt5[2] ? {4'd0, LR8[31-:28]}:(LR8);
    assign LR2 = Shamt5[1] ? {2'd0, LR4[31-:30]}:(LR4);
    assign LR1 = Shamt5[0] ? {1'd0, LR2[31-:31]}:(LR2);

    wire [31:0] ASR16, ASR8, ASR4, ASR2, ASR1;
    assign ASR16 = Shamt5[4] ?  { {16{ShIn[31]}}, ShIn[31-:16]}:(ShIn);
    assign ASR8 = Shamt5[3] ?   { {8{ShIn[31]}}, ASR16[31-:24]}:(ASR16);
    assign ASR4 = Shamt5[2] ?   { {4{ShIn[31]}}, ASR8[31-:28]}:(ASR8);
    assign ASR2 = Shamt5[1] ?   { {2{ShIn[31]}}, ASR4[31-:30]}:(ASR4);
    assign ASR1 = Shamt5[0] ?   { {ShIn[31]}, ASR2[31-:31]}:(ASR2);

    wire [31:0] ROR16, ROR8, ROR4, ROR2, ROR1;
    assign ROR16 = Shamt5[4] ?  { ShIn[15:0], ShIn[31-:16]}:(ShIn);
    assign ROR8 = Shamt5[3] ?   { ShIn[7:0], ROR16[31-:24]}:(ROR16);
    assign ROR4 = Shamt5[2] ?   { ShIn[3:0], ROR8[31-:28]}:(ROR8);
    assign ROR2 = Shamt5[1] ?   { ShIn[1:0], ROR4[31-:30]}:(ROR4);
    assign ROR1 = Shamt5[0] ?   { ShIn[0], ROR2[31-:31]}:(ROR2);

    always @(*) begin
        case(Sh)
            2'b00:  ShOut = LL1;
            2'b01:  ShOut = LR1;
            2'b10:  ShOut = ASR1;
            2'b11:  ShOut = ROR1;
        endcase
    end
endmodule 
