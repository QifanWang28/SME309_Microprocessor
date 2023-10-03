`timescale 1ns/1ps

module key_d
#(
    parameter NUM_KEY = 3,
    parameter CLK_FREQ = 100_000_000    // The frequency of board is 100MHz
)
(
    input clk,
    input rst_n,
    input [NUM_KEY-1:0] key,            // key_press[0] BTNU, key_press[1] BTND, key_press[2] BTNC
    output [NUM_KEY-1:0] key_out
);
    localparam SCAN_CNT = CLK_FREQ * 20 / 1000 - 1;
    localparam SCAN_CNT_WIDTH = $clog2(SCAN_CNT);
				  
    reg [SCAN_CNT_WIDTH-1:0] counter; 
    reg [NUM_KEY-1:0] key_prev;

    wire [NUM_KEY-1:0]  key_change = key_prev ^ key;    // Judge the key whether be pressed

    assign key_out = (counter == SCAN_CNT) & key_prev;

    // Control the counter
    always @(posedge clk or negedge rst_n)  begin
        if(!rst_n)  begin
            counter <= {(SCAN_CNT_WIDTH){1'b0}};
            key_prev <= {(NUM_KEY){1'b0}};
        end
        else if(key_change) begin
            counter <= {(SCAN_CNT_WIDTH){1'b0}};
            key_prev <= key_change;
        end
        else begin
            if(counter == SCAN_CNT_WIDTH)   begin
                counter <= {(SCAN_CNT_WIDTH){1'b0}};
            end
            else begin
                counter <= counter + 1'd1;
            end
            key_prev <= key_prev;
        end
    end
    
endmodule
