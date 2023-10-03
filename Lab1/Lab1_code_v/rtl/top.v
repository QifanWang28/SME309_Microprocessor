`timescale 1ns/1ps
module top_display_rom 
#
(
    parameter CLK_FREQ = 100_000_000
)
(
    input btn_p,
    input btn_spdup,
    input btn_spddn,
    input clk,
    input rst_n,
    output [7:0] anode,
    output [6:0] cathode,
    output test_led,
    output [1:0] st,
    output dp,
    output [7:0] led
);

    /////////////////////////////////////////////////////
    wire [31:0] rom_out;
    wire [7:0]  rom_addr;
    wire [31:0] out_data, out_instr;
    assign led = rom_addr;
    assign rom_out = (rom_addr[7])? out_data : out_instr;

    assign st = status;
    data_mem 
    #(
        .ADDR_NUM     (128          ),
        .ADDR_WIDTH   (7            ),
        .OUTPUT_WIDTH (32           )
    )
    u_data_mem(
        .clk       (clk         ),
        .rst_n     (rst_n       ),
        .rd_en     (rom_addr[7] ),
        .data_addr (rom_addr[6:0]  ),
        .out_data  (out_data    )
    );


    instr_mem 
    #(
        .ADDR_NUM     (128          ),
        .ADDR_WIDTH   (7            ),
        .OUTPUT_WIDTH (32           )
    )
    u_instr_mem(
    	.clk        (clk            ),
        .rst_n      (rst_n          ),
        .rd_en      (!rom_addr[7]   ),
        .instr_addr (rom_addr[6:0]     ),
        .out_instr  (out_instr      )
    );
    ////////////////////////////////////////////////////////
    // Key check module
    wire [2:0]  key_check;
    key_d 
    #(
        .NUM_KEY        (3              ),
        .CLK_FREQ       (CLK_FREQ       )
    )
    u_key_d(
    	.clk     (clk     ),
        .rst_n   (rst_n   ),
        .key     ({btn_p, btn_spddn, btn_spdup}     ),
        .test_led(test_led),
        .key_out (key_check )
    );
    /////////////////////////////////////////////////////////
    // Status_machine
    wire [1:0] status;
    status_machine u_status_machine(
    	.clk       (clk       ),
        .rst_n     (rst_n     ),
        .key_press (key_check ),
        .status    (status    )
    );
    //////////////////////////////////////////////////////////
    reg [3:0] num;

    always @(*) begin
        case(anode)
            8'b1111_1110:   num = rom_out[3:0];
            8'b1111_1101:   num = rom_out[7:4];
            8'b1111_1011:   num = rom_out[11:8];
            8'b1111_0111:   num = rom_out[15:12];
            8'b1110_1111:   num = rom_out[19:16];
            8'b1101_1111:   num = rom_out[23:20];
            8'b1011_1111:   num = rom_out[27:24];
            8'b0111_1111:   num = rom_out[31:28];
        endcase
    end

    segment_display 
    #(
        .CLK_FREQ     (CLK_FREQ  )
    )
    u_segment_display(
    	.clk     (clk     ),
        .rst_n   (rst_n   ),
        .num     (num     ),
        .status  (status  ),
        .addr    (rom_addr),
        .anode   (anode   ),
        .cathode (cathode ),
        .dp      (dp      )
    );

endmodule