module RegisterF2D
(
    input clk,
    input rst_p,
    input refresh,
    input Stall,

    input [31:0] InstrF,

    output [31:0] InstrD
);
    
    reg [31:0] InstrD_reg;

    always @(posedge clk or posedge rst_p) begin
        if(rst_p)   begin
            InstrD_reg <= 32'd0;
        end
        else if(refresh)    begin
            InstrD_reg <= 32'd0;
        end
        else if(Stall)  begin
            InstrD_reg <= InstrD_reg;
        end
        else begin
            InstrD_reg <= InstrF;
        end
    end

    assign InstrD = InstrD_reg;

endmodule