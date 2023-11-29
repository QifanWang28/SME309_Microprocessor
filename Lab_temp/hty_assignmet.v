module memory
#(
    parameter BYTE_ADDR_WIDTH = 27,
    parameter BYTE_ADDR_ALL = 30
)
(
    input clk,
    input [29:0] addr,  // The address of the memory
    input [6:0] data_input,
    
    input wr_en,
    input rd_en,

    output reg [6:0] data_output,
    output err
);
    
    reg [63:0] mem [2**BYTE_ADDR_WIDTH-1:0];

    // Read from memory, the MSB for judging
    wire [63:0] addr_data;
    assign addr_data = wr_en ? mem[addr[29:3]]: 64'dz;

    reg RD_odd_even;
    always @(*) begin
        case(addr[2:0])
            3'b000: {RD_odd_even, data_output} = addr_data[7:0]; 
            3'b001: {RD_odd_even, data_output} = addr_data[15:8];
            3'b010: {RD_odd_even, data_output} = addr_data[23:16];
            3'b011: {RD_odd_even, data_output} = addr_data[31:24];
            3'b100: {RD_odd_even, data_output} = addr_data[39:32];
            3'b101: {RD_odd_even, data_output} = addr_data[47:40];
            3'b110: {RD_odd_even, data_output} = addr_data[55:48];
            3'b111: {RD_odd_even, data_output} = addr_data[63:56];
            default: {RD_odd_even, data_output} = addr_data[7:0];
        endcase
    end

    assign err = RD_odd_even ^ (^data_output);

    wire WR_odd_even;

    assign WR_odd_even = ^data_input;
    // Write to the memory
    always @(posedge clk) begin
        if(wr_en)   begin
            case(addr[2:0])
                3'b000:  mem[addr[29:3]][7-:8] <= {WR_odd_even, data_input};
                3'b001:  mem[addr[29:3]][15-:8] <= {WR_odd_even, data_input};
                3'b010:  mem[addr[29:3]][23-:8] <= {WR_odd_even, data_input};
                3'b011:  mem[addr[29:3]][31-:8] <= {WR_odd_even, data_input};
                3'b100:  mem[addr[29:3]][39-:8] <= {WR_odd_even, data_input};
                3'b101:  mem[addr[29:3]][47-:8] <= {WR_odd_even, data_input};
                3'b110:  mem[addr[29:3]][55-:8] <= {WR_odd_even, data_input};
                3'b111:  mem[addr[29:3]][63-:8] <= {WR_odd_even, data_input};
                default: mem[addr[29:3]][7-:8] <= {WR_odd_even, 7'd0};
            endcase
            
        end
    end
endmodule