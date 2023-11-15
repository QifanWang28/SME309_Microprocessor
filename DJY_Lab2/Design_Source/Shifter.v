module Shifter(
    input [1:0] Sh,//移动的方式
    input [4:0] Shamt5,//移动多少
    input [31:0] ShIn,//被移动的指令
    
    output reg [31:0] ShOut
    );
    wire [31:0] LR16,LR8,LR4,LR2,LR1;
    wire [31:0] LL16,LL8,LL4,LL2,LL1;
    wire [31:0] ASR16,ASR8,ASR4,ASR2,ASR1;
    wire [31:0] ROR16,ROR8,ROR4,ROR2,ROR1;
    
    assign LR16 = Shamt5[4] ? {16'd0, ShIn[31:16]}:(ShIn);
    assign LR8 = Shamt5[3] ? {8'd0, LR16[31:8]}:(LR16);
    assign LR4 = Shamt5[2] ? {4'd0, LR8[31:4]}:(LR8);
    assign LR2 = Shamt5[1] ? {2'd0, LR4[31:2]}:(LR4);
    assign LR1 = Shamt5[0] ? {1'd0, LR2[31:1]}:(LR2);
    
    assign LL16 = Shamt5[4] ? {ShIn[15:0],16'b0} : (ShIn);
    assign LL8 = Shamt5[3] ? {LL16[23:0],8'b0} : (LL16);
    assign LL4 = Shamt5[2] ? {LL8[27:0],4'b0} : (LL8);
    assign LL2 = Shamt5[1] ? {LL4[29:0],2'b0} : (LL4);
    assign LL1 = Shamt5[0] ? {LL2[30:0],1'b0} : (LL2);
   
    assign ASR16 = Shamt5[4] ? {{16{ShIn[31]}}, ShIn[31:16]} : (ShIn);
    assign ASR8 = Shamt5[3] ? {{8{ShIn[31]}},ASR16[31:8]}:(ASR16);
    assign ASR4 = Shamt5[2] ? {{4{ShIn[31]}},ASR8[31:4]}:(ASR8);
    assign ASR2 = Shamt5[1] ? {{2{ShIn[31]}},ASR4[31:2]}:(ASR4);
    assign ASR1 = Shamt5[0] ? {{ShIn[31]},ASR2[31:1]}:(ASR2);
    
    assign ROR16 = Shamt5[4] ? {ShIn[15:0], ShIn[31:16]} : (ShIn);
    assign ROR8 = Shamt5[3] ? {ROR16[7:0], ROR16[31:8]}:(ROR16);
    assign ROR4 = Shamt5[2] ? {ROR8[3:0], ROR8[31:4]}:(ROR8);
    assign ROR2 = Shamt5[1] ? {ROR4[1:0],ROR4[31:2]}:(ROR4);
    assign ROR1 = Shamt5[0] ? {ROR2[0],ROR2[31:1]}:(ROR2);
    
    always@(*) begin
        case(Sh)
            2'b00:
                begin
                 ShOut = LL1;
                end
            2'b01:
                begin
                ShOut = LR1;
                end
            2'b10:
                begin
                ShOut = ASR1;
                end
            2'b11:
                begin
                ShOut = ROR1;
                end
            default:
                begin
                ShOut = ShIn;
                end
        endcase
    end
   
endmodule 
