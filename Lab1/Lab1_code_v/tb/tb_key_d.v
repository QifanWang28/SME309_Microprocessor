`timescale  1ns / 1ps

module tb_key_d;

// key_d Parameters
parameter PERIOD    = 10         ;
parameter NUM_KEY   = 3          ;
parameter CLK_FREQ  = 500;

// key_d Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [NUM_KEY-1:0]  key                   = 0 ;

// key_d Outputs
wire  [NUM_KEY-1:0]  key_out               ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

key_d #(
    .NUM_KEY  ( NUM_KEY  ),
    .CLK_FREQ ( CLK_FREQ ))
 u_key_d (
    .clk                     ( clk                    ),
    .rst_n                   ( rst_n                  ),
    .key                     ( key      [NUM_KEY-1:0] ),

    .key_out                 ( key_out  [NUM_KEY-1:0] )
);

initial
begin
    #160 key = 3'b010;
    #200 key = 3'b000;
    #200 key = 3'b001;
    #2000 key = 3'b000;
    #200 key = 3'b001;
    #200 key = 3'b001;
    #200
    $finish;
end

endmodule