module segment_decoder (
    input [3:0] char,
    output [6:0] cathode
);
    reg [6:0] decoder;
    assign cathode = decoder;
    always @(*)  begin
        case (char)
            4'h0:   decoder = 7'h01;
            4'h1:   decoder = 7'h1F;
            4'h2:   decoder = 7'h12;
            4'h3:   decoder = 7'h06;
            4'h4:   decoder = 7'h4C;
            4'h5:   decoder = 7'h24;
            4'h6:   decoder = 7'h20;
            4'h7:   decoder = 7'h0F;
            4'h8:   decoder = 7'h00;
            4'h9:   decoder = 7'h04;
            4'hA:   decoder = 7'h08;
            4'hB:   decoder = 7'h60;
            4'hC:   decoder = 7'h31;
            4'hD:   decoder = 7'h42;
            4'hE:   decoder = 7'h30;
            4'hF:   decoder = 7'h38;
            default: decoder = 7'h00;
        endcase
    end
endmodule