module status_machine
(
    input clk,
    input rst_n,
    input [2:0] key_press,  // key_press[0] BTNU, key_press[1] BTND, key_press[2] BTNC
    output [1:0] status     // status: 0 low speed; 1 mid speed; 2 high speed; 3 pause;
);
    reg [1:0] status_reg;
    reg [1:0] status_save;

    assign status = status_reg;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)  begin
            status_reg <= 2'd1;
            status_save <= 2'd1;
        end
        else begin
            case(status)
                2'd0: begin
                    if(key_press[0])    begin
                        status_reg <= 2'd1;
                    end
                    else if(key_press[2])   begin
                        status_reg <= 2'd3;
                        status_save <= 2'd0;
                    end
                    else if(key_press[1])begin
                        status_reg <= 2'd0;
                    end
                    else begin
                        status_reg <= status_reg;
                        status_save <= status_save;
                    end
                end
                2'd1: begin
                    if(key_press[0])    begin
                        status_reg <= 2'd2;
                    end
                    else if(key_press[2])   begin
                        status_reg <= 2'd3;
                        status_save <= 2'd1;
                    end
                    else if(key_press[1] )begin
                        status_reg <= 2'd0;
                    end
                    else begin
                        status_reg <= status_reg;
                        status_save <= status_save;
                    end
                end
                2'd2: begin
                    if(key_press[0])    begin
                        status_reg <= 2'd2;
                    end
                    else if(key_press[2])   begin
                        status_reg <= 2'd3;
                        status_save <= 2'd2;
                    end
                    else if(key_press[1]) begin
                        status_reg <= 2'd1;
                    end
                    else begin
                        status_reg <= status_reg;
                        status_save <= status_save;
                    end
                end
                2'd3: begin
                    if(key_press[2])    begin
                        status_reg <= status_save;
                    end
                    else    begin
                        status_reg <= status_reg;
                        status_save <= status_save;
                    end
                end
                default: begin
                    status_reg <= 2'd1;
                    status_save <= 2'd1;
                end
            endcase
        end
    end
endmodule