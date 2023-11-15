module Decoder(
    input [31:0] Instr,
	
    output PCS,
    output RegW, //
    output MemW, //
    output MemtoReg,//
    output ALUSrc,//
    output [1:0] ImmSrc,//
    output [1:0] RegSrc,//
    output NoWrite,
    output reg [1:0] ALUControl,//
    output reg [1:0] FlagW//
    ); 
    
    reg [1:0]ALUOp ; 
    reg Branch ;
   
    //Instr[23] funct里u的值。来判断是加还是减。- u=0 + u= 1,同时把ALUOp变为两位，也是低位不变，高位就表示0-    1+
   
  
    assign RegW = ((Instr[27:26]==2'b00) ||(Instr[27:26]==2'b01 && Instr[20]==1'b1 )) ? 1'b1: 1'b0;
    assign MemW = (Instr[27:26]==2'b01 && Instr[20]==1'b0);
    assign MemtoReg = (Instr[27:26]==2'b01 && Instr[20]==1'b1);
    assign ALUSrc = (Instr[27:26]==2'b00 && Instr[25]==1'b0) ? 1'b0: 1'b1;
    assign ImmSrc[1] = (Instr[27:26]==2'b10);
    assign ImmSrc[0] = (Instr[27:26]==2'b01);
    assign RegSrc[1] = (Instr[27:26]==2'b01 && Instr[20]==1'b0);
    assign RegSrc[0] = (Instr[27:26]==2'b10);
    
    
    // assign NoWrite = (ALUOp[27:26]==2'b11 && (Instr[24:21]==4'b1011 || Instr[24:21]==4'b1010) && Instr[20]) ? 1'b1 : 1'b0;
    assign NoWrite = (ALUOp ==2'b10 && (Instr[24:21]==4'b1011 || Instr[24:21]==4'b1010) && Instr[20]) ? 1'b1 : 1'b0;

    always@(*) begin
        if(Instr[27]==1) begin
            Branch = 1'b1;
        end
        else begin
            Branch = 1'b0;
        end
    end
   // ALUOp的高位表示是不是DF，低位表示的是如果是DF，那是加还是减 0- 1+
    always@(*) begin
        if(Instr[27:26] == 2'b00) begin
            ALUOp[1] = 1'b1;
        end
        else begin 
            ALUOp[1] = 1'b0;
        end

        if(Instr[27:26] == 2'b01 && !Instr[23]) begin
            ALUOp[0] = 1'b1;
        end
        else begin 
            ALUOp[0] = 1'b0;
        end
         
    end
    
    // always@(*) begin
    //     if(Instr[27:26] == 2'b00) begin
    //         ALUOp = 2'b11;
    //     end
    //     else if(Instr[27:26] == 2'b01 && !Instr[23]) begin
    //         ALUOp = 2'b01;
    //     end
    //     else begin 
    //         ALUOp = 2'b00;
    //     end
    // end
    
    //PC Logic
    assign PCS = ((Instr[15:12] == 4'b1111 && RegW) || (Branch == 1'b1 )) ? 1'b1 : 1'b0;
    //ALUDecoder
    always@(*) begin
        if(ALUOp[1]==1'b1) begin
            case(Instr[24:21])
                4'b0100:
                    ALUControl = 2'b00;
                4'b0010,4'b1010,4'b1011:
                    ALUControl = 2'b01;
                4'b0000:
                    ALUControl = 2'b10;
                4'b1100:
                    ALUControl = 2'b11;
                default:
                    ALUControl = 2'b00;
            endcase
        end
        else if (ALUOp[1] == 1'b0) begin
            if (ALUOp[0] == 1'b0) begin
                ALUControl = 2'b00;
            end
            else if (ALUOp[0] == 1'b1) begin
                ALUControl = 2'b01;
            end
        end
    end
    
    always@(*) begin 
        if(ALUOp[1] == 1'b0 || Instr[20] == 1'b0) begin
            FlagW = 2'b00;
        end
        else if (ALUOp[1] == 1'b1) begin
            case(Instr[24:20])
                5'b01001,5'b00101,5'b10101,5'b10111: FlagW = 2'b11;
                5'b00001,5'b11001: FlagW = 2'b10;
            default:  FlagW = 2'b00;
            endcase  
        end
    end
   
endmodule