module state_machine (
  input wire clk,         
  input wire speed_u,   
  input wire speed_d,   
  input wire btn_p,   
  output reg [1:0] state,
  output [7:0] addr_w
);


// 定义状态
parameter STATE_LOW = 2'b00;
parameter STATE_NORMAL = 2'b01;
parameter STATE_HIGH = 2'b10;
parameter PAUSED = 2'b11;



parameter SEC = 10000000;
parameter LOW_FREQ = SEC * 4 - 1;
parameter NORMAL_FREQ = SEC -1;
parameter HIGH_FREQ = SEC / 4 - 1;


// 初始状态为中速
reg [1:0] current_state = STATE_NORMAL;
reg [1:0] last_state = STATE_NORMAL;


always @(posedge clk) begin
  case (state)
    STATE_NORMAL: begin
      if (speed_u) current_state <= STATE_HIGH;
      else if (speed_d) current_state <= STATE_LOW;
      else if (btn_p) current_state <= PAUSED;
    end
    STATE_LOW: begin
      if (speed_u) current_state <= STATE_NORMAL;
      else if (btn_p) current_state <= PAUSED;
      else  current_state<=STATE_LOW;
    end
    STATE_HIGH: begin
      if (speed_d) current_state <= STATE_NORMAL;
      else if (btn_p) current_state <= PAUSED;
      else current_state <= STATE_HIGH;
    end
    PAUSED: begin
        if (btn_p) current_state <= last_state;
        else    current_state <=PAUSED;
    end
  endcase
end

// 更新状态寄存器
always @(posedge clk) begin
  state <= current_state;
end


always @(posedge clk) begin
    if(state != PAUSED & current_state == PAUSED)    
        last_state <= state;
    else
        last_state <=last_state;
end

reg [ 29:0 ]cnt =0;
reg [7:0] addr =0;
assign addr_w = addr;
always @(posedge clk) begin
    case(state)
    STATE_LOW :      
        if( cnt >=LOW_FREQ) begin
            cnt <=0;
            addr <= addr + 1;
        end
        else begin
            cnt <=cnt + 1;
            addr <= addr;
        end
    STATE_NORMAL :   
        if( cnt >=NORMAL_FREQ) begin
            cnt <=0;
            addr <= addr + 1;
        end
        else begin
            cnt <=cnt + 1;
            addr <= addr;
        end
    STATE_HIGH :     
        if( cnt >=HIGH_FREQ) begin
            cnt <=0;
            addr <= addr + 1;
        end
        else begin
            cnt <=cnt + 1;
            addr <= addr;
        end
    default :   begin
            cnt <= 0; // stay the value is also accptable
            addr <= addr;
        end
    endcase
end

endmodule
