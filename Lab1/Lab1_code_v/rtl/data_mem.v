`timescale 1ns/1ps

module data_mem
#
(	
	parameter ADDR_NUM = 128,
	parameter ADDR_WIDTH = $clog2(ADDR_NUM),
	parameter OUTPUT_WIDTH = 32
)
(
	input clk,
	input rst_n,
	input rd_en,
    input [ADDR_WIDTH-1:0] data_addr,
    output [OUTPUT_WIDTH-1:0] out_data
);

reg [OUTPUT_WIDTH-1:0] DATA_CONST_MEM [ADDR_NUM-1:0];
reg [OUTPUT_WIDTH-1:0] out_mem;

assign out_data = out_mem; 

always @(posedge clk or negedge rst_n)	begin
	if(!rst_n)	begin
		out_mem <= {(OUTPUT_WIDTH){1'b0}};
	end
	else if(rd_en)	begin
		out_mem <= DATA_CONST_MEM[data_addr];
	end
	else begin
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
			for(i = 2; i < ADDR_NUM; i = i+1) begin 
				DATA_CONST_MEM[i] = i; 
			end
end
endmodule