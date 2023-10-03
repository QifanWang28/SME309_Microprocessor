`timescale 1ns/1ps

module data_mem
(
	input clk,
	input rst_n,
    input [6:0] data_addr,
    output [31:0] out_data
);

reg [31:0] DATA_CONST_MEM [127:0];
reg [31:0] out_mem;

assign out_data = out_mem; 

always @(posedge clk or negedge rst_n)	begin
	if(!rst_n)	begin
		out_mem <= 32'd0;
	end
	else	begin
		out_mem <= DATA_CONST_MEM[data_addr];
	end
end
//----------------------------------------------------------------
// Data (Constant) Memory
//----------------------------------------------------------------
integer i;
initial begin
			DATA_CONST_MEM[0] = 32'h00000800; 
			DATA_CONST_MEM[1] = 32'hABCD1234; 
			for(i = 2; i < 128; i = i+1) begin 
				DATA_CONST_MEM[i] = i; 
			end
end
endmodule