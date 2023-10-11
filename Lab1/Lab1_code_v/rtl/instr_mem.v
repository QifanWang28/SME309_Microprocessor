`timescale 1ns/1ps

module instr_mem
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
    input [ADDR_WIDTH-1:0] instr_addr,
    output [OUTPUT_WIDTH-1:0] out_instr
);

reg [OUTPUT_WIDTH-1:0] INSTR_MEM [ADDR_NUM:0];
reg [OUTPUT_WIDTH-1:0] out_mem;

assign out_instr = out_mem; 

always @(posedge clk or negedge rst_n)	begin
	if(!rst_n)	begin
		out_mem <= {(OUTPUT_WIDTH){1'b0}};
	end
	else if(rd_en)	begin
		out_mem <= INSTR_MEM[instr_addr];
	end
	else begin
		out_mem <= out_mem;
	end
end
//----------------------------------------------------------------
// Instruction Memory
//----------------------------------------------------------------
integer i;
initial begin
			INSTR_MEM[0] = 32'hE3A00000; 
			INSTR_MEM[1] = 32'hE1A0100F; 
			INSTR_MEM[2] = 32'hE0800001; 
			INSTR_MEM[3] = 32'hE2511001; 
			INSTR_MEM[4] = 32'h1AFFFFFC; 
			INSTR_MEM[5] = 32'hE59F01E8; 
			INSTR_MEM[6] = 32'hE58F57E0; 
			INSTR_MEM[7] = 32'hE59F57DC; 
			INSTR_MEM[8] = 32'hE59F21D8; 
			INSTR_MEM[9] = 32'hE5820000; 
			INSTR_MEM[10] = 32'hE5820004; 
			INSTR_MEM[11] = 32'hE0800001; 
			INSTR_MEM[12] = 32'hE2511001; 
			INSTR_MEM[13] = 32'h1AFFFFFC; 
			INSTR_MEM[14] = 32'hE59F01C4; 
			INSTR_MEM[15] = 32'hE58F57BC; 
			INSTR_MEM[16] = 32'hE59F57B8; 
			INSTR_MEM[17] = 32'hE59F21B4; 
			INSTR_MEM[18] = 32'hE5820000; 
			INSTR_MEM[19] = 32'hE5820004; 
			INSTR_MEM[20] = 32'hE0800001; 
			INSTR_MEM[21] = 32'hE2511001; 
			INSTR_MEM[22] = 32'h1AFFFFFC; 
			INSTR_MEM[23] = 32'hE59F01A0; 
			INSTR_MEM[24] = 32'hE58F5798; 
			INSTR_MEM[25] = 32'hE59F5794; 
			INSTR_MEM[26] = 32'hE59F2190; 
			INSTR_MEM[27] = 32'hE5820000; 
			INSTR_MEM[28] = 32'hE5820004; 
			INSTR_MEM[29] = 32'hE0800001; 
			INSTR_MEM[30] = 32'hE2511001; 
			INSTR_MEM[31] = 32'h1AFFFFFC; 
			INSTR_MEM[32] = 32'hE59F017C; 
			INSTR_MEM[33] = 32'hE58F5774; 
			INSTR_MEM[34] = 32'hE59F5770; 
			INSTR_MEM[35] = 32'hE59F216C; 
			INSTR_MEM[36] = 32'hE5820000; 
			INSTR_MEM[37] = 32'hE5820004; 
			INSTR_MEM[38] = 32'hE0800001; 
			INSTR_MEM[39] = 32'hE2511001; 
			INSTR_MEM[40] = 32'h1AFFFFFC; 
			INSTR_MEM[41] = 32'hE59F0158; 
			INSTR_MEM[42] = 32'hE58F5750; 
			INSTR_MEM[43] = 32'hE59F574C; 
			INSTR_MEM[44] = 32'hE59F2148; 
			INSTR_MEM[45] = 32'hE5820000; 
			INSTR_MEM[46] = 32'hE5820004; 
			INSTR_MEM[47] = 32'hEAFFFFFE; 
			for(i = 48; i < 128; i = i+1) begin 
				INSTR_MEM[i] = 32'h0; 
			end
end

endmodule