`timescale  1ns / 1ps

module tb_segment_display;

// segment_display Parameters
parameter PERIOD    = 10             ;
parameter CLK_FREQ  = 8;

// segment_display Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [3:0]  num                           = 0 ;
reg   [1:0]  status                        = 0 ;

// segment_display Outputs
wire  [7:0]  addr                          ;
wire  [7:0]  anode                         ;
wire  [6:0]  cathode                       ;
wire  dp                                   ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

segment_display #(
    .CLK_FREQ ( CLK_FREQ ))
 u_segment_display (
    .clk                     ( clk            ),
    .rst_n                   ( rst_n          ),
    .num                     ( num      [3:0] ),
    .status                  ( status   [1:0] ),

    .addr                    ( addr     [7:0] ),
    .anode                   ( anode    [7:0] ),
    .cathode                 ( cathode  [6:0] ),
    .dp                      ( dp             )
);

initial
begin
    #20 status = 2'd0; num = 4'hA;
    #400    num = 4'hF;
    #400    status = 2'd2; num = 4'h1;
    #100    status = 2'd3; num = 4'h2;
    $finish;
end

endmodule