`timescale  1ns / 1ps

module tb_data_mem;

// data_mem Parameters
parameter PERIOD        = 10             ;      
parameter ADDR_NUM      = 128            ;      
parameter ADDR_WIDTH    = $clog2(ADDR_NUM);      
parameter OUTPUT_WIDTH  = 32             ;      

// data_mem Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   rd_en                                = 0 ;
reg   [ADDR_WIDTH-1:0]  data_addr          = 0 ;

// data_mem Outputs
wire  [OUTPUT_WIDTH-1:0]  out_data         ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

data_mem #(
    .ADDR_NUM     ( ADDR_NUM     ),
    .ADDR_WIDTH   ( ADDR_WIDTH   ),
    .OUTPUT_WIDTH ( OUTPUT_WIDTH ))
 u_data_mem (
    .clk                     ( clk                           ),
    .rst_n                   ( rst_n                         ),
    .rd_en                   ( rd_en                         ),
    .data_addr               ( data_addr  [ADDR_WIDTH-1:0]   ),

    .out_data                ( out_data   [OUTPUT_WIDTH-1:0] )
);

initial
begin
    #30 rd_en <= 1'b1;  data_addr <= 7'd5;
    #20 rd_en <= 1'd0;  data_addr <= 7'd10;
    #20 data_addr <= 7'd15;
    #20 rd_en <= 1'd1;  data_addr <= 7'd18;
    $finish;
end

endmodule