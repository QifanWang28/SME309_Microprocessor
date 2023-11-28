module ProgramCounter(
    input CLK,
    input Reset,
    input PCSrc,
    input [31:0] Result,
    input Busy,

    output reg [31:0] PC,
    output [31:0] PC_Plus_4
); 

//fill your Verilog code here
wire [31:0] next_PC;
assign next_PC = PCSrc ? Result: PC_Plus_4;

always @(posedge CLK or posedge Reset) begin
    if(Reset)  begin
        PC <= 32'd0;
    end
    else begin
        if(Busy)    begin
            PC <= PC;
        end
        else begin
            PC <= next_PC;
        end
    end
end

assign PC_Plus_4 = PC + 3'd4;

endmodule