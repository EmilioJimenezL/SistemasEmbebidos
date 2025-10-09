module dacGTimer #(
    parameter n = 8
) (
    input RST,
    input CLK,
    input EN,
    input [n-1:0] K,
    output reg Tout
);

    reg [n-1:0] Qn, Qp;
    
    always @* begin
        if (EN) begin
            if (Qp == K) begin
                Qn = {n{1'b0}};
                Tout = 1'b1;
            end else begin
                Qn = Qp + 1;
                Tout = 1'b0;
            end
        end else begin
            Qn = {n{1'b0}};
            Tout = 1'b0;
        end
    end
    
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Qp <= {n{1'b0}};
        else
            Qp <= Qn;
    end

endmodule