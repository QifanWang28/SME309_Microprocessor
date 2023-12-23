module RegisterM2W_Cond (
    input clk,
    input rst_p,
    // input refresh,
    input Stall,

    input PCsrcM,
    input RegWriteM,
    input MemtoRegM,
    input MWriteM,

    output PCsrcW,
    output RegWriteW,
    output MemtoRegW,
    output MWriteW
);

    reg PCsrc_reg;
    reg RegWrite_reg;
    reg MemtoReg_reg;

    always @(posedge clk or posedge rst_p)  begin
        if(rst_p)   begin
            PCsrc_reg <= 1'd0;
            RegWrite_reg <= 1'd0;
            MemtoReg_reg <= 1'd0;
        end
        // else if(refresh)    begin
        //     PCsrc_reg <= 1'd0;
        //     RegWrite_reg <= 1'd0;
        //     MemtoReg_reg <= 1'd0;
        // end
        else if(Stall)  begin
            PCsrc_reg <= PCsrc_reg;
            RegWrite_reg <= RegWrite_reg;
            MemtoReg_reg <= MemtoReg_reg;
        end
        else    begin
            PCsrc_reg <= PCsrcM;
            RegWrite_reg <= RegWriteM;
            MemtoReg_reg <= MemtoRegM;
        end
    end

    assign PCsrcW = PCsrc_reg;
    assign RegWriteW = RegWrite_reg;
    assign MemtoRegW = MemtoReg_reg;
endmodule