`timescale  1ns / 1ps

module tb_top_display_rom;

// top_display_rom Parameters
parameter PERIOD    = 10;
parameter CLK_FREQ  = 400;

// top_display_rom Inputs
reg   btn_p                                = 0 ;
reg   btn_spdup                            = 0 ;
reg   btn_spddn                            = 0 ;
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;

// top_display_rom Outputs
wire  [7:0]  anode                         ;
wire  [6:0]  cathode                       ;
wire  dp                                   ;
wire  [7:0]  led                           ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

top_display_rom #(
    .CLK_FREQ ( CLK_FREQ ))
 u_top_display_rom (
    .btn_p                   ( btn_p            ),
    .btn_spdup               ( btn_spdup        ),
    .btn_spddn               ( btn_spddn        ),
    .clk                     ( clk              ),
    .rst_n                   ( rst_n            ),

    .anode                   ( anode      [7:0] ),
    .cathode                 ( cathode    [6:0] ),
    .dp                      ( dp               ),
    .led                     ( led        [7:0] )
);

initial
begin
    #20     btn_p = 1;
    #1000    btn_p = 0;
    #1000    btn_p = 1;
    #100    btn_p = 0;
    #1000   btn_spdup = 1;
    #2000    btn_spdup = 0; btn_spddn = 1;
    #2000   btn_spddn = 0;
    #1000 
    $finish;
end

endmodule