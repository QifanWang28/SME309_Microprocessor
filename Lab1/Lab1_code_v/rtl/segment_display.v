module segment_display
#(
    parameter ONE_JUMP = 28'd100_000_000
)
(
    input clk,
    input rst_n,
    input [3:0] num,        // Display which to display
    input [1:0] status,     // status: 0 low speed; 1 mid speed; 2 high speed; 3 pause
    output [7:0] addr,      // Which memory to use
    // output [7:0] anode,
    output [6:0] cathode,   // Display cathode
    output dp
);
    localparam  QUARTER_JUMP = ONE_JUMP / 4;

    assign dp = 1'd0;   // Don't use dp in this task

    reg [28:0] clk_count;
    reg [3:0]  valid_count;
    reg valid;
    reg [7:0] addr_cnt;

    segment_decoder u_segment_decoder(
    	.char    (num    ),
        .cathode (cathode )  
    );

    wire [3:0] count_limit;
    assign count_limit = (status == 2) ? 4'd0 : ((status == 1) ? 4'd3 : 4'd15);

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)  begin
            valid <= 1'd0;
            valid_count <= 4'd0;
        end
        else if(status == 2'd3) begin
            valid <= 1'd0;
            valid_count <= 4'd0;
        end 
        else if(valid_count == count_limit) begin
            valid <= 1'd1;
            valid_count <= 4'd0;
        end   
        else begin
            valid <= 1'd0;
            valid_count <= valid_count + 1'd1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)  begin
            clk_count <= 29'd0;
            addr_cnt <= 8'd0;
        end
        else if(clk_count == ONE_JUMP) begin
            clk_count <= 29'd0;
            addr_cnt <= addr_cnt + 1'd1;
        end
        else    begin
            clk_count <= clk_count + valid;
            addr_cnt <= addr_cnt;
        end
    end
endmodule