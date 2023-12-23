module ResgisterE2M_Cond (
    input clk,
    input rst_p,
    // input refresh,
    input Stall,

    input PCSrcE,
    input RegWriteE,
    input MemWriteE,
    input MemtoRegE,
    input MWriteE,
    // input [31:0] ALUResultE,
    // input [31:0] WriteDataE,
    // input [3:0] A3_addrE,

    output PCSrcM,
    output RegWriteM,
    output MemWriteM,
    output MemtoRegM,
    output MWriteM

    
    // output [31:0] ALUResultM,
    // output [31:0] WriteDataM,
    // output [3:0] A3_addrM
);
    
    reg PCSrc_reg;
    reg RegWrite_reg;
    reg MemWrite_reg;
    reg MemtoReg_reg;
    // reg [31:0] ALUResult_reg;
    // reg [31:0] WriteData_reg;
    // reg [3:0] A3_addr_reg;
    
    always @(posedge clk or posedge rst_p) begin
        if(rst_p)   begin
            PCSrc_reg <= 1'd0;
            RegWrite_reg <= 1'd0;
            MemWrite_reg <= 1'd0;
            MemtoReg_reg <= 1'b0;
            // ALUResult_reg <= 32'd0;
            // WriteData_reg <= 32'd0;
            // A3_addr_reg <= 4'd0;
        end
        // else if(refresh)    begin
        //     PCSrc_reg <= 1'd0;
        //     RegWrite_reg <= 1'd0;
        //     MemWrite_reg <= 1'd0;
        //     MemtoReg_reg <= 1'b0;
        //     // ALUResult_reg <= 32'd0;
        //     // WriteData_reg <= 32'd0;
        //     // A3_addr_reg <= 4'd0;
        // end
        else if(Stall)  begin
            PCSrc_reg <= PCSrc_reg;
            RegWrite_reg <= RegWrite_reg;
            MemWrite_reg <= MemWrite_reg;
            MemtoReg_reg <= MemtoReg_reg;
        end
        else    begin
            PCSrc_reg <= PCSrcE;
            RegWrite_reg <= RegWriteE;
            MemWrite_reg <= MemWriteE;
            MemtoReg_reg <= MemtoRegE;
            // ALUResult_reg <= ALUResultE;
            // WriteData_reg <= WriteDataE;
            // A3_addr_reg <= A3_addrE;
        end
    end
    
    assign PCSrcM = PCSrc_reg;
    assign RegWriteM = RegWrite_reg;
    assign MemWriteM = MemWrite_reg;
    assign MemtoRegM = MemtoReg_reg;
    // assign ALUResultM = ALUResult_reg;
    // assign WriteDataM = WriteData_reg;
    // assign A3_addrM = A3_addr_reg;
endmodule