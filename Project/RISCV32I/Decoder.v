`define R_type 3'b000
`define I_type 3'b001
`define S_type 3'b010
`define B_type 3'b011
`define U_type 3'b100
`define J_type 3'b101

module Decoder(
    input [31:0] Instr,
	
    output PCS,
    output reg PCS_dire,
    output reg RegW, 
    output reg MemW, 
    output reg MemtoReg,
    output reg ALUSrc,  // 0 > reg; 1 > Imm
    
    output reg [3:0] ALUControl,
    output reg ALUSrc_A,
    output reg PC_4,

    output reg [3:0] ImmSrc,    // ImmSrc[3] zero 
    output reg Imm,             // New
    output reg [1:0] Load_size // 0 for byte, 1 for half, 2 for whole
    ); 
    
    reg [1:0] ALUOp; 
    reg Branch;
    
    wire [6:0] opcode = Instr[6:0];
    wire funct3 = Instr[14:12];

    wire [6:0] funct7 = Instr[31:25];
    // PC Logic
    assign PCS = Branch;

    always @(*) begin
        if(opcode == 7'b0110011)    begin
            Branch = 1'b0;
            PCS_dire = 1'd0;
            MemtoReg = 1'b0;
            MemW = 1'b0;
            ALUSrc = 1'b0;      // 0 > reg; 1 > Imm
            ImmSrc[2:0] = 3'd0;      // 
            RegW = 1'b1;
            Imm = 1'b0;
            Load_size = 2'd0;
            ALUSrc_A = 1'b0;
            PC_4 = 1'b0;
            if(funct3 == 3'd0)  begin
                if(funct7 == 7'h00) begin
                    ALUControl = 4'd0;
                end
                else if(funct7 == 7'h20) begin
                    ALUControl = 4'd1;
                end
                ImmSrc[3] = 3'b0;
            end
            else if(funct3 == 3'd4) begin
                ALUControl = 4'd2;
                ImmSrc[3] = 3'b0;
            end
            else if(funct3 == 3'd6) begin
                ALUControl = 4'd3;
                ImmSrc[3] = 3'b0;
            end
            else if(funct3 == 3'd7) begin
                ALUControl = 4'd4;
                ImmSrc[3] = 3'b0;
            end
            else if(funct3 == 3'd1) begin
                ALUControl = 4'd5;
                ImmSrc[3] = 3'b0;
            end
            else if(funct3 == 3'd5) begin
                if(funct7 == 7'h00) begin
                    ALUControl = 4'd6;
                    ImmSrc[3] = 3'b0;
                end
                else if(funct7 == 7'h20) begin
                    ALUControl = 4'd7;
                    ImmSrc[3] = 3'b0;
                end
            end
            else if(funct3 == 3'd2) begin
                ALUControl = 4'd8;
                ImmSrc[3] = 3'b0;
            end
            else if(funct3 == 3'd3) begin
                ALUControl = 4'd9;
                ImmSrc[3] = 3'b1;
            end
        end
        else if(opcode == 7'b0010011)    begin
            Branch = 1'b0;
            PCS_dire = 1'd0;
            MemtoReg = 1'b0;
            MemW = 1'b0;
            ALUSrc = 1'b1;      // 0 > reg; 1 > Imm
            ImmSrc[2:0] = `I_type;      // 
            RegW = 1'b1;
            // Imm = 1'b0;
            Load_size = 2'd0;
            ALUSrc_A = 1'b0;
            PC_4 = 1'd0;
            if(funct3 == 3'd0)  begin
                ALUControl = 4'd0;
                Imm = 1'b0;
                ImmSrc[3] = 1'b0;
            end
            else if(funct3 == 3'd4) begin
                ALUControl = 4'd2;
                Imm = 1'b0;
                ImmSrc[3] = 1'b0;
            end
            else if(funct3 == 3'd6) begin
                ALUControl = 4'd3;
                Imm = 1'b0;
                ImmSrc[3] = 1'b0;
            end
            else if(funct3 == 3'd7) begin
                ALUControl = 4'd4;
                Imm = 1'b0;
                ImmSrc[3] = 1'b0;
            end
            else if(funct3 == 3'd1) begin
                ALUControl = 4'd5;
                Imm = 1'b1;
                ImmSrc[3] = 1'b0;
            end
            else if(funct3 == 3'd5) begin
                if(Instr[26:20]==7'h00) begin
                    ALUControl = 4'd6;
                    Imm = 1'b1;
                    ImmSrc[3] = 1'b0;
                end
                else if(Instr[26:20]==7'h20) begin
                    ALUControl = 4'd7;
                    Imm = 1'b1;
                    ImmSrc[3] = 1'b0;
                end
            end
            else if(funct3 == 3'd2) begin
                ALUControl = 4'd8;
                Imm = 1'b0;
                ImmSrc[3] = 1'b0;
            end
            else if(funct3 == 3'd3) begin
                ALUControl = 4'd9;
                Imm = 1'b0;
                ImmSrc[3] = 1'b1;
            end
        end

        else if(opcode == 7'b0000011)    begin
            Branch = 1'b0;
            PCS_dire = 1'd0;
            MemtoReg = 1'b1;
            MemW = 1'b0;
            ALUSrc = 1'b1;      // 0 > reg; 1 > Imm
            ImmSrc[2:0] = `I_type;      // 
            RegW = 1'b1;
            Imm = 1'b0;
            ALUControl = 4'd0;
            ALUSrc_A = 1'b0;
            PC_4 = 1'd0;
            if(funct3 == 3'b0)  begin
                Load_size = 2'd2;
                ImmSrc[3] = 1'b0;
            end
            else if(funct3 == 3'd1)  begin
                Load_size = 2'd1;
                ImmSrc[3] = 1'b0;
            end
            else if(funct3 == 3'd2)  begin
                Load_size = 2'd0;
                ImmSrc[3] = 1'b0;
            end
            else if(funct3 == 3'd4)  begin
                Load_size = 2'd2;
                ImmSrc[3] = 1'b1;
            end
            else if(funct3 == 3'd5)  begin
                Load_size = 2'd1;
                ImmSrc[3] = 1'b1;
            end
        end
        else if(opcode == 7'b0100011)    begin
            Branch = 1'b0;
            PCS_dire = 1'd0;
            MemtoReg = 1'b0;
            MemW = 1'b1;
            ALUSrc = 1'b1;      // 0 > reg; 1 > Imm
            ImmSrc[2:0] = `I_type;      // 
            RegW = 1'b0;
            Imm = 1'b0;
            ALUControl = 4'd0;
            ALUSrc_A = 1'b0;
            PC_4 = 1'd0;
            if(funct3 == 3'b0)  begin
                Load_size = 2'd2;
                ImmSrc[3] = 1'b0;
            end
            else if(funct3 == 3'd1)  begin
                Load_size = 2'd1;
                ImmSrc[3] = 1'b0;
            end
            else if(funct3 == 3'd2)  begin
                Load_size = 2'd0;
                ImmSrc[3] = 1'b0;
            end
        end

        else if(opcode == 7'b1100011)    begin
            Branch = 1'b1;
            PCS_dire = 1'd0;
            MemtoReg = 1'b0;
            MemW = 1'b0;
            ALUSrc = 1'b1;      // 0 > reg; 1 > Imm
            ImmSrc[2:0] = `B_type;      // 
            RegW = 1'b0;
            Imm = 1'b0;
            ALUControl = 4'd0;
            Load_size = 2'd0;
            ALUSrc_A = 1'b1;
            PC_4 = 1'd0;
            if(funct3 == 3'b0)  begin
                ImmSrc[3] = 1'b0;
            end
            else if(funct3 == 3'd1)  begin
                ImmSrc[3] = 1'b0;
            end
            else if(funct3 == 3'd4)  begin
                ImmSrc[3] = 1'b0;
            end
            else if(funct3 == 3'd5)  begin
                ImmSrc[3] = 1'b0;
            end
             else if(funct3 == 3'd6)  begin
                ImmSrc[3] = 1'b1;
            end
             else if(funct3 == 3'd7)  begin
                ImmSrc[3] = 1'b1;
            end
        end
        else if(opcode == 7'b1101111)   begin
            Branch = 1'b1;
            PCS_dire = 1'd1;
            MemtoReg = 1'b0;
            MemW = 1'b0;
            ALUSrc = 1'b1;      // 0 > reg; 1 > Imm
            ImmSrc[2:0] = `J_type;      // 
            RegW = 1'b1;
            Imm = 1'b0;
            ALUControl = 4'd0;
            Load_size = 2'd0;
            ImmSrc[3] = 1'b0;
            ALUSrc_A = 1'b1;
            PC_4 = 1'd1;
        end
        else if(opcode == 7'b1100111)   begin
            Branch = 1'b1;
            PCS_dire = 1'd1;
            MemtoReg = 1'b0;
            MemW = 1'b0;
            ALUSrc = 1'b1;      // 0 > reg; 1 > Imm
            ImmSrc[2:0] = `I_type;      // 
            RegW = 1'b1;
            Imm = 1'b0;
            ALUControl = 4'd0;
            Load_size = 2'd0;
            ImmSrc[3] = 1'b0;
            ALUSrc_A = 1'b1;
            PC_4 = 1'd1;
        end
        else if(opcode == 7'b0110111)   begin
            Branch = 1'd0;
            PCS_dire = 1'd0;
            MemtoReg = 1'b0;
            MemW = 1'b0;
            ALUSrc = 1'b1;      // 0 > reg; 1 > Imm
            ImmSrc[2:0] = `U_type;      // 
            RegW = 1'b1;
            Imm = 1'b0;
            ALUControl = 4'd10;
            Load_size = 2'd0;
            ImmSrc[3] = 1'b0;
            ALUSrc_A = 1'b1;
            PC_4 = 1'd0;
        end
        else if(opcode == 7'b0010111)   begin
            Branch = 1'b0;
            PCS_dire = 1'd0;
            MemtoReg = 1'b0;
            MemW = 1'b0;
            ALUSrc = 1'b1;      // 0 > reg; 1 > Imm
            ImmSrc[2:0] = `U_type;      // 
            RegW = 1'b1;
            Imm = 1'b0;
            ALUControl = 4'd11;
            Load_size = 2'd0;
            ImmSrc[3] = 1'b0;
            ALUSrc_A = 1'b1;
            PC_4 = 1'd0;
        end
    end




    // always@(*)   begin
    //     casex({opcode, funct_I, funct_U, funct_S})
    //         7'b00_x_xx_1x:  {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, ALUOp}  = 11'b0_0_0_x_xx_1_xx_00;
    //         7'b00_0_xx_0x:  {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, ALUOp}  = 11'b0000xx10011;
    //         7'b00_1_xx_0x:  {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, ALUOp}  = 11'b0001001x011;
    //         7'b01_x_xx_x1:  {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, ALUOp}  = 11'b0_0_0_x_xx_1_xx_00;
    //         7'b01_x_0_0_x0: {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0x110101001;
    //         7'b01_x_0_1_x0: {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0101011x001;
    //         7'b01_x_1_0_x0: {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0x110101000;
    //         7'b01_x_1_1_x0: {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b0101011x000;
    //         7'b10_x_xx_xx:    {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}  = 11'b1001100x100;
    //         default:    {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc[1:0], ALUOp}   = 10'h3FF;
    //     endcase
    // end
    
    // // ALU Decoder
    // always @(*) begin
    //     casex({ALUOp, funct_cmd, funct_S})
    //         7'b00_xxxx_x: {ALUControl, FlagW, NoWrite} = 5'b00_00_0;
    //         7'b01_xxxx_x: {ALUControl, FlagW, NoWrite} = 5'b01_00_0;
    //         7'b11_0100_0: {ALUControl, FlagW, NoWrite} = 5'b00_00_0;
    //         7'b11_0100_1: {ALUControl, FlagW, NoWrite} = 5'b00_11_0;
    //         7'b11_0010_0: {ALUControl, FlagW, NoWrite} = 5'b01_00_0;
    //         7'b11_0010_1: {ALUControl, FlagW, NoWrite} = 5'b01_11_0;
    //         7'b11_0000_0: {ALUControl, FlagW, NoWrite} = 5'b10_00_0;
    //         7'b11_0000_1: {ALUControl, FlagW, NoWrite} = 5'b10_10_0;
    //         7'b11_1100_0: {ALUControl, FlagW, NoWrite} = 5'b11_00_0;
    //         7'b11_1100_1: {ALUControl, FlagW, NoWrite} = 5'b11_10_0;
    //         7'b11_1010_1: {ALUControl, FlagW, NoWrite} = 5'b01_11_1;
    //         7'b11_1011_1: {ALUControl, FlagW, NoWrite} = 5'b00_11_1;
    //         default:   {ALUControl, FlagW, NoWrite} = 5'b11111;
    //     endcase
    // end
endmodule