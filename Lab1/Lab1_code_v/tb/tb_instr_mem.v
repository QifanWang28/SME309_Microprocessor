`timescale  1ns / 1ps

module tb_instr_mem;

// instr_mem Parameters
parameter PERIOD        = 10             ;
parameter ADDR_NUM      = 128            ;
parameter ADDR_WIDTH    = $clog2(ADDR_NUM);
parameter OUTPUT_WIDTH  = 32             ;

// instr_mem Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   rd_en                                = 0 ;
reg   [ADDR_WIDTH-1:0]  instr_addr         = 0 ;

// instr_mem Outputs
wire  [OUTPUT_WIDTH-1:0]  out_instr        ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

instr_mem #(
    .ADDR_NUM     ( ADDR_NUM     ),
    .ADDR_WIDTH   ( ADDR_WIDTH   ),
    .OUTPUT_WIDTH ( OUTPUT_WIDTH ))
 u_instr_mem (
    .clk                     ( clk                            ),
    .rst_n                   ( rst_n                          ),
    .rd_en                   ( rd_en                          ),
    .instr_addr              ( instr_addr  [ADDR_WIDTH-1:0]   ),

    .out_instr               ( out_instr   [OUTPUT_WIDTH-1:0] )
);

initial
begin
    #30 rd_en <= 1'b1;  instr_addr <= 7'd5;
    #20 rd_en <= 1'd0;  instr_addr <= 7'd10;
    #20 instr_addr <= 7'd15;
    #20 rd_en <= 1'd1;  instr_addr <= 7'd18;
    $finish;
end

endmodule