module CondLogic(
    input CLK,
    input PCS,
    input RegW,
    input MemW,
    input NoWrite,
    input [1:0] FlagW,
    input [3:0] Cond,
    input [3:0] ALUFlags,
    
    output PCSrc,
    output RegWrite,
    output MemWrite
    ); 
    
    reg CondEx ;
    reg N = 0, Z = 0, C = 0, V = 0 ;
    wire [1:0] FlagWrite;
    
    assign PCSrc = PCS & CondEx;
    assign RegWrite = RegW & CondEx & !NoWrite;
    assign MemWrite = MemW & CondEx;
    assign FlagWrite = FlagW & {(2){CondEx}};
    
    always@(posedge CLK) begin
        if(FlagWrite[1] == 1) begin
            N <= ALUFlags[3]; 
            Z <= ALUFlags[2]; 
        end
        if(FlagWrite[0] == 1) begin
            C <= ALUFlags[1];
            V <= ALUFlags[0];
        end
    end
    
    always@(*) begin
        case(Cond)
            4'b0000:
                begin
                    CondEx = Z;
                end
            4'b0001:
                begin
                    CondEx = ~Z;
                end
            4'b0010:
                begin
                    CondEx = C;
                end
            4'b0011:
                begin
                    CondEx = ~C;
                end
            4'b0100:
                begin
                    CondEx = N;
                end
            4'b0101:
                begin
                    CondEx = ~N;
                end
            4'b0110:
                begin
                    CondEx = V;
                end
            4'b0111:
                begin
                    CondEx =~V;           
                end
            4'b1000:
                begin
                    CondEx = ~Z & C;
                end
            4'b1001:
                begin
                    CondEx = Z | ~C;
                end
            4'b1010:
                begin
                    CondEx = ~(N ^ V);
                end
            4'b1011:
                begin
                    CondEx = N ^ V;
                end
            4'b1100:
                begin
                    CondEx =~Z & ~(N ^V);
                end
            4'b1101:
                begin
                   CondEx = Z | ( N ^ V);
                end
            4'b1110:
                begin
                   CondEx = 1'b1;
                end
            default:
                begin
                    CondEx =1'b0;
                end
        endcase
    end
           
endmodule