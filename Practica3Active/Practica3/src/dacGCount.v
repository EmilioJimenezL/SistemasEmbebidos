module dacGCount #(
    parameter n = 8
) (
    input RST,
    input CLK,
    input [1:0] OPC,
    input [n-1:0] K,
    output reg EOC,
    output [n-1:0] Q
);

    reg [n-1:0] Qn, Qp;
    
    assign Q = Qp;
    
    always @* begin
        case (OPC)
            2'b00: Qn = Qp;
            2'b01: Qn = Qp + 1;
            default: Qn = {n{1'b0}};
        endcase
    end
    
    always @* begin
        if (Qp == K)
            EOC = 1'b1;
        else
            EOC = 1'b0;
    end
    
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Qp <= {n{1'b0}};
        else
            Qp <= Qn;
    end

endmodule