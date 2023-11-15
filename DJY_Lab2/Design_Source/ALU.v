module ALU(
    input [31:0] Src_A,
    input [31:0] Src_B,
    input [1:0] ALUControl,

    output [31:0] ALUResult,
    output [3:0] ALUFlags
    );
    
    wire [31:0] B;
    wire [31:0] sum;
    
    assign B = (ALUControl[0] == 0) ? Src_B : ~Src_B;
    assign sum =  Src_A + B + ALUControl[0];
    
    assign ALUResult = (ALUControl == 2'b00 || ALUControl == 2'b01) ? sum :
                       (ALUControl == 2'b10) ? (Src_A & Src_B) :
                       (ALUControl == 2'b11) ? (Src_A | Src_B) :
                       32'b0;
    
    assign ALUFlags[3] = ALUResult[31];
    assign ALUFlags[2] = !ALUResult;
    assign ALUFlags[1] = (((Src_A ^ B) & ALUControl[0]) | (Src_A & B)) & !ALUControl[1];
    assign ALUFlags[0] = ~(ALUControl[0] ^ Src_A[31] ^ Src_B[31]) & (Src_A[31] ^ sum[31]) & (!ALUControl[1]);
    
endmodule













