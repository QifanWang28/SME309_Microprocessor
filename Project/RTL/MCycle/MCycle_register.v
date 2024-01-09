module MCycle_register (
    input CLK,
    input Reset,
    
    input Start,
    input i_Busy,  //We can use count and busy too
    input [3:0] i_RA3,

    output o_Mul_result_out,

    // output o_MWrite,
    // output o_RegWrite,
    // output o_PCSrc,
    // output o_MemtoReg,
    output [3:0] o_RA3
);
    // reg [3:0] RA3_reg;
    // reg [4:0] Count;

    // always @(posedge CLK or posedge Reset)  begin
    //     if(Reset)   begin
    //         Count <= 5'd0;
    //         RA3_reg <= 4'd0;
    //     end
    //     else if(Start)  begin
    //         Count <= 5'd0;
    //         RA3_reg <= i_RA3;
    //     end
    //     // else if(Count == 5'd30)   begin
    //     //     Count <= 5'd0;
    //     // end
    //     else begin
    //         Count <= Count + 1'd1;
    //         RA3_reg <= RA3_reg;
    //     end
    // end

    // assign o_Mul_result_out = (Count == 5'd31);
    
    reg [3:0] RA3_reg;
    reg Busy_reg;

    always @(posedge CLK or posedge Reset)  begin
        if(Reset)   begin
            RA3_reg <= 4'd0;
            Busy_reg <= 1'b0;
        end
        else if(Start)  begin
            Busy_reg <= i_Busy;
            RA3_reg <= i_RA3;
        end
        else if(o_Mul_result_out)   begin
            RA3_reg <= 4'd0;
            Busy_reg <= 1'b0;
        end
        else begin
            Busy_reg <= i_Busy;
            RA3_reg <= RA3_reg;
        end
    end

    assign o_Mul_result_out = Busy_reg & ~i_Busy;
    assign o_RA3 = (i_Busy&~Busy_reg)? i_RA3:RA3_reg; 
endmodule