module dacFSM (
    input RST,
    input CLK,
    input WR,
    output reg EOW,
    input EOC,
    input EOS,
    input EOT,
    output reg [1:0] ENC,
    output reg [1:0] ENS,
    output reg ENT,
    output reg SYNC,
    output reg SCLK
);

    reg [3:0] Qn, Qp;
    
    always @* begin
        case (Qp)
            4'b0000: begin
                if (WR)
                    Qn = 4'b0001;
                else
                    Qn = Qp;
                SYNC = 1'b1;
                SCLK = 1'b1;
                EOW = 1'b0;
                ENT = 1'b0;
                ENC = 2'b11;
                ENS = 2'b11;
            end
            4'b0001: begin
                if (EOT)
                    Qn = 4'b0010;
                else
                    Qn = Qp;
                SYNC = 1'b0;
                SCLK = 1'b1;
                EOW = 1'b0;
                ENT = 1'b1;
                ENC = 2'b00;
                ENS = 2'b00;
            end
            4'b0010: begin
                if (EOT)
                    Qn = 4'b0011;
                else
                    Qn = Qp;
                SYNC = 1'b0;
                SCLK = 1'b0;
                EOW = 1'b0;
                ENT = 1'b1;
                ENC = 2'b00;
                ENS = 2'b00;
            end
            4'b0011: begin
                if (EOS)
                    Qn = 4'b0100;
                else
                    Qn = 4'b0001;
                SYNC = 1'b0;
                SCLK = 1'b1;
                EOW = 1'b0;
                ENT = 1'b1;
                ENC = 2'b00;
                ENS = 2'b01;
            end
            4'b0100: begin
                if (EOC)
                    Qn = 4'b0111;
                else
                    Qn = 4'b0101;
                SYNC = 1'b0;
                SCLK = 1'b1;
                EOW = 1'b0;
                ENT = 1'b0;
                ENC = 2'b01;
                ENS = 2'b11;
            end
            4'b0101: begin
                if (EOT)
                    Qn = 4'b0110;
                else
                    Qn = Qp;
                SYNC = 1'b1;
                SCLK = 1'b1;
                EOW = 1'b0;
                ENT = 1'b1;
                ENC = 2'b00;
                ENS = 2'b00;
            end
            4'b0110: begin
                Qn = 4'b0001;
                SYNC = 1'b1;
                SCLK = 1'b1;
                EOW = 1'b0;
                ENT = 1'b0;
                ENC = 2'b00;
                ENS = 2'b00;
            end
            4'b0111: begin
                if (EOT)
                    Qn = 4'b1000;
                else
                    Qn = Qp;
                SYNC = 1'b1;
                SCLK = 1'b1;
                EOW = 1'b0;
                ENT = 1'b1;
                ENC = 2'b00;
                ENS = 2'b00;
            end
            default: begin
                Qn = 4'b0000;
                SYNC = 1'b1;
                SCLK = 1'b1;
                EOW = 1'b1;
                ENT = 1'b0;
                ENC = 2'b00;
                ENS = 2'b00;
            end
        endcase
    end
    
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Qp <= 4'b0000;
        else
            Qp <= Qn;
    end

endmodule