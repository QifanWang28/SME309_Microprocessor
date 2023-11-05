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
    // output reg test_led,
    output [NUM_KEY-1:0] key_out    
);
    localparam SCAN_CNT = CLK_FREQ * 20 / 1000 - 1;
    localparam SCAN_CNT_WIDTH = $clog2(SCAN_CNT);

    reg [SCAN_CNT_WIDTH-1:0] counter; 
    reg [NUM_KEY-1:0] key_prev;
    reg [NUM_KEY-1:0] key_status;

    wire [2:0] key_change = key_prev ^ key;    // Judge the key whether be pressed

    wire [NUM_KEY-1:0] key_stable;
    assign key_stable = {(NUM_KEY){(counter == SCAN_CNT)}} & key_prev;   // Attention: 

    // Control the counter
    always @(posedge clk or negedge rst_n)  begin
        if(!rst_n)  begin
            counter <= {(SCAN_CNT_WIDTH){1'b0}};
            key_prev <= {(NUM_KEY){1'b0}};
            // test_led <= 1'd0;
        end
        else if(key_change) begin
            counter <= {(SCAN_CNT_WIDTH){1'b0}};
            key_prev <= key;
            // test_led <= ~test_led;
        end
        else begin
            if(counter == SCAN_CNT)   begin
                counter <= {(SCAN_CNT_WIDTH){1'b0}};
            end
            else begin
                counter <= counter + 1'd1;
            end
            key_prev <= key_prev;
        end
    end
    
    always @(posedge clk or negedge rst_n)  begin
        if(!rst_n)  begin
            key_status <= 3'b000;
        end
        else if(counter == SCAN_CNT) begin
            key_status <= key_stable;
        end
    end

    reg [NUM_KEY-1:0]   key_reg;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)  begin
            key_reg <= 3'd0;
        end
        else begin
            key_reg <= key_status;
        end
    end

    assign key_out = (key_reg ^ key_status) & (~key_reg);
endmodule
