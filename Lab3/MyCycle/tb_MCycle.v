`timescale 1ns / 1ps

module tb_MCycle();
  localparam width = 32;
  localparam period = 2;
  reg CLK;  
  reg RESET; 
  reg Start; 
  reg MCycleOp; 
  reg [width-1:0] Operand1;
  reg [width-1:0] Operand2;
  wire [width-1:0] Result;
  wire Busy;

  initial begin 
    CLK = 1'b0;
    forever #(period/2) CLK = ~ CLK;
  end

  initial fork
    RESET  = 1'b1;
    Operand1  = 32'd6;
    Operand2  = 32'd3;
    Start = 1'b0;
    MCycleOp = 1'b0;
    #10 
    RESET  = 1'b0;
    #12
    Start = 1'b1;
    #20
    Start = 1'b0;
    #100 begin
    Start = 1'b1;
    MCycleOp = 1'b1;
    end
    #120
    Start = 1'b0;    
    #200 begin
    Start = 1'b1;
    MCycleOp = 1'b0;
    Operand1  = 32'hfcdeffff;
    Operand2  = 32'hfaffffff;
    end
    #220
    Start = 1'b0;  
    #300
    begin
    Start = 1'b1;
    MCycleOp = 1'b1;
    end
    #320
    Start = 1'b0;
    #400
    begin
    Start = 1'b1;
    MCycleOp = 1'b0;
    Operand1  = 32'hfcdefffd;
    Operand2  = 32'h2;
    end
    #420
    Start = 1'b0;
    #500
    begin
    Start = 1'b1;
    MCycleOp = 1'b1;
    end
    #520
    Start = 1'b0;
    #600
    $finish;
  join

  MCycle #(.width(width)) MCycle1(
    CLK,
    RESET,
    Start,
    MCycleOp,
    Operand1,
    Operand2,
    Result,
    Busy
  );

endmodule
