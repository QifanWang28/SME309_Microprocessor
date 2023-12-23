module RegisterM2W_Data (
    input clk,
    input rst_p,
    // input refresh,
    input Stall,

    input [31:0] RD_M,
    input [31:0] ALUOut_M,
    input [3:0] A3_addrM,
    input MemtoRegM,

    output [31:0] RD_W,
    output [31:0] ALUOut_W,
    output [3:0] A3_addrW,
    output MemtoRegW
);

    reg [31:0] RD_reg;
    reg [31:0] ALUOut_reg;
    reg [3:0] A3_addr_reg;
    reg MemtoReg_reg;

    always @(posedge clk or posedge rst_p)  begin
        if(rst_p)   begin
            RD_reg <= 32'd0;
            ALUOut_reg <= 32'd0;
            A3_addr_reg <= 4'd0; 
            MemtoReg_reg <= 1'b0;
        end
        // else if(refresh)    begin
        //     RD_reg <= 32'd0;
        //     ALUOut_reg <= 32'd0;
        //     A3_addr_reg <= 4'd0; 
        //     MemtoReg_reg <= 1'b0;
        // end
        else if(Stall)  begin
            RD_reg <= RD_reg;
            ALUOut_reg <= ALUOut_reg;
            A3_addr_reg <= A3_addr_reg;
            MemtoReg_reg <= MemtoReg_reg;
        end
        else    begin
            RD_reg <= RD_M;
            ALUOut_reg <= ALUOut_M;
            A3_addr_reg <= A3_addrM;
            MemtoReg_reg <= MemtoRegM; 
        end
    end

    assign RD_W = RD_reg;
    assign ALUOut_W = ALUOut_reg;
    assign A3_addrW = A3_addr_reg;
    assign MemtoRegW = MemtoReg_reg;
endmodule