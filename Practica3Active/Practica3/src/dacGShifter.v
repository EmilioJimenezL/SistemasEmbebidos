module dacGShifter #(
    parameter n = 8,
    parameter m = 3
) (
    input [m-1:0] S,
    input [n-1:0] Din,
    output Dout
);

    wire [n:0] SH;
    
    assign SH = {Din, 1'b0};
    assign Dout = SH[n - S];

endmodule