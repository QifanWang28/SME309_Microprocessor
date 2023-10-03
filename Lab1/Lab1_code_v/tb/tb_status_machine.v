`timescale  1ns / 1ps

module tb_status_machine;

// status_machine Parameters
parameter PERIOD  = 10;


// status_machine Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [2:0]  key_press                     = 0 ;

// status_machine Outputs
wire  [1:0]  status                        ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

status_machine  u_status_machine (
    .clk                     ( clk              ),
    .rst_n                   ( rst_n            ),
    .key_press               ( key_press  [2:0] ),

    .status                  ( status     [1:0] )
);

initial
begin
    #30 key_press = 3'b100;
    #30 key_press = 3'b010;
    #20 key_press = 3'b000;
    #20 key_press = 3'b001;
    #20 key_press = 3'b000;
    #20 key_press = 3'b110;
    $finish;
end

endmodule