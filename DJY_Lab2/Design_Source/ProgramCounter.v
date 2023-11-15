module ProgramCounter(
    input CLK,
    input Reset,
    input PCSrc,
    input [31:0] Result,
    
    output reg [31:0] PC,
    output [31:0] PC_Plus_4
);     
    always@(posedge CLK or posedge Reset) begin 
        if(Reset) begin
            PC <=32'b0;
        end 
        else begin
            if(PCSrc==1) begin
                PC <= Result;
            end
            else if(PCSrc==0) begin
                PC <= PC + 3'b100;
            end
         end    
    end
    
    assign PC_Plus_4 = PC + 3'b100;
    
endmodule