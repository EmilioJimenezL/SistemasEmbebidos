module dacGReg #(
    parameter n = 8
) (
    input RST,
    input CLK,
    input LDR,
    input [n-1:0] Din,
    output [n-1:0] Dout
);

    reg [n-1:0] Qn, Qp;
    
    assign Dout = Qp;
    
    always @* begin
        if (LDR)
            Qn = Din;
        else
            Qn = Qp;
    end
    
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Qp <= {n{1'b0}};
        else
            Qp <= Qn;
    end

endmodule