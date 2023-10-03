module keys
#(
    parameter CLK_FREQ = 100_000_000 // clock frequency(Mhz), 100 MHz, T = 1/100= 0.01 us
)
(
    input wire clk, // clock input
    input wire pause,
    input wire spdup,
    input wire spddn,
    output reg pause_status,
    output reg spddn_status,
    output reg spdup_status
);
    // local paramerts
    localparam KEY_CLK_MAX = CLK_FREQ * 20 / 1000 - 1; // 20ms
    reg [31:0] key_clk_cnt = 32'b0;

    // key input in previous clock cycle
    reg pause_prev = 1'b1;
    reg spddn_prev = 1'b1;
    reg spdup_prev = 1'b1;

    initial begin
        pause_status = 1'b1;
        spddn_status = 1'b1;
        spdup_status = 1'b1;
    end

    // key change, which may not stable, that happening in current clock cycle
    wire pause_change_now;
    assign pause_change_now = pause ^ pause_prev;
    wire spddn_change_now;
    assign spddn_change_now = spddn ^ spddn_prev;
    wire spdup_change_now;
    assign spdup_change_now = spdup ^ spdup_prev;

    // key stably change after 20ms sampling time
    wire pause_change_stably;
    assign pause_change_stably = (key_clk_cnt == KEY_CLK_MAX) && (pause_status ^pause_prev) > 0;
    wire spddn_change_stably;
    assign spddn_change_stably = (key_clk_cnt == KEY_CLK_MAX) && (spddn_status ^spddn_prev) > 0;
    wire spdup_change_stably;
    assign spdup_change_stably = (key_clk_cnt == KEY_CLK_MAX) && (spdup_status ^spdup_prev) > 0;

    // timer for key pin sampling, driven by clk & reset
    always @(posedge clk) begin
        if (pause_change_now > 0) begin
        // clk reset when key changed
            pause_prev <= pause;
            key_clk_cnt <= 32'b0;
        end
        else if (spddn_change_now > 0) begin
        // clk reset when key changed
            key_clk_cnt <= 32'b0;
        end
        else if (spdup_change_now > 0) begin
        // clk reset when key changed
            spdup_prev <= spdup;
            key_clk_cnt <= 32'b0;
        end
        else begin
        // when key not changed, compare to previous clock cycle
            pause_prev <= pause_prev;
            spddn_prev <= spddn_prev;
            spdup_prev <= spdup_prev;
        // clk counter for sampling time
        if (key_clk_cnt == KEY_CLK_MAX) begin
            key_clk_cnt <= 32'b0;
        end
        else begin
            key_clk_cnt <= key_clk_cnt + 32'b1;
        end
        end
    end
    
    // key status update, when key change stably, driven by clk & reset
    always @(posedge clk) begin
        if (pause_change_stably > 0) begin
            pause_status <= pause_prev;
        end
        else begin
            pause_status <= pause_status;
        end

        if (spddn_change_stably > 0) begin
            spddn_status <= spddn_prev;
        end
        else begin
            spddn_status <= spddn_status;
        end

        if (spdup_change_stably > 0) begin
            spdup_status <= spdup_prev;
        end
        else begin
            spdup_status <= spdup_status;
        end
    end
endmodule
