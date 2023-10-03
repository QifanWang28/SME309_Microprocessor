`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/04 20:03:50
// Design Name: 
// Module Name: led_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module led_tb();
    reg in_tb;
    wire [7:0] out_tb;
    led u_led(.in(in_tb), .out(out_tb));
    initial begin
        in_tb = 0;
        #10
        in_tb = 1;
        #10
        in_tb = 0;
        #10
        in_tb = 1;
        #30
        $finish;
    end
endmodule
