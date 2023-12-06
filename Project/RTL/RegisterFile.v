module RegisterFile(
    input CLK,
    input WE3,
    input [3:0] A1,
    input [3:0] A2,
    input [3:0] A3,
    input [31:0] WD3,
    input [31:0] R15,

    output [31:0] RD1,
    output [31:0] RD2
    );
    
    // declare RegBank
    reg [31:0] RegBank[0:14];
 
    assign RD1 = (A1==15) ? R15: RegBank[A1];
    assign RD2 = (A2==15) ? R15: RegBank[A2];

    always@(posedge CLK)    begin
        if(WE3) begin
            RegBank[A3] <= WD3;
        end
    end

endmodule