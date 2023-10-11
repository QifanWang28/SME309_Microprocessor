module segment_display
#(
    parameter CLK_FREQ = 28'd100_000_000
)
(
    input clk,
    input rst_n,
    input [3:0] num,        // Display which to display
    input [1:0] status,     // status: 0 low speed; 1 mid speed; 2 high speed; 3 pause
    output [7:0] addr,      // Which memory to use
    output [7:0] anode,
    output [6:0] cathode,   // Display cathode
    output dp
);
    localparam  QUARTER_JUMP = CLK_FREQ / 4 - 1;
    localparam  ANODE_JUMP = CLK_FREQ / 400 - 1;
    assign dp = 1'd1;   // Don't use dp in this task

    reg [24:0] clk_count;
    reg [3:0]  valid_count;
    reg valid;
    reg [7:0] addr_cnt;

    assign addr = addr_cnt;

    reg [7:0] anode_reg;
    assign anode = anode_reg;

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
            clk_count <= 25'd0;
            addr_cnt <= 8'd0;
        end
        else if(clk_count == QUARTER_JUMP) begin
            clk_count <= 25'd0;
            addr_cnt <= addr_cnt + 1'd1;    // valid
        end
        else    begin
            clk_count <= clk_count + valid;
            addr_cnt <= addr_cnt;
        end
    end

    reg [$clog2(ANODE_JUMP)-1:0] anode_cnt;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)  begin
            anode_reg <= 8'b1111_1110;
            anode_cnt <= 'd0;
        end
        else if(anode_cnt == ANODE_JUMP)   begin
            anode_reg <= {anode[6:0], anode[7]};
            anode_cnt <= 'd0;
        end
        else begin
            anode_cnt <= anode_cnt+1'd1;
        end
    end
endmodule