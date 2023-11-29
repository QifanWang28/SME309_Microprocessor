module Decoder(
    input [31:0] Instr,
    output PCS,
    output RegW, //
    output MemW, //
    output MemtoReg,//
    output ALUSrc,//
    output [1:0] ImmSrc,//
    output [2:0] RegSrc,//
    output NoWrite,
    output M_Start,
    output MWrite,
    output MCycleOp,
    output reg [1:0] ALUControl,//
    output reg [1:0] FlagW//
    ); 
    
    reg [1:0]ALUOp ; 
    reg Branch ;
    reg [2:0] Mode;
   
    //Instr[23] funct��u��ֵ�����ж��Ǽӻ��Ǽ���- u=0 + u= 1,ͬʱ��ALUOp��Ϊ��λ��Ҳ�ǵ�λ���䣬��λ�ͱ�ʾ0-    1+
   
  
    assign RegW = ((Instr[27:26]==2'b00) ||(Instr[27:26]==2'b01 && Instr[20]==1'b1 ) ) ? 1'b1: 1'b0;
    assign MemW = (Instr[27:26]==2'b01 && Instr[20]==1'b0);
    assign MemtoReg = (Instr[27:26]==2'b01 && Instr[20]==1'b1);
    assign ALUSrc = (Instr[27:26]==2'b00 && Instr[25]==1'b0) ? 1'b0: 1'b1;
    assign ImmSrc[1] = (Instr[27:26]==2'b10);
    assign ImmSrc[0] = (Instr[27:26]==2'b01);
    assign RegSrc[1] = (Instr[27:26]==2'b01 && Instr[20]==1'b0);
    assign RegSrc[0] = (Instr[27:26]==2'b10);
    assign RegSrc[2] = ((Mode == 3'b000) || (Mode == 3'b010)) ? 1'b1 : 1'b0;
   
    assign NoWrite = (ALUOp==2'b10 && (Instr[24:21]==4'b1011 || Instr[24:21]==4'b1010) && Instr[20]) ? 1'b1 : 1'b0;
    
    assign M_Start = ((Mode == 3'b000) || (Mode == 3'b010)) ? 1'b1 : 1'b0;
    assign MWrite = ((Mode == 3'b000) || (Mode == 3'b010)) ? 1'b1 : 1'b0;
    assign MCycleOp = (Mode == 3'b000) ? 1'b0 : (Mode == 3'b010) ? 1'b1 :1'b0;
    
    always@(*) begin
      case(Instr[27:26])
          2'b00:begin
              if(Instr[25] == 0 && Instr[7:4] == 4'b1001 && Instr[24:21] == 4'b0000)     
                  Mode = 3'b000; //MUL
              else
                  Mode = 3'b001; //DP
          end
          2'b01:begin
              if(Instr[25:20] == 6'b111111 && Instr[7:4] == 4'b1111)
                  Mode = 3'b010; //DIV
              else
                  Mode = 3'b011; //MEM
          end
          2'b10: 
              Mode = 3'b100; //B
          default:
              Mode = 3'b000;
      endcase
    end
    
    always@(*) begin
        if(Instr[27]==1) begin
            Branch = 1'b1;
        end
        else begin
            Branch = 1'b0;
        end
    end
    //ALUOp�ĸ�λ��ʾ�ǲ���DF����λ��ʾ���������DF�����Ǽӻ��Ǽ� 0- 1+
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