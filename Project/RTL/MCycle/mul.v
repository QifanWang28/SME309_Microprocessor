module mul
#(
    parameter WIDTH = 24
) 
(
    input clk,   
    input RESET, 
    input Start, 
    input [WIDTH-1:0] a, 
    input [WIDTH-1:0] b, 
    output [WIDTH *2-1:0] c, 
    output reg Busy  
);
    reg [4:0] cnt;
    reg [WIDTH *2-1:0] Multiplicand;
    reg [WIDTH -1:0] Multiplier;
    reg [WIDTH *2-1:0] Product;
    assign c = Product;


    always @(posedge clk or posedge RESET) begin
      if(RESET) begin
        cnt <= 0 ;
        Multiplicand <=0;
        Multiplier <= 0;
        Product <=0;
        Busy <=0;
      end
      else if(Start) begin
        cnt <= 0;
        Multiplicand <=a;
        Multiplier <= b;
        Product <=0;
        Busy <= 1;
      end
      else if(Busy) begin
        if(cnt == WIDTH-1) begin
            cnt <= 0 ;
            Multiplicand <=0;
            Multiplier <= 0;
            Product <= Multiplier[0]? Product + Multiplicand : Product;
            Busy <=0;
        end
        else begin
            cnt <= cnt + 1;
            Multiplicand <= Multiplicand<<1;
            Multiplier <= Multiplier >>1;
            Busy <= Busy;
            Product <= Multiplier[0]? Product + Multiplicand : Product;
        end
      end
      else begin
        cnt <= 0 ;
        Multiplicand <=0;
        Multiplier <= 0;
        Product <=0;
        Busy <=0;
      end
    end


endmodule