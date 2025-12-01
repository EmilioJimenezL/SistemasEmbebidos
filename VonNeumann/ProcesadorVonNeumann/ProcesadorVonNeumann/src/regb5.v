module regb5 (
    input [4:0] cs,
    input clk,
    input reset,
    input [3:0] datoin,
    output reg [3:0] b
);

reg [3:0] bres;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        b <= 4'b0000;
        bres <= 4'b0000;
    end else begin
        case (cs)
            5'b10010: b <= datoin;  // Carga datoin en b
            5'b11100: bres <= b;    // Guarda b en bres
            5'b11101: b <= bres;    // Carga bres en b
            default: ;              // No hace nada
        endcase
    end
end

endmodule