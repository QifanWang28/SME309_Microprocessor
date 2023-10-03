`timescale 1ns/1ps

module instr_mem
(
	input clk,
	input rst_n,
    input [6:0] instr_addr,
    output [31:0] out_instr
);

reg [31:0] INSTR_MEM [127:0];
reg [31:0] out_mem;

assign out_instr = out_mem; 

always @(posedge clk or negedge rst_n)	begin
	if(!rst_n)	begin
		out_mem <= 32'd0;
	end
	else	begin
		out_mem <= INSTR_MEM[instr_addr];
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
			INSTR_MEM[11] = 32'hEAFFFFFE; 
			for(i = 12; i < 128; i = i+1) begin 
				INSTR_MEM[i] = 32'h0; 
			end
end

endmodule