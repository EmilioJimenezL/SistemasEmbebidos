module DAC7565 (
    input RST,
    input CLK,
    input WR,
    output EOW,
    input DRST,
    input [15:0] Ch0,
    input [15:0] Ch1,
    input [15:0] Ch2,
    input [15:0] Ch3,
    output DAC_SCLK,
    output DAC_SYNC,
    output DAC_DIN,
    output DAC_LDAC,
    output DAC_RST
);

    wire EOC, EOS, EOT, ENT;
    wire [1:0] SE;
    wire [1:0] ENS, ENC;
    wire [4:0] SB;
    reg [5:0] CMD;
    reg [15:0] DAT;
    wire [15:0] D0, D1, D2, D3;
    wire [23:0] STREAM;
    
    assign DAC_LDAC = 1'b0;
    assign DAC_RST = ~DRST;
    assign STREAM = {2'b00, CMD, ~DAT};
    
    always @* begin
        case (SE)
            2'b00: begin
                DAT = D0;
                CMD = 6'b000000;
            end
            2'b01: begin
                DAT = D1;
                CMD = 6'b000010;
            end
            2'b10: begin
                DAT = D2;
                CMD = 6'b000100;
            end
            default: begin
                DAT = D3;
                CMD = 6'b100110;
            end
        endcase
    end
    
    dacGReg #(.n(16)) RegCh0 (.RST(RST), .CLK(CLK), .LDR(WR), .Din(Ch0), .Dout(D0));
    dacGReg #(.n(16)) RegCh1 (.RST(RST), .CLK(CLK), .LDR(WR), .Din(Ch1), .Dout(D1));
    dacGReg #(.n(16)) RegCh2 (.RST(RST), .CLK(CLK), .LDR(WR), .Din(Ch2), .Dout(D2));
    dacGReg #(.n(16)) RegCh3 (.RST(RST), .CLK(CLK), .LDR(WR), .Din(Ch3), .Dout(D3));
    
    dacGShifter #(.n(24), .m(5)) Shifter (.S(SB), .Din(STREAM), .Dout(DAC_DIN));
    
    dacGCount #(.n(2)) ChCount (.RST(RST), .CLK(CLK), .OPC(ENC), .K(2'b11), .EOC(EOC), .Q(SE));
    dacGCount #(.n(5)) BitCount (.RST(RST), .CLK(CLK), .OPC(ENS), .K(5'b10111), .EOC(EOS), .Q(SB));
    dacGTimer #(.n(3)) ISPFreq (.RST(RST), .CLK(CLK), .EN(ENT), .K(3'b100), .Tout(EOT));
    
    dacFSM Control (.RST(RST), .CLK(CLK), .WR(WR), .EOW(EOW), .EOC(EOC), .EOS(EOS), 
                   .EOT(EOT), .ENC(ENC), .ENS(ENS), .ENT(ENT), .SYNC(DAC_SYNC), .SCLK(DAC_SCLK));

endmodule