module RegisterD2E_Cond
(
    input clk,
    input rst_p,
    input refresh,
    input Stall,

    input PCSD,
    input RegWD,
    input MemWD,
    input [1:0] FlagWD,
    input [1:0] ALUControlD,
    input MemtoRegD,
    input ALUSrcD,
    input [3:0] CondD,

    output PCSE,
    output RegWE,
    output MemWE,
    output [1:0] FlagWE,
    output [1:0] ALUControlE,
    output MemtoRegE,
    output ALUSrcE,
    output [3:0] CondE,

    input doneD,
    input M_StartD,
    input MCycleOpD,
    input MWriteD,

    output doneE,
    output M_StartE,
    output MCycleOpE,
    output MWriteE,

    input NoWriteD,
    output NoWriteE


    // input [31:0] RD1_D,
    // input [31:0] RD2_D,
    // input [31:0] Extend_D,
    // input [3:0] A3_addr_D,

    // output [31:0] RD1_E,
    // output [31:0] RD2_E,
    // output [31:0] Extend_E,
    // output [3:0] A3_addr_E
);
    
    reg PCS_reg;
    reg RegW_reg;
    reg MemW_reg;
    reg [1:0] FlagW_reg;
    reg [1:0] ALUControl_reg;
    reg MemtoReg_reg;
    reg ALUSrc_reg;
    reg [3:0] Cond_reg;

    reg done_reg;
    reg M_Start_reg;
    reg MCycleOp_reg;
    reg MWrite_reg;

    reg NoWrite_reg;
    // reg [31:0] RD1_reg;
    // reg [31:0] RD2_reg;
    // reg [31:0] Extend_reg;
    // reg [3:0] A3_addr_reg;

    always @(posedge clk or posedge rst_p) begin
        if(rst_p)   begin
            PCS_reg <= 1'd0;
            RegW_reg <= 1'd0;
            MemW_reg <= 1'd0;
            FlagW_reg <= 2'd0;
            ALUControl_reg <= 2'd0;
            MemtoReg_reg <= 1'd0;
            ALUSrc_reg <= 1'd0;
            Cond_reg <= 4'd0;

            done_reg <= 1'd0;
            M_Start_reg <= 1'd0;
            MCycleOp_reg <= 1'd0;
            MWrite_reg <= 1'd0;

            NoWrite_reg <= 1'b0;
            // RD1_reg <= 32'd0;
            // RD2_reg <= 32'd0;
            // Extend_reg <= 32'd0;
            // A3_addr_reg <= 4'd0;
        end
        else if(refresh)    begin
            PCS_reg <= 1'd0;
            RegW_reg <= 1'd0;
            MemW_reg <= 1'd0;
            FlagW_reg <= 2'd0;
            ALUControl_reg <= 2'd0;
            MemtoReg_reg <= 1'd0;
            ALUSrc_reg <= 1'd0;
            Cond_reg <= 4'd0;

            done_reg <= 1'd0;
            M_Start_reg <= 1'd0;
            MCycleOp_reg <= 1'd0;
            MWrite_reg <= 1'd0;

            NoWrite_reg <= 1'b0;
            // RD1_reg <= 32'd0;
            // RD2_reg <= 32'd0;
            // Extend_reg <= 32'd0;
            // A3_addr_reg <= 4'd0;
        end
        else if(Stall)  begin
            PCS_reg <= PCS_reg;
            RegW_reg <= RegW_reg;
            MemW_reg <= MemW_reg;
            FlagW_reg <= FlagW_reg;
            ALUControl_reg <= ALUControl_reg;
            MemtoReg_reg <= MemtoReg_reg;
            ALUSrc_reg <= ALUSrc_reg;
            Cond_reg <= Cond_reg;

            done_reg <= done_reg;
            M_Start_reg <= M_Start_reg;
            MCycleOp_reg <= MCycleOp_reg;
            MWrite_reg <= MWrite_reg;

            NoWrite_reg <= NoWrite_reg;
        end
        else begin
            PCS_reg <=  PCSD;
            RegW_reg <= RegWD;
            MemW_reg <= MemWD;
            FlagW_reg <= FlagWD;
            ALUControl_reg <= ALUControlD;
            MemtoReg_reg <= MemtoRegD;
            ALUSrc_reg <= ALUSrcD;
            Cond_reg <= CondD;

            done_reg <= doneD;
            M_Start_reg <= M_StartD;
            MCycleOp_reg <= MCycleOpD;
            MWrite_reg <= MWriteD;

            NoWrite_reg <= NoWriteD;
            // RD1_reg <= RD1_D;
            // RD2_reg <= RD2_D;
            // Extend_reg <= Extend_D;
            // A3_addr_reg <= A3_addr_D;
        end
    end

    assign PCSE = PCS_reg;
    assign RegWE = RegW_reg;
    assign MemWE = MemW_reg;
    assign FlagWE = FlagW_reg;
    assign ALUControlE = ALUControl_reg;
    assign MemtoRegE = MemtoReg_reg;
    assign ALUSrcE = ALUSrc_reg;
    assign CondE = Cond_reg;

    assign doneE = done_reg;
    assign M_StartE = M_Start_reg;
    assign MCycleOpE = MCycleOp_reg;
    assign MWriteE = MWrite_reg;

    assign NoWriteE = NoWrite_reg;
    // assign RD1_E = RD1_reg;
    // assign RD2_E = RD2_reg;
    // assign Extend_E = Extend_reg;
    // assign A3_addr_E = A3_addr_reg;
endmodule