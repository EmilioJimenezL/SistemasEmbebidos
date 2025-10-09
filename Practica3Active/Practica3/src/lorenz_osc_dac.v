module lorenz_osc_dac (
    input RST,
    input CLK,
    input DRST,		  
    output EOW,
    output DAC_SCLK,
    output DAC_SYNC,
    output DAC_DIN,
    output DAC_LDAC,
    output DAC_RST
);

    wire [31:0] Xout, Yout, Zout;
    wire [15:0] Xout16, Yout16, Zout16;
    reg [12:0] Qi;
    reg [15:0] Qii;
    reg WR;
    wire NRST;
    
    parameter K = 13'b0000011111010;
    parameter zero = 13'b0000000000000;
    
    lorenz_osc lorenz (
        .clk(CLK),
        .rst(NRST),
        .x(Xout),
        .y(Yout),
        .z(Zout)
    );
    
    DAC7565 DAC (
        .RST(RST),
        .CLK(CLK),
        .WR(WR),
        .EOW(EOW),
        .DRST(1'b0),
        .Ch0(Xout16),
        .Ch1(Yout16),
        .Ch2(Yout16),
        .Ch3(Zout16),
        .DAC_SCLK(DAC_SCLK),
        .DAC_SYNC(DAC_SYNC),
        .DAC_DIN(DAC_DIN),
        .DAC_LDAC(DAC_LDAC),
        .DAC_RST(DAC_RST)
    );
    
    assign Xout16 = {Xout[31], Xout[26:12]};
    assign Yout16 = {Yout[31], Yout[26:12]};
    assign Zout16 = {Zout[31], Zout[26:12]};  
    assign NRST = ~RST;
    
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Qi <= 13'b0000000000000;
        end else begin
            if (Qi == zero) begin
                WR <= 1'b1;
                Qi <= K;
                Qii <= Qii + 1;
            end else begin
                WR <= 1'b0;
                Qi <= Qi - 1;
                Qii <= Qii;
            end
        end
    end

endmodule