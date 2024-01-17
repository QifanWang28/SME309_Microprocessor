module Cache (
    input clk,

    input [31:0] Addr,
    
    input MemWrite,

    input [31:0] ReadData,
    input [31:0] WriteData,

    output Hit,         // Stall all device outside

    output MemWrite2Memory,
    output [31:0] MissAddr,
    output [31:0] Data2Memory,
    output [31:0] Data
);
    
    wire [21:0] Addr_tag = Addr[31:10];
    wire [7:0] Addr_index = Addr[9:2];

    // The first two bits split the four block
    reg Data_Block_valid [1023:0];
    reg Data_Block_Dirty [1023:0];
    reg [21:0] Data_Block_Tag [1023:0];
    reg [31:0] Data_Block_Data [1023:0];                

    integer i;
    initial begin
        for(i = 0; i < 1024; i = i + 1)   begin
            Data_Block_Data[i] = 32'd0;
            Data_Block_Tag[i] = 22'd0;
            Data_Block_valid[i] = 1'd0;
            Data_Block_Dirty[i] = 1'd0;
        end
    end

    wire Exist_0 = Data_Block_valid[{2'd0, Addr_index}];
    wire Exist_1 = Data_Block_valid[{2'd1, Addr_index}];
    wire Exist_2 = Data_Block_valid[{2'd2, Addr_index}];
    wire Exist_3 = Data_Block_valid[{2'd3, Addr_index}]; 

    wire Tag0_equal = Exist_0 & (Data_Block_Tag[{2'd0, Addr_index}] == Addr_tag);
    wire Tag1_equal = Exist_1 & (Data_Block_Tag[{2'd1, Addr_index}] == Addr_tag);
    wire Tag2_equal = Exist_2 & (Data_Block_Tag[{2'd2, Addr_index}] == Addr_tag);
    wire Tag3_equal = Exist_3 & (Data_Block_Tag[{2'd3, Addr_index}] == Addr_tag);

    reg [31:0] Addr_reg = 32'd0; 
    always @(posedge clk) begin
        Addr_reg <= Addr;
    end

    wire change = Addr_reg != Addr;

    wire [1:0] BLK_NUM;

    
    Cache_Controller u_Cache_Controller(
        .clk        (clk        ),
        .Addr       (Addr       ),
        .Tag0_equal (Tag0_equal ),
        .Tag1_equal (Tag1_equal ),
        .Tag2_equal (Tag2_equal ),
        .Tag3_equal (Tag3_equal ),

        .Empty_0    (~Exist_0),
        .Empty_1    (~Exist_1),
        .Empty_2    (~Exist_2),
        .Empty_3    (~Exist_3),

        .Hit        (Hit        ),
        .Usecache   (change     ),
        .BLK_NUM    (BLK_NUM    )
    );

    
    always @(posedge clk) begin
        if(!Hit & !MemWrite) begin
            Data_Block_valid[{BLK_NUM, Addr_index}] <= 1'b1;
            Data_Block_Tag[{BLK_NUM, Addr_index}] <= Addr_tag;
            Data_Block_Data[{BLK_NUM, Addr_index}] <= ReadData;
            Data_Block_Dirty[{BLK_NUM, Addr_index}] <= 1'd0;
        end
        else if(Hit & MemWrite)begin
            Data_Block_valid[{BLK_NUM, Addr_index}] <= 1'b1;
            Data_Block_Data[{BLK_NUM, Addr_index}] <= WriteData;
            Data_Block_Dirty[{BLK_NUM, Addr_index}] <= 1'd1;
        end
        else if(!Hit & MemWrite)    begin
            Data_Block_valid[{BLK_NUM, Addr_index}] <= 1'b1;
            Data_Block_Tag[{BLK_NUM, Addr_index}] <= Addr_tag;
            Data_Block_Data[{BLK_NUM, Addr_index}] <= WriteData;
            Data_Block_Dirty[{BLK_NUM, Addr_index}] <= 1'd1;
        end
    end

    assign Data = Tag0_equal ? Data_Block_Data[{2'd0, Addr_index}] : 
                  Tag1_equal ? Data_Block_Data[{2'd1, Addr_index}] :
                  Tag2_equal ? Data_Block_Data[{2'd2, Addr_index}] :
                  Tag3_equal ? Data_Block_Data[{2'd3, Addr_index}] : 32'dz;

    assign Hit = Tag0_equal | Tag1_equal | Tag2_equal | Tag3_equal;
    // assign MemWrite2Memory = (!Hit & MemWrite & Data_Block_valid[{BLK_NUM, Addr_index}] & Data_Block_Dirty[{BLK_NUM, Addr_index}]) | 
    // (!Hit & !MemWrite & Data_Block_Dirty[{BLK_NUM, Addr_index}] & Data_Block_valid[{BLK_NUM, Addr_index}]);
    assign MemWrite2Memory = (!Hit & Data_Block_valid[{BLK_NUM, Addr_index}] & Data_Block_Dirty[{BLK_NUM, Addr_index}]);

    assign Data2Memory = Data_Block_Data[{BLK_NUM, Addr_index}];
    assign MissAddr = {Data_Block_Tag[{BLK_NUM, Addr_index}], Addr_index, 2'b00};
endmodule   