module State_compare
(
    input [31:0] Instr,

    input [31:0] RS1,
    input [31:0] RS2,

    output Condex
);

    wire [6:0] opcode = Instr[6:0];
    wire funct3 = Instr[14:12];

    wire whether_B = (opcode != 7'b1100011) ? 1'b1: 1'b0;

    reg cond;
    always @(*) begin
        if(funct3 == 3'd0)  begin
            cond = (RS1==RS2);
        end
        if(funct3 == 3'd1)  begin
            cond = (RS1!=RS2);
        end
        if(funct3 == 3'd4)  begin
            cond = (RS1 < RS2);
        end
        if(funct3 == 3'd5)  begin
            cond = (RS1 >= RS2);
        end
        if(funct3 == 3'd6)  begin
            cond = (RS1 < RS2);
        end
        if(funct3 == 3'd7)  begin
            cond = (RS1 >= RS2);
        end
    end
    assign Condex = whether_B | cond;
endmodule