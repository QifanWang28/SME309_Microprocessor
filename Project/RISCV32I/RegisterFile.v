module RegisterFile(
    input CLK,
    input WE3,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,

    input [31:0] WD3,
    input [31:0] PC,

    output [31:0] RD1,
    output [31:0] RD2
    );
    
    // declare RegBank
    reg [31:0] RegBank[1:31];
    

    assign RD1 = (A1 == 0) ? 0: RegBank[A1];
    assign RD2 = (A2 == 0) ? 0: RegBank[A2];

    always@(posedge CLK)    begin
        if(WE3) begin
            RegBank[A3] <= WD3;
        end
    end

endmodule