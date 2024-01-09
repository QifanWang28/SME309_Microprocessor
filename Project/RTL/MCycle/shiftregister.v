module shiftregister #(parameter FIXED_DEPTH = 1, DATA_WIDTH = 1) (
    input clk,
    input rst,
    input [DATA_WIDTH-1:0] din,
    output [DATA_WIDTH-1:0] dout
);

generate
if(FIXED_DEPTH == 0) begin
    assign dout = din;
end
else if (FIXED_DEPTH == 1) begin
    regist #(DATA_WIDTH) u_reg (
        .i_clk(clk), // input clock
        .i_rst_n(~rst), // input reset
        .i_d(din),
        .o_q(dout)
    );
end else begin
    wire [FIXED_DEPTH*DATA_WIDTH-1:0] out_delay;
    regist #(FIXED_DEPTH*DATA_WIDTH) u_reg (
        .i_clk(clk), // input clock
        .i_rst_n(~rst), // input reset
        .i_d({out_delay[(FIXED_DEPTH-1)*DATA_WIDTH-1:0], din}),
        .o_q(out_delay)
    );
    assign dout = out_delay[FIXED_DEPTH*DATA_WIDTH-1-:DATA_WIDTH];
end
endgenerate

endmodule