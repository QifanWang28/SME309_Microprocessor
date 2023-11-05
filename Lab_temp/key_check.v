module Key_check
(	
	input Clk_50mhz,
	
	input btn_pause,
	input btn_up,
	input btn_down,
	
	output reg Key_pause= 1'd0,
	output reg Key_up= 1'd0,
	output reg Key_down= 1'd0
);

	reg [31:0] cnt1= 32'd0;
	
	reg Key_pause2= 1'd0;
	reg Key_up2= 1'd0;
	reg Key_down2= 1'd0;
	
	always @ (posedge Clk_50mhz)
	begin
        if(cnt1 == 32'd5_0000)
        begin
            cnt1 <= 0;
            Key_pause2 <= btn_pause;
            Key_up2 <= btn_up;
            Key_down2 <= btn_down;

            if((Key_pause2 == 1'd1) && (btn_pause == 1'd0))
                Key_pause <= 1'd1;
            if((Key_up2 == 1'd1) && (btn_up == 1'd0))
                Key_up <= 1'd1;
            if((Key_down2 == 1'd1) && (btn_down == 1'd0))
                Key_down <= 1'd1;	
        end
        else
        begin
            cnt1 <= cnt1 + 32'd1;
            Key_pause <= 1'd0;
            Key_up <= 1'd0;
            Key_down <= 1'd0;
        end
	
	end				
	
endmodule
