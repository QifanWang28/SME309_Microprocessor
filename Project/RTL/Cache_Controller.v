module Cache_Controller (
    input clk,
    input [31:0] Addr,

    input Tag0_equal,
    input Tag1_equal,
    input Tag2_equal,
    input Tag3_equal,

    input Empty_0,
    input Empty_1,
    input Empty_2,
    input Empty_3,
    
    input Hit,
    input Usecache,
    output reg [1:0] BLK_NUM
);
    wire [7:0] Addr_index = Addr[9:2];

    reg [1:0] Tree_LRU [255:0];

    integer i;
    initial begin
        for(i = 0; i < 256; i = i + 1)  begin
            Tree_LRU[i] = 2'd0;
        end
    end

    always @(*) begin
        if(Tag0_equal|Empty_0) BLK_NUM = 2'd0;
        else if(Tag1_equal|Empty_1) BLK_NUM = 2'd1;
        else if(Tag2_equal|Empty_2) BLK_NUM = 2'd2;
        else if(Tag3_equal|Empty_3) BLK_NUM = 2'd3;
        else BLK_NUM = {Tree_LRU[Addr_index][0], Tree_LRU[Addr_index][1]};
    end

    
    always @(posedge clk) begin
        if(!Hit & Usecache)    begin
            Tree_LRU[Addr_index] <= Tree_LRU[Addr_index] + 1'd1; 
        end
        else if(Usecache)begin
            Tree_LRU[Addr_index] <= BLK_NUM[Addr_index] + 1'd1;
        end
        else begin
            Tree_LRU[Addr_index] <= Tree_LRU[Addr_index];
        end
    end
    // reg [1:0] reg0[255:0];
    // reg [1:0] reg1[255:0];
    // reg [1:0] reg2[255:0];
    // reg [1:0] reg3[255:0];

    // wire [21:0] Addr_tag = Addr[31:10];
    

    // integer i;
    // initial begin
    //     for(i = 0; i < 256; i = i + 1)  begin
    //         reg0[i] = 2'd3;
    //         reg1[i] = 2'd2;
    //         reg2[i] = 2'd1;
    //         reg3[i] = 2'd0;
    //     end 
    // end

    // always @(posedge clk)   begin
    //     if(!Hit)    begin   // need modifing
    //         reg3[Addr_index] <= reg2[Addr_index];
    //         reg2[Addr_index] <= reg1[Addr_index];
    //         reg1[Addr_index] <= reg0[Addr_index];
    //         reg0[Addr_index] <= reg3[Addr_index];
    //     end
    //     else if
    // end
endmodule