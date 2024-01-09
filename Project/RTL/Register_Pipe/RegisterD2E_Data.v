module RegisterD2E_Data
(
    input clk,
    input rst_p,
    input refresh,
    input Stall,
    
    input [3:0] RA1_D,
    input [3:0] RA2_D,

    input [31:0] RD1_D,
    input [31:0] RD2_D,
    input [31:0] Extend_D,
    input [3:0] A3_addrD,
    
    input [1:0] Sh_D,
    input [4:0] Shamt5_D,

    output [3:0] RA1_E,
    output [3:0] RA2_E,

    output [31:0] RD1_E,
    output [31:0] RD2_E,
    output [31:0] Extend_E,
    output [3:0] A3_addrE,
    output [1:0] Sh_E,
    output [4:0] Shamt5_E

);
    
    reg [31:0] RD1_reg;
    reg [31:0] RD2_reg;
    reg [31:0] Extend_reg;
    reg [3:0] A3_addr_reg;
    
    reg [1:0] Sh_reg;
    reg [4:0] Shamt5_reg;

    reg [3:0] RA1_reg, RA2_reg;
    always @(posedge clk or posedge rst_p) begin
        if(rst_p)   begin
            RD1_reg <= 32'd0;
            RD2_reg <= 32'd0;
            Extend_reg <= 32'd0;
            A3_addr_reg <= 4'd0;
            Sh_reg <= 2'd0;
            Shamt5_reg <= 5'd0;
            RA1_reg <= 4'd0;
            RA2_reg <= 4'd0;
        end
        else if(refresh)    begin
            RD1_reg <= 32'd0;
            RD2_reg <= 32'd0;
            Extend_reg <= 32'd0;
            A3_addr_reg <= 4'd0;
            Sh_reg <= 2'd0;
            Shamt5_reg <= 5'd0;
            RA1_reg <= 4'd0;
            RA2_reg <= 4'd0;
        end
        else if(Stall)  begin
            RA1_reg <= RA1_reg;
            RA2_reg <= RA2_reg;
            RD1_reg <= RD1_reg;
            RD2_reg <= RD2_reg;
            Extend_reg <= Extend_reg;
            A3_addr_reg <= A3_addr_reg;
            Sh_reg <= Sh_reg;
            Shamt5_reg <= Shamt5_reg;
        end
        else begin
            RA1_reg <= RA1_D;
            RA2_reg <= RA2_D;
            RD1_reg <= RD1_D;
            RD2_reg <= RD2_D;
            Extend_reg <= Extend_D;
            A3_addr_reg <= A3_addrD;
            Sh_reg <= Sh_D;
            Shamt5_reg <= Shamt5_D;
        end
    end

    assign RD1_E = RD1_reg;
    assign RD2_E = RD2_reg;
    assign Extend_E = Extend_reg;
    assign A3_addrE = A3_addr_reg;
    assign Sh_E = Sh_reg;
    assign Shamt5_E = Shamt5_reg;
    assign RA1_E = RA1_reg;
    assign RA2_E = RA2_reg;
endmodule